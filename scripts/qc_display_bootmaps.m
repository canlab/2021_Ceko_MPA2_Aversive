%% This code runs QC on map displays

% run first:
% a_set_up_paths ...
% a2_mc_set_up_paths
% a2_set_default_options

%% Prep

cd(qcdir);
f_ext='.png';
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

%%
% GENERAL 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

patt=fmri_data(['General_b10000_qc_unthr.nii']);
%patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 1:2, 'maxcolor', [0.4 0 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_unc01.nii']);
% patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 3:4, 'maxcolor', [0.4 0.2 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_unc001.nii']);
% patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 5:6, 'maxcolor', [0.4 0.4 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_FDR05.nii']);
% patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 7:8, 'maxcolor', [0.4 0.6 0.6], 'mincolor', [0 0 0]);

figtitle = sprintf(['qc_brainmap_General_b10_unthr_01_001_fdr.png'])
savename = fullfile(qcfigsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% GENERAL 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

patt=fmri_data(['General_b10000_qc_unthr.nii']);
patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 1:2, 'maxcolor', [0.4 0 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_unc01.nii']);
patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 3:4, 'maxcolor', [0.4 0.2 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_unc001.nii']);
patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 5:6, 'maxcolor', [0.4 0.4 0.6], 'mincolor', [0 0 0]);

patt=fmri_data(['General_b10000_qc_FDR05.nii']);
patt = threshold (patt, [3 Inf], 'raw-between');
o2=addblobs(o2, patt, 'wh_montages', 7:8, 'maxcolor', [0.4 0.6 0.6], 'mincolor', [0 0 0]);

figtitle = sprintf(['qc_brainmap_General_pos_values_b10_unthr_01_001_fdr.png'])
savename = fullfile(qcfigsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;





