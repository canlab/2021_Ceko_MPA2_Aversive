%% Core multimodal / specific systems 

% This script creates core systems via conjunction between weight maps and model encoding maps 
% run a_set_up_paths_always_run_first.m

%% set working dir and model names 

working_dir = scriptsrevdir;
% brain model names 
models = {'NGeneral' 'NVisneg' 'Vispos'}; 


load(fullfile(resultsrevdir,'NORMPLS_bootstats10000_N55_gm.mat'));

% This loads the pls model weight statistical images for each model:
% pls_bs_statimg(1) - dat size: 63545 = the correct size for a GM masked image = OK 
% pls_bs_statimg_fdr05(1) - datp,ste,sig size: 63545, sig voxels 6445 
% 
%
% Model encoding maps  
% ----------------------------------------------------------------- % 
load(fullfile(resultsrevdir, 'results_encode/encode_out.mat')); 

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
    pls_core_statimg(m) = conjunction (pls_encode_statimg_fdr05(m),pls_bs_statimg_fdr05(m),pls_encode_statimg_fdr05(m)1);
end

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

