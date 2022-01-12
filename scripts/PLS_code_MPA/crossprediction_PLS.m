
%% This code computes and saves multiaversive General and Stimulus-Specific PLS patterns 

% (1) Loads and reorganizes data 
% image data (beta images: 55 subjects x 4 stimulus types x 4 intensity levels = 880 files) 
% aversiveness ratings 

% (2) Runs cross-validated models and saves:
% fold images (5 folds per model, for 5 models) --> cv pattern maps for application on the same individuals 
% cv beta weights (coefficients)   
% cv intercepts 
% cv dot products 
% cv cosine similarity
% ratings 
% meta data: subject and fold info

% (3) Runs full model and saves:
% full beta weights
% full intercept 
% full sample images = final signature weight maps for application to new datasets 

% (4) Bootstrapping 
% runs bootstrapping and saves stats 
% saves boorstrapped images to interpretation and display 


dosave = true;

% ---------------------------------------------------
% Phil Kragel, Marta Ceko, and Tor Wager 2021
% ---------------------------------------------------

% run a_set_up_paths_always_run_first
% or specify directory paths here:

% basedir = '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/';
% resultsdir = fullfile(basedir, 'results');
% behdatadir = fullfile(basedir, 'data/data_behavior'); 
% 
% % main scripts dir
% scriptsdir = '/Applications/Canlab/2021_Ceko_MPA2_Aversive/scripts';
% cd(scriptsdir)

%% load and GM mask data 
%
% Create 'dat', which is the full dataset
% add metadata_table t, which describes outcome self-report data, folds, subject IDs

% load images and behavior 
% ----------------------------------------------

load(fullfile(resultsdir, 'data_objects.mat')); 

import_Behav_MPA2 % this script lives in (scriptsdir) and imports rating data from behdatadir

% Specify models 
% ----------------------------------------------
models = {'General' 'Pressure' 'Thermal' 'Sound' 'Visual'};
%
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';      
ints=rem(1:16,4);ints(ints==0)=4;   

% reorganize into a dat 
% ----------------------------------------------
for d=1:16
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Pain_Avoid(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end
% %% optional L2 norm 
% dat=rescale(dat, 'l2norm_images')

% reorganize behavior into dat.Y
% ----------------------------------------------
avers_mat=condf2indic(modality);
for i=1:size(avers_mat,1)
    avers_mat(i,find(avers_mat(i,:)))=dat.Y(i);
    
end
avers_mat=[dat.Y avers_mat];

%
dat.removed_images=0;
dat.removed_voxels=0;

% Mask with the improved GM mask (Kragel)
% ----------------------------------------------
% loaded via a2_mc_set_up_paths and also specified in a2_set_default_options 

% % re-specify here if needed: 
% maskdir = fullfile(basedir, 'masks');
% gm_mask = fullfile(maskdir, 'gm_mask.nii');


gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);


% Specify folds (55/11 = 5)
% ----------------------------------------------

