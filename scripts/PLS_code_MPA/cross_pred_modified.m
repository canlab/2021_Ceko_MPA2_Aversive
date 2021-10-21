% Marta: Modified to fit own environment + mask + colors
% Marta: added saving of statistical bs images 

% addpath(genpath('D:\GitHub\'))
% addpath(genpath('D:\spm12'))

%% load data 

cd(scriptsdir)

load(fullfile(resultsdir, 'data_objects.mat'));
import_Behav_MPA2

% Specify models 
models = {'General' 'Pressure' 'Thermal' 'Sound' 'Visual'};
%
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';
ints=rem(1:16,4);ints(ints==0)=4;
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

%%
avers_mat=condf2indic(modality);
for i=1:size(avers_mat,1)
    avers_mat(i,find(avers_mat(i,:)))=dat.Y(i);
    
end
avers_mat=[dat.Y avers_mat];

%
dat.removed_images=0;
dat.removed_voxels=0;

% make sure mask is on path!! 
gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 

dat=apply_mask(dat,gm_mask);

%dat=remove_empty(dat);

%%

% % display mean image 
% m=mean(dat);
% figure; o2=montage(m);


%%
% kinds=ceil(subjects/11);  
% 
% for k=1:5
%     
%     train= kinds~=k;
%     test= ~train;
%     [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)',avers_mat(train,:),20);
%     
%     yhat(test,:)=[ones(length(find(test)),1) dat.dat(:,test)']*b_pls;
% 
% end

%%
kinds=ceil(subjects/11);
for k=1:5
    train= kinds~=k;
    test= ~train;
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)',avers_mat(train,:),20);
    yhat(test,:)=[ones(length(find(test)),1) dat.dat(:,test)']*b_pls;
    
    for m=1:length(models)
        cv_bpls=fmri_data;
        cv_bpls.volInfo=dat.volInfo;
        cv_bpls.dat=b_pls(2:end,m);
        cv_bpls.removed_voxels=dat.removed_voxels;
%         cv_bpls.fullpath=[models{m} '_CV' num2str(k)  '.nii'];
%         write(cv_bpls,'overwrite');
%         
        dat.removed_images = 0;
        test_dat=dat;
        test_dat.dat=test_dat.dat(:,test);
        pexp_xval_cs(test,m) = apply_mask(test_dat,cv_bpls,'pattern_expression','cosine_similarity');
        pexp_xval_dp(test,m) = apply_mask(test_dat,cv_bpls,'pattern_expression');
    end
end

%
%[xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat',avers_mat,20);

[xl,yl,xs,ys,b_plsfull,pctvar,mse,stats] = plsregress(dat.dat',avers_mat,20);

yhatfull = [ones(length(find(subjects)),1) dat.dat']*b_plsfull; 

%% Save stats
% --------------------------------------------------------------------
savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
%savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm_L2.mat'));

save(savefilename, 'avers_mat', '-v7.3');

save(savefilename, 'yhat','b_pls', 'pexp_xval_cs', 'pexp_xval_dp', '-append'); % cross-val PLS outcomes 

save(savefilename, 'yhatfull', 'b_plsfull', '-append'); % full PLS outcomes 

%% Save intercepts into a separate variable (1 per model) 
% --------------------------------------------------------------------
int_plsfull = b_plsfull(1,:);

save(savefilename, 'int_plsfull', '-append'); % full PLS outcomes 

save(savefilename, 'models', '-append'); % full PLS outcomes

%% Write files w/ b_pls weights on full sample --> final signature weight map for application to new datasets   
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

%% Bootstrap 
% 
% bs_b=bootstrp(10000,@bootpls20dim,dat.dat',avers_mat);
% r_bs_b=reshape(bs_b,10000,1+size(dat.dat,1),5);
% r_bs_b=r_bs_b(:,2:end,:);

bs_b=bootstrp(10000,@bootpls20dim,dat.dat',avers_mat); % function BETA = bootpls20dim(x,y)[~,~,~,~,BETA] = plsregress(x,y,20);
r_bs_b=reshape(bs_b,10,1+size(dat.dat,1),5);
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
%save(savefilenamedata, 'bs_b', 'r_bs_b','b_mean_coeff', 'b_pls', '-append');


% save other useful information 
datvol = dat.volInfo;  % why can't I save under orig name? 
datnovox = dat.removed_voxels;
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};
save(savefilenamedata, 'datvol', '-append'); % version flag is not required when using the '-append' flag 
save(savefilenamedata, 'datnovox', '-append'); 
save(savefilenamedata, 'models', '-append'); 

%% Save bs stat images %% write bootstrapped files for interpretation and display 

load(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));

% Display and save pattern maps
%Original code: 
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


% Save data together with the bootstrapped output 'package' 
% -------------------------------------------------------------------------
% reminder where we are saving
savefilenamedata =(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));
save(savefilenamedata, 'pls_bs_statimg', '-append'); % version flag is not required when using the '-append' flag 
save(savefilenamedata, 'pls_bs_statimg_fdr05', '-append'); % version flag is not required when using the '-append' flag 










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
