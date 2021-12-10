% Test aversive PLS patterns on additional pleasant datasets

% HEAT vs WARMTH : Kohoutova ML workshop data 
%     - non-negative: warmth
%     - negative: heat

% -------------------------------------------------------------------------
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
% for control 
nps = which('weights_NSF_grouppred_cvpcr.img');
siips = which('nonnoc_v11_4_137subjmap_weighted_mean.nii');

% calculate pattern expression values
pexp_gens = apply_mask(data_test, gens, 'pattern_expression', 'ignore_missing');
pexp_mechs = apply_mask(data_test, mechs, 'pattern_expression', 'ignore_missing');
pexp_therms = apply_mask(data_test, therms, 'pattern_expression', 'ignore_missing');
pexp_audis = apply_mask(data_test, audis, 'pattern_expression', 'ignore_missing');
pexp_viss = apply_mask(data_test, viss, 'pattern_expression', 'ignore_missing');
pexp_nps = apply_mask(data_test, nps, 'pattern_expression', 'ignore_missing');
pexp_siips = apply_mask(data_test, siips, 'pattern_expression', 'ignore_missing');

% reshape pexp values to plot
toplot(:,:,1) = reshape(pexp_gens, 59, 2);
toplot(:,:,2) = reshape(pexp_mechs, 59, 2);
toplot(:,:,3) = reshape(pexp_therms, 59, 2);
toplot(:,:,4) = reshape(pexp_audis, 59, 2);
toplot(:,:,5) = reshape(pexp_viss, 59, 2);
toplot(:,:,6) = reshape(pexp_nps, 59, 2);
toplot(:,:,7) = reshape(pexp_siips, 59, 2);

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips'};
create_figure; nplots = size(toplot,3); 
connames = {'heat' 'warmth'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','noviolin', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_warm_friend.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips'};
create_figure; nplots = size(toplot,3); 
connames = {'heat' 'warmth'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_violin_test_on_warm_friend.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);




