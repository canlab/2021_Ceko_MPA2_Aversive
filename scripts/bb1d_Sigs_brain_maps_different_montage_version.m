%% Saves PLS pattern brain maps for figures 

% 
plspatternsdir=(fullfile(resultsdir, 'patterns/PLS_patterns'));
cd(plspatternsdir)

% for now saving in that dir, should probs be saving in Figures

f_ext='.png';

%%% NOTE: maps are already FDR05 and n=10 thresholded 

%% General
% ----------------------------------------------------------------------- %
% For Figures: 
% GENERAL 
o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    patt=fmri_data('General_b10000_unc001.nii')
    colormaxg = [0.9 0.9 1]
    colorming = colormaxg-0.5
    montage(patt, o2, 'wh_montages', m:m+1, 'maxcolor', colormaxg, 'mincolor', colorming);
end
figtitle = sprintf(['GEN_pattern_b10000_unc001.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    patt=fmri_data('General_b10000_unc01.nii')
    colormaxg = [0.9 0.9 1]
    colorming = colormaxg-0.5
    montage(patt, o2, 'wh_montages', m:m+1, 'maxcolor', colormaxg, 'mincolor', colorming);
end
figtitle = sprintf(['GEN_pattern_b10000_unc01.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% can't see much with that color


o2 = canlab_results_fmridisplay([], 'multirow', 1);

for m = 1
    patt=fmri_data('General_b10000_unc01.nii')

    montage(patt, o2, 'wh_montages', m:m+1, 'maxcolor', [0.1 0.1 0.1], 'mincolor', [0.1 0.1 0.1]);
end
figtitle = sprintf(['GEN_pattern_b10000_unc01_black.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% PER MODALITY - VIS
o2 = canlab_results_fmridisplay([], 'multirow', 3);

colormax= [1 0.2 0.4;
            1 0.6 0.2;
            0 0.6 0.4;
            0 0.4 1];
colormin = colormax-0.3;


m=2;
patt=fmri_data('Mechanical_b10000_unc01.nii')
montage(patt, o2, 'wh_montages', 1:2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));

m=3;
patt=fmri_data('Thermal_b10000_unc01.nii')
montage(patt, o2, 'wh_montages', 3:4, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));

m=4;
patt=fmri_data('Sound_b10000_unc01.nii')
montage(patt, o2, 'wh_montages', 5:6, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));

figtitle = sprintf(['MOD_Mech_to_Sound_pattern_b10000_unc01.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% VIS
o2 = canlab_results_fmridisplay([], 'multirow', 1);
m=5
patt=fmri_data('Visual_b10000_unc01.nii')
montage(patt, o2, 'wh_montages', 1:2, 'mincolor', colormin(m-1,:), 'maxcolor', colormax (m-1,:));

figtitle = sprintf(['MOD_Vis_pattern_b10000_unc01.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;







patt=fmri_data('General_b10000_unc001.nii')


montage (generalpatt, 'full'); snapnow
figtitle = sprintf('Brain map general 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

