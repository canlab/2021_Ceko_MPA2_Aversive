
%% This code rethresholds output maps 

% run first:
% a_set_up_paths ...
% a2_mc_set_up_paths
% a2_set_default_options




%% load and GM mask data 

% load images and behavior 
% ----------------------------------------------

load(fullfile(dataobjdir, 'data_objects.mat')); 

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


%% Load boot outcomes, save unthr and thresholded boot maps 

cd(qcdir);
load(fullfile(qcdir,'PLS_bootstats10000_N55_gm.mat'));
load(fullfile(qcdir,'PLS_crossvalidated_N55_gm.mat'));

diary ('Bootstrapped_maps_thresholding_qc');

models = {'General' 'Pressure' 'Thermal' 'Sound' 'Visual'};

for m=1:length(models)
    
    bsb_stat=statistic_image;
    bsb_stat.volInfo=dat.volInfo;
    bsb_stat.dat=b_Z_coeff(:,m);
    bsb_stat.p=b_P_coeff(:,m);
    bsb_stat.removed_voxels=dat.removed_voxels; 

    % Unthresholded 
    %bsb_stat.dat(~bsb_stat.sig)=nan;
    bsb_stat.fullpath=[models{m} '_b10000_qc_unthr.nii'];
    write(bsb_stat, 'overwrite'); 
    
    % 01 uncorrected 
    % ------------------------------------------
    bsb_stat=threshold(bsb_stat,.01,'unc','k',10);
    bsb_stat.fullpath=[models{m} '_b10000_qc_unc01.nii'];
    write(bsb_stat, 'overwrite');
    %orthviews(bsb_stat);pause(5)  

    % 001 uncorrected 
    % ------------------------------------------
    bsb_stat=threshold(bsb_stat,.001,'unc','k',10);
    bsb_stat.fullpath=[models{m} '_b10000_qc_unc001.nii'];
    write(bsb_stat, 'overwrite');
    %orthviews(bsb_stat);pause(5)

    % FDR corr
    % -----------------------------------------
    bsb_stat=threshold(bsb_stat,.05,'fdr','k',10);
    bsb_stat.fullpath=[models{m} '_b10000_qc_FDR05.nii'];
    write(bsb_stat, 'overwrite');
    %orthviews(bsb_stat);pause(5)
end

diary off




