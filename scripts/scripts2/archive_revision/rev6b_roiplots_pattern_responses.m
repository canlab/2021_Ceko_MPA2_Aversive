%% EDFig1d - RIGHT 

% This script plots pattern responses to negative and positive visuali stimuli 
% in vStr and Amy


clear all
a_set_up_paths_always_run_first

cd(scriptsrevdir)


%% Prep   
cd(resultsrevdir)
patt(1)=fmri_data(['patterns/NGeneral_b10000_FDR05.nii']);
patt(2)=fmri_data(['patterns/NVisneg_b10000_FDR05.nii']);
patt(3)=fmri_data(['patterns/NVispos_b10000_FDR05.nii']);


%% plot conditions 
% ----------------------------------------------
% use same atlas as in main paper
atlas_obj = load_atlas('canlab2018_2mm');
          
colors_to_plot = {[0.9 0.7 0] [0.2 0.8 1] [1 0.4 1]};  

%        
figtitle=sprintf('Plot_pattern_ROI');
create_figure(figtitle)

% NAc; Left, Rightt
% -------------------------------------------------------------------------

NAc_L = select_atlas_subset(atlas_obj, {'NAC_L'}, 'flatten');  
NAc_L.labels = {'NAc_L'};
NAc_R = select_atlas_subset(atlas_obj, {'NAC_R'}, 'flatten');  
NAc_R.labels = {'NAc_R'};


subplot(2,2,1);

clear r
for m =1:size(patt,2)
r{m} = extract_roi_averages(patt(m), NAc_L);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot, 'title', 'vStr left');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''); ylabel(''); drawnow

subplot(2,2,2);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, NAc_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot,'title', 'vStr right');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow

% Amy; Left, Right
% -------------------------------------------------------------------------
%{'Amygdala_CM_','DG_Hippocampus_','Amygdala_SF_','CA3_Hippocampus_','Amygdala_AStr_','Amygdala_LB_','CA1_Hippocampus_'}

Amy = select_atlas_subset(atlas_obj, {'Amygdala'}, 'flatten');  
AmyLR = split_atlas_by_hemisphere(Amy)
Amy_L = select_atlas_subset(AmyLR, {'Amygdala_L'}, 'flatten');
Amy_R = select_atlas_subset(AmyLR, {'Amygdala_R'}, 'flatten');


subplot(2,2,3);

clear r
r = {1,8}
for i =1:size(DATA_OBJ,2)
r{i} = extract_roi_averages(DATA_OBJ{i}, Amy_L);
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
r{i} = extract_roi_averages(DATA_OBJ{i}, Amy_R);
end

clear toplot
toplot = [r{1}.dat r{2}.dat r{3}.dat r{4}.dat r{5}.dat r{6}.dat r{7}.dat r{8}.dat];
h = barplot_columns(toplot, 'nofig','noind', 'colors', colors_to_plot,'title', 'amygdala rightt');
set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off'); 
xlabel(''), ylabel(''); drawnow

% 
plugin_save_figure


%% 
montage([NAc_L NAc_R Amy_L Amy_R])















