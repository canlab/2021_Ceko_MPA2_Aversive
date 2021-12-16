%%

% This script creates images for Supplementary Figure XX 


%% set working dir and model names 

% brain model names 
models = {'NGeneral' 'NVisneg' 'Vispos'}; 

%% load weight maps
cd(resultsrevdir)
patt(1)=fmri_data(['patterns/NGeneral_b10000_FDR05.nii']);
patt(2)=fmri_data(['patterns/NVisneg_b10000_FDR05.nii']);
patt(3)=fmri_data(['patterns/NVispos_b10000_FDR05.nii']);

cd(scriptsrevdir)

%% Visualization
% ------------------------------------------------------------------------%
% colormax= [0.8 0.6 0;  % brown yellow
%            0.4 0.8 1;  % light blue
%            0.9 0.6 1]; % light pink
%        
       
colormax = [0.9 0.7 0;
            0.2 0.8 1;  % light blue
           1 0.4 1]; 
       
colormin = colormax-0.3;

% [0.6 0 0.8] * 256 = 154 0 205 --> to compare to colors in pptx 


% display thresholded maps
for m=1:3
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


% display pos and neg on single map 

o2 = fmridisplay
o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
enlarge_axes(gcf,0.7,1.4);
axh = axes('Position', [-0.02 .75-.3 .17 .17]);
axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);

patt(2) = threshold (patt(2), [3 Inf], 'raw-between', 'k', 10);
o2 = addblobs(o2, region(patt(2)), 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));

patt(3) = threshold (patt(3), [3 Inf], 'raw-between', 'k', 10);
o2 = addblobs(o2, region(patt(3)), 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));