kinds=ceil(subjects/11);  % Training Fold (number indicates which test fold the participant belongs to

% clear cv_bpls % in case you are rerunning the below code, better to have a clean slate

%% save info about subjects, folds, and ratings in metadata and save intercept

% Pull subject names out of fullpath and add to table
pat = 'MPA2s\d+';
subjid = regexp(cellstr(dat.fullpath), pat, 'match');
subjid = [subjid{:}]';
subjid = repmat(subjid, 16, 1);

% metadata table:
t = table(subjects, subjid, kinds, avers_mat, 'VariableNames', {'Subject' 'subject_id' 'Fold' 'Aversion_ratings'});
t = splitvars(t, 'Aversion_ratings', 'NewVariableNames', models);

% Add level and stimulus type
% lev = ones(55, 1); % stim_int
% lev = [lev; 2*lev; 3*lev; 4*lev];
% lev = repmat(lev, 4, 1);

stimtype = ones(220, 1);
stimtype = [stimtype; 2*stimtype; 3*stimtype; 4*stimtype];

t = addvars(t, stim_int, stimtype, 'NewVariableNames', {'Intensity_level' 'Stimulus_type'});

% Add folds
[indic, xlevels] = condf2indic(kinds);
t = addvars(t, indic, 'NewVariableNames', 'fold_indic');

t = splitvars(t, 'fold_indic', 'NewVariableNames', {'fold1' 'fold2' 'fold3' 'fold4' 'fold5'});

t = addvars(t, indic, 'NewVariableNames', 'fold_indic_matrix');

t.Properties.Description = 'MPA2 cross-validated PLS metadata. Aversion ratings included (these are Y in PLS).';

t.Properties.VariableDescriptions = {'Participant number' 'Participant ID code'...
    'Cross-val fold number (test fold)' 'General aversion ratings' 'Pressure aversion ratings' 'Thermal aversion ratings' 'Sound aversion ratings' 'Visual aversion ratings' ...
    'Stimulus intensity level' 'Stim type:1=Pressure, 2=Thermal, 3=Sound, 4=Visual' 'Indicator that image is in test set for Fold 1' 'Indicator that image is in test set for Fold 2' 'Indicator that image is in test set for Fold 3' 'Indicator that image is in test set for Fold 4' 'Indicator that image is in test set for Fold 5'...
    'Fold indicator matrix (1 = in test fold)'};


dat.metadata_table = t;

%% Run cross-validated models
% ----------------------------------------------
%
% Initialize images
% dat is template object
% Create an "empty" data object that is a copy of dat
for m = 1:length(models)
    
    eval(['cv_pls_object_' models{m} ' = dat;']);
    eval(['cv_pls_object_' models{m} '.dat = zeros(size(dat.dat, 1), 1);']); % keep removed voxels the same and match to .dat
	eval(['cv_pls_object_' models{m} '.removed_images = [];']);
    eval(['cv_pls_object_' models{m} '.metadata_table = t;']);
    
    source_notes = sprintf('MPA2 5 models trained with plsregress, images are folds');
    eval(['cv_pls_object_' models{m} '.source_notes = source_notes;']);
    
    eval(['cv_pls_object_' models{m} '.dat_descrip = ''Trained cv models, one image with model weights per fold'';']);
end

%

for k = 1:5  % for each fold
    
    fprintf('FOLD %d\n----------------------\n', k);
    
    train= kinds~=k; % 4/5
    test= ~train; %  1/5
    
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)', avers_mat(train,:), 20);
    
    yhat(test,:) = [ones(length(find(test)),1) dat.dat(:,test)'] * b_pls;
    
    cv_pls_intercepts{k} = b_pls(1, :);
   
    % Create an object with all models for this fold
    % -----------------------------------------------
    cv_bpls = fmri_data;             % Note: this only works if the training data space matches the standard default space exactly! It should be ok here.
    cv_bpls.volInfo = dat.volInfo;
    
    % TOR: save CV, save intercepts
    % cv_bpls is organized by fold.  One object per fold, with all models.
    % 5 images for 5 models.  trained on 880*4/5 images
    % -----------------------------------------------
    cv_bpls.dat = b_pls(2:end, :);                      % All models, this fold
    cv_bpls.removed_voxels = dat.removed_voxels;
    cv_bpls.additional_info{1} = cv_pls_intercepts{k};  % Add 5 intercepts for 5 models
    cv_bpls.additional_info{2} = 'Cell 1: 5 intercepts for 5 models';
    cv_bpls.additional_info{3} = indic(:, k);
    cv_bpls.additional_info{4} = 'Indicator for test images in fold; 0 = train, 1 = test';
    cv_bpls.source_notes = sprintf('MPA2 5 models trained with plsregress, fold %d', k);
    
    % Apply to test images. This has advantages over doing it manually -
    % e.g., selects metadata_table rows too, better bookkeeping
    test_dat = get_wh_image(dat, find(test));
    
    % Add test metadata table
    cv_bpls.metadata_table = test_dat.metadata_table;
    
    % Apply to test data - add intercepts to dot product
    pexp_xval_cs_test = apply_mask(test_dat, cv_bpls, 'pattern_expression', 'cosine_similarity');
    pexp_xval_dp_test = apply_mask(test_dat, cv_bpls, 'pattern_expression') + cv_pls_intercepts{k};
    
    % Add cross-val pattern expression to metadata table
    cv_bpls.metadata_table = addvars(cv_bpls.metadata_table, pexp_xval_cs_test, pexp_xval_dp_test, 'NewVariableNames', {'test_pexp_cs' 'test_pexp_dp'});
    
    cv_bpls.metadata_table.Properties.VariableDescriptions{end - 1} = 'Test participants pattern expression - cosine sim';
    cv_bpls.metadata_table.Properties.VariableDescriptions{end} = 'Test participants pattern expression - dot product';
    
    % aggregate into overall
    pexp_xval_cs(test, :) = pexp_xval_cs_test;
    pexp_xval_dp(test, :) = pexp_xval_dp_test;
    
    % save the object organized by fold.  One object per fold, with all models.
    eval(['cv_pls_fold_' num2str(k) ' = cv_bpls;']);
    
    % Organized by model, with one object per model and each fold as an image (5 images for 5 folds). 
    % -----------------------------------------------
    
    for m = 1:length(models)

        % organize into a cv_pls object with each fold as an image (5 images for 5 folds). 
        % cv_bpls_object_General, cv_bpls_object_Pressure, cv_bpls_object_Thermal,cv_bpls_object_Sound cv_bpls_object_Visual

        eval(['cv_pls_object_' models{m} '.dat(:, k) = cv_bpls.dat(:, m);']);

        eval(['cv_pls_object_' models{m} '.additional_info{1}(k) = cv_pls_intercepts{k}(m);']);

        eval(['cv_pls_object_' models{m} '.additional_info{2} = ''Model intercepts for each fold'';']);
       
    end
    
end

%% Save

% To apply models in cv_PLS_models_by_fold to new data:
% 1 - identify test observations
% fold = 1, test = obj.metadata_table.fold_indic_matrix(:, fold);
%
% 2 - select test dataset, test_dat = get_wh_image(obj, find(test));
%
% 3 - apply models and add intercepts:  
% pexp_xval_dp_test = apply_mask(test_dat, obj, 'pattern_expression') + obj.additional_info{1};

% now done above 


if dosave
    
    save(fullfile(resultsdir, 'patterns', 'PLS_CV_patterns', 'cv_PLS_models_by_fold'), 'cv_pls_fold*');
    
    save(fullfile(resultsdir, 'patterns', 'PLS_CV_patterns', 'cv_PLS_models'), 'cv_pls_object*');
    
end

%% 

% Add modeltable to save
% ----------------------------------------------
%
% dat = DATA_OBJ{1};

for m = 1:length(models)
    
    modeltable = addvars(t, pexp_xval_cs(:, m), 'NewVariableNames', ['pexp_xval_cs_' models{m}]);
    
    modeltable.Properties.VariableDescriptions{end} = ['Cross-validated pattern expression for ' models{m} ', cosine sim'];
    
    modeltable = addvars(modeltable, pexp_xval_dp(:, m), 'NewVariableNames', ['pexp_xval_dp_' models{m}]);
    
    modeltable.Properties.VariableDescriptions{end} = ['Cross-validated pattern expression for ' models{m} ', dot product'];
    
end


%% Run full model
% ----------------------------------------------

[xl,yl,xs,ys,b_plsfull,pctvar,mse,stats] = plsregress(dat.dat',avers_mat,20);

yhatfull = [ones(length(find(subjects)),1) dat.dat']*b_plsfull; 

int_plsfull = b_plsfull(1, :); % full model intercept 

%% Save stats for cv models and for full model
% --------------------------------------------------------------------

% Cross-validated
% --------------------
if dosave
    
    savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
    %savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm_L2.mat'));
    
    save(savefilename, 'cv_pls_fold*', '-v7.3'); % data + metadata for all models by fold
    save(savefilename, 'cv_pls_object*', '-append'); % data + metadata by object
        
    save(savefilename, 'modeltable', '-append'); % table w/ metadata
    
    % save aggregated dp (with intercept), cv
    save(savefilename,'pexp_xval_cs', 'pexp_xval_dp', '-append'); % cross-val PLS outcomes 

    
    save(savefilename, 'modeltable', '-append'); % table w/ metadata
    
    % Add full model stats
    % -------------------
    save(savefilename, 'yhatfull', 'b_plsfull', '-append'); % full PLS outcomes
    
    
    save(savefilename, 'int_plsfull', '-append'); % full model intercept in separate variable
    
end

%% Write files w/ b_pls weights on full sample --> final signature weight maps for application to new datasets  
% -----------------------------------------------------------------------------------------------------------

for m=1:length(models)
    bs_stat=statistic_image;
    bs_stat.volInfo=dat.volInfo;
    bs_stat.dat=b_plsfull(2:end,m);
    bs_stat.removed_voxels=dat.removed_voxels;
    %orthviews(bs_stat)

    % Unthresholded 
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_bplsF_unthr.nii'];
    write(bs_stat, 'overwrite');  
end

%% Bootstrap 10,000

bs_b=bootstrp(10000,@bootpls20dim,dat.dat',avers_mat); % function BETA = bootpls20dim(x,y)[~,~,~,~,BETA] = plsregress(x,y,20);
r_bs_b=reshape(bs_b,10000,1+size(dat.dat,1),5);
r_bs_b=r_bs_b(:,2:end,:);

b_mean_coeff = squeeze(nanmean(r_bs_b));
b_ste_coeff = squeeze(nanstd(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);

% Save stats
% --------------------------------------------------------------------
savefilenamedata =(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));
save(savefilenamedata, 'b_Z_coeff', '-v7.3');
save(savefilenamedata, 'b_P_coeff', '-append');
save(savefilenamedata, 'bs_b', 'r_bs_b','b_mean_coeff', 'b_pls', '-append');


% save other useful information 
datvol = dat.volInfo;  % why can't I save under orig name? 
datnovox = dat.removed_voxels;
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};
save(savefilenamedata, 'datvol', '-append'); % Note to self: version flag is not required when using the '-append' flag 
save(savefilenamedata, 'datnovox', '-append'); 
save(savefilenamedata, 'models', '-append'); 

%% Save bs stat images %% write bootstrapped files for interpretation and display 

load(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));

% Display and save pattern maps
% Original code: 
for m=1:length(models)
    
    % create stat img
    bs_stat=statistic_image;
    
    % populate stat img
    % ------------------------------
    % data
    bs_stat.dat=b_Z_coeff(:,m);
    bs_stat.p=b_P_coeff(:,m);
    
    % meta-info
    bs_stat.volInfo=datvol; % pulled from the original dat.volInfo
    bs_stat.removed_voxels=0; % pulled from the original dat.removed_voxels 
    %orthviews(bs_stat)
   
    % save statistical image for further calculations (e.g., conjunctions) 
    pls_bs_statimg(m) = bs_stat;  
end

% Save at fdr-corr
for m=1:length(models)
    
    % create stat img
    bs_stat=statistic_image;
    
%     % populate stat img
%     % ------------------------------
%     % data
    bs_stat.dat=b_Z_coeff(:,m);
    bs_stat.p=b_P_coeff(:,m);
%     
%     % meta-info
    bs_stat.volInfo=datvol; % pulled from the original dat.volInfo
    bs_stat.removed_voxels=0;  %pulled from the original dat.removed_voxels 
%     %orthviews(bs_stat)
   
    bs_stat = threshold (bs_stat, .05, 'fdr');
    % save statistical image for further calculations (e.g., conjunctions) 
    pls_bs_statimg_fdr05(m) = bs_stat; 
end


% Save data together with the bootstrapped output  
% -------------------------------------------------------------------------
% reminder where we are saving
savefilenamedata =(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));
save(savefilenamedata, 'pls_bs_statimg', '-append'); 
save(savefilenamedata, 'pls_bs_statimg_fdr05', '-append');


%% Write bootstrapped files for interpretation and display 

%%%% TODO: REWRITE WITHOUT NANING __ TEST FIRST -- -

for m=1:length(models) 
    
    % write out images 
    % ------------------------------
    % unthr 
    bs_stat.fullpath=[models{m} '_b10000_unthr.nii'];
    write(bs_stat, 'overwrite');    
 
    %FDR corr
    bs_stat=threshold(bs_stat,.05,'fdr','k',10);
    % sig field tells us which voxels to use for masking -- if I NAN it I remove information 
    % bs_stat.dat(~bs_stat.sig)=nan;  % won't be able to rethreshold bc I just removed all the values
    
    % resave these without naning sig and see if same
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_FDR05.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)
    
    %001 uncorrected 
    bs_stat=threshold(bs_stat,.001,'unc','k',10);
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_unc001.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)
    
    %01 uncorrected 
    bs_stat=threshold(bs_stat,.01,'unc','k',10);
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_unc01.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)  
end

