% Test aversive PLS patterns on additional pleasant datasets

% Van't Hoff 2021 _ BASIC _

% (3a) VISUAL: Wehrum et al. 2013 
%     - high arousal (sexual images)
%     - low arousal (non-sexual pleasant images)
%     - no arousal neutral control? 

% test General, Visual
    
%% Test on contrasts 
% load data 
% prep_1_wehrum_set_conditions.m
cd /Users
cd ../
% run from highest dir (cd .)
dozipimages = false;  
prep_2_load_image_data_and_save % ... has gone psycho
% all of a sudden it looks for data in current dir + datadir, instead of
% datadir - not sure if the issue is with the script or on my (matlab) side
prep_3_calc_univariate_contrast_maps_and_save


% analysis 
% -------------------------------------------------------------------------
data_test = DATA_OBJ_CON;

% a priori models
gens = fullfile(resultsdir,'patterns','PLS_patterns', 'General_b10000_unthr.nii');
mechs = fullfile(resultsdir,'patterns','PLS_patterns', 'Mechanical_b10000_unthr.nii');
therms = fullfile(resultsdir,'patterns','PLS_patterns', 'Thermal_b10000_unthr.nii');
audis = fullfile(resultsdir,'patterns','PLS_patterns', 'Sound_b10000_unthr.nii');
viss = fullfile(resultsdir,'patterns','PLS_patterns', 'Visual_b10000_unthr.nii');
% for control 
nps = which('weights_NSF_grouppred_cvpcr.img');
siips = which('nonnoc_v11_4_137subjmap_weighted_mean.nii');

% calculate pattern expression values
for d = 1:size(DATA_OBJ_CON,2)
    pexp_gens{d} = apply_mask(data_test{d}, gens, 'pattern_expression', 'ignore_missing');
    pexp_mechs{d} = apply_mask(data_test{d}, mechs, 'pattern_expression', 'ignore_missing');
    pexp_therms{d} = apply_mask(data_test{d}, therms, 'pattern_expression', 'ignore_missing');
    pexp_audis{d} = apply_mask(data_test{d}, audis, 'pattern_expression', 'ignore_missing');
    pexp_viss{d} = apply_mask(data_test{d}, viss, 'pattern_expression', 'ignore_missing');
    pexp_nps{d} = apply_mask(data_test{d}, nps, 'pattern_expression', 'ignore_missing');
    pexp_siips{d} = apply_mask(data_test{d}, siips, 'pattern_expression', 'ignore_missing');
end

% reshape pexp values to plot
clear toplot
toplot(:,:,1) = [pexp_gens{1} pexp_gens{2} pexp_gens{3} pexp_gens{4} pexp_gens{5}];
toplot(:,:,2) = [pexp_mechs{1} pexp_mechs{2} pexp_mechs{3} pexp_mechs{4} pexp_mechs{5}];
toplot(:,:,3) = [pexp_therms{1} pexp_therms{2} pexp_therms{3} pexp_therms{4} pexp_therms{5}];
toplot(:,:,4) = [pexp_audis{1} pexp_audis{2} pexp_audis{3} pexp_audis{4} pexp_audis{5}];
toplot(:,:,5) = [pexp_viss{1} pexp_viss{2} pexp_viss{3} pexp_viss{4} pexp_viss{5}];
toplot(:,:,6) = [pexp_nps{1} pexp_nps{2} pexp_nps{3} pexp_nps{4} pexp_nps{5}];
toplot(:,:,7) = [pexp_siips{1} pexp_siips{2} pexp_siips{3} pexp_siips{4} pexp_siips{5}];

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips'};
create_figure; nplots = size(toplot,3); 
connames = {'NegMinPos' 'NegMinNeut' 'NegMinSex' ...
                     'SexMinPos' 'SexMinNeut'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','noviolin', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Wehrum_CONTRASTS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% plot w/ violins
create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Wehrum_CONTRASTS_violin.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);











