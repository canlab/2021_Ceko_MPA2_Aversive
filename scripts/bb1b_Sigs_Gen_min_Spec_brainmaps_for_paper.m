%% Creates difference maps Gen - each Spec 

% create and save brain maps 

% enforce 
f_ext='.png';


%% Gen - Mech 
% ----------------------------------------------------------------------- %
mechpatt=fmri_data('G_Mechanical_b10000_FDR05.nii')
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (mechpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map gen mech 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(mechpatt));
figtitle = sprintf('Brain map gen mech 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(mechpatt));
figtitle = sprintf('Brain map gen mech 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(mechpatt), 'compact2', 'noverbose', 'nooutline');
figtitle = sprintf('Brain map gen mech 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


%% Gen - Thermal
% ----------------------------------------------------------------------- %
thermpatt=fmri_data('G_Thermal_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (thermpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map gen therm 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(thermpatt));
figtitle = sprintf('Brain map gen therm 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(thermpatt));
figtitle = sprintf('Brain map gen therm 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(thermpatt), 'compact2', 'noverbose', 'nooutline');
figtitle = sprintf('Brain map gen therm 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


%% Gen - Sound
% ----------------------------------------------------------------------- %
soundpatt=fmri_data('G_Sound_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (soundpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map gen sound 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(soundpatt));
figtitle = sprintf('Brain map gen sound 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(soundpatt));
figtitle = sprintf('Brain map gen sound 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(soundpatt), 'compact2', 'noverbose', 'nooutline');
figtitle = sprintf('Brain map gen sound 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

%% Gen - Visual
% ----------------------------------------------------------------------- %
visualpatt=fmri_data('G_Visual_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (visualpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map gen visual 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(visualpatt));
figtitle = sprintf('Brain map gen visual 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2); % good ins, midline
o2=addblobs(o2,region(visualpatt));
figtitle = sprintf('Brain map gen visual 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(visualpatt), 'compact2', 'noverbose', 'nooutline', 'spacing', 4);
figtitle = sprintf('Brain map gen visual 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

