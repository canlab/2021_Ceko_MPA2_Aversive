% Valence tests on independent datasets 
 
% WEHRUM
% Neg vs. Neut images
% Pos vs. Neut images 

% HEAT vs WARMTH : Kohoutova ML workshop data 
%     - non-negative: warmth
%     - negative: heat

%%  ------------------------------------------------------------------------- 
%   Pos / Neg vs. Neutral images 
%   -------------------------------------------------------------------------
% Test on contrasts 
cd(scriptsrevdir)
prep_1_wehrum_set_conditions

cd /
dozipimages = false;  
omit_histograms = true;         
dofullplot = false;
prep_2_load_image_data_and_save 
prep_3_calc_univariate_contrast_maps_and_save

printhdr('Save results');

savefilename = fullfile(resultsrevdir,'wehrum','image_names_and_setup.mat');
%save(savefilename, 'DAT');
load(savefilename, 'DAT');

savefilenamedata = fullfile(resultsrevdir,'wehrum', 'data_objects.mat');
save(savefilenamedata, 'DATA_OBJ', '-v7.3');  
save(savefilenamedata, 'DATA_OBJ_CON', '-v7.3');  

load(fullfile(resultsrevdir,'wehrum', 'data_objects.mat'));


diary on
diaryname = fullfile(['rev2b_wehrum_sex_' date '_output.txt']);
diary(diaryname);

%% analysis 
% -------------------------------------------------------------------------
data_test = DATA_OBJ_CON;

% a priori models
gens = fullfile(resultsdir,'patterns','PLS_patterns', 'General_b10000_unthr.nii');
mechs = fullfile(resultsdir,'patterns','PLS_patterns', 'Mechanical_b10000_unthr.nii');
therms = fullfile(resultsdir,'patterns','PLS_patterns', 'Thermal_b10000_unthr.nii');
audis = fullfile(resultsdir,'patterns','PLS_patterns', 'Sound_b10000_unthr.nii');
viss = fullfile(resultsdir,'patterns','PLS_patterns', 'Visual_b10000_unthr.nii');

% calculate pattern expression values
  
for d = 1:size(DATA_OBJ_CON,2)
    pexpW_gens{d} = apply_mask(data_test{d}, gens, 'pattern_expression', 'ignore_missing');
    pexpW_mechs{d} = apply_mask(data_test{d}, mechs, 'pattern_expression', 'ignore_missing');
    pexpW_therms{d} = apply_mask(data_test{d}, therms, 'pattern_expression', 'ignore_missing');
    pexpW_audis{d} = apply_mask(data_test{d}, audis, 'pattern_expression', 'ignore_missing');
    pexpW_viss{d} = apply_mask(data_test{d}, viss, 'pattern_expression', 'ignore_missing');
end

% reshape pexp values to plot
clear toplot
toplot(:,:,1) = [pexpW_gens{1} pexpW_gens{2} pexpW_gens{3}];
toplot(:,:,2) = [-pexpW_mechs{1} -pexpW_mechs{2} -pexpW_mechs{3}]; % because it has a negative response in each condition! 
toplot(:,:,3) = [pexpW_therms{1} pexpW_therms{2} pexpW_therms{3}];
toplot(:,:,4) = [pexpW_audis{1} pexpW_audis{2} pexpW_audis{3}];
toplot(:,:,5) = [pexpW_viss{1} pexpW_viss{2} pexpW_viss{3}];

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss'};
create_figure; nplots = size(toplot,3); 
connames = {'Neg' 'Pos' 'Sex'};

colors_to_plot = {[0 0.2 1] [1 0.8 1] [0.5 0.5 0.5]};  

for n = 1:nplots
    axh(n) = subplot(2,5,n);
    h = barplot_columns(toplot(:,:,n),'nofig','noind', 'colors', colors_to_plot, 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off', 'YLim', [-3500 6500]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2b_study5_Wehrum.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% plot for figure: violins,no stars, no labels 
create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(2,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'nostars','colors',colors_to_plot, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off', 'YLim', [-3500 6500]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2b_study5_Wehrum_violin.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);




diary off
