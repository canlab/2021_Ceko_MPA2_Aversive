%% Creates and saves list and montage of clusters

f_ext='.png';

%% Diary 
diaryname = fullfile(['Clusters_tables_' date '_output.txt']);
diary(diaryname);

% 
plspatternsdir=(fullfile(resultsdir, 'patterns/PLS_patterns'));
cd(plspatternsdir)

load(fullfile(resultsdir,'PLS_bootstats10000_N55_ResultsTable.mat'));

%% Write out cluster stats
for m=1:5
writetable(results_table{m},'Allpatt_FDRcorr.xls','Sheet',m);
end

%%% NOTE: maps are already FDR05 and n=10 thresholded 

%% Clusters 
% General 
generalpatt=fmri_data('General_b10000_FDR05.nii')
r=region(generalpatt); 

montage(r,'colormap','regioncenters');
figtitle = sprintf('Clusters General 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% Mechanical 
clear r 
mechpatt=fmri_data('Mechanical_b10000_FDR05.nii')
r=region(mechpatt); 

montage(r,'colormap','regioncenters');
figtitle = sprintf('Clusters Mechanical 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% Therm
clear r 
thermpatt=fmri_data('Thermal_b10000_FDR05.nii')
r=region(thermpatt); 

montage(r,'colormap','regioncenters');
figtitle = sprintf('Clusters Thermal 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% Sound 
clear r 
soundpatt=fmri_data('Sound_b10000_FDR05.nii');
r=region(soundpatt); 

montage(r,'colormap','regioncenters');
figtitle = sprintf('Clusters Sound 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

% Visual
clear r 
visualpatt=fmri_data('Visual_b10000_FDR05.nii');
r=region(visualpatt); 

montage(r,'colormap','regioncenters');
figtitle = sprintf('Clusters Visual 0.05 FDR boot10 full montage');
savename=([figtitle f_ext]); saveas(gcf,savename); drawnow, snapnow;

diary off