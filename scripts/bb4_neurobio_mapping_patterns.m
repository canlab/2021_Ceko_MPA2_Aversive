

%% Map patterns to neuroanatomical ROIs via riverplot
% ----------------------------------------------------------------------- %

% maps patterns to relevant brain regions
% displays contributions (pie-charts) 
% can I quantify pie-chart contributions too - chi-square?



% Prep targets and patterns 
% ----------------------------------------------------------------------- %

% General neg affect, primary sensory set were created using
% roi_create_aversive_pathways_atlas 

load(fullfile(roiscriptsdir, 'modgen_full.mat'));
load(fullfile(roiscriptsdir, 'modgen_compact.mat'));
load(fullfile(roiscriptsdir, 'primary_compact.mat'));
%load(fullfile(roiscriptsdir, 'Yeo17_compact.mat'));
% 
% 
[patt, patt_names] = load_patterns_001; % so it matches the other sigs used for comparisons
patt.image_names = patt_names';

%montage(patt)


% Re-threshold maps to match the montages (>t3)
patt = threshold(patt, [3 Inf], 'raw-between');
% montage(patt)

%% Patterns to general aversive areas
% ----------------------------------------------------------------------- %
modgen = modgen_full
modgen.image_names = modgen.labels

% Colors
n = length(patt_names);
patt_colors={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 

modgen_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2] [0.6 1 0.2] [0.4 0 0] [0.6 0 0] [0.6 0.2 0]}; % n = 10

% Create river plot and save 
figure; 
[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', modgen, 'colors1', patt_colors, 'colors2', modgen_colors, 'pos');
riverplot_toggle_lines(ribbons);

figtitle = sprintf(['Riverplot_patt001_to_modgenfull.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_matrix) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_modgen');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end
plugin_save_figure

%% Patterns to general aversive areas compact
% ----------------------------------------------------------------------- %
modgen = modgen_compact
modgen.image_names = modgen.labels

% Colors
n = length(patt_names);
patt_colors={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 

modgen_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2] [0.6 1 0.2] [0.4 0 0]}; % % n = 8

% Create river plot and save 
figure; 
[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', modgen, 'colors1', patt_colors, 'colors2', modgen_colors, 'pos');
riverplot_toggle_lines(ribbons);

% figtitle = sprintf(['Riverplot_patt001_to_modgencompact.png'])
% savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

sim_gen = sim_matrix;
savefilename = fullfile(resultsdir, 'sim_matrices.mat');
save(savefilename, 'sim_gen');


% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_matrix) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_modgencompact');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end
plugin_save_figure

%% Patterns to primary sensory
% ----------------------------------------------------------------------- %
prims = primary_compact
prims.image_names = prims.labels

% Colors
n = length(patt_names);
patt_colors={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 

prims_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2]}; % n = 6

% Create river plot and save 
figure; 
[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', prims, 'colors1', patt_colors, 'colors2', prims_colors, 'pos');
riverplot_toggle_lines(ribbons);

figtitle = sprintf(['Riverplot_patt001_to_prims.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% save sim_matrix
sim_prims = sim_matrix
savefilename = fullfile(resultsdir, 'sim_matrices.mat');
save(savefilename, 'sim_prims','-append');

% 

% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_matrix) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_prims');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end
plugin_save_figure


%% Patterns to retroins
% ----------------------------------------------------------------------- %
prims = retroins
prims.image_names = prims.labels

% Colors
n = length(patt_names);
patt_colors={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 
prims_colors = {[0.4 0 0] [0.6 0 0]}; % n = 2

% Create river plot and save 
figure; 
[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', prims, 'colors1', patt_colors, 'colors2', prims_colors, 'pos');
riverplot_toggle_lines(ribbons);

figtitle = sprintf(['Riverplot_patt001_to_retroins.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


%% Patterns to Yeo
% ----------------------------------------------------------------------- %
yeo = Yeo17_compact
yeo.image_names = yeo.labels

% Colors
n = length(patt_names);
patt_colors={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 

yeo_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2] [0.6 1 0.2] [0.4 0 0] [0.6 0 0] [0.6 0.2 0] ...
    [0.6 0.4 0] [0.6 0.6 0] [0.6 0.8 0.2] [0.6 1 0.2] [0.4 0 0] [0.6 0 0]}; % n = 16

% Create river plot and save 
figure; 
[layer1, layer2, ribbons, sim_matrix] = riverplot(patt, 'layer2', yeo, 'colors1', patt_colors, 'colors2', yeo_colors, 'pos');
riverplot_toggle_lines(ribbons);

figtitle = sprintf(['Riverplot_patt001_to_yeo.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;






%% 
% 
% %% SAME BUT WITH POLAR PLOTS 
% % MODGEN INCL PAG
% % ----------------------------------------------------------------------- %
% modgen = modgen_full
% modgen.image_names = modgen.labels
% 
% % at 001 - 
% patt001=load_patterns_001
% image_similarity_plot(patt001,'mapset',modgen,'networknames',modgen.image_names, 'plotstyle', 'polar', 'colors', pattcolors);
% 
% % at FDR -
% pattFDR=load_patterns_thr
% image_similarity_plot(pattFDR,'mapset',modgen,'networknames',modgen.image_names, 'plotstyle', 'polar', 'colors', pattcolors);
% 
% 
% % PRIMARY SENSORY
% % ----------------------------------------------------------------------- %
% prim = primary_compact
% prim.image_names = prim.labels
% 
% % at 001 -
% patt001=load_patterns_001
% image_similarity_plot(patt001,'mapset',prim,'networknames',prim.image_names, 'plotstyle', 'polar', 'colors', pattcolors);
% 
% % at FDR - 
% pattFDR=load_patterns_thr
% image_similarity_plot(pattFDR,'mapset',prim,'networknames',prim.image_names, 'plotstyle', 'polar', 'colors', pattcolors);
% % 
% 
% % OTHER PATTERNS 
% % at FDR -- NaN
% pattFDR = load_patterns_thr
% image_similarity_plot(pattFDR,'kragelemotion','plotstyle', 'polar', 'colors', pattcolors);
% 
%
% 
