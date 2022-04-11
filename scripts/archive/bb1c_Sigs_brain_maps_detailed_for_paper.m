%% Saves PLS pattern brain maps for figures 

% 
plspatternsdir=(fullfile(resultsdir, 'patterns/PLS_patterns'));
cd(plspatternsdir)

% for now saving in that dir, should probs be saving in Figures

f_ext='.png';

%%% NOTE: maps are already FDR05 and n=10 thresholded 

%% General
% ----------------------------------------------------------------------- %
generalpatt=fmri_data('General_b10000_FDR05.nii')
t = generalpatt


montage (generalpatt, 'full'); snapnow
figtitle = sprintf('Brain map general 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


t = generalpatt
%t = threshold(generalpatt, [0 Inf], 'raw-between');

%% Full brain cutaways 
anat = fmri_data(which('keuken_2014_enhanced_for_underlay.img'), 'noverbose');

% MPFC 
create_figure('cutaways'); axis off

p = isosurface(anat, 'thresh', 140, 'nosmooth', 'ylim', [-Inf -20]);
p2 = isosurface(anat, 'thresh', 140, 'nosmooth', 'xlim', [-Inf 0], 'YLim', [-30 Inf]);
alpha 1 ; lightRestoreSingle; view(135, 30); colormap gray;
surface_handles = [p p2]
render_on_surface(t, surface_handles, 'colormap', 'summer');


create_figure('isosurface');
surface_handles = isosurface(atlas_obj);
han = addbrain('left_insula_slab');
%set(han, 'FaceAlpha', 0.3);

% surface_handles = isosurface(atlas_obj, 'thresh', 140, 'nosmooth', 'xlim', [-43 -33], 'YLim', [-15 20], 'ZLim', [-15 8]);
% 
% render_on_surface(t, surface_handles, 'colormap', 'hot');
render_on_surface(t, surface_handles, 'colormap', 'summer', 'clim', [0 6]);

view(-127, 33);
material dull
set(surface_handles, 'FaceAlpha', .85);
snapnow








keywords = {'left_cutaway' 'right_cutaway' 'left_insula_slab' 'right_insula_slab' 'accumbens_slab' 'coronal_slabs' 'coronal_slabs_4' 'coronal_slabs_5'};

for i = 1:length(keywords)

    create_figure('cutaways'); axis off

    surface_handles = surface(t, keywords{i});

    % This essentially runs the code below:

    % surface_handles = addbrain(keywords{i}, 'noverbose');
    % render_on_surface(t, surface_handles, 'clim', [-7 7]);

    % Alternative: This command creates the same surfaces:
    % surface_handles = canlab_canonical_brain_surface_cutaways(keywords{i});
    % render_on_surface(t, surface_handles, 'clim', [-7 7]);

    drawnow, snapnow

end

%% General on insula 

t = pls_core_statimg_nok(1)
atlas_obj = load_atlas ('insula');

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);

% Now we'll set some lighting and figure properties
axis image vis3d off
material dull
view(210, 20);
lightRestoreSingle

drawnow, snapnow

% You can render blobs on these surfaces too.

render_on_surface(t, surface_handles);
drawnow, snapnow


%% General on thalamus
atlas_obj = load_atlas('thalamus');
%atlas_obj = load_atlas('bg');

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);

% Set lighting and figure properties
axis image vis3d off
material dull
view(210, 20);
lightRestoreSingle

drawnow, snapnow

% Render blobs on surfaces
render_on_surface(t, surface_handles, 'colormap', 'hot');
drawnow, snapnow

t = select_core_system_nok(2)

render_on_surface(t, surface_handles, 'colormap', 'cool');
drawnow, snapnow

%% General on amy
atlas_obj = load_atlas('canlab2018_2mm');
atlas_obj = select_atlas_subset(atlas_obj, {'Amy'}, 'flatten');

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);

han = addbrain('limbic');
set(han, 'FaceAlpha', 1);

% Now we'll set some lighting and figure properties
axis image vis3d off
material dull
view(210, 20);
lightRestoreSingle

drawnow, snapnow

% You can render blobs on these surfaces too.

render_on_surface(t, surface_handles, 'colormap', 'hot');
drawnow, snapnow

%% on ains .... needs work

atlas_obj = load_atlas('pain_pathways_atlas_obj.mat')

atlas_obj=select_atlas_subset(atlas_obj, {'aIns'});

% atlas_obj = load_atlas('canlab2018_2mm');
% atlas_obj = select_atlas_subset(atlas_obj, {'Def'}, 'labels_2');

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);

% let's add a cortical surface for context
% We'll make the back surface (right) opaque, and the front (left) transparent
% han = addbrain('right_insula_slab');
% set(han, 'FaceAlpha', 1);

han = addbrain('transparent_surface');
% set(han, 'FaceAlpha', 1);

% han2 = addbrain('left_insula_slab');
% set(han2, 'FaceAlpha', 0.1);

axis image vis3d off
material dull
view(-88, 31);
lightRestoreSingle

drawnow, snapnow

render_on_surface(t, surface_handles, 'colormap', 'hot');
drawnow, snapnow




%% 
anat = fmri_data(which('keuken_2014_enhanced_for_underlay.img'), 'noverbose');

create_figure('cutaways'); axis off


atlas_obj = load_atlas('pain_pathways_atlas_obj.mat')

atlas_obj=select_atlas_subset(atlas_obj, {'aIns'});

%atlas_obj=select_atlas_subset(atlas_obj, {'s1'});
% atlas_obj = load_atlas('canlab2018_2mm');
% atlas_obj = select_atlas_subset(atlas_obj, {'Def'}, 'labels_2');

create_figure('isosurface');
surface_handles = isosurface(atlas_obj);
han = addbrain('left_insula_slab');
%han = addbrain('hires left');
set(han, 'FaceAlpha', 0.1);

surface_handles = isosurface(atlas_obj, 'thresh', 140, 'nosmooth', 'xlim', [-43 -33], 'YLim', [-15 20], 'ZLim', [-15 8]);

render_on_surface(t, surface_handles, 'colormap', 'hot');

view(-127, 33);
material dull
set(surface_handles, 'FaceAlpha', .85);
snapnow





%% 
% Detailed sagittal views: 
generalpatt=fmri_data('General_b10000_unc01.nii')
t = threshold(generalpatt, [0 7], 'raw-between');
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 1); % 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(generalpatt)) % 'cmaprange', [2 7]);

figtitle = sprintf('Brain map general 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% [fc, fc_names] = load_patterns_thr;
% colors_mont={[0.5 0.5 0.5] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}' 
% fc_colors = colors_mont;
% 
% o2 = canlab_results_fmridisplay([]);
% 
% figure;o2 = fmridisplay;
% o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2);
% for i = 1:n
%     
%     myfc = get_wh_image(fc, i);
%     o2 = addblobs(o2, region(myfc), 'color', fc_colors{i});
%     
% end

drawnow, snapnow