% Test aversive PLS patterns on additional pleasant datasets

% (1) TASTE, TOUCH: Soo Ahn Lee & Wani Woo, Cocoanlab
%     - positive (sweet (chocolate), light touch)
%     - negative (quinine, capsaicin)  - General might respond = additional validation
% test General, (Mechanical)

% -------------------------------------------------------------------------
% a_set_up_paths_always_run_first

% load data 
% -------------------------------------------------------------------------
load('/Users/marta/Documents/DATA/MPA2/34bin_beta/betadat_34bin_58subjs.mat');

% data description
% -------------------------------------------------------------------------
% betadat_34bin: 
% each run (cap, choc, quin, touch) lasts 14.5 mins and is divided into 34 bins, each bin is 25 seconds (34 x 25 = 850 seconds = 14.17 mins) 
% stimulation starts at bin 4 and bin 17
% duration caps   - 90 sec  --> 90/25 = ca. 3.5 bins
% duration sweet - 180 sec --> 180/25 = ca. 7 bins
% duration quin  - 90 (email pic) or 120 (email text)?  checking ...
% duration touch - 180 sec --> 180/25 = ca. 7 bins

% whfolds: size = 1972 = 58 participants x 35 bins

% analysis 
% -------------------------------------------------------------------------

%% touch
% ----------------------------------------------
% expecting no response to NPS, SIIPS, GENS, THERMS 

clear data_test

data_test = fmri_data(which('gray_matter_mask.nii'), which('gray_matter_mask.nii')); 
data_test.dat = betadat_34bin.touch.dat
data_test.Y = betadat_34bin.touch.y

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
toplot(:,:,1) = reshape(pexp_gens, 58, 34);
toplot(:,:,2) = reshape(pexp_mechs, 58, 34);
toplot(:,:,3) = reshape(pexp_therms, 58, 34);
toplot(:,:,4) = reshape(pexp_audis, 58, 34);
toplot(:,:,5) = reshape(pexp_viss, 58, 34);
toplot(:,:,6) = reshape(pexp_nps, 58, 34);
toplot(:,:,7) = reshape(pexp_siips, 58, 34);

% include ratings, to see how they match the stimulus timings
toplot(:,:,8) = reshape(data_test.Y, 58,34);
toplot(:,:,8) = - toplot(:,:,8); 

% plot full run
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(8,1,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n});
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1c_touch_plot_fullrun.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% plot stimulus period
% -------------------------------------------------------------------------

% extract relevant bins
clear toplot_stim
toplot_stim = toplot(:,[4:10,17:23],:);

totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'stim 1' 'stim 1' 'stim 1' 'stim 1' 'stim 1' 'stim 1' 'stim 1' ...
    'stim2' 'stim2' 'stim2' 'stim2' 'stim2' 'stim2' 'stim2'};

for n = 1:nplots
    axh(n) = subplot(4,4,n);
    barplot_columns(toplot_stim(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n}, 'names', binnames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1c_touch_plot_stim.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% plot bl before + 1st bin of stim 
% -------------------------------------------------------------------------
% extract relevant bins
clear toplot_blstim
toplot_blstim = toplot(:,[3 16 4 17],:);

% save for later
toplot_blstim_touch = toplot_blstim;

% plot
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'base 1' 'base 2' 'stim 1' 'stim 2'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot_blstim(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n}, 'colors', seaborn_colors(8), 'names', binnames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1c_touch_plot_BL_STIM.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% plot 3 stimuli together: 

% plot
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'caps b1' 'caps b2' 'caps s1' 'caps s2' ...
    'sweet b1' 'sweet b2' 'sweet s1' 'sweet s2' ...
    'touch b1' 'touch b2' 'touch s1' 'touch s2'};

for n = 1:nplots
    axh(n) = subplot(4,4,n);
    barplot_columns([toplot_blstim_cap(:,:,n) toplot_blstim_sweet(:,:,n) toplot_blstim_touch(:,:,n)] ,'nofig','noind', 'noviolin', 'title', totitle{n}, 'colors', seaborn_colors(16), 'names', binnames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1_cap_sweet_touch_plot_BL_STIM.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% plot
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'caps b1' 'caps b2' 'caps s1' 'caps s2' ...
    'sweet b1' 'sweet b2' 'sweet s1' 'sweet s2' ...
    'touch b1' 'touch b2' 'touch s1' 'touch s2'};

for n = 1:nplots
    axh(n) = subplot(4,4,n);
    barplot_columns([toplot_blstim_cap(:,:,n) toplot_blstim_sweet(:,:,n) toplot_blstim_touch(:,:,n)] ,'nofig','noind', 'title', totitle{n}, 'colors', seaborn_colors(16), 'names', binnames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1_violin_cap_sweet_touch_plot_BL_STIM.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);






