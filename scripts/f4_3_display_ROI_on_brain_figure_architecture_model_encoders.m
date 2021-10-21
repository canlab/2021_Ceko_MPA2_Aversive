%% ROIs along sensory pathways

% This script displays ROIs on brain surfaces 


%% set up 
% ------------------------------------------------------------------------

% run a_set_up_paths_always_run_first.m
working_dir = scriptsdir;
cd(working_dir);


%% load ROIs 
% ------------------------------------------------------------------------

%load ROIs from saved 
load (fullfile(resultsdir, 'ROI_obj_to_plot.mat'));



%% THALAMUS
% --------------------------------------------------------------------------------- 
o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [0 4], 'spacing', 1);
o2 = addblobs (o2, thal_obj);
figtitle = 'ROI_THAL_AX_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

% Better view of LGN and MGN
thal_genic = select_atlas_subset(thal_obj,{'LGN' 'MGN'});

o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [-8 -4], 'spacing', 1);
o2 = addblobs (o2, thal_genic);
figtitle = 'ROI_THAL_AX_GENIC_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

% 3D display of the ROI
create_figure('isosurface');
surface_handles = isosurface(thal_obj);

% Set lighting and figure properties
axis image vis3d off
material dull
view(210, 20);
lightRestoreSingle

figtitle = 'ROI_THAL_map.png'; savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% Don't like it with brain surface added, tried various options though
% han = addbrain('surface right');
% set(han, 'FaceAlpha', 0.1);

% --------------------------------------------------------------------------------- 
%% COLLICULI + BS
% ---------------------------------------------------------------------------------
o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [2 6], 'spacing', 1);
o2 = addblobs (o2, collic1_obj);
figtitle = 'ROI_COLLIC_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [0 6], 'spacing', 1);
o2 = addblobs (o2, bs_obj);
figtitle = 'ROI_BS_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

% --------------------------------------------------------------------------------- 
%% CORE AFFECT 
% --------------------------------------------------------------------------------- 
%affect_compact = cc

%figtitle = 'ROI_encoders_CC.png'
figtitle = 'ROI_encoders_AFFECT.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [0 6], 'spacing', 1);
o2 = addblobs (o2, affect_obj);
figtitle = 'ROI_AFFECT_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [0 6], 'spacing', 1);
o2 = addblobs (o2, affect_obj);
figtitle = 'ROI_AFFECT_AX_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [-50 -30], 'spacing', 1);
o2 = addblobs (o2, affect_obj);
figtitle = 'ROI_AFFECT_SAG2_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [-20 0], 'spacing', 1);
o2 = addblobs (o2, affect_obj);
figtitle = 'ROI_AFFECT_AX2_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2


% --------------------------------------------------------------------------------- 
%% INSULA:
% --------------------------------------------------------------------------------- 
o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [-40 -35], 'spacing', 1);
o2 = addblobs (o2, ins);
figtitle = 'ROI_INS_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [-40 -35], 'spacing', 1);
o2 = addblobs (o2, aINS);

% --------------------------------------------------------------------------------- 
%% SENSORY
% --------------------------------------------------------------------------------- 

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [-60 -30], 'spacing', 2);
o2 = addblobs (o2, S1);
o2 = addblobs (o2, S2);
figtitle = 'ROI_S1S2full_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sagittal','slice_range', [-50 0], 'spacing', 2);
o2 = addblobs (o2, AV_obj);
figtitle = 'ROI_AUDIVIS_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [-10 10], 'spacing', 2);
o2 = addblobs (o2, AV_obj);
figtitle = 'ROI_AUDIVIS_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'axial','slice_range', [10 40], 'spacing', 2);
o2 = addblobs (o2, ss_obj);
figtitle = 'ROI_SS_AX_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sag','slice_range', [-60 -40], 'spacing', 2);
o2 = addblobs (o2, ss_obj);
figtitle = 'ROI_SS_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2

o2 = fmridisplay; o2 = montage(o2, 'sag','slice_range', [-60 -30], 'spacing', 2);
o2 = addblobs (o2, A_23);
figtitle = 'ROI_A23_SAG_map.png';
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; clear o2



% %% PLAY WITH CUTAWAYS 
% 
% 
% figure; addbrain('midbrain_group');
% addbrain('lc'); addbrain('rvm'); addbrain('VPL'); addbrain('thalamus');
% addbrain('bg');
% addbrain('hires left');
% view(135, 10); lightRestoreSingle;
% 
% atlas_obj = load_atlas('pain_pathways_atlas_obj.mat')
% 
% atlas_obj=select_atlas_subset(atlas_obj, {'aIns'});
% 
% atlas_obj = load_atlas('affect_obj');
% % atlas_obj = select_atlas_subset(atlas_obj, {'Def'}, 'labels_2');
% 
% create_figure('isosurface');
% surface_handles = isosurface(ins_obj);
% addbrain('hires left');
% view(135, 10); lightRestoreSingle;
% 
% render_on_surface(t1, surface_handles, 'colormap', 'hot');
% % 
% figure; addbrain('surface left');
% figure; addbrain('left_insula_slab');
% 
% view(135, 10); lightRestoreSingle;
% 
% figure; 
% 
% han =  isosurface(anat, 'thresh', 140, 'nosmooth', 'xlim', [-Inf 0], 'YLim', [-30 Inf])
% anat = fmri_data(which('keuken_2014_enhanced_for_underlay.img'), 'noverbose');
% figure;
% anat = fmri_data(which('keuken_2014_enhanced_for_underlay.img'), 'noverbose');
% [isosurf, isocap] = deal({});
% [p, ~, isosurf{1}, isocap{1}] = isosurface(anat, 'thresh', 140, 'nosmooth', 'xlim', [-Inf 0]);


