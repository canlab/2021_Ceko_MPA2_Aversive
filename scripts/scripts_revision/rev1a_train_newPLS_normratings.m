% Train PLS to predict norm ratings of positive and negative images 
% & plot response 

% Prep
cd(scriptsrevdir);
prep_1_posneg_set_conditions 

resultsdir = resultsrevdir;

% run from highest dir
prep_2_load_image_data_and_save % ... has gone psycho
% all of a sudden it looks for data in current dir + datadir, instead of
% datadir - not sure if the issue is with the script or on my (matlab) side


% %% Univariate contrasts to neg / pos, neg lin / pos lin, and between conditions
% cd(scriptsrevdir)
% prep_3_calc_univariate_contrast_maps_and_save
% c_univariate_contrast_maps_posneg

%% Now, lets train and test PLS 

% load images and behavior 
% ----------------------------------------------
load(fullfile(resultsrevdir, 'data_objects.mat')); 

import_Behav_NEGPOS %

% Specify models 
% ----------------------------------------------
models = {'NGeneral' 'NVisneg' 'NVispos'};   % General here would ideally give us general arousal
%
modality=[];stim_int=[];
subjects=repmat(1:55,1,8)';      
ints=rem(1:8,4);ints(ints==0)=4;   

% reorganize Experience session into a dat 
% ----------------------------------------------
for d=1:8
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Norm_negpos(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end
% %% optional L2 norm 
% dat=rescale(dat, 'l2norm_images')

% reorganize behavior into dat.Y
% ----------------------------------------------
norm_mat=condf2indic(modality);
for i=1:size(norm_mat,1)
    norm_mat(i,find(norm_mat(i,:)))=dat.Y(i);
    
end
norm_mat=[dat.Y norm_mat];

dat.removed_images=0;
dat.removed_voxels=0;

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

kinds=ceil(subjects/11);  % 5 folds 
[indic, xlevels] = condf2indic(kinds);

%%
for k = 1:5  % for each fold
    
    fprintf('FOLD %d\n----------------------\n', k);
    
    train= kinds~=k; % 4/5
    test= ~train; %  1/5
    
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)', norm_mat(train,:), 20);
    
    yhat(test,:) = [ones(length(find(test)),1) dat.dat(:,test)'] * b_pls;
    
    cv_pls_intercepts{k} = b_pls(1, :);
   
    % Create an object with all models for this fold
    % -----------------------------------------------
    cv_bpls = fmri_data;             % Note: this only works if the training data space matches the standard default space exactly! It should be ok here.
    cv_bpls.volInfo = dat.volInfo;

    % 3 images for 3 models.  trained on 440*4/5 images
    % -----------------------------------------------
    cv_bpls.dat = b_pls(2:end, :);                      % All models, this fold
    cv_bpls.removed_voxels = dat.removed_voxels;
    cv_bpls.additional_info{1} = cv_pls_intercepts{k};  % Add 5 intercepts for 5 models
    cv_bpls.additional_info{2} = 'Cell 1: 3 intercepts for 3 models';
    cv_bpls.additional_info{3} = indic(:, k);
    cv_bpls.additional_info{4} = 'Indicator for test images in fold; 0 = train, 1 = test';
    cv_bpls.source_notes = sprintf('MPA2 3 models trained with plsregress, fold %d', k);
    
    % Experience session: Apply to test images 
    % -----------------------------------------------
    test_dat = get_wh_image(dat, find(test));

    % Apply to test data - add intercepts to dot product
    pexp_xval_cs_test = apply_mask(test_dat, cv_bpls, 'pattern_expression', 'cosine_similarity');
    pexp_xval_dp_test = apply_mask(test_dat, cv_bpls, 'pattern_expression') + cv_pls_intercepts{k};

    % aggregate into overall
    pexp_xval_cs(test, :) = pexp_xval_cs_test;
    pexp_xval_dp(test, :) = pexp_xval_dp_test;
end


% Reorganize, save
% Xval patterns for each model are in the 440/1 format
% reshape into 55 x 8
for m = 1:3
    % Experience Session
    cs_E(:,:,m) = reshape(pexp_xval_cs(:,m), 55, 8);
    dp_E(:,:,m) = reshape(pexp_xval_dp(:,m), 55, 8);
end

% append these to DAT

% General Model
DAT.NORMPLSXVAL_GEN_conditions.raw.dotproduct = [dp_E(:,:,1)];
DAT.NORMPLSXVAL_GEN_conditions.raw.cosine_sim = [cs_E(:,:,1)];

% NEG Norm Vis Specific 
DAT.NORMPLSXVAL_NNV_conditions.raw.dotproduct = [dp_E(:,:,2)];
DAT.NORMPLSXVAL_NNV_conditions.raw.cosine_sim = [cs_E(:,:,2)];

% POS Norm Vis Specific 
DAT.NORMPLSXVAL_PNV_conditions.raw.dotproduct = [dp_E(:,:,3)];
DAT.NORMPLSXVAL_PNV_conditions.raw.cosine_sim = [cs_E(:,:,3)];


printhdr('Save results');

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
save(savefilename, 'DAT', '-append');
% 


%% Run full model
% ----------------------------------------------

[xl,yl,xs,ys,b_plsfull,pctvar,mse,stats] = plsregress(dat.dat',norm_mat,20);

yhatfull = [ones(length(find(subjects)),1) dat.dat']*b_plsfull; 

int_plsfull = b_plsfull(1, :); % full model intercept 


%% Save stats
% --------------------------------------------------------------------
savefilename=(fullfile(resultsrevdir, 'NORMPLS_crossvalidated_N55_gm.mat'));
%savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm_L2.mat'));

save(savefilename, 'norm_mat', '-v7.3');

save(savefilename, 'yhat','b_pls', 'pexp_xval_cs', 'pexp_xval_dp', '-append'); % cross-val PLS outcomes 

save(savefilename, 'yhatfull', 'b_plsfull', '-append'); % full PLS outcomes 

int_plsfull = b_plsfull(1,:);

save(savefilename, 'int_plsfull', '-append'); % full PLS outcomes 

save(savefilename, 'models', '-append'); % full PLS outcomes


%% Write files w/ b_pls weights on full sample --> final signature weight maps for application to new datasets  
% -----------------------------------------------------------------------------------------------------------
% cd(scriptsrevdir)
% load(fullfile(resultsrevdir, 'NORMPLS_crossvalidated_N55_gm.mat'));


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

%% Bootstrap 10,000 and save stats and niftis

bs_b=bootstrp(10000,@bootpls20dim,dat.dat',norm_mat); % function BETA = bootpls20dim(x,y)[~,~,~,~,BETA] = plsregress(x,y,20);
r_bs_b=reshape(bs_b,10000,1+size(dat.dat,1),3);
r_bs_b=r_bs_b(:,2:end,:);

b_mean_coeff = squeeze(nanmean(r_bs_b));
b_ste_coeff = squeeze(nanstd(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);

% Save stats
% --------------------------------------------------------------------
savefilenamedata =(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_gm.mat'));
save(savefilenamedata, 'b_Z_coeff', '-v7.3');
save(savefilenamedata, 'b_P_coeff', '-append');
save(savefilenamedata, 'bs_b', 'r_bs_b','b_mean_coeff', 'b_pls', '-append');

% save other useful information 
datvol = dat.volInfo;  % why can't I save under orig name? 
datnovox = dat.removed_voxels;
save(savefilenamedata, 'datvol', '-append'); % Note to self: version flag is not required when using the '-append' flag 
save(savefilenamedata, 'datnovox', '-append'); 
save(savefilenamedata, 'models', '-append'); 

%load(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_gm.mat'));

% Save bootstrapped stat images 
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
   
    % save statistical images for further calculations (e.g., conjunctions) 
    pls_bs_statimg(m) = bs_stat; 
    
       
    bs_stat = threshold (bs_stat, .05, 'fdr');
    pls_bs_statimg_fdr05(m) = bs_stat;
    
end


% Save data together with the bootstrapped output  
% -------------------------------------------------------------------------
% reminder where we are saving
savefilenamedata =(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_gm.mat'));
save(savefilenamedata, 'pls_bs_statimg', '-append'); 
save(savefilenamedata, 'pls_bs_statimg_fdr05', '-append');


%%  Write bootstrapped nii files for interpretation and display 

%%%% TODO: REWRITE WITHOUT NANING __ TEST FIRST -- -

for m=1:length(models) 
    
    % write out images 
    % ------------------------------
    % unthr 
    bs_stat=statistic_image;
    bs_stat.volInfo=dat.volInfo;
    
    bs_stat.dat=b_Z_coeff(:,m);
    bs_stat.p=b_P_coeff(:,m);
    
    bs_stat.removed_voxels=dat.removed_voxels;
    
    bs_stat.fullpath=[models{m} '_b10000_unthr.nii'];
    write(bs_stat, 'overwrite'); 
    
    %FDR corr
    bs_stat=threshold(bs_stat,.05,'fdr','k',10);
    % sig field tells us which voxels to use for masking -- if I NAN it I remove information 
    % bs_stat.dat(~bs_stat.sig)=nan;  % won't be able to rethreshold bc I just removed all the values
    
    % resave these without naning sig and see if same
    %bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_FDR05.nii'];
    write(bs_stat, 'overwrite');
end

%%

% 
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

results_NG = results_table{1}; writetable(results_NG, 'NG_clusters.txt');
results_NN = results_table{2}; writetable(results_NN, 'NN_clusters.txt');
results_NP = results_table{3}; writetable(results_NP, 'NP_clusters.txt');

savefilenamedata =(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_ResultsTable.mat'));
save(savefilenamedata, 'results_table');

