%% Core multimodal / specific systems 

% This script creates core systems via conjunction between weight maps and model encoding maps 
% run a_set_up_paths_always_run_first.m

%% set working dir and model names 

working_dir = scriptsrevdir;
% brain model names 
models = {'NGeneral' 'NVisneg' 'Vispos'}; 


load(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_gm.mat'));

% check size & space 21/26/21 
% This loads the pls model weight statistical images for each model:
% pls_bsb_statimg(1) - dat size: 63545 x 1;          nvox: 271633 n_inmmask: 104388 
% pls_bsb_statimg_fdr05(1) - - dat size: 63545 x 1;  nvox: 271633 n_inmmask: 104388 
%
% Model encoding maps  
% ----------------------------------------------------------------- % 
load(fullfile(resultsrevdir, 'results_encode/encode_out.mat')); 

% This loads the pls model encoding statistical images for each model:
% Npls_encode_statimg(1) - dat size:  72017 x 1;    nvox: 271633 n_inmask: 72017
% Npls_encode_statimg_fdr05(1) - dat size: 63391×1; nvox: 271633 n_inmask: 72017

% n_inmask is reduced during .... because the fmri_obj ...
 
% 
%% Create core systems via conjunction of model weight + model encoding statistical images for each model
% ------------------------------------------------------------------------%
for m=1:length(models)
    % conjunction model weights and model encoders 
    
%     Use larger image first here (conj probably takes info from the first image and that one seems more fitting here (for the montage below) -
%     If I use bs_statimg_fdr05 as the first image for conj instead, it throws an error: "illegal size for mask.dat, because it does not match ins volInfo structure"
    Npls_core_statimg(m) = conjunction (Npls_encode_statimg_fdr05(m),pls_bsb_statimg_fdr05(m),1);
end
% did not work
% Error using statistic_image/conjunction (line 24)
% Objects are not in same space --- compare_space option 3 

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

Npls_encode_resampled(m) = resample_space(pls_encode_statimg_fdr05(m),gm_mask);
Npls_bs_resampled(m) = resample_space(pls_bs_statimg_fdr05(m),gm_mask);

for m=1:length(models)
    % conjunction model weights and model encoders 
    
%     Use larger image first here (conj probably takes info from the first image and that one seems more fitting here (for the montage below) -
%     If I use bs_statimg_fdr05 as the first image for conj instead, it throws an error: "illegal size for mask.dat, because it does not match ins volInfo structure"
    Npls_core_statimg(m) = conjunction (Npls_encode_resampled(m),Npls_bs_statimg_fdr05(m),1);
end
% still not working 

%% Visualization
% ------------------------------------------------------------------------%
colormax = [0.9 0.7 0;
            0.2 0.8 1;  % light blue
           1 0.4 1]; 
       
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 3);

for m=1:3
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', m*2-1:m*2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_NORMPLS_weights_encoders_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;


% T-test and save output for further calculations
% ---------------------------------%
for m=1:5
    core_statimg =  core_system(m);
    
    core_statimg = threshold (core_statimg, .05, 'fdr', 'k', 10);
    pls_core_statimg_fdr05(m) = core_statimg;
end

% Save all stat images in one location (redundancy, shareable)
% -------------------------------------------------------------------------
savefilename = fullfile(resultsrevdir,'PLS_stat_images.mat');

% save core systems derived from model weights + model encoders
save(savefilename, 'pls_core_statimg', '-v7.3');

% save model weights 
save(savefilename, 'pls_bs_statimg', '-append');
save(savefilename, 'pls_bs_statimg_fdr05', '-append'); 

% save model encoders
save(savefilename, 'pls_encode_statimg', '-append');
save(savefilename, 'pls_encode_statimg_fdr05', '-append'); 

% save model names 
save(savefilename, 'models', '-append'); 


% -------------------------------------------------------------------------
%% Save table of clusters for Common Core System 

diary on
diaryname = fullfile(['NORMClustersCore_common_tables_sorted_' date '_output.txt']);
diary(diaryname);
% 
 for m = 1
    t = pls_core_statimg(m);  % retain positive 
    r = region(t);
    %figure; montage (r, 'regioncenters')
    table(r, 'nolegend');
 end 
diary off

