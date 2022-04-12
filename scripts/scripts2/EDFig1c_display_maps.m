%% ED Figure 1c

% This script plots model weights and encoders created in: 
% prep_3_create_model_encoding_maps.m

%% set working dir and model names 

a_set_up_paths_always_run_first

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

%% AMYGDALA PATTERNS - Display in more detail for figs
% AMY ==== -27, -4, -20

% (patterns) 

% Axial
for m=1:3
    o2 = fmridisplay
    o2 = montage(o2, 'axial','slice_range', [-30 -10], 'spacing', 1);
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    figtitle = [models{m} '_Visualize_Weights_AMY_AXIAL.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    %clear o2
end

% Coronal
for m=1:3
    o2 = fmridisplay
    o2 = montage(o2, 'coronal','slice_range', [-10 0], 'spacing', 1);
    patt(m) = threshold (patt(m), [3 Inf], 'raw-between', 'k', 10);
    o2 = addblobs(o2, region(patt(m)), 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    figtitle = [models{m} '_Visualize_Weights_AMY_COR.png'];
    savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
    %clear o2
end


%load(savefilename, 'Npls_encode_statimg');
%load(savefilename, 'Nencode_obj');


%% Save encode maps for figures 
% ----------------------------------------------------------------------- %
colormax = [0.9 0.7 0;
            0.2 0.8 1;  % light blue
           1 0.4 1]; 
       
colormin = colormax-0.3;

o2 = canlab_results_fmridisplay([], 'multirow', 3);
for m = 1:3
    % Threshold maps for figure @ positive values, some reasonable p value
    Nencode_statimg = ttest (Nencode_obj(m));

    Nencode_statimg = threshold (Nencode_statimg, [3 Inf], 'raw-between');

    o2=addblobs(o2,Nencode_statimg, 'wh_montages', m*2-1:m*2, 'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
end

figtitle = sprintf(['MODALITIES_NORMPLS_modelencoder_pos_t3.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

% NICER MONTAGE FOR FIGURE, TO MATCH MAIN PAPER 

% (a) Encoders
for m=1:3
    o2 = fmridisplay
    o2 = montage(o2, 'axial', 'slice_range', [-18 50], 'onerow', 'spacing', 6, 'noverbose');
    enlarge_axes(gcf,0.7,1.4);
    axh = axes('Position', [-0.02 .75-.3 .17 .17]);
    axh(2) = axes('Position', [.022 .854-.3 .17 .17]);
    o2 = montage(o2, 'saggital', 'slice_range', [-6 6], 'spacing', 12, 'onerow', 'noverbose', 'existing_axes', axh);
    
    Npls_encode_statimg_fdr05_t3(m)=threshold (Npls_encode_statimg_fdr05(m), [3 Inf], 'raw-between');
    o2 = addblobs(o2, region(Npls_encode_statimg_fdr05_t3(m)),'mincolor', colormin(m,:), 'maxcolor', colormax (m,:));
    
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

Npls_encode_statimg_fdr05_t3(2)=threshold (Npls_encode_statimg_fdr05(2), [3 Inf], 'raw-between');
o2 = addblobs(o2, region(Npls_encode_statimg_fdr05_t3(2)),'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));

Npls_encode_statimg_fdr05_t3(3)=threshold (Npls_encode_statimg_fdr05(3), [3 Inf], 'raw-between');
o2 = addblobs(o2, region(Npls_encode_statimg_fdr05_t3(3)),'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));

figtitle = [models{m} '_NPLS_Visualize_Encode_NEG_AND_POS_fdr05_t3.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2


%% ENCODE MAPS  - display maps, conjunction

% Re-recreate tmaps
genvis = ttest (Nencode_obj(1));
genvis = threshold (genvis, [3 Inf], 'raw-between');

negvis = ttest (Nencode_obj(2));
negvis = threshold (negvis, [3 Inf], 'raw-between');

posvis = ttest (Nencode_obj(3));
posvis = threshold (posvis, [3 Inf], 'raw-between');

% Create display 
o2 = canlab_results_fmridisplay([], 'multirow', 4);

% GEN, NEGVIS, POSVIS
o2=addblobs(o2,region(genvis),'wh_montages', 1:2, 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));

o2=addblobs(o2,region(negvis),'wh_montages', 3:4, 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));
o2=addblobs(o2,region(posvis),'wh_montages', 3:4, 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));

% CONJUNCTION 
conj_negposvis = conjunction (Npls_encode_statimg_fdr05(2), Npls_encode_statimg_fdr05(3), 1);
% NO OVERLAP between NEG and POS; nothing to map
% Grouping contiguous voxels:   0 regions

conj_gennegvis = conjunction (Npls_encode_statimg_fdr05(1), Npls_encode_statimg_fdr05(2), 1);
o2=addblobs(o2,region(conj_gennegvis),'wh_montages', 5:6, 'color', [0.2 1 0.2]);

conj_genposvis = conjunction (Npls_encode_statimg_fdr05(1), Npls_encode_statimg_fdr05(3), 1);
o2=addblobs(o2,region(conj_genposvis),'wh_montages', 7:8,  'color', [1 .4 0]);

figtitle = sprintf('Conjunction_NEGPOS_GENNEG_GENPOS_SRwtnROB_conj.png');
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% SOME OVERLAP GEN+NEG, GEN+POS - as expected
% Grouping contiguous voxels:  75 regions
% sagittal montage:  22 voxels displayed, 1819 not displayed on these slices
% axial montage: 619 voxels displayed, 1222 not displayed on these slices
% Grouping contiguous voxels:  40 regions
% sagittal montage:  14 voxels displayed, 529 not displayed on these slices
% axial montage: 183 voxels displayed, 360 not displayed on these slices
% 
% Focus on Amy
% Axial
o2 = fmridisplay
o2 = montage(o2, 'axial','slice_range', [-30 -10], 'spacing', 1);
o2 = addblobs(o2, region(genvis), 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));
o2 = addblobs(o2, region(negvis), 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));
o2 = addblobs(o2, region(posvis), 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));
figtitle = [models{m} '_Visualize_Encode_AMY_AXIAL.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% Coronal
o2 = fmridisplay
o2 = montage(o2, 'coronal','slice_range', [-10 0], 'spacing', 1);
o2 = addblobs(o2, region(genvis), 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));
o2 = addblobs(o2, region(negvis), 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));
o2 = addblobs(o2, region(posvis), 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));
figtitle = [models{m} '_Visualize_Encode_AMY_COR.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% hard to see that both GEN and NEG are in here! 
% Cor Gen only
o2 = fmridisplay
o2 = montage(o2, 'coronal','slice_range', [-10 0], 'spacing', 1);
o2 = addblobs(o2, region(genvis), 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));
figtitle = [models{m} '_Visualize_Encode_Gen_AMY_COR.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;

% BETTER TO DISPLAY THE CONJUNCTION --- on top
% Coronal
o2 = fmridisplay
o2 = montage(o2, 'coronal','slice_range', [-10 0], 'spacing', 1);
o2 = addblobs(o2, region(genvis), 'mincolor', colormin(1,:), 'maxcolor', colormax (1,:));
o2 = addblobs(o2, region(negvis), 'mincolor', colormin(2,:), 'maxcolor', colormax (2,:));
o2 = addblobs(o2, region(posvis), 'mincolor', colormin(3,:), 'maxcolor', colormax (3,:));
o2 = addblobs(o2, region(conj_gennegvis), 'color', [0.2 1 0.2]);
o2 = addblobs(o2, region(conj_genposvis), 'color', [1 0.4 0]);
figtitle = [models{m} '_Visualize_Encode_Conjunction_AMY_COR.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;







