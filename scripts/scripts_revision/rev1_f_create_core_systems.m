%% Core multimodal / specific systems 

% This script creates core systems via conjunction between weight maps and model encoding maps 
% run a_set_up_paths_always_run_first.m

%% set working dir and model names 

working_dir = scriptsdir;

% Here are the names of the 5 PLS brain models: 
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};


%% load data

% Model weights
% ----------------------------------------------------------------- % 
% ----------------------------------------------------------------- % 
% stored in ../results/patterns/PLS_patterns 
% resultsdir = fullfile(basedir, 'results');

load(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));

% This loads the pls model weight statistical images for each model:
% pls_bs_statimg(1) - dat size: 63545 = the correct size for a GM masked image = OK 
% pls_bs_statimg_fdr05(1) - datp,ste,sig size: 63545, sig voxels 6445 
% 
%
% Model encoding maps  
% ----------------------------------------------------------------- % 
% ----------------------------------------------------------------- % 
SR_analysisdir = fullfile(basedir, 'SR_analysis');
SR_resultsdir = fullfile(SR_analysisdir, 'results');

% Load output of /SR_analysis/scripts/bb4b_neurobio_interpretation_via_SR
% ----------------------------------------------------------------- % 
% savefilename = fullfile(SR_resultsdir, 'SR_out.mat');
load(fullfile(SR_resultsdir, 'SR_out.mat')); 

% This loads the pls model encoding statistical images for each model:
% pls_encode_statimg(1) - dat size: 1043888 = the correct size for un
% unmasked image = OK bc the fdr-corr is masked 
% pls_encode_statimg_fdr05(1) - datp,ste,sig size: 63545, sig voxels 28171
 
% 
%% Create core systems via conjunction of model weight + model encoding statistical images for each model
% ------------------------------------------------------------------------%
for m=1:length(models)
    % conjunction model weights and model encoders 
    
%     Use larger image first here (conj probably takes info from the first image and that one seems more fitting here (for the montage below) -
%     If I use bs_statimg_fdr05 as the first image for conj instead, it throws an error: "illegal size for mask.dat, because it does not match ins volInfo structure"
    pls_core_statimg(m) = conjunction (pls_encode_statimg_fdr05(m),pls_bs_statimg_fdr05(m),1);
end

%% Visualization
% ------------------------------------------------------------------------%
colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

% [0.6 0 0.8] * 256 = 154 0 205 --> to compare to colors in pptx 

o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m=1
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', m:m*2, 'contour', 'color', colormax (m,:));
end
figtitle = sprintf('Conjunction_PLS_weights_encoders_General.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

o2 = canlab_results_fmridisplay([], 'multirow', 4);
for m=2:5
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_weights_encoders_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% Display each specific on top of common 
o2 = canlab_results_fmridisplay([], 'multirow', 4);
for m=1
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', 1:2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', 3:4, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', 5:6, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', 7:8, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD 
end

for m=2:5
    o2 = addblobs(o2,region(pls_core_statimg(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_weights_encoders_Specific_on_Common.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;


% T-test and save output for further calculations
% ---------------------------------%
for m=1:5
    core_statimg =  core_system(m);
    
    core_statimg = threshold (core_statimg, .05, 'fdr', 'k', 10);
    pls_core_statimg_fdr05(m) = core_statimg;
end

% Append 
savefilename = fullfile(SR_resultsdir, 'Maxmodels_rob_per_sub.mat');
save(savefilename, 'pls_selectencode_statimg', '-append');
save(savefilename, 'pls_selectencode_statimg_fdr05', '-append');


% Save all stat images in one location (redundancy, shareable)
% -------------------------------------------------------------------------
%savefilename = fullfile(resultsdir,'PLS_stat_images.mat');

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


%% POSTHOC correction: see d2_type_selective_core script for creation of pls_core_statimg_nok
% Then use that one in the step below to extract Table of Clusters 

% -------------------------------------------------------------------------
%% Save table of clusters for Common Core System NOK

% diary on
% diaryname = fullfile(['ClustersCore_common_tables_sorted_' date '_output.txt']);
% diary(diaryname);
% % 
%  for m = 1
%     t = pls_core_statimg(m);  % retain positive 
%     r = region(t);
%     %figure; montage (r, 'regioncenters')
%     table(r, 'nolegend');
%  end 
% 
% diary off

diary on
diaryname = fullfile(['ClustersCore_common_nok_sorted_' date '_output.txt']);
diary(diaryname);
% 
 for m = 1
    t = pls_core_statimg_nok(m);  % retain positive 
    r = region(t);
    %figure; montage (r, 'regioncenters')
    table(r, 'nolegend');
 end 

diary off
 

% -------------------------------------------------------------------------
%% Display region centers for Common Core System NOK


 for m = 1
    t = pls_core_statimg_nok(m);  % retain positive 
    r = region(t);
    figure; montage (r, 'regioncenters')
    %table(r, 'nolegend');
 end 

 
