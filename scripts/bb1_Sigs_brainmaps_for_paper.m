%% Saves PLS pattern brain maps for figures 

% 
plspatternsdir=(fullfile(resultsdir, 'patterns/PLS_patterns'));
cd(plspatternsdir)

% for now saving in that dir, should probs be saving in Figures)


f_ext='.png';

% 
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

%%
% GENERAL 
o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    % Threshold maps for figure @ positive values, some reasonable p value
    patt=fmri_data(['General_b10000_unthr.nii']);
    
    patt = threshold (patt, [3 Inf], 'raw-between');

    %montage(patt, o2, 'wh_montages', 1:2, 'maxcolor', [0.9 0.9 1], 'mincolor', [0.1 0.1 0.1]);

    montage(patt, o2, 'wh_montages', 1:2, 'maxcolor', [0.4 0 0.6], 'mincolor', [0 0 0]);
%     colormaxg = [0.9 0.9 1]
%     colorming = colormaxg-0.5
%     montage(SR_statimg, o2, 'wh_montages', m:m+1, 'maxcolor', colormaxg, 'mincolor', colorming);
end

figtitle = sprintf(['Brainmap_General_VIOLET_b10_unthr_t3_pos.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% extra slices and colormap
figure; o2 = fmridisplay;
for m = 2
   o2 = montage(o2, 'coronal', 'slice_range', [-22 26], 'spacing', 4);
   o2 = addblobs(o2, region(patt), 'maxcolor', [0.9 0.9 1], 'mincolor', [0.1 0.1 0.1]);
end
figtitle = sprintf(['Brainmap_General_b10_unthr_t3_pos_extra.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


generalpatt=fmri_data('General_b10000_unc01.nii')
t = threshold(generalpatt, [0 7], 'raw-between');
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 1); % 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(generalpatt)) % 'cmaprange', [2 7]);

figtitle = sprintf('Brain map general 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;



figtitle = sprintf(['Brainmap_General_b10_unthr_t3_pos.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% PER MODALITY 

colormax= [1 0.2 0.4;
            1 0.6 0.2;
            0 0.6 0.4;
            0 0.4 1];
colormin = colormax-0.3;

colornegmax = [1 0.8 0.8];
colornegmin = colornegmax-0.2;

o2 = canlab_results_fmridisplay([], 'multirow', 4);

for m = 2:5

    patt=fmri_data([models{m} '_b10000_unthr.nii']);
    patt = threshold (patt, [3 Inf], 'raw-between');

    o2=addblobs(o2,patt, 'wh_montages', m*2-3:m*2-2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));
    %o2=addblobs(o2,patt, 'wh_montages', m*2-3:m*2-2, 'splitcolor',{colormax(m-1,:) colormin(m-1,:) colornegmax colornegmin});
end

figtitle = sprintf(['Brainmap_MODS_b10_unthr_t3.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;




%%%%% MORE DETAILED VIEWS %%%%%%%%%%%%%%%%%%%%%%
%% General
% ----------------------------------------------------------------------- %
generalpatt=fmri_data('General_b10000_FDR05.nii')
%create_figure

montage (generalpatt, 'full'); snapnow
figtitle = sprintf('Brain map general 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;
% 




%% General
% ----------------------------------------------------------------------- %
generalpatt=fmri_data('General_b10000_FDR05.nii')
%create_figure
%gen=montage(region(generalpatt), 'trans', 'full'); % displays each cluster in diff flat color, takes forever
%generalpattk10=threshold(generalpatt, [-1 1], 'raw-between', 'k', 10)
montage (generalpatt, 'full'); snapnow
figtitle = sprintf('Brain map general 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;
% 

% Detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 44], 'spacing', 4); % 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(generalpatt));
figtitle = sprintf('Brain map general 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2);  %'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(generalpatt));
figtitle = sprintf('Brain map general 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(generalpatt));
figtitle = sprintf('Brain map general 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
%o2=canlab_results_fmridisplay(region(generalpatt), 'compact2', 'noverbose', 'nooutline');
o2=canlab_results_fmridisplay(region(generalpatt), 'compact2', 'noverbose', 'nooutline', 'overlay', 'icbm152_2009_symmetric_for_underlay.img');
figtitle = sprintf('Brain map general 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


%% Mechanical 
% ----------------------------------------------------------------------- %
mechpatt=fmri_data('Mechanical_b10000_FDR05.nii')
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (mechpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map mech 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(mechpatt));
figtitle = sprintf('Brain map mech 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(mechpatt));
figtitle = sprintf('Brain map mech 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(mechpatt), 'compact2', 'noverbose', 'nooutline', 'overlay', 'icbm152_2009_symmetric_for_underlay.img');
figtitle = sprintf('Brain map mech 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


%% Thermal
% ----------------------------------------------------------------------- %
thermpatt=fmri_data('Thermal_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (thermpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map therm 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(thermpatt));
figtitle = sprintf('Brain map therm 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(thermpatt));
figtitle = sprintf('Brain map therm 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(thermpatt), 'compact2', 'noverbose', 'nooutline', 'overlay', 'icbm152_2009_symmetric_for_underlay.img');
figtitle = sprintf('Brain map therm 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;


%% Sound
% ----------------------------------------------------------------------- %
soundpatt=fmri_data('Sound_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (soundpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map sound 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(soundpatt));
figtitle = sprintf('Brain map sound 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(soundpatt));
figtitle = sprintf('Brain map sound 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(soundpatt), 'compact2', 'noverbose', 'nooutline', 'overlay', 'icbm152_2009_symmetric_for_underlay.img');
figtitle = sprintf('Brain map sound 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

%% Visual
% ----------------------------------------------------------------------- %
visualpatt=fmri_data('Visual_b10000_FDR05.nii');
%o2=canlab_results_fmridisplay(region(pressurepatt),'montage', 'compact2', 'noverbose', 'nooutline');
montage (visualpatt, 'full hcp'); snapnow;
figtitle = sprintf('Brain map visual 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed sagittal views: 
figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [-44 -38], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(visualpatt));
figtitle = sprintf('Brain map visual 0.05 FDR boot10 sagittal left');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

figure;o2 = fmridisplay;
o2 = montage(o2, 'saggital', 'slice_range', [38 44], 'spacing', 2, 'overlay', 'icbm152_2009_symmetric_for_underlay.img'); % good ins, midline
o2=addblobs(o2,region(visualpatt));
figtitle = sprintf('Brain map visual 0.05 FDR boot10 sagittal right');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% more detailed horizontal 
o2=canlab_results_fmridisplay(region(visualpatt), 'compact2', 'noverbose', 'nooutline', 'spacing', 4, 'overlay', 'icbm152_2009_symmetric_for_underlay.img');
figtitle = sprintf('Brain map visual 0.05 FDR boot10 horizontal');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

