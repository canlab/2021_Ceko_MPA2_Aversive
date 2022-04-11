%% Computation of model encoding maps a.k.a source reconstruction (SR) 

% (1) subject-level encode (=SR) maps by (ROBUST) regressing univariate brain maps (dat.dat) onto PLS outcomes (yhat)

% (2) group level encode maps 
% - 2nd level t-test across SR maps to obtain group maps 

% (3) SHARED REGIONS: 
% - Conjunction analyses on 2nd level maps


%% Define dirs for these analyses 
encode_scriptsdir = scriptsrevdir;
encode_resultsdir = fullfile (resultsrevdir, 'results_encode');

encode_datadir = fullfile(encode_resultsdir, 'data');
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

% dat 104388 x 440 single
% nvox = 271633
% n_inmask / wh_inmask = 104388

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

% dat 63545 x 440 single
% nvox = still 271633  
% n_inmask / wh_inmask =sstill 104388


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
% For each model (1 - 3), run regress (brainony) in each subject (1 - 55)
for m=1:length(models)
    dat.Y = yhat(:,m);  % assign PLS model outcome (yhat) to dat.Y (regression predictee)
    for s = 1:n_subj
        this_idx = find(uniq_subj(s) == subjects);
        this_dat = dat.get_wh_image(this_idx);
        this_dat.additional_info = dat.additional_info(this_idx);
        this_dat.image_names = [];
        this_dat.fullpath = [];
        %
        
        if size((this_dat.Y),1) == 8
            subj_dat{s} = this_dat; % regression predictor
            m % log moodel
            s % log subject 
            subj_out_rob{s} = regress(subj_dat{s},'brainony','nodisplay', 'robust');
        else
            fprintf('this_dat.Y should contain 2 x 4 values per subject!')
        end
        
        % SR = regression output per model: 
        mod_out_rob{m}{s}=subj_out_rob{s};  % dat size is preserved (63545) = OK! 
        % volInfo, as above, % nvox =  271633, n_inmask / wh_inmask =sstill 104388
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
strus =  string(uniq_subj);
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
        % beta_img.volInfo, as above, dat: [63545×1 single], % nvox =  271633, n_inmask / wh_inmask = still 104388
    end
end

% check size
ng=fmri_data('NGeneral_01_beta_rob.nii'); % dat: [72017×1 single] %nvox = 271633, n_inmask: 72017 .... why? 

% ok for revision analysis
% sum(beta_img.removed_voxels ==1) is 40843 --> 104388 (all data) = 63545 = OK!

! mv *_beta_rob.nii '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/results/results_revision/results_encode/data'

%% (2) Group (2nd-level) encode maps 
% ------------------------------------------------------------------------%
% Load beta image files into one fmri_object per model
% ---------------------------------%
NGeneral_names = filenames(fullfile(encode_datadir,'NGeneral*rob.nii'));  
NVisneg_names = filenames(fullfile(encode_datadir,'NVisneg*rob.nii'));
NVispos_names = filenames(fullfile(encode_datadir,'NVispos*rob.nii'));
% 
cd(scriptsrevdir);
clear Nencode_obj
Nencode_obj(1) = fmri_data(NGeneral_names);
Nencode_obj(2) = fmri_data(NVisneg_names); 
Nencode_obj(3) = fmri_data(NVispos_names); 

% Append outputs to saved file
% ----------------------------------------------------------------------- %
savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
save(savefilename, 'Nencode_obj', '-append');

% Mahanolobis Dist: 
plot(Nencode_obj(1)); % a few outliers uncorr, 0 corr
plot(Nencode_obj(2)); % a few outliers uncorr, 0 corr
plot(Nencode_obj(3)); % a few outliers uncorr, 0 corr 


%% T-test and save output for further calculations
% ---------------------------------%
for m=1:3
    Nencode_statimg = ttest (Nencode_obj(m));
    
    Npls_encode_statimg(m) = Nencode_statimg;
    
    Nencode_statimg = threshold (Nencode_statimg, .05, 'fdr');
    Npls_encode_statimg_fdr05(m)= Nencode_statimg;
    
end

% Save unthresholded maps 
% ---------------------------------%
for m=1:3
    Nencode_statimg = ttest (Nencode_obj(m));

    Nencode_statimg.fullpath=[models{m} '_NPLS_model_encoder_unthr.nii'];
%     write(SR_statimg, 'overwrite');
    write(Nencode_statimg, 'thresh', 'overwrite');
    
    figure; montage(Nencode_statimg); figtitle = sprintf([models{m} '_NORMPLS_model_encoder_unthr.png'])
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
end

% Save fdr-thresholded maps 
% ---------------------------------%

for m=1:3
    Nencode_statimg = ttest (Nencode_obj(m));
    Nencode_statimg = threshold (Nencode_statimg, .05, 'fdr', 'k', 10);
    Nencode_statimg.fullpath=[models{m} '_NPLS_model_encoder_FDR05.nii'];
% %     write(SR_statimg, 'overwrite');
    write(Nencode_statimg, 'thresh', 'overwrite');
    
    figure; montage(Nencode_statimg); figtitle = sprintf([models{m} '_NORMPLS_model_encoder_FDR05.png'])
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

end


% save table of clusters < 0.05 FDR, k 10
% ---------------------------------%
r=[]; 
poscl = []; negcl = []; results_table = [];

for m=1:3
    Nencode_statimg(m) = ttest (Nencode_obj(m));
    Nencode_statimg(m) = threshold (Nencode_statimg(m), .05, 'fdr', 'k', 10);
    r{m} = region(Nencode_statimg(m))
    [poscl{m}, negcl{m}, results_table{m}] = table(r{m}, 'nosep');
    results = results_table{m}; writetable(results,[models{m} '_encode_clusters.txt']);
end


% Append to saved stats  
% ----------------------------------------------------------------------- %
savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
save(savefilename, 'Npls_encode_statimg', '-append');
save(savefilename, 'Npls_encode_statimg_fdr05', '-append');




