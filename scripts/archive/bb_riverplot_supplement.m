%% Example: Mapping images to an atlas and visualizing them with a river plot

% Thal7=which('1000subjects_TightThalamus_clusters007_ref.nii.gz');
% thal7 = fmri_data(Thal7, [], 'noverbose', 'sample2mask');

% cblm = load_atlas (

[fc, fc_names] = load_patterns_thr;
[cblm, cblm_names] = load_image_set('pain_pdm'); %   looks good, mostly pain to pain
[cblm, cblm_names] = load_image_set('pauli');


%% Add labels to image_names (used in riverplot.m method)
% -------------------------------------------------------------------

fc.image_names = fc_names';
%fc.image_names = fc.labels;
%cblm.image_names = cblm.labels;
cblm.image_names = cblm_names';

%% Define Colors
% -------------------------------------------------------------------

colors_mont={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' % general is yellow 
fc_colors = colors_mont;
fc_color = {[.5 0 1]};                                  % for riverplot
%cblm_colors = colorcube_colors(num_regions(cblm));      % for riverplot


% Some display helper functions
dashes = '----------------------------------------------';
printhdr = @(str) fprintf('%s\n%s\n%s\n', dashes, str, dashes);


%% View the atlas to see what it looks like
% -------------------------------------------------------------------
% montage(cblm) will also work here. This plot is a little nicer because
% it will show both the atlas and the networks side by side

o2 = canlab_results_fmridisplay([], 'multirow', 2);

o2 = montage(cblm, o2, 'wh_montages', 1:2);
% title_montage(o2, 2, 'Cerebellar atlas');
% 
% title_montage(o2, 4, 'Functional Networks');

for i = 1:n
    
    myfc = get_wh_image(fc, i);
    o2 = addblobs(o2, region(myfc), 'wh_montages', 3:4, 'color', fc_colors{i}, 'smooth');
    
end

drawnow, snapnow


% % Get regions (for slice montage)
% r = atlas2region(cblm);
% 
% % Show them on a montage
% montage(r, 'regioncenters');


%% Create a river plot for the overall relationship, and plot the matrix
% The ribbon thicknesses in the riverplot are proportional to the cosine
% similarity between the network map and the region.

figtitle=sprintf('Viz_Riverplot_Sigs_thal');
create_figure(figtitle) 

[layer1, layer2, ribbons, sim_matrix] = riverplot(fc, 'layer2', cblm) % 'colors1', fc_colors, 'colors2', cblm_colors);

drawnow, snapnow

%% Visualize the matrix and identify the top network for each region
% This is a bit crowded. Let's view the matrix:

figtitle=sprintf('Viz_Matrix_Sigs_cing');
create_figure(figtitle, 1, 2)

%create_figure('matrix', 1, 2);
set(gcf, 'Position', [182   232   670   723]);

imagesc(sim_matrix)

set(gca, 'XTick', 1:n, 'XTickLabel', fc_names, ...
    'YTick', 1:length(cing_names), 'YTickLabel', format_strings_for_legend(cing_names), ...
    'XTickLabelRotation', 45, 'Ydir', 'reverse');

colorbar

% Change the colormap to be more intuitive
cm = colormap_tor([1 1 1], [1 0 0]);
colormap(cm)

title('Cosine similarity')

subplot(1, 2, 2)

sim_centered = zscore(zscore(sim_matrix)')';

sim_centered(sim_centered < 0) = 0;         % threshold to show only top values

imagesc(sim_centered)

set(gca, 'XTick', 1:n, 'XTickLabel', fc_names, ...
    'YTick', 1:length(cing_names), 'YTickLabel', format_strings_for_legend(cing_names), ...
    'XTickLabelRotation', 45, 'Ydir', 'reverse');

colorbar


title('Relative (double Z-scored) similarity')

drawnow, snapnow

plugin_save_figure

%% Get best region and make a table

[~, wh_max] = max(sim_centered');

Anatomical_Region = format_strings_for_legend(cblm.labels');
Funct_Network = format_strings_for_legend(fc_names(wh_max))';

results_table = table(Anatomical_Region, Funct_Network);
results_table = sortrows(results_table, 'Funct_Network');

disp(results_table)