% From what I can see, naning the non-sig dat above replaces the use of 
% the 'thresh' flag when writing to .nii: 

% Replace empty vox/images
% obj = replace_empty(obj);
% 
% if any(strcmp(varargin, 'thresh'))
%     
%     if ~isa(obj, 'statistic_image')
%         disp('Warning: Thresholding only works with statistic_image objects.');
%     else
%         disp('Writing thresholded statistic image.');
%         obj.dat(~obj.sig) = 0;
%     end
%     
% end
% 

%% 
% print # of clusters and FDR corrected values
% save tables of clusters
r=[]; 
poscl = []; negcl = []; results_table = [];
for m=1:length(models)
    bs_stat(m)=statistic_image;
    bs_stat(m).volInfo=dat.volInfo;
    bs_stat(m).dat=b_Z_coeff(:,m);
    bs_stat(m).p=b_P_coeff(:,m);
    bs_stat(m).removed_voxels=dat.removed_voxels;
    bs_stat(m).dat(~bs_stat(m).sig)=nan;
%     
    % FDR corr
    sprintf('Displaying for model %3.0f',m)
    t(m)=threshold(bs_stat(m),.05,'fdr','k',10);
    r{m}=region(t(m));
    [poscl{m}, negcl{m}, results_table{m}] = table(r{m}, 'nosep');
