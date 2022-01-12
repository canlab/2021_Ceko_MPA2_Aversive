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
%% caps 
% ----------------------------------------------
clear data_test

data_test = fmri_data(which('gray_matter_mask.nii'), which('gray_matter_mask.nii')); 
data_test.dat = betadat_34bin.caps.dat
data_test.Y = betadat_34bin.caps.y

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

clear caps_pexpstim caps_pexpbase
caps_pexpstim = mean(toplot(:,[4:7,17:20],:),2);
caps_pexpbase = mean(toplot(:,[1:3,8:16,21:34],:),2);
caps_pexpbasetrim = mean(toplot(:,[1:3,12:16],:),2);

% SAVE FOR PLOT ACROSS CONDITIONS in 1d_plot_all_Lee
% ------------------------------------------------------------------------
savefilenamedata =(fullfile(resultsrevdir,'Pattexps_Lee.mat'));
save(savefilenamedata, 'caps_pexpstim'); 
save(savefilenamedata, 'caps_pexpbase', '-append'); 
save(savefilenamedata, 'caps_pexpbasetrim', '-append'); 


%% plot full run
% -------------------------------------------------------------------------
create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(3,8,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n});
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1a_caps_plot_fullrun.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% plot stimulus period
% -------------------------------------------------------------------------
% extract relevant bins
clear toplot_stim
toplot_stim = toplot(:,[4:7,17:20],:);

create_figure; nplots = size(toplot,3); 
binnames = {'stim 1' 'stim 1' 'stim 1' 'stim 1'  'stim2' 'stim2' 'stim2' 'stim2'};

for n = 1:nplots
    axh(n) = subplot(4,4,n);
    barplot_columns(toplot_stim(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n}, 'names', binnames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1a_caps_plot_stim.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% % plot bl before + 1st bin of stim 
% % -------------------------------------------------------------------------
% % extract relevant bins
% clear toplot_blstim
% toplot_blstim = toplot(:,[3 16 4 17],:);
% 
% % save for later
% toplot_blstim_cap = toplot_blstim 
% 
% 
% % plot
% create_figure; nplots = size(toplot,3); 
% binnames = {'base 1' 'base 2' 'stim 1' 'stim 2'};
% 
% for n = 1:nplots
%     axh(n) = subplot(4,5,n);
%     barplot_columns(toplot_blstim(:,:,n),'nofig','noind', 'noviolin', 'title', totitle{n}, 'colors', seaborn_colors(8), 'names', binnames);
%     set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
%     xlabel(''), ylabel(''); drawnow
% end
% figtitle = 'rev2_1a_caps_plot_BL_STIM.png'
% savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);
% 

