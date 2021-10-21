%% Display in more detail for figs: Core multimodal / selective specific systems 

 % This script displays detailed views of interest and saves pngs for figures

%% Prep 

% set working dir and model names
% ----------------------------------------------------------------- % 
working_dir = scriptsdir;

% brain model names 
models = {'Common' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

% load data 
% ----------------------------------------------------------------- % 
archivedir=fullfile(resultsdir,'archive')
%load(fullfile(resultsdir,'PLS_stat_images.mat'));
load(fullfile(archivedir,'PLS_stat_images.mat'));

% relevant stat imgs: 

% Common Core System
% pls_core_statimg_nok (1)  

% Specific Core Systems
% select_core_system_nok (2-5) 

% set colors 
% ------------------------------------------------------------------------%
colormax= [0.6 0 0.8;  % purple
           1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];
colormin = colormax-0.3;

% [0.6 0 0.8] * 256 = 154 0 205 --> to compare to colors in pptx 
  
% Define maps to display 

% Common 
t1 =  pls_core_statimg_nok(1);

% Specific
% Mech
t2 = select_core_system_nok(2);
% Therm
t3 = select_core_system_nok(3);
% Audi
t4 = select_core_system_nok(4);
% Vis
t5 = select_core_system_nok(5);



%% Overview (full montage) of each 

% Select Core System w. Contour
for m=1
    o2 = fmridisplay
    montage(pls_core_statimg_nok(m),'full','contour','color', colormax (m,:));
    figtitle = [models{m} '_Visualize_FULL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

% Select Core System w. Contour
for m=5
    o2 = fmridisplay
    montage(select_core_system_nok(m),'full','contour','color', colormax (m,:));
    figtitle = [models{m} '_Visualize_FULL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
    clear o2
end

%% More slices Common System

% Common   - sagittal lateral 
for m = 1
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'sagittal','slice_range', [-50 50], 'spacing', 2);
    o2 = addblobs (o2, region(pls_core_statimg_nok(m)), 'contour','color', colormax (m,:));
    figtitle = [models{m} '_Visualize_LATERAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
    clear o2
end


% AMY, NAC
for m=1
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [-22 10], 'spacing', 2);
    o2 = addblobs (o2, region(pls_core_statimg_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_LATERAL_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
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


%% More slices Specific Systems 

% Select Core Systems  - sagittal lateral 
for m=2:5
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'sagittal','slice_range', [-50 50], 'spacing', 2);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_LATERAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;
    clear o2
end

% Mechanical not visible on the above (X too lateral), tried better slices in sagittal, 
% AXIAL looks better though, so will display that 
% Somatosensory (BA2)	L	384	-61	-27	40	Cortex_Dorsal_AttentionB
% Somatosensory (BA1)	R	2264	57	-15	49	Cortex_SomatomotorA
% 
for m=2
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [37 57], 'spacing', 1);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_LATERAL_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end


% More detailed thermal axial
% 
for m=3
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [37 57], 'spacing', 1);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_LATERAL_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end


% More detailed thermal axial for the M1/premotor cluster
% 
for m=3
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [60 70], 'spacing', 1);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

% More detailed thermal axial for VStr
% 
for m=3
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [-10 10], 'spacing', 2);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_AXIAL_BOTTOM_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end


% More detailed visual axial for amy and PHG
% 
for m=5
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'axial','slice_range', [-20 -4], 'spacing', 1);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_AXIAL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end

for m=5
    figure;o2 = fmridisplay;
    o2 = montage(o2, 'sagittal','slice_range', [10 28], 'spacing', 1);
    o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour','color', colormax (m,:)); 
    figtitle = [models{m} '_Visualize_LATERAL_DETAIL_CONTOUR_SelectCoreSystem.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    clear o2
end


%% Multiple models on ROI maps
% INSULA display gen, therm, audi

figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-40 -30], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans','color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_INSULA_LEFT_SelectCoreSystem.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% right
figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [30 40], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour','color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans','color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_INSULA_RIGHT_SelectCoreSystem.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;


% THAL display gen, therm, audi

figure;o2 = fmridisplay;
% o2 = montage(o2, 'axial','slice_range', [-10 8], 'spacing', 1);
% figtitle = ['Models_Empty_Thal_SelectCoreSystem.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_Thal_SelectCoreSystem.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

figure;o2 = fmridisplay;
o2 = montage(o2, 'coronal','slice_range', [-30 -10], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_Thal_COR_SelectCoreSystem.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;



figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-14 14], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_Thal_Sag.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% MAP colliculi
figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-8 8], 'spacing', 1);
for m = 4:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'contour', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_Collic_Sag.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% MAP RVM, PAG
figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-8 8], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_BS_Sag.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% S1 / S2 Left
figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-60 -40], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_S1_LEFT_Sag.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% S1 / S2 Right
figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [40 60], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_S1_RIGHT_Sag.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% somatosensory from above 
figure;o2 = fmridisplay;
o2 = montage(o2, 'axial','slice_range', [40 60], 'spacing', 1);
for m = 1 
o2 = addblobs (o2, region(pls_core_statimg_nok(1)), 'contour', 'color', colormax (1,:)); 
end 
for m = 2:5
o2 = addblobs (o2, region(select_core_system_nok(m)), 'trans', 'color', colormax (m,:)); 
end
figtitle = ['Models_Visualize_SS_Axial.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;



%% Map Common to Yeo -- both hemispheres - 

% Setup
yeo17 = load_atlas ('yeo17networks') 
yeo17.image_names = strrep (yeo17.labels, '_', '  ');

pattcolors_comm = {[0.6 0 0.8]}'
pattcolors_spec = {[1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}'

% MAP COMMON 
image_similarity_plot(pls_core_statimg_nok(1),'mapset',yeo17,'networknames',yeo17.image_names, 'plotstyle', 'polar', 'colors', pattcolors_comm);

figtitle = sprintf(['Common_Yeo17polar.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; % close;

hh = findobj(gca, 'Type', 'Text');  delete(hh);
figtitle = sprintf(['Common_Yeo17polar_nolabels.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; % close;

