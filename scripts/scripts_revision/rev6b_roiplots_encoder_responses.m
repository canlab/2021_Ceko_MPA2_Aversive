
%% Plots and 3D visualizations of model encoding maps in ROIS


clear all
a_set_up_paths_always_run_first

cd(scriptsrevdir)


%% Prep   
cd(resultsrevdir)
encode_resultsdir = fullfile (resultsrevdir, 'results_encode');
savefilename = fullfile(encode_resultsdir, 'encode_out.mat');
load(savefilename, 'Nencode_obj');


cd(scriptsrevdir)

%% plot model encoders
% ----------------------------------------------
% copy-pasted from f4_1_prep_figure....  
% use same atlas as in main paper

% CM, SF, LC, AStr (technically a transitional area but included here (and tiny)  
atlas_obj = load_atlas('canlab2018_2mm');
amy = select_atlas_subset(atlas_obj, {'Amy'}, 'flatten');
amy.labels = {'Amy'}

amyLR = split_atlas_by_hemisphere(amy)
amy_L = select_atlas_subset(amyLR, {'Amy_L'}, 'flatten');
amy_R = select_atlas_subset(amyLR, {'Amy_R'}, 'flatten');

% vStr
atlas_obj = load_atlas('pauli_bg');
vStr = select_atlas_subset(atlas_obj, {'V_Striatum'}, 'flatten');  
vStr.labels = {'vStr'};

vstrLR = split_atlas_by_hemisphere(vStr)
vstr_L = select_atlas_subset(vstrLR, {'vStr_L'}, 'flatten');
vstr_R = select_atlas_subset(vstrLR, {'vStr_R'}, 'flatten');

% Looks good
% roismontage = [vStr amy]
% montage(roismontage)
comparevstr = [vStr NAc_L NAc_R]
montage(comparevstr)

% colors
colors_to_plot = {[0.9 0.7 0] [0.2 0.8 1] [1 0.4 1]};  


%% Plot encoders in ROIs, split by hemi

%        
figtitle=sprintf('Plot_encode_ROI');
create_figure(figtitle)

subplot(2,2,1); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), vstr_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin', 'nostars','colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,2); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), vstr_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','nostars','colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,3); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), amy_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','nostars','colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow


subplot(2,2,4); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), amy_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','nostars','colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

% 
plugin_save_figure


%% with stars and title 
% ----------------------------------------------
%         
figtitle=sprintf('Plot_encode_ROI_stars');
create_figure(figtitle)

subplot(2,2,1); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), vstr_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','colors', colors_to_plot,  'title', 'vStr left');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,2); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), vstr_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','colors', colors_to_plot,  'title', 'vStr right');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,3); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), amy_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','colors', colors_to_plot, 'title', 'amygdala left');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow


subplot(2,2,4); clear r

for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), amy_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig', 'noviolin','colors', colors_to_plot, 'title', 'amygdala right');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

% 
plugin_save_figure


%% Simplify figure, collapse across hemis   
figtitle=sprintf('Plot_encode_acrosshemi_ ROI');
create_figure(figtitle)

subplot(2,3,1);

clear r
for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), vStr);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig','nostars', 'noviolin', 'colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 11, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow


subplot(2,3,2);

clear r
for m =1:size(Nencode_obj,2)
r{m} = extract_roi_averages(Nencode_obj(m), amy);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig','nostars','noviolin', 'colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 11, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow

% 
plugin_save_figure



















%% Plot encoders on 3D surface amy, Nac

for m=1:3
    Nencode_statimg(m) = ttest (Nencode_obj(m));
    Nencode_statimg(m) = threshold (Nencode_statimg(m), .05, 'fdr', 'k', 10);
end

% ROIs
atlas_obj = load_atlas('canlab2018_2mm');
atlas_obj = select_atlas_subset(atlas_obj, {'Striatum' 'Amygdala'});

%%
% NCommon ('Arousal')  on 3D
% -------------------------------------------------------------------------
figtitle=sprintf('Plots_3D_NGen');
create_figure(figtitle); axis off

surface_handles = isosurface(atlas_obj);
view(-120, -18); drawnow, snapnow; lightRestoreSingle;

% add for context
myp = addbrain('caudate'); myp = [myp addbrain('hippocampus')];
set(myp,'FaceColor', [0.5 0.6 0.6], 'FaceAlpha',0.15)

% render blobs 
han = render_on_surface(Nencode_statimg(1),surface_handles, 'colormap', 'copper', 'clim', [0 7]);
colorbar off

plugin_save_figure


% NNeg  on 3D
% -------------------------------------------------------------------------
figtitle=sprintf('Plots_3D_NNeg');
create_figure(figtitle); axis off

surface_handles = isosurface(atlas_obj);
view(-120, -18); drawnow, snapnow; lightRestoreSingle;

% add for context
myp = addbrain('caudate'); myp = [myp addbrain('hippocampus')];
set(myp,'FaceColor', [0.5 0.6 0.6], 'FaceAlpha',0.15)

% render blobs 
han = render_on_surface(Nencode_statimg(2),surface_handles, 'colormap', 'cool', 'clim', [0 7]);
colorbar off

plugin_save_figure


% NPos on 3D
% -------------------------------------------------------------------------
figtitle=sprintf('Plots_3D_NPos');
create_figure(figtitle); axis off

surface_handles = isosurface(atlas_obj);
view(-120, -18); drawnow, snapnow; lightRestoreSingle;

% add for context
myp = addbrain('caudate'); myp = [myp addbrain('hippocampus')];
set(myp,'FaceColor', [0.5 0.6 0.6], 'FaceAlpha',0.15)

% render blobs 
han = render_on_surface(Nencode_statimg(3),surface_handles, 'colormap', 'spring', 'clim', [0 7]);
colorbar off

plugin_save_figure


%% Also plot Aversive Visual for comparison
clear encode_resultsdir
cd(resultsdir)
encode_resultsdir = fullfile (resultsdir, 'patterns/PLS_model_encoders');
savefilename = fullfile(encode_resultsdir, 'model_encode_obj.mat');
load(savefilename, 'encode_obj');

for m=5
    encode_statimg(m) = ttest (encode_obj(m));
    encode_statimg(m) = threshold (encode_statimg(m), .05, 'fdr', 'k', 10);
end

% NNeg  on 3D
% -------------------------------------------------------------------------
figtitle=sprintf('Plots_3D_NegVis');
create_figure(figtitle); axis off

surface_handles = isosurface(atlas_obj);
view(-120, -18); drawnow, snapnow; lightRestoreSingle;

% add for context
myp = addbrain('caudate'); myp = [myp addbrain('hippocampus')];
set(myp,'FaceColor', [0.5 0.6 0.6], 'FaceAlpha',0.15)

% render blobs 
han = render_on_surface(encode_statimg(5),surface_handles, 'colormap', 'winter', 'clim', [0 7]);
colorbar off

plugin_save_figure