end

savefilenamedata =(fullfile(resultsdir,'PLS_bootstats10000_N55_ResultsTable.mat'));
save(savefilenamedata, 'results_table');


% %% Write unthresh files Gen - each Spec 
% % subtract each spec (:,2-5) from gen (:,1)
% 
% for m=2:length(models);
%     b_Z_coeff_G(:,m) = b_Z_coeff(:,1) - b_Z_coeff(:,m);
%     bs_stat=statistic_image;
%     bs_stat.volInfo=dat.volInfo;
%     bs_stat.dat=b_Z_coeff_G(:,m);
%     bs_stat.p=b_P_coeff(:,m);
%     bs_stat.removed_voxels=dat.removed_voxels;
%     %orthviews(bs_stat)
% 
%     % FDR 
%     bs_stat=threshold(bs_stat,.05,'fdr','k',10);
%     bs_stat.dat(~bs_stat.sig)=nan;
%     bs_stat.fullpath=['G_' models{m} '_b10000_FDR05.nii'];
%     write(bs_stat, 'overwrite');
%     %orthviews(bs_stat);pause(5)
% end


%%
%% Define masks

% maskdir = fullfile(pwd, 'masks');
% which ('ROI_auditory_MNI.img') 

% copy all masks into /Applications/Canlab/CanlabCore/CanlabCore/canlab_canonical_brains/Canonical_brains_surfaces/
% Early sensory ROIs 

