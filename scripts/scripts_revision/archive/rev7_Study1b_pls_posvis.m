

% This script applies full sample PLS signatures to MPA2 positive visual 'non-reactive' images 
% 
% this is not the correct approach (should be applying cross-val) but 
% I just want to remind myself real quick if the other Patterns responded
% at all

% PLS signatures: multiple predictive patterns for aversive experience: General, Mechanical pain,
%         Thermal pain, Aversive Sounds, Visual aversive images


clear all
a_set_up_paths_always_run_first

cd(scriptsrevdir)

%% Prep   

% Load pos images data 
% ----------------------------------------------
clear DAT DATA_OBJ

posvisloc =   '/Volumes/GoogleDrive/My Drive/A_Multi_lab_world_map/Aversive_Project/Aversive_validation_ind_datasets/POSVIS'
load(fullfile(posvisloc,'results', 'image_names_and_setup.mat'));
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

load(fullfile(posvisloc,'results', 'data_objects.mat'));
fprintf('Loaded condition data from results%sDATA_OBJ\n', filesep);


%% Apply to main effects (4 stim modalities) 
% Choose subset of conditions 
k = length(DAT.conditions) % conditions are 1 mod x 4 stim intensities

% All Signatures

printhdr('Extracting all signatures');

% Dot product metric
DAT.SIG_conditions.raw.dotproduct = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions, 'image_set', 'multiaversive');


%% Plot dp
% Plot with error bars 
% -------------------------------------------------------
pexp_color = [0.9 0.9 0.9];  % posvis 

figtitle=sprintf('Plot_FULLSAMPLEdotpr_pos_Study1b');
create_figure(figtitle);

y(:,:,1) = table2array(DAT.SIG_conditions.raw.dotproduct.General_aversive(:,1:4));
y(:,:,2) = table2array(DAT.SIG_conditions.raw.dotproduct.Mech_pain(:,1:4));
y(:,:,3) = table2array(DAT.SIG_conditions.raw.dotproduct.Thermal_pain(:,1:4));
y(:,:,4) = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Sound(:,1:4));
y(:,:,5) = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Visual(:,1:4));

x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings

for m = 1:5
    subplot(3,5,m)
    
    h = ploterr (x,nanmean(y(:,:,m)),[],ste(y(:,:,m))); % 'abshhxy', 0);
    set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',pexp_color, 'MarkerEdgeColor', 'k', ...
        'markersize', 6, 'linewidth', 1);
    set(h(2), 'color', 'k', 'linewidth', 1);
    
    line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 1, 'linestyle', '-');
    set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [-0.2 0.25], 'XTick', 0:0.1:0.3,'YTick', -0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
    set(gca,'LineWidth', 1,'FontSize', 10);
end

plugin_save_figure





