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
diaryname = fullfile(['rev2_combined_warm_wehrum_' date '_output.txt']);
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
toplot(:,:,1) = [pexpW_gens{1} pexpW_gens{2}];
toplot(:,:,2) = [-pexpW_mechs{1} -pexpW_mechs{2}]; % because it has a negative response in each condition! 
toplot(:,:,3) = [pexpW_therms{1} pexpW_therms{2}];
toplot(:,:,4) = [pexpW_audis{1} pexpW_audis{2}];
toplot(:,:,5) = [pexpW_viss{1} pexpW_viss{2}];

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss'};
create_figure; nplots = size(toplot,3); 
connames = {'Neg' 'Pos'};

colors_to_plot = {[0 0.2 1] [1 0.8 1]};  

for n = 1:nplots
    axh(n) = subplot(2,5,n);
    h = barplot_columns(toplot(:,:,n),'nofig','noind', 'colors', colors_to_plot, 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off', 'YLim', [-3500 6500]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_study5_Wehrum.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% plot for figure: violins,no stars, no labels 
create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(2,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'nostars','colors',colors_to_plot, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off', 'YLim', [-3500 6500]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_study5_Wehrum_violin.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);



%%  ------------------------------------------------------------------------- 
%   Warm vs. Heat dataset 
%   -------------------------------------------------------------------------

mldir = '/Applications/interpret_ml_neuroimaging';
gray_matter_mask = which('gray_matter_mask.img');
%gm_mask = which ('gm_mask.nii');

clear cont_imgs toplot 
% read images
cont_imgs{1} = filenames(fullfile(mldir, 'data', 'derivatives', 'contrast_images', 'heat*nii'), 'char');
cont_imgs{2} = filenames(fullfile(mldir, 'data', 'derivatives', 'contrast_images', 'warmth*nii'), 'char');

% data_test = fmri_data(cont_imgs);
data_test = fmri_data(cont_imgs, gray_matter_mask);

%data_test = fmri_data(cont_imgs, gm_mask);

% a priori models
gens = fullfile(resultsdir,'patterns','PLS_patterns', 'General_b10000_unthr.nii');
mechs = fullfile(resultsdir,'patterns','PLS_patterns', 'Mechanical_b10000_unthr.nii');
therms = fullfile(resultsdir,'patterns','PLS_patterns', 'Thermal_b10000_unthr.nii');
audis = fullfile(resultsdir,'patterns','PLS_patterns', 'Sound_b10000_unthr.nii');
viss = fullfile(resultsdir,'patterns','PLS_patterns', 'Visual_b10000_unthr.nii');


% calculate pattern expression values
pexp_gens = apply_mask(data_test, gens, 'pattern_expression', 'ignore_missing');
pexp_mechs = apply_mask(data_test, mechs, 'pattern_expression', 'ignore_missing');
pexp_therms = apply_mask(data_test, therms, 'pattern_expression', 'ignore_missing');
pexp_audis = apply_mask(data_test, audis, 'pattern_expression', 'ignore_missing');
pexp_viss = apply_mask(data_test, viss, 'pattern_expression', 'ignore_missing');

% reshape pexp values to plot
clear toplot
toplot(:,:,1) = reshape(pexp_gens, 59, 2);
toplot(:,:,2) = reshape(pexp_mechs, 59, 2);
toplot(:,:,3) = reshape(pexp_therms, 59, 2);
toplot(:,:,4) = reshape(pexp_audis, 59, 2);
toplot(:,:,5) = reshape(pexp_viss, 59, 2);

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss'};
create_figure; nplots = size(toplot,3); 
connames = {'hot' 'warm'};

colors_to_plot = {[1 0.6 0.2] [1 1 0.8]}; 


for n = 1:nplots
    axh(n) = subplot(2,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','colors', colors_to_plot, 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off', 'YLim', [-15000 20000]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_study6_violin_test_on_warm.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% plot for figure - no stars, no labels
create_figure; nplots = size(toplot,3); 
connames = {'hot' 'warm'};

for n = 1:nplots
    axh(n) = subplot(2,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','nostars','colors', colors_to_plot, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 10, 'box', 'off', 'YLim', [-15000 20000]); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_study6_violin_test_on_warm_FIGURE.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

diary off
