

%% Map model encoding maps to neuroanatomical ROIs via riverplot
% ----------------------------------------------------------------------- %

% maps patterns to relevant brain regions
% displays contributions (pie-charts) 
% can I quantify pie-chart contributions too - chi-square?


% Prep targets and patterns 
% ----------------------------------------------------------------------- %

% General neg affect, primary sensory set were created using
% roi_create_aversive_pathways_atlas 

% load(fullfile(roiscriptsdir, 'modgen_full.mat'));
% load(fullfile(roiscriptsdir, 'modgen_compact.mat'));
% load(fullfile(roiscriptsdir, 'primary_compact.mat'));

% 
[patt, patt_names] = load_SR_maps_thr; % should be FDR maps, but none of
% the thresholded maps got written (see notes in mapping_modelencoders.m)
patt.image_names = patt_names';

patt = threshold(patt, [3 Inf], 'raw-between');


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

figtitle = sprintf(['Riverplot_SRthr_to_modgenfull.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_matrix) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_modgen.png');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end

savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


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

% figtitle = sprintf(['Riverplot_SRthr_to_modgencompact.png'])
% savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

sim_gen_SR = sim_matrix
savefilename = fullfile(SR_resultsdir, 'sim_matrices_SR.mat');
save(savefilename, 'sim_gen_SR');

% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_gen) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_modgencompact.png');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    h = wani_pie(piedata(i,:)./sum(piedata(i,:))*100, 'cols',cols, 'notext');
end

savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


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

% figtitle = sprintf(['Riverplot_SRthr_to_prims.png'])
% savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

sim_prims_SR = sim_matrix
savefilename = fullfile(SR_resultsdir, 'sim_matrices_SR.mat');
save(savefilename, 'sim_prims_SR', '-append');

% Mini Pies
cols=[0.5 0.5 0.5
    1 0.2 0.4 
    1 0.6 0.2
    0 0.6 0.4
    0 0.4 1];

piedata=abs(sim_prims) % is already positive in this case
piedata(piedata==0) = 0.00001

figtitle=sprintf('Mini_pies_prims.png');
create_figure(figtitle)
for i = 1:size(piedata,1)
    subplot(1,size(piedata,1),i)
    percent_pie(i,:) = piedata(i,:)./sum(piedata(i,:))*100
    h = wani_pie(percent_pie(i,:), 'cols',cols, 'notext');
end
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


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

figtitle = sprintf(['Riverplot_SRthr_to_retroins.png'])
savename = fullfile(SR_figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
