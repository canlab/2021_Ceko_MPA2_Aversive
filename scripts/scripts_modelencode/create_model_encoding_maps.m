%% Computation of model encoding maps a.k.a source reconstruction (SR) aka structure coefficients (SC)

% (1) subject-level SR maps by (ROBUST) regressing univariate brain maps (dat.dat) onto PLS outcomes (yhat)

% (2) group level SR maps 
% - 2nd level t-test across SR maps to obtain group maps 

% (3) SHARED REGIONS: 
% - Conjunction analyses on 2nd level maps
%
% (3) KEY WINNER REGIONS: 
% - Model - Max (all-model) on subject-level, 
% - then 2nd level t-test 
%

%% Define dirs for these analyses 

% a_set_up_paths_always_run_first 

SR_scriptsdir = fullfile(scriptsdir, 'scripts_modelencode');
SR_resultsdir = fullfile (resultsdir, 'results_modelencode/results');
SR_figsavedir = fullfile(SR_resultsdir, 'figures');


SR_datadir = fullfile(SR_resultsdir, 'data');
SR_datarobdir = fullfile(SR_datadir, 'reg_rob'); % robust regression
SR_datatraddir = fullfile(SR_datadir, 'reg_trad'); % non-robust regression
SR_datamaxrobdir = fullfile(SR_datadir, 'max_rob'); 


%% IF RERUNNING PARTS OF THE SCRIPT, LOAD SAVED DATA FIRST:

% Structure coefficient (SC, aka SR, aka modelencoders):
% betas per subject (55 subject files for each stim)

load(fullfile(SR_resultsdir, 'SR_out.mat'));
% this loads
% mod_out_rob  --- 1st level structure coefficients per participant
% SR_obj -- 2nd level group maps 
% pls_encoders  -- t-tested group maps 
% It takes a hot minute to load, it is a large file!

models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};


% NOTE: ALSO SAVED FINAL OUTPUTS ONLY IN A SMALLER FILE
% pls_encoders 


%% Load data 
cd(scriptsdir);


load(fullfile(resultsdir, 'data_objects.mat'));
import_Behav_MPA2

%% Rearrange and GM mask
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
% subj identifiers and some other info
dat.additional_info = subjects 
dat.Y_descrip = 'Avoidance ratings'
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

% mask GM
dat.removed_images=0;
dat.removed_voxels=0;

% is the maskdir on path? 
masksdir
gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

%% Load yhat 
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

% Move to the SR-dedicated dir for analysis
cd(SR_scriptsdir)

%% Background: source reconstruction (SR) aka structure coefficients - Haufe et al. 2014 NeuroImage
% ----------------------------------------------------------------------- %
% SR is a function of the covariance of the data matrix and the model weights.

% Why? %% it tells us where individual voxels covary with our predicted outcome
% and that is biologically meaningful

% How? %% regress data.dat onto yhat

% Considerations and alternatives (discussion with Bogdan)
% ---------------------------------------------------------- %
% - They don't need to be cross validated
% - predictions = y_hat, it's an n x 1 vector; X = fmri_data.dat object, vx x n matrix -  input fmri_data object we used to make predictions on 
% - source reconstruction in matlab is X*y_hat or regress data.dat onto yhat
% - Refer to equation (7) from the paper for this. Refer to equation (6) for the more general formula that is valid when the assumptions underlying equation (7) aren't satisfied
%       To check if you use equation (6) or equation (7), get your PLS components and check if they're independent (I think they are). 
%       If the covariance of your PLS component vectors are uniformly 0 (i.e. the covariance matrix is an identity matrix), then you can just use A = X_centered * y_hat_centered
%       You could just do a univariate regression of outcome on data, but with PLS you have a regularized solution, so this gives you a denoised version of the univariate GLM
% Marta: X*yhat (with X = dat.dat) gives me the multiplication of each voxel in each contrast image by the respective prediction yhat, right?
% Meaning that source recon is the dotproduct of yhat and dat.dat, whereas yhat is the dotproduct of dat.dat and b? 
% Bogdan: you've got it right, except dont forget orientations of the data and order of operations

% 
%% (1) Source reconstruction (subject-level)
% % ----------------------------------------------------------------------- %
% regress in each subj the 4 lvs x 4 stim types (=16 imgs) on yhat 
% -- > I will use regress 'brainony' option and use 'robust'  
% -- > brain = X = dat.dat
% -- > yhat becomes dat.Y 