figtitle = ['NPOSNEG_Visualize_Weights.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2



%load(savefilename, 'pls_encode_statimg');


%% Save montages for figures 
% ----------------------------------------------------------------------- %
colormax = [0.9 0.7 0;
            0.2 0.8 1;  % light blue
           1 0.4 1]; 
       
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 3);
for m = 1:3
    % Threshold maps for figure @ positive values, some reasonable p value
    encode_statimg = ttest (encode_obj(m));

    encode_statimg = threshold (encode_statimg, [3 Inf], 'raw-between');

    o2=addblobs(o2,encode_statimg, 'wh_montages', m*2-1:m*2, 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
end

figtitle = sprintf(['MODALITIES_NORMPLS_modelencoder_pos_t3.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% NICER MONTAGE FOR FIGUR, TO MATCH MAIN PAPER 

% (a) Encoders
for m=1:3
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    pls_encode_statimg_fdr05_t3(m)=threshold (pls_encode_statimg_fdr05(m), [3 Inf], 'raw-between');
    o2 = addblobs(o2, region(pls_encode_statimg_fdr05_t3(m)),'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    
    figtitle = [models{m} '_NPLS_Visualize_Encode_fdr05_t3.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end
% pls_encode_statimg_fdr05_nok: same maps


% Display pos + neg on same map

o2 = fmridisplay
o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
enlarge_axes(gcf,0.7,1.4);
axh = axes('Position', [-0.02 .75-.3 .17 .17]);
axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);

pls_encode_statimg_fdr05_t3(2)=threshold (pls_encode_statimg_fdr05(2), [3 Inf], 'raw-between');
o2 = addblobs(o2, region(pls_encode_statimg_fdr05_t3(2)),'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));

pls_encode_statimg_fdr05_t3(3)=threshold (pls_encode_statimg_fdr05(3), [3 Inf], 'raw-between');
o2 = addblobs(o2, region(pls_encode_statimg_fdr05_t3(3)),'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));

figtitle = [models{m} '_NPLS_Visualize_Encode_NEG_AND_POS_fdr05_t3.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2


%% ENCODE MAPS  - display maps, conjunction

load(fullfile(encode_resultsdir, 'encode_out.mat'));

% Re-recreate tmaps
genvis = ttest (encode_obj(1));
genvis = threshold (genvis, [3 Inf], 'raw-between');

negvis = ttest (encode_obj(2));
negvis = threshold (negvis, [3 Inf], 'raw-between');

posvis = ttest (encode_obj(3));
posvis = threshold (posvis, [3 Inf], 'raw-between');

% Create display 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

% GEN, NEGVIS, POSVIS
o2=addblobs(o2,region(genvis),'wh_montages', 1:2, 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));

o2=addblobs(o2,region(negvis),'wh_montages', 3:4, 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));
o2=addblobs(o2,region(posvis),'wh_montages', 3:4, 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));


% CONJUNCTION 

% SOMETHING IS WRONG HERE, IT IS SHOWING 0 VOXEL OVERLAP, even for Gen +Pos
% % Overlap
conj_vis = conjunction (pls_encode_statimg_fdr05(2), pls_encode_statimg_fdr05(3), 1);
o2=addblobs(o2,region(conj_vis),'wh_montages', 3:4, 'trans', 'color', [1 1 0]);

conj_gennegvis = conjunction (pls_encode_statimg_fdr05(1), pls_encode_statimg_fdr05(2), 1);
o2=addblobs(o2,region(conj_vis),'wh_montages', 5:6, 'trans', 'color', [1 1 0]);

conj_genposvis = conjunction (pls_encode_statimg_fdr05(1), pls_encode_statimg_fdr05(3), 1);
o2=addblobs(o2,region(conj_vis),'wh_montages', 7:8, 'trans', 'color', [1 1 0]);

figtitle = sprintf('Conjunction_GENVIS_NEGVIS_POSVIS_SRwtnROB_conj.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% NO OVERLAP between NEG and POS:
% Grouping contiguous voxels:  39 regions
% sagittal montage: 301 voxels displayed, 8120 not displayed on these slices
% axial montage: 2844 voxels displayed, 5577 not displayed on these slices
% Grouping contiguous voxels: 153 regions
% sagittal montage: 480 voxels displayed, 6170 not displayed on these slices
% axial montage: 2270 voxels displayed, 4380 not displayed on these slices
% Grouping contiguous voxels:   0 regions


%% AMYGDALA - model encoding maps 

atlas_obj = load_atlas('canlab2018_2mm');
atlas_obj = select_atlas_subset(atlas_obj, {'Amy'});

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);

han = addbrain('transparent_surface');
%set(han, 'FaceAlpha', 1);

axis image vis3d off
material dull
view(-88, 31);
lightRestoreSingle
drawnow, snapnow

render_on_surface(negvis, surface_handles, 'colormap', 'hot');
render_on_surface(posvis, surface_handles, 'colormap', 'cold');
drawnow, snapnow

%% Display in more detail for figs

% Sagittal lateral 
for m=1:3
    o2 = fmridisplay
    o2 = montage(o2, 'sagittal','slice_range', [-50 50], 'spacing', 2);
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    figtitle = [models{m} '_Visualize_Weights_SAG.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

% AMY:  DISPLAY ALL THREE MODELS 
% -------------------------------------------------------------------------

o2 = fmridisplay
o2 = montage(o2, 'axial','slice_range', [-22 -8], 'spacing', 1);
for m=1:3
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    figtitle = [models{m} '_Visualize_Weights_AMY_AXIAL.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    %clear o2
end

% AMY ==== -27, -4, -20
o2 = fmridisplay
o2 = montage(o2, 'coronal','slice_range', [-10 0], 'spacing', 1);
for m=1:3
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    figtitle = [models{m} '_Visualize_Weights_AMY_COR.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    %clear o2
end



% mid Z of the brain 
for m=1
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [0 26], 'spacing', 2);
    o2 = addblobs (o2, region(pls_core_statimg_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_MID_LATERAL_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end


% top of the brain 
for m=1
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [27 57], 'spacing', 2);
    o2 = addblobs (o2, region(pls_core_statimg_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_TOP_LATERAL_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end










