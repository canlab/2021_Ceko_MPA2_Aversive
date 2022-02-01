% Test aversive PLS patterns on additional pleasant datasets

% Van't Hoff 2021 _ BASIC _

% (3a) VISUAL: Wehrum et al. 2013 
%     - high arousal (sexual images)
%     - low arousal (non-sexual pleasant images)
%     - no arousal neutral control? 

% (3b) VISUAL: Reddan at al. ... 
%     - high arousal (sexual images)
%     - low arousal (non-sexual pleasant images)
%     - no arousal neutral control? 

% test General, Visual
    

%% Test on conditions 
% load data 
% -------------------------------------------------------------------------
shared_drive  = '/Volumes/GoogleDrive/My Drive/A_Multi_lab_world_map/2021_VantHof_Sophie_BASIC_sex_classifier/'

load(fullfile(shared_drive,'results/data_objects.mat'));
load(fullfile(shared_drive,'results/image_names_and_setup.mat'))

basedir = '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/';
resultsdir = fullfile(basedir, 'results');
figsavedir = fullfile(resultsdir, 'figures');

% data description
% -------------------------------------------------------------------------
% con_0004 -- 4: sexual
% con_0001 -- 1: positive
% con_0002 -- 2: negative
% con_0003 -- 3: neutral

% 97 subjects

% analysis 
% -------------------------------------------------------------------------
data_test = DATA_OBJ;

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
for d = 1:size(DATA_OBJ,2)
    pexp_gens{d} = apply_mask(data_test{d}, gens, 'pattern_expression', 'ignore_missing');
    pexp_mechs{d} = apply_mask(data_test{d}, mechs, 'pattern_expression', 'ignore_missing');
    pexp_therms{d} = apply_mask(data_test{d}, therms, 'pattern_expression', 'ignore_missing');
    pexp_audis{d} = apply_mask(data_test{d}, audis, 'pattern_expression', 'ignore_missing');
    pexp_viss{d} = apply_mask(data_test{d}, viss, 'pattern_expression', 'ignore_missing');
    pexp_nps{d} = apply_mask(data_test{d}, nps, 'pattern_expression', 'ignore_missing');
    pexp_siips{d} = apply_mask(data_test{d}, siips, 'pattern_expression', 'ignore_missing');
end

% reshape pexp values to plot
toplot(:,:,1) = [pexp_gens{1} pexp_gens{2} pexp_gens{3} pexp_gens{4}];
toplot(:,:,2) = [pexp_mechs{1} pexp_mechs{2} pexp_mechs{3} pexp_mechs{4}];
toplot(:,:,3) = [pexp_therms{1} pexp_therms{2} pexp_therms{3} pexp_therms{4}];
toplot(:,:,4) = [pexp_audis{1} pexp_audis{2} pexp_audis{3} pexp_audis{4}];
toplot(:,:,5) = [pexp_viss{1} pexp_viss{2} pexp_viss{3} pexp_viss{4}];
toplot(:,:,6) = [pexp_nps{1} pexp_nps{2} pexp_nps{3} pexp_nps{4}];
toplot(:,:,7) = [pexp_siips{1} pexp_siips{2} pexp_siips{3} pexp_siips{4}];

% plot 
totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips'};
create_figure; nplots = size(toplot,3); 
connames = {'sexual' 'positive' 'negative' 'neutral'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind','noviolin', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Wehrum_CONDS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

create_figure; nplots = size(toplot,3); 

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns(toplot(:,:,n),'nofig','noind', 'colors', seaborn_colors(8), 'title', totitle{n}, 'names', connames);
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_test_on_Wehrum_violin_CONDS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);











