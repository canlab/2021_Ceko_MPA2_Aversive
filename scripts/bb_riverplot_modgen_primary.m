%% 

modgen = modgen_compact
modgen.image_names = modgen.labels;

%%  Regions for Figure
% % -------------------------------------------------------------------


modgen_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2] [0.6 1 0.2] [0.4 0 0]}

% Get regions (for slice montage)
r = atlas2region(modgen);

% Show them on a montage
figure;
montage(r, 'regioncenters', 'colors', modgen_colors);

figtitle = sprintf(['ROIs_regioncenters.png'])
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% show MCC, vMPFC and dMPFC on sagittal
figure; 
montage(r(3), 'color', [0.6 0.2 0], 'full'); % 
% figtitle = sprintf(['ROIs_MCC.png']);
% savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;

o2 = montage(r(4),  'color', [0.6 0.4 0], 'full');

o2 = montage(r(5), 'color', [0.6 0.6 0], 'full');







%% Early sensory regions 
% ------------------------------------------------------------------

cblm = primary_compact
cblm.image_names = cblm.labels;


cblm_colors = {[0.4 0 0] [0.6 0 0] [0.6 0.2 0] [0.6 0.4 0] ...
    [0.6 0.6 0] [0.6 0.8 0.2]};


%% Get regions (for slice montage)
r = atlas2region(cblm);

% % Show them on a montage
montage(r, 'regioncenters', 'colors', cblm_colors);

