% Test aversive PLS patterns on additional pleasant datasets

% (4) VISUAL: Reddan at al. ... 
%     - high arousal (sexual images)
%     - low arousal (non-sexual pleasant images)
%     - no arousal neutral control? 

% test General, Visual
    

%% Test on conditions 
% load data 
% -------------------------------------------------------------------------
neg_imgs = fullfile(datadir,'Study2_IAPS2Embody_GAPED','IAPS_n18_negative.nii');
pos_imgs = fullfile(datadir,'Study2_IAPS2Embody_GAPED','IAPS_n18_positive.nii');
sex_imgs = fullfile(datadir,'Study2_IAPS2Embody_GAPED','IAPS_n18_sexual.nii');

clear data_test
data_test{1}=fmri_data(neg_imgs);
data_test{2}=fmri_data(pos_imgs);
data_test{3}=fmri_data(sex_imgs);

% analysis 
% -------------------------------------------------------------------------
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
for d = 1:size(data_test,2)
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
toplot(:,:,1) = [pexp_gens{1} pexp_gens{2} pexp_gens{3}];
toplot(:,:,2) = [pexp_mechs{1} pexp_mechs{2} pexp_mechs{3}];
toplot(:,:,3) = [pexp_therms{1} pexp_therms{2} pexp_therms{3}];
toplot(:,:,4) = [pexp_audis{1} pexp_audis{2} pexp_audis{3}];
toplot(:,:,5) = [pexp_viss{1} pexp_viss{2} pexp_viss{3}];
toplot(:,:,6) = [pexp_nps{1} pexp_nps{2} pexp_nps{3}];
toplot(:,:,7) = [pexp_siips{1} pexp_siips{2} pexp_siips{3}];

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips'};
create_figure; nplots = size(toplot,3); 
connames = {'negative' 'positive' 'sexual'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','noviolin', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Reddan_CONDS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Reddan_violin_CONDS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);