% Need to rearrange dat.dat first, right now:
% - 880 rows = (55 subj x 4 lvs x 4 stim types)
% - 63545 columns (gm_masked)

%% Prep 
uniq_subj = unique(subjects); 
n_subj = length(uniq_subj);

% assign temporarilly yhat to dat.Y (the computations below are only
% concerning dat.dat and yhat, we don't care about avoidance ratings here) 
dat.X = dat.Y % (to keep it safe) 

%% COMPUTE SR FOR EACH SUBJECT ON CROSS-VAL YHAT
% For each model, run regress (brainony) in each subject 
for m=1:length(models);
    dat.Y = yhat(:,m);  % assign PLS model outcome (yhat) to dat.Y (regression predictee)
    for s = 1:n_subj;
        this_idx = find(uniq_subj(s) == subjects);
        this_dat = dat.get_wh_image(this_idx);
        this_dat.additional_info = dat.additional_info(this_idx);
        this_dat.image_names = [];
        this_dat.fullpath = [];
        %
        if size((this_dat.Y),1) == 16;
            subj_dat{s} = this_dat; % regression predictor
            subj_out_rob{s} = regress(subj_dat{s},'brainony','nodisplay', 'robust');
        else
            fprintf('this_dat.Y should contain 4 x 4 values per subject!')
        end
        
        % SR = regression output per model: 
        mod_out_rob{m}{s}=subj_out_rob{s};  % dat size is preserved (63545) = OK! 
    end
end
%%

%% 
% Save outputs and other useful variables:
% ----------------------------------------------------------------------- %
printhdr('Save output');

% saving SR betas 
savefilename = fullfile(SR_resultsdir, 'SR_out.mat');
save(savefilename, 'mod_out_rob', '-v7.3');

% save for vol Info 
subj_dat_info_for_others = subj_dat{1};
save(savefilename, 'subj_dat', '-append'); % full PLS outcomes 

% to load these files 
                                                                                                                                                                                                                                   

%% Prep SR outputs (=1st level model encoding maps) for 2nd level 
% ---------------------------------------------------------------------- %
% The output are voxel-wise beta values describing the relationship between
% the predictor brain data (dat.dat) and the predictee PLS model outcomes (yhat)
% These betas are saved for each subject in ...b.dat (statistic image), 
% I am going to write each one out and then load them all into one fmri_data
% object per model so I can run a group t-test on those (as I would on 1st-level beta
% maps from a standard univariate analysis) 

% Make all subject identifiers are equally long 
strus =  string(uniq_subj)
struspad = pad(strus,2,'left','0');
subjcell = cellstr(struspad)';

models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

% MODEL ENCODING MAPS:
% Save ROBUST betas from above into image files 
for m=1:length(models)
    for s=1:n_subj
        beta_img = statistic_image;
        beta_img.volInfo = subj_dat{1}.volInfo; % same for all
        beta_img.dat = mod_out_rob{m}{s}.b.dat(:,1); % 1st output = slope, % 2nd = intercept
        beta_img.removed_voxels = mod_out_rob{m}{s}.b.removed_voxels;    % removed_voxels: 104388 logical
        beta_img.fullpath = ([models{m} '_' subjcell{s} '_beta_rob.nii']);
        write(beta_img,'overwrite');
    end
end

% sum (removed_voxels ==1) is 40843 --> 104388 (all data) = 63545 = OK!

% ! mv *_beta_rob.nii data/reg_rob

%% (2) Group (2nd-level) SR maps 
% ------------------------------------------------------------------------%

% Load beta image files into one fmri_object per model
% ---------------------------------%
Gnames = filenames(fullfile(SR_datarobdir,'General*rob.nii'),'absolute');  
Mnames = filenames(fullfile(SR_datarobdir,'Mechanical*rob.nii'),'absolute');
Tnames = filenames(fullfile(SR_datarobdir,'Thermal*rob.nii'),'absolute');
Anames = filenames(fullfile(SR_datarobdir,'Sound*rob.nii'),'absolute');
Vnames = filenames(fullfile(SR_datarobdir,'Visual*rob.nii'),'absolute');

% 
cd(scriptsdir);
SR_obj(1) = fmri_data(Gnames,);  % size(SR_obj(1).dat)
SR_obj(2) = fmri_data(Mnames); 
SR_obj(3) = fmri_data(Tnames);  
SR_obj(4) = fmri_data(Anames);  
SR_obj(5) = fmri_data(Vnames); 

% dat = 104388 values  (whole brain) 
% dat = 72017 GM mask (improved) 

% Append outputs to saved file: 
savefilename = fullfile(SR_resultsdir, 'SR_out.mat');
%save(savefilename, 'SR_obj', '-append');

load(savefilename, 'SR_obj');

% Histos look good, Global mean looks good
% Mahanolobis Dist: 
plot(SR_obj(1)); % 1 outlier uncorr, 0 corr
plot(SR_obj(2)); % 1 outlier uncorr, 0 corr
plot(SR_obj(3)); % 1 outlier uncorr, 0 corr 
plot(SR_obj(4)); % 1 outlier uncorr, 0 corr 
plot(SR_obj(5)); % 3 outliers uncorr, 0 corr 


% T-test and save output for further calculations
% ---------------------------------%
for m=1:5
    SR_statimg = ttest (SR_obj(m));
    
    pls_encode_statimg(m) = SR_statimg
    
    SR_statimg = threshold (SR_statimg, .05, 'fdr');
    pls_encode_statimg_fdr05(m) = SR_statimg
end

% Save unthresholded maps 
% ---------------------------------%
for m=1:5
    SR_statimg = ttest (SR_obj(m));

    SR_statimg.fullpath=[models{m} '_PLS_model_encoder_unthr.nii'];
%     write(SR_statimg, 'overwrite');
    write(SR_statimg, 'thresh', 'overwrite');
    
    figure; montage(SR_statimg); figtitle = sprintf([models{m} '_PLS_model_encoder_unthr.png'])
    savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
end


% Save fdr-thresholded maps 
% ---------------------------------%
for m=1:5
    SR_statimg = ttest (SR_obj(m));
    SR_statimg = threshold (SR_statimg, .05, 'fdr', 'k', 10);
    SR_statimg.fullpath=[models{m} '_PLS_model_encoder_FDR05.nii'];
%     write(SR_statimg, 'overwrite');
    write(SR_statimg, 'thresh', 'overwrite');
    
    figure; montage(SR_statimg); figtitle = sprintf([models{m} '_PLS_model_encoder_FDR05.png'])
    savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
end


%% Save pls model encoder stat image  
savefilename = fullfile(SR_resultsdir, 'SR_out.mat');
save(savefilename, 'pls_encode_statimg', '-append');
save(savefilename, 'pls_encode_statimg_fdr05', '-append');

%load(savefilename, 'pls_encode_statimg');


%% Save montages for figures 

% GENERAL 
o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    % Threshold maps for figure @ positive values, some reasonable p value
    SR_statimg = ttest (SR_obj(m));

    SR_statimg = threshold (SR_statimg, [3 Inf], 'raw-between');
 
    montage(SR_statimg, o2, 'wh_montages', 1:2, 'maxcolor', [0.4 0 0.6], 'mincolor', [0.1 0.1 0.1]);
%     colormaxg = [0.9 0.9 1]
%     colorming = colormaxg-0.5
%     montage(SR_statimg, o2, 'wh_montages', m:m+1, 'maxcolor', colormaxg, 'mincolor', colorming);
end

figtitle = sprintf(['GEN_PLS_modelencoder_pos_t3_violet.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% PER MODALITY 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

colormax= [1 0.2 0.4;
            1 0.6 0.2;
            0 0.6 0.4;
            0 0.4 1];
colormin = colormax-0.3;

for m = 2:5
    % Threshold maps for figure @ positive values, some reasonable p value
    SR_statimg = ttest (SR_obj(m)); 
    
    SR_statimg = threshold (SR_statimg, [3 Inf], 'raw-between');
  
    %montage(SR_statimg,o2, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
    o2=addblobs(o2,SR_statimg, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
end

figtitle = sprintf(['MODALITIES_PLS_modelencoder_pos_t3.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


%% (3) SHARED REGIONS via positive conjunction analysis of SR maps 
% SR maps include pos and neg values
% ------------------------------------------------------------------------%

o2 = canlab_results_fmridisplay([], 'multirow', 4);

colormax= [1 0.2 0.4;
            1 0.6 0.2;
            0 0.6 0.4;
            0 0.4 1];
colormin = colormax-0.3;


% Positive conjunction ('1' flag) performed on FDR-corr maps derived from betas, save png files for figure
for m=2:length(models)
    
    % Each model w general
    conj(m) = conjunction (pls_encode_statimg_fdr05(m), pls_encode_statimg_fdr05(1),1);
    
    %o2=addblobs(o2,region(conj(m)),'trans','color', [1 0 0]);
    o2=addblobs(o2,region(conj(m)),'wh_montages', m*2-3:m*2-2, 'color', colormax (m-1,:));

end
figtitle = sprintf('Conjunction_MODS_and_GEN_SRwtnROB_conj.png');
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% Conj of mechanical and thermal + their maps 

% Re-recreate tmaps 
tmech = ttest (SR_obj(2));
tmech = threshold (tmech, [3 Inf], 'raw-between');

ttherm = ttest (SR_obj(3));
ttherm = threshold (ttherm, [3 Inf], 'raw-between');

% Create display 
o2 = canlab_results_fmridisplay([], 'multirow', 2);

% Tmech, therm
o2=addblobs(o2,region(tmech),'wh_montages', 3:4, 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));
o2=addblobs(o2,region(ttherm),'wh_montages', 3:4, 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));


% % Overlap
conj_pain = conjunction (pls_encode_statimg_fdr05(2), pls_encode_statimg_fdr05(3), 1);
o2=addblobs(o2,region(conj_pain),'wh_montages', 1:2, 'trans', 'color', [1 1 0]);
o2=addblobs(o2,region(conj_pain),'wh_montages', 3:4, 'trans', 'color', [1 1 0]);

figtitle = sprintf('Conjunction_MECHandTHERM_SRwtnROB_conj.png');
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;



%% (4) KEY WINNER REGIONS via Model - max (all - model) computations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPROACH: 
% Use rob reg SR maps
% Compute model - max (all - model) for each subject
% T-test across subjects 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reminder:
%         % regression output per model: 
%         mod_out{m}{s}=subj_out{s};
%         mod_out_rob{m}{s}=subj_out_rob{s};
%     end
% end

uniq_subj = unique(subjects); 
n_subj = length(uniq_subj);

clear maxmodels 
for s=1:n_subj;
    
    % Max across MTAV to subtract from G
    max_mod = max([mod_out_rob{2}{s}.b.dat(:,1) mod_out_rob{3}{s}.b.dat(:,1) mod_out_rob{4}{s}.b.dat(:,1) mod_out_rob{5}{s}.b.dat(:,1)]');
    max_mod =  max_mod';
    maxmodels{1}{s} = max_mod;
    clear max_mod
    
    %mean_mod = mean ([mod_out_rob{2}{s}.b.dat(:,1) mod_out_rob{3}{s}.b.dat(:,1) mod_out_rob{4}{s}.b.dat(:,1) mod_out_rob{5}{s}.b.dat(:,1)]');
    
    % Max across TAVG to subtract from M 
    max_mod = max([mod_out_rob{3}{s}.b.dat(:,1) mod_out_rob{4}{s}.b.dat(:,1) mod_out_rob{5}{s}.b.dat(:,1) mod_out_rob{1}{s}.b.dat(:,1)]');
    max_mod =  max_mod';
    maxmodels{2}{s} = max_mod;
    clear max_mod
    
    % Max across AVGM to subtract from T
    max_mod = max([mod_out_rob{4}{s}.b.dat(:,1) mod_out_rob{5}{s}.b.dat(:,1) mod_out_rob{1}{s}.b.dat(:,1) mod_out_rob{2}{s}.b.dat(:,1)]');
    max_mod =  max_mod';
    maxmodels{3}{s} = max_mod;
    clear max_mod
    
    % Max across VGTM to substract from A
    max_mod = max([mod_out_rob{5}{s}.b.dat(:,1) mod_out_rob{1}{s}.b.dat(:,1) mod_out_rob{2}{s}.b.dat(:,1) mod_out_rob{3}{s}.b.dat(:,1)]');
    max_mod =  max_mod';
    maxmodels{4}{s} = max_mod;
    clear max_mod
    
    % Max across GTMA to subtract from V
    max_mod = max([mod_out_rob{1}{s}.b.dat(:,1) mod_out_rob{2}{s}.b.dat(:,1) mod_out_rob{3}{s}.b.dat(:,1) mod_out_rob{4}{s}.b.dat(:,1)]');
    max_mod =  max_mod';
    maxmodels{5}{s} = max_mod;
    clear max_mod
end


%% 
% % Save output:
% printhdr('Save output');
% 
% savefilename = fullfile(SR_resultsdir, 'Maxmodels_rob_per_sub.mat');
% save(savefilename, 'maxmodels', '-v7.3');

% Make all subject identifiers equally long 
strus =  string(uniq_subj)
struspad = pad(strus,2,'left','0');
subjcell = cellstr(struspad)';

for m=1:length(models);
    for s=1:n_subj;
        % subtract max across all but m from m 
        m_min_maxmodels{m}{s} = mod_out_rob{m}{s}.b.dat(:,1) - maxmodels{m}{s}
    end
end

% Save outputs from above into image files
for m=1:length(models)
    for s=1:n_subj;
        max_img = statistic_image; 
        max_img.volInfo = subj_dat{1}.volInfo;% same for all
        max_img.removed_voxels =  subj_dat{1}.removed_voxels % same for all
        max_img.dat = m_min_maxmodels{m}{s}; %
        max_img.fullpath = ([models{m} '_' subjcell{s} '_m_minus_max_wtn_rob.nii']);
        write(max_img,'overwrite');
    end
end
! mv *_rob.nii ../data/m_minus_max_rob

% 2nd-level t-test 
% ------------------------------------------------------------------------%

% Load image files into one fmri_object per model
% ---------------------------------%
SR_data_m_min_max = fullfile(SR_datadir, 'm_minus_max_rob');
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};
Gnames = filenames(fullfile(SR_data_m_min_max,'General*m_minus_max_wtn_rob.nii'),'absolute');
Mnames = filenames(fullfile(SR_data_m_min_max,'Mechanical*m_minus_max_wtn_rob.nii'),'absolute');
Tnames = filenames(fullfile(SR_data_m_min_max,'Thermal*m_minus_max_wtn_rob.nii'),'absolute');
Anames = filenames(fullfile(SR_data_m_min_max,'Sound*m_minus_max_wtn_rob.nii'),'absolute');
Vnames = filenames(fullfile(SR_data_m_min_max,'Visual*m_minus_max_wtn_rob.nii'),'absolute');

% Model Minus Max objects 
MMM_obj(1) = fmri_data(Gnames);  
MMM_obj(2) = fmri_data(Mnames); 
MMM_obj(3) = fmri_data(Tnames);  
MMM_obj(4) = fmri_data(Anames);  
MMM_obj(5) = fmri_data(Vnames); 


%%
% Save output:
printhdr('Save output');

savefilename = fullfile(SR_resultsdir, 'Maxmodels_rob_per_sub.mat');
save(savefilename, 'MMM_obj', '-append');
load(savefilename, 'MMM_obj');


% T-test, threshold and write to .nii
% ---------------------------------%
for m=1:5;
    t_min_maxt = ttest (MMM_obj(m));
    
    t_min_maxt = threshold (t_min_maxt, .05, 'fdr');
    
    t_min_maxt.fullpath=[models{m} '_minus_maxothers_FDR05.nii'];
    write(t_min_maxt, 'overwrite');
    
    t_min_maxt = threshold (t_min_maxt,[0 Inf],'raw-between');
    t_min_maxt.dat(~t_min_maxt.sig) = nan;
    t_min_maxt.fullpath=[models{m} '_minus_maxothers_pos.nii'];
    write(t_min_maxt, 'overwrite');
end


% Added this later to save with name matching the other stat maps 

% T-test and save output for further calculations
% ---------------------------------%
for m=1:5
    MMM_statimg = ttest (MMM_obj(m));
    
    pls_selectencode_statimg(m) = MMM_statimg
    
    MMM_statimg = threshold (MMM_statimg, .05, 'fdr');
    pls_selectencode_statimg_fdr05(m) = MMM_statimg
end

% Append 
savefilename = fullfile(SR_resultsdir, 'Maxmodels_rob_per_sub.mat');
save(savefilename, 'pls_selectencode_statimg', '-append');
save(savefilename, 'pls_selectencode_statimg_fdr05', '-append');

% Also append to the file with all the other relevant PLS stat imgs 
savefilename = fullfile(resultsdir,'PLS_stat_images.mat');

% save type-selective model encoders
save(savefilename, 'pls_selectencode_statimg', '-append');
save(savefilename, 'pls_selectencode_statimg_fdr05', '-append'); 


% GENERAL -- all values are negative, i.e. no result to include in Fig. 
o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    t_min_maxt = ttest (MMM_obj(m));
    %t_min_maxt = threshold (t_min_maxt, .05, 'fdr');
    
    t_min_maxt = threshold (t_min_maxt,[0 Inf],'raw-between');
    %t_min_maxt.dat(~t_min_maxt.sig) = nan;

    montage(t_min_maxt, o2, 'wh_montages', m:m+1, 'maxcolor', [0.9 0.9 1], 'mincolor', [0.1 0.1 0.1]);
end
    
figtitle = sprintf(['GEN_minus_maxothers_pos.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% PER MODALITY
o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m = 2:5
    % Threshold maps for figure @ positive values, some reasonable p value
    t = ttest (MMM_obj(m)); 
  
    t = threshold(t, [0 Inf],'raw-between'); % 
    %t = threshold(t, .05, 'fdr');
    %o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
    o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'contour', 'color',colormax(m-1,:));
end

figtitle = sprintf(['Disjunction_MODS_minus_maxothers_pos.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

diary on
diaryname = fullfile(['PLS_KEY_Clusters_tables_' date '_output.txt']);
diary(diaryname);

%%  print table of significant regions 
 for m = 2:5
    t = ttest (MMM_obj(m)); 
    t = threshold(t, [0 Inf],'raw-between');  % retain positive 
    r = region(t);
    table(r);
 end 
 
 diary off
 
% savefilename = fullfile(SR_resultsdir, 'SR_out.mat');
% save(savefilename, 'tt', '-append');


%% Map disjunction key areas to Yeo17
% target
bb_create_yeo17_compact_atlas
yeo1=Yeo17_compact
yeo1.image_names = strrep (yeo1.labels, '_', '  ');

pattcolors = {[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}'

% FDR
keyareas_FDR=load_mmm_maps_thr
image_similarity_plot(keyareas_FDR,'mapset',yeo1,'networknames',yeo1.image_names, 'plotstyle', 'polar', 'colors', pattcolors);

figtitle = sprintf(['Yeo17polar_key_disjunction_FDR.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% FOR FIGURE: Fix range, remove labels, remove r-values
yeo1.image_names = {'' '' '' '' '' '' '' '' '' '' '' '' '' '' '' ''}
keyareas_FDR=load_mmm_maps_thr
image_similarity_plot(keyareas_FDR,'mapset',yeo1,'networknames',yeo1.image_names,'plotstyle', 'polar', 'colors', pattcolors);
hh = findobj(gca, 'Type', 'Text');  delete(hh);

figtitle = sprintf(['Yeo17polar_key_disjunction_NO_LABELS_FDR.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%v

%% (5) KEY PAIN (therm/mech) REGIONS via therm/mech Model  - mech/therm model computations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPROACH: 
% Use rob reg SR maps
% Compute model - model for each subject
% T-test across subjects 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% end
%%
uniq_subj = unique(subjects); 
n_subj = length(uniq_subj);

% Make all subject identifiers equally long 
strus =  string(uniq_subj)
struspad = pad(strus,2,'left','0');
subjcell = cellstr(struspad)';


for s=1:n_subj;
    % subtract max across all but m from m
    mech_min_therm{s} = mod_out_rob{2}{s}.b.dat(:,1) - mod_out_rob{3}{s}.b.dat(:,1);
    therm_min_mech{s} = mod_out_rob{3}{s}.b.dat(:,1) - mod_out_rob{4}{s}.b.dat(:,1)
end


% Save outputs from above into image files
for s=1:n_subj;
    max_img = statistic_image;
    max_img.volInfo = subj_dat{1}.volInfo;% same for all
    max_img.removed_voxels = mod_out_rob{2}{s}.b.removed_voxels;
    max_img.dat = mech_min_therm{s}; %
    max_img.fullpath = ([models{2} '_' subjcell{s} '_mech_min_therm_wtn_rob.nii']);
    write(max_img,'overwrite');
end

% Save outputs from above into image files
for s=1:n_subj;
    max_img = statistic_image;
    max_img.volInfo = subj_dat{1}.volInfo;% same for all
    max_img.removed_voxels = mod_out_rob{3}{s}.b.removed_voxels;
    max_img.dat = therm_min_mech{s}; %
    max_img.fullpath = ([models{3} '_' subjcell{s} '_therm_min_mech_wtn_rob.nii']);
    write(max_img,'overwrite');
end


! mv *_rob.nii ../data/m_minus_m

% 2nd-level t-test 
% ------------------------------------------------------------------------%

% Load image files into one fmri_object per model
% ---------------------------------%

% datadir for model minus model (m minus m)
SR_data_m_min_m = fullfile(SR_datadir, 'm_minus_m');
Mnames = filenames(fullfile(SR_data_m_min_m,'Mechanical_*rob.nii'),'absolute');

SR_data_m_min_m = fullfile(SR_datadir, 'm_minus_m');
Tnames = filenames(fullfile(SR_data_m_min_m,'Thermal_*rob.nii'),'absolute');

% Model minus M objects 
MM_obj(1) = fmri_data(Mnames);  
MM_obj(2) = fmri_data(Tnames); 

% all of these have 72017 voxels

% Save output:
printhdr('Save output');

savefilename = fullfile(SR_resultsdir, 'ModelminModel_rob_per_sub.mat');
save(savefilename, 'MM_obj', '-append');


% T-test, threshold and write to .nii
% ---------------------------------%

% Mech on Therm
% m_min_t = ttest (MM_obj(1));
% m_min_t = threshold (m_min_t, .05, 'fdr');
% m_min_t.fullpath=[models{2} '_ROB_wtn_m_min_t_FDR05.nii'];
% write(m_min_t, 'overwrite');
% 
% m_min_t= threshold (t_min_maxt,[0 Inf],'raw-between');
% m_min_t.dat(~m_min_t.sig) = nan;
% m_min_t.fullpath=[models{2} '_ROB_wtn_m_min_t_pos.nii'];
% write(m_min_t, 'overwrite');
% 
% % Therm on mech
% t_min_m = ttest (MM_obj(2));
% t_min_m = threshold (t_min_m, .05, 'fdr');
% t_min_m.fullpath=[models{3} '_ROB_wtn_t_min_m_FDR05.nii'];
% write(t_min_m, 'overwrite');
% 
% t_min_m = threshold (t_min_m,[0 Inf],'raw-between');
% t_min_m.dat(~t_min_m.sig) = nan;
% t_min_m.fullpath=[models{3} '_ROB_wtn_t_min_m_pos.nii'];
% write(t_min_m, 'overwrite');


diary on
diaryname = fullfile(['ClustersPaint3_tables_sorted_' date '_output.txt']);
diary(diaryname);

%%  print table of significant regions 
 for m = 1:2
    t = ttest (MM_obj(m)); 
    t = threshold (t, .05, 'fdr');
    t = threshold(t, [3 Inf],'raw-between');  % retain positive 
    r = region(t);
    %figure; montage (r, 'regioncenters')
    table(r);
 end 
 
 diary off




colorpain= [1 0.4 0.6;
            1 0.6 0.4];

%% PER MODALITY
o2 = canlab_results_fmridisplay([], 'multirow', 4);

% Threshold maps for figure @ positive values, some reasonable p value
t = ttest (MM_obj(1));

t = threshold(t, [3 Inf],'raw-between'); 
%
%t = threshold(t, .05, 'fdr');
%o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
o2=addblobs(o2,t, 'wh_montages', 3:4, 'contour','color',colorpain(1,:));

t = ttest (MM_obj(2));

t = threshold(t, [3 Inf],'raw-between'); %
%t = threshold(t, .05, 'fdr');
%o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
o2=addblobs(o2,t, 'wh_montages',5:6, 'contour','color',colorpain(2,:));

% % Overlap
conj_pain = conjunction (t_bs_rob(2), t_bs_rob(3), 1);
o2=addblobs(o2,region(conj_pain),'wh_montages', 7:8, 'trans', 'color', [1 1 0]);

%% ADD MECH + THERM on top of each other 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

t = ttest (MM_obj(2));

t = threshold(t, [3 Inf],'raw-between'); %
%t = threshold(t, .05, 'fdr');
%o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
o2=addblobs(o2,t, 'wh_montages',7:8, 'contour','color',colorpain(2,:));

t = ttest (MM_obj(1));

t = threshold(t, [3 Inf],'raw-between'); %
%t = threshold(t, .05, 'fdr');
%o2=addblobs(o2,t, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
o2=addblobs(o2,t, 'wh_montages', 7:8, 'contour','color',colorpain(1,:));


figtitle = sprintf(['Disjunction_colormin_MODS_ONTOP_wtn_minus_pain_pos.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% 









