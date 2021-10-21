%% Core multimodal / specific systems 

% This script applies a 'type-selectivity filter' to core systems 
% by conjuncting the core maps with selectencode maps (model - max (remaining models)) 

% run a_set_up_paths_always_run_first.m

%% set working dir and model names 

working_dir = scriptsdir;

%% load data
archivedir=fullfile(resultsdir,'archive')
%load(fullfile(resultsdir,'PLS_stat_images.mat'));
load(fullfile(archivedir,'PLS_stat_images.mat'));

% Several stat imgs are loaded: 
% ------------------------------------
% (1) pls_selectencode_statimg
% -- type-selective model encoding maps (MMM_obj) + fdr, 10k
% -- created in bb4b_neurobio_interpretation_via_SR
% dat size = 104388, removed_voxels = 0

% (2) pls_encode_statimg + fdr, 10k
% -- model encoders 
% -- created in bb4b_neurobio_interpretation_via_SR
% dat size = 104388, removed_voxels = 0

% (3) pls_bs_statimg + fdr, 10k
% -- model weights
% -- created in cross_pred_modified
% dat size = 63545, removed_voxels = 0

% (3) pls_core_statimg -- no fdr, these are conjunctions of fdr-ed images 
% -- core = conjunction of pls_encode and pls_bs
% -- created in d1_create_core_systems
% dat size = 63545, removed_voxels = 104388 (--> 40843 removed) 


%% Conjunction of core maps and type-selective maps - initial input maps are thd at fdr 05, k > 10
% -----------------------------------------------------------------------------------------------%
% There were no type-selective voxels for the common system (model 1), 
% so we will do this on models 2-5 only 

for m=2:5
    select_core_system(m) = conjunction (pls_core_statimg(m),pls_selectencode_statimg_fdr05(m),1);
end

% which one is entered first doesn't matter in this case (good!)

%% Visualization select core system 
% ------------------------------------------------------------------------%

colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m=2:5
    o2 = addblobs(o2,region(select_core_system(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_core_selectcore_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% 

%% Repeat with input stat maps thresholded at fdr (no extent treshold), then k > 10 of final map
% -----------------------------------------------------------------------------------------%

% (1) Thd inputs for core

for m=1:5
    pls_encode_statimg_fdr05_nok(m) = threshold (pls_encode_statimg(m), .05, 'fdr');
end

% size (pls_encode_statimg(1).dat) % 104388 - ok
% size (pls_encode_statimg_fdr05_nok(1).dat) % 63545 - ok
% 

for m=1:5
    pls_bs_statimg_fdr05_nok(m) = threshold (pls_bs_statimg(m), .05, 'fdr');
end

% size (pls_bs_statimg(1).dat) % 63545 - ok - 
% size (pls_bs_statimg_fdr05_nok(1).dat) % 63545 - ok
% 
% (2) Thd selectencode
for m=1:5
    pls_selectencode_statimg_fdr05_nok(m) = threshold (pls_selectencode_statimg(m), .05, 'fdr');
end

% size (pls_selectencode_statimg(1).dat) % 104388 - ok - 
% size (pls_selectencode_statimg_fdr05_nok(1).dat) % 63545 - ok

% Build core system maps
% -------------------------------% 
for m=1:5
    pls_core_statimg_nok(m) = conjunction (pls_encode_statimg_fdr05_nok(m),pls_bs_statimg_fdr05_nok(m),1);
end

% Build select core system maps
% -------------------------------% 
for m=1:5
    select_core_system_nok(m) = conjunction (pls_core_statimg_nok(m),pls_selectencode_statimg_fdr05_nok(m),1);
end


% save into existing PLS_stat_images 

savefilename = fullfile(archivedir,'PLS_stat_images.mat');

% save model weights nok
save(savefilename, 'pls_bs_statimg_fdr05_nok', '-append'); 

% save model encoders nok
save(savefilename, 'pls_encode_statimg_fdr05_nok', '-append'); 

% save select encoders nok
save(savefilename, 'pls_selectencode_statimg_fdr05_nok', '-append'); 

% save core system nok
save(savefilename, 'pls_core_statimg_nok', '-append'); 

% save select core system nok
save(savefilename, 'select_core_system_nok', '-append'); 


%% Visualization core system NOK
% ------------------------------------------------------------------------%

colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m=2:5
    o2 = addblobs(o2,region(pls_core_statimg_nok(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_NOK_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% 



%% Visualization select core system NOK
% ------------------------------------------------------------------------%

colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m=2:5
    o2 = addblobs(o2,region(select_core_system_nok(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_core_selectcore_NOK_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% 

% % This should be empty:
% o2 = canlab_results_fmridisplay([], 'multirow', 1);
% for m=1
%     o2 = addblobs(o2,region(select_core_system_nok(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
% end
% % It is empty, ok


% %% Thd k > 10, visualize again
% % ------------------------------------------------------------------------%
% 
% for m=1:5
%     select_core_system_k10(m) = threshold (select_core_system_nok(m), .05, 'fdr', 'k', 10);
%     select_core_system_k10(m) = threshold (select_core_system_k10(m), [0 Inf],'raw-between');
% end
% 
% o2 = canlab_results_fmridisplay([], 'multirow', 4);
% 
% for m=2:5
%     o2 = addblobs(o2,region(select_core_system_k10(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
% end
% figtitle = sprintf('Conjunction_PLS_core_selectcore_K10_Specific.png');
% savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% % 



%% Visualize comparison: map derived from fdr, k > 10, map derived from fdr, nok 
% ------------------------------------------------------------------------%


o2 = canlab_results_fmridisplay([], 'multirow', 4);
for m=2:5
    o2 = addblobs(o2,region(select_core_system_nok(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
    o2 = addblobs(o2,region(select_core_system(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', 'k'); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_core_selectcore_COMPARISON_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

%% Get tables of clusters 
% ------------------------------------------------------------------------%
% diary on
% diaryname = fullfile(['ClustersCoreSelect_tables_sorted_' date '_output.txt']);
% diary(diaryname);
% % 
%  for m = 1:5
%     t = select_core_system(m);  % retain positive 
%     r = region(t);
%     %figure; montage (r, 'regioncenters')
%     table(r, 'nolegend');
%  end %

diary on
diaryname = fullfile(['ClustersCoreSelectNOK_tables_sorted_' date '_output.txt']);
diary(diaryname);
% 
 for m = 1:5
    t = select_core_system_nok(m);  % retain positive 
    r = region(t);
    %figure; montage (r, 'regioncenters')
    table(r, 'nolegend');
 end 






%----------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------%
%% Sanity checks 
%----------------------------------------------------------------------------------%
%----------------------------------------------------------------------------------%

% Inspect inputs separately (core system NOK, selectencode NOK)  
% ------------------------------------------------------------------------%
colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 4);
for m=2:5
    o2 = addblobs(o2,region(pls_core_statimg_nok(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_core_NOK_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% that one looks good
% 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m=2:5
    o2 = addblobs(o2,region(pls_selectencode_statimg_fdr05(m)),'wh_montages', m*2-3:m*2-2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end
figtitle = sprintf('Conjunction_PLS_selectencode_NOK_Specific.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% 
% that one does not look good ... it is because I kept pos AND NEGATIVE
% values - it should not matter, bc I am forcing the positive conjunction,
% but lets just DC

% 
savefilename = fullfile(SR_resultsdir, 'Maxmodels_rob_per_sub.mat');
load(savefilename, 'MMM_obj');

% rethreshold select encode map to keep positive values 
for m=2
    pls_se(m) = ttest(MMM_obj(m));
    pls_se_fdr05_nok(m) = threshold (pls_se(m), .05, 'fdr');
    pls_se_fdr05_nok_pos(m) = threshold (pls_se_fdr05_nok(m),[0 Inf],'raw-between');
end

% conjunction 
for m=2
    sc_system(m) = conjunction (pls_core_statimg_nok(m),pls_se_fdr05_nok(m),1);
end
% 
o2 = canlab_results_fmridisplay([], 'multirow', 2);
for m=2
o2 = addblobs(o2,region(select_core_system(m)),'wh_montages', 1:2, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
o2 = addblobs(o2,region(sc_system(m)),'wh_montages', 3:4, 'contour','color', colormax (m,:)); % COLORS LOOK GOOD
end 

figtitle = sprintf('Conjunction_PLS_Sanity_check.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
% looks good, maps are the same 
% 
% 
