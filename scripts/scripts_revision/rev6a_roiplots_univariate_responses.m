

% This script examines univ responses to negative and positive visual
% stimuli 


clear all
a_set_up_paths_always_run_first

cd(scriptsrevdir)

%% Prep   

% Load univ brain maps
% ------------------------------------------------------------
clear DAT DATA_OBJ

load(fullfile(resultsrevdir, 'image_names_and_setup.mat'));
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

load(fullfile(resultsrevdir, 'data_objects.mat'));
fprintf('Loaded condition data from results%sDATA_OBJ\n', filesep);

% T-tests for each condition separately
% ------------------------------------------------------------------------
k = length(DATA_OBJ);
t = cell(1, k);

for i = 1:k
    
    t{i} = ttest(DATA_OBJ{i});
    t{i} = threshold(t{i}, .01, 'unc');
    
end

% Brain maps each condition separately
% ------------------------------------------------------------------------
o2 = canlab_results_fmridisplay([], 'multirow', 4);

for i = 1:4
    o2 = addblobs(o2, region(t{i}), 'wh_montages', [2*i-1:2*i]);
    o2 = title_montage(o2, 2*i, DAT.conditions{i});
end
figtitle = ['Univariate_negvis_conditions.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2


o2 = canlab_results_fmridisplay([], 'multirow', 4);

for i = 5:8
    o2 = addblobs(o2, region(t{i}), 'wh_montages', [2*(i-4)-1:2*(i-4)]);
    o2 = title_montage(o2, 2*(i-4), DAT.conditions{i});
end
figtitle = ['Univariate_posvis_conditions.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

%% plot conditions 
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

          
colors_to_plot = {[0.4 0.8 1] [0.4 0.8 1] [0.4 0.8 1] [0.4 0.8 1] ... % light blue
    [0.9 0.6 1] [0.9 0.6 1] [0.9 0.6 1] [0.9 0.6 1]};           % light pink

%%        
figtitle=sprintf('Plot_univariate_ROI_per_condition');
create_figure(figtitle)


subplot(2,2,1);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, vstr_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot, 'title', 'vStr left');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,2);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, vstr_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot,'title', 'vStr right');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow


subplot(2,2,3);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, amy_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot,'title', 'amygdala left');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow


subplot(2,2,4);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, amy_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot,'title', 'amygdala right');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow

% 
plugin_save_figure


%% Simplify figure, collapse across hemis
          
colors_to_plot = {[0.4 0.8 1] [0.4 0.8 1] [0.4 0.8 1] [0.4 0.8 1] ... % light blue
    [0.9 0.6 1] [0.9 0.6 1] [0.9 0.6 1] [0.9 0.6 1]};   

figtitle=sprintf('Plot_univariate_acrosshemi_ ROI_per_condition');
create_figure(figtitle)

subplot(3,4,1);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, vStr);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig', 'noind', 'colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize', 6, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(3,4,2);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, amy);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind','colors', colors_to_plot);
set(gca,'LineWidth', 1, 'FontSize',6, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow

% 
plugin_save_figure















