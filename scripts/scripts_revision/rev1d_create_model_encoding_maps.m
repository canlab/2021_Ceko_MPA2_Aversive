%% Computation of model encoding maps a.k.a source reconstruction (SR) 

% (1) subject-level encode (=SR) maps by (ROBUST) regressing univariate brain maps (dat.dat) onto PLS outcomes (yhat)

% (2) group level encode maps 
% - 2nd level t-test across SR maps to obtain group maps 

% (3) SHARED REGIONS: 
% - Conjunction analyses on 2nd level maps

% (4) DISJUNCTION 

%% Define dirs for these analyses 
encode_scriptsdir = scriptsrevdir;
encode_resultsdir = fullfile (resultsrevdir, 'results_encode');

encode_datadir = fullfile(encode_resultsdir, 'data');
encode_datarobdir = fullfile(encode_datadir, 'reg_rob'); % robust regression
encode_datamaxrobdir = fullfile(encode_datadir, 'max_rob'); 

%% Load data 
cd(scriptsrevdir);

load(fullfile(resultsrevdir, 'data_objects.mat')); 
import_Behav_NEGPOS %

models = {'NGeneral' 'NVisneg' 'NVispos'}; 
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

% reorganize behavior into dat.Y
% ----------------------------------------------
norm_mat=condf2indic(modality);
for i=1:size(norm_mat,1)
    norm_mat(i,find(norm_mat(i,:)))=dat.Y(i);
    
end
norm_mat=[dat.Y norm_mat];

dat.removed_images=0;
dat.removed_voxels=0;
dat.additional_info = subjects 

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

%% Load yhat 
load(fullfile(resultsrevdir, 'NORMPLS_crossvalidated_N55_gm.mat'));

%% (1) Source reconstruction (subject-level)
% % ----------------------------------------------------------------------- %
% regress in each subj the 4 lvs x 2 stim types (=8 imgs) on yhat 
% -- > I will use regress 'brainony' option and use 'robust'  
% -- > brain = X = dat.dat; yhat becomes dat.Y 

% Need to rearrange dat.dat first, right now:
% - 440 rows = (55 subj x 4 lvs x 2 stim types)
% - 63545 columns (gm_masked)

%% Prep 
uniq_subj = unique(subjects); 
n_subj = length(uniq_subj);

% assign temporarilly yhat to dat.Y (the computations below are only
% concerning dat.dat and yhat, we don't care about subj ratings here) 
dat.X = dat.Y % (to keep it safe) 
linestr = '______________________________________________________';

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
        if size((this_dat.Y),1) == 8;
            subj_dat{s} = this_dat; % regression predictor
            subj_out_rob{s} = regress(subj_dat{s},'brainony','nodisplay', 'robust');
        else
            fprintf('this_dat.Y should contain 2 x 4 values per subject!')
        end
        
        % SR = regression output per model: 
        mod_out_rob{m}{s}=subj_out_rob{s};  % dat size is preserved (63545) = OK! 
    end
end

% 
% Save outputs and other useful variables:
% ----------------------------------------------------------------------- %
printhdr('Save output');

savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
save(savefilename, 'mod_out_rob', '-v7.3');

subj_dat_info_for_others = subj_dat{1};
save(savefilename, 'subj_dat', '-append'); % full PLS outcomes 

%% Prep outputs (=1st level model encoding maps) for 2nd level 
% ---------------------------------------------------------------------- %
% Make all subject identifiers are equally long 
strus =  string(uniq_subj)
struspad = pad(strus,2,'left','0');
subjcell = cellstr(struspad)';

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

% ok for revision analysis
% sum(beta_img.removed_voxels ==1) is 40843 --> 104388 (all data) = 63545 = OK!

! mv *_beta_rob.nii '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/results/results_revision/results_encode/data'

%% (2) Group (2nd-level) encode maps 
% ------------------------------------------------------------------------%
% Load beta image files into one fmri_object per model
% ---------------------------------%
NGeneral_names = filenames(fullfile(encode_datarobdir,'NGeneral*rob.nii'));  
NVisneg_names = filenames(fullfile(encode_datarobdir,'NVisneg*rob.nii'));
NVispos_names = filenames(fullfile(encode_datarobdir,'NVispos*rob.nii'));
% 
cd(scriptsrevdir);
encode_obj(1) = fmri_data(NGeneral_names);  % size(SR_obj(1).dat)
encode_obj(2) = fmri_data(NVisneg_names); 
encode_obj(3) = fmri_data(NVispos_names);  

% dat = 104388 values  (whole brain) 
% dat = 72017 GM mask (improved) 

% Append outputs to saved file
% ----------------------------------------------------------------------- %
savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
save(savefilename, 'encode_obj', '-append');

% Mahanolobis Dist: 
plot(encode_obj(1)); % a few outliers uncorr, 0 corr
plot(encode_obj(2)); % a few outliers uncorr, 0 corr
plot(encode_obj(3)); % a few outliers uncorr, 0 corr 


% T-test and save output for further calculations
% ---------------------------------%
for m=1:3
    encode_statimg = ttest (encode_obj(m));
    
    pls_encode_statimg(m) = encode_statimg;
    
    encode_statimg = threshold (encode_statimg, .05, 'fdr');
    pls_encode_statimg_fdr05(m) = encode_statimg;
end

% Save unthresholded maps 
% ---------------------------------%
for m=1:3
    encode_statimg = ttest (encode_obj(m));

    encode_statimg.fullpath=[models{m} '_NPLS_model_encoder_unthr.nii'];
%     write(SR_statimg, 'overwrite');
    write(encode_statimg, 'thresh', 'overwrite');
    
    figure; montage(encode_statimg); figtitle = sprintf([models{m} '_NORMPLS_model_encoder_unthr.png'])
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
end

% Save fdr-thresholded maps 
% ---------------------------------%
for m=1:3
    encode_statimg = ttest (encode_obj(m));
    encode_statimg = threshold (encode_statimg, .05, 'fdr', 'k', 10);
    encode_statimg.fullpath=[models{m} '_NPLS_model_encoder_FDR05.nii'];
%     write(SR_statimg, 'overwrite');
    write(encode_statimg, 'thresh', 'overwrite');
    
    figure; montage(encode_statimg); figtitle = sprintf([models{m} '_NORMPLS_model_encoder_FDR05.png'])
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
end

% Append to saved stats  
% ----------------------------------------------------------------------- %
savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
save(savefilename, 'pls_encode_statimg', '-append');
save(savefilename, 'pls_encode_statimg_fdr05', '-append');

