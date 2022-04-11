%% Core multimodal / specific systems 

% This script creates images for Supplementary Figures XX 

% S Fig XX 
% (a) model encoding maps
% (b) core system maps - conjunction of weight map & model encoding map

% S Fig XX 
% (a) model weight maps 


%% set working dir and model names 

working_dir = scriptsdir;

% brain model names 
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

%% load data

% Model weights
% ----------------------------------------------------------------- % 
%% load data
archivedir=fullfile(resultsdir,'archive')
%load(fullfile(resultsdir,'PLS_stat_images.mat'));
load(fullfile(archivedir,'PLS_stat_images.mat'));

% relevant stat imgs
% ------------------------------------
% pls_bs_statimg
% pls_encode_statimg 
% pls_core_statimg 

%% Visualization
% ------------------------------------------------------------------------%
colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

% [0.6 0 0.8] * 256 = 154 0 205 --> to compare to colors in pptx 
  
    
% (a) Encoders
for m=1:5
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    pls_encode_statimg_fdr05_t3(m)=threshold (pls_encode_statimg_fdr05(m), [3 Inf], 'raw-between');
    o2 = addblobs(o2, region(pls_encode_statimg_fdr05_t3(m)),'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    
    figtitle = [models{m} '_Visualize_Encode_fdr05_t3.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end
% pls_encode_statimg_fdr05_nok: same maps


% Core System 
for m=1:5
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    o2 = addblobs(o2, region(pls_core_statimg_nok(m)), 'contour', 'color', colormax (m,:));
    
    figtitle = [models{m} '_Visualize_CoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

% Select Core System 
for m=2:5
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    o2 = addblobs(o2, region(select_core_system_nok(m)), 'contour', 'color', colormax (m,:));
    
    figtitle = [models{m} '_Visualize_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

% Weight maps
% the above way (displaying thresholded pls_bs_statimg) did not work: 
% Error using region>prep_mask_object (line 470)
% Illegal size for mask.dat, because it does not match its volInfo structure.
% don't want to deal with that now, 

% workaround: 

% 
plspatternsdir=(fullfile(resultsdir, 'patterns/PLS_patterns'));
cd(plspatternsdir)

patt(1)=fmri_data(['General_b10000_FDR05.nii']);
patt(2)=fmri_data(['Mechanical_b10000_FDR05.nii']);
patt(3)=fmri_data(['Thermal_b10000_FDR05.nii']);
patt(4)=fmri_data(['Sound_b10000_FDR05.nii']);
patt(5)=fmri_data(['Visual_b10000_FDR05.nii']);

% display thresholded maps
for m=1:5
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    
    figtitle = [models{m} '_Visualize_Weights.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

%% Sanity check

% these 2 maps look the same

o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m = 1
    % Threshold maps for figure @ positive values, some reasonable p value
    patt=fmri_data(['General_b10000_unthr.nii']);
    patt = threshold (patt, [3 Inf], 'raw-between', 'k', 10);
    
    montage(patt, o2, 'wh_montages', 3:4, 'maxcolor', [0.4 0 0.6], 'mincolor', [0 0 0]);
    
    patt=fmri_data(['General_b10000_FDR05.nii']);
    patt = threshold (patt, [3 Inf], 'raw-between', 'k', 10);
    
    montage(patt, o2, 'wh_montages', 5:6, 'maxcolor', [0.4 0 0.6], 'mincolor', [0 0 0]);
end







