% Train PLS to predict norm ratings of positive and negative images 
% & plot response 

% Prep
cd(scriptsrevdir);
resultsdir = resultsrevdir;
b_reload_saved_matfiles
c_univariate_contrast_maps_posneg

% load images and behavior 
% ----------------------------------------------
% load(fullfile(resultsrevdir, 'data_objects.mat'));  
% import_Behav_NEGPOS %

%   'NegVis'               
%   'PosVis'                
%   'NegVisLin'             
%   'PosVisLin'             
%    'Neg Pos'          
%    'NegLin PosLin'


% 
% plot conditions in vStr - 
% ----------------------------------------------
% use same atlas as in main paper
atlas_obj = load_atlas('canlab2018_2mm');
% NAc
% -------------------------------------------------------------------------
NAc = select_atlas_subset(atlas_obj, {'NAC_L' 'NAC_R'}, 'flatten');  
NAc.labels = {'NAc'};

clear r
r = {1,8}
for i = i:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, NAc);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
barplot_columns(toplot, 'nofig');




o2 = fmridisplay
r = region(contrast_t_unc{2}, 'noverbose');
o2 = montage(o2, 'axial', 'slice_range', [-10 10], 'spacing',1, 'noverbose');
o2 = addblobs(o2, r, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'noverbose'); 
o2 = legend(o2);

figtitle = ['Pos_05fdr_axial.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

% clusters with k>10 saved in r 
[results_table] = table_simple(r)
writetable(results_table, 'norm_visual_pos_05_clusters.txt');



% plot conditions (activation per level) 
% barplotcolumns violins (pure barplots not allowed)