% visual, auditory, somatosensory 

% amy 

%% Run PLS in masks 
%masks={'BA123', 'BA17_vis', 'auditory'};
masks={'rvm', 'pbn', 'pag'};
%masks={'auditory'};
for m=1:3
    
    stim_masked_dat=apply_mask(dat,fmri_data(['ROI_' masks{m} '.nii']));
    
    
    for k=1:5
        
        train= kinds~=k;
        test= ~train;
        [xl,yl,xs,ys,b_pls,pctvar] = plsregress(stim_masked_dat.dat(:,train)',avers_mat(train,:),20);
        
        yhat_modal(m,test,:)=[ones(length(find(test)),1) stim_masked_dat.dat(:,test)']*b_pls;
        
    end
    
end

%% null models

% masks={'visual','auditory','somatosensory'};
% masks={'BA123', 'BA17_vis', 'auditory'};

masks={'rvm', 'pbn', 'pag'};
for m=1:3
    
    stim_masked_dat=apply_mask(dat,fmri_data(['ROI_' masks{m} '.nii']));
    
    for it=1:1000
        n_avers_mat=avers_mat(randperm(length(avers_mat)),:);
        for k=1:5
            
            train= kinds~=k;
            test= ~train;
            [xl,yl,xs,ys,b_pls,pctvar] = plsregress(stim_masked_dat.dat(:,train)',n_avers_mat(train,:),20);
            
            yhat_modal_null(m,test,:)=[ones(length(find(test)),1) stim_masked_dat.dat(:,test)']*b_pls;
            
        end
       
        null_corr(it,m,:)=diag(corr(squeeze(yhat_modal_null(m,:,:)),n_avers_mat));
      it/1000  
    end
    
end

%% Plots (1) bar, (2) matrix 
% commented by Marta

%% Bar plots 
%%
% this is necessary:  
clear toplot 

% Define models and modalities (even if defined above, for more flexibility here) 

models = {'General' 'Mechanical' 'Thermal' 'Auditory' 'Visual'};

modalities = { 'Mechanical' 'Thermal' 'Auditory' 'Visual'};

% Define data to plot 
% we are plotting the diagonal only here since this is a barplot
toplot(1,:)=diag(corr(yhat,avers_mat));  
% first bar plot = whole brain 
for m=1:3  %  barplots 2-4 (1+1,1+2,1+3) are the masks from last section
    toplot(m+1,:)=diag(corr(squeeze(yhat_modal(m,:,:)),avers_mat));
    % y_hat per mask (=vector 880 values)
end

figure; 
bar(toplot)
legend(models)
ylabel 'Prediction-Outcome Correlation'
set(gca,'XTickLabels',{'Whole-brain' masks{:}})


%% Matrix plots 
% Moved to separate script
