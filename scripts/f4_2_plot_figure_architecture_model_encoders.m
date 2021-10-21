%% Wihin-participant model encoders in ROIs along sensory pathways

% This script plots:

% (1) bar plots of mean within-participant model encoding values in selected ROIs
% (2) distribution plots of data presented in the final figure 4 


%% set up 
% ------------------------------------------------------------------------

% run a_set_up_paths_always_run_first.m
working_dir = scriptsdir;
cd(working_dir);

colors_to_plot = {[0.6 0 0.8] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]}; 


%% load data and ROIs 
% ------------------------------------------------------------------------

% load model encoding values from saved
load(fullfile(resultsdir, 'model_encode_obj.mat'));

%load ROIs from saved 
load (fullfile(resultsdir, 'ROI_obj_to_plot.mat'));


%% extract from ROI and plot
% --------------------------------------------------------------------------------- 
%% THALAMUS
% --------------------------------------------------------------------------------- 

for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m), thal_obj);
end
% model 1, subregion 1, 55 subjects 

create_figure
nplots = size(thal_obj.labels,2); % 
labels = thal_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow 
end
figtitle = 'ROI_encoders_THAL.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% --------------------------------------------------------------------------------- 
%% COLLICULI + BS
% --------------------------------------------------------------------------------- 
coll_bs = [collic1_obj bs_obj]
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m), coll_bs);
end

create_figure
nplots = size(coll_bs.labels,2); % 
labels = coll_bs.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_COLLIC_BS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% --------------------------------------------------------------------------------- 
%% CORE AFFECT 
% --------------------------------------------------------------------------------- 
%affect_compact = cc

for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m), affect_compact);
end

create_figure
nplots = size(affect_compact.labels,2); % 
labels = affect_compact.labels;

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow
end

% --------------------------------------------------------------------------------- 
%% INSULA:
% --------------------------------------------------------------------------------- 
clear ins
ins = [ins_obj ins_audi]
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),ins);
end

create_figure
nplots = size(ins.labels,2); % 
labels = ins.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_INS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% --------------------------------------------------------------------------------- 
%% SENSORY
% --------------------------------------------------------------------------------- 

for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),sense_obj);
end

create_figure; nplots = size(sense_obj.labels,2); labels = sense_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_SENS_FULL.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% Mechanical is not showing up in these a priori (large) S1s,
archivedir=fullfile(resultsdir,'archive')
load(fullfile(archivedir,'PLS_stat_images.mat'));

% extract from the actual clusters
r = region (select_core_system_nok(2));
r = table(r,'nolegend');

% Left S1 (BA2)
for m = 1:5
    extracted_roi{m} = extract_data(r(1),encode_obj(m));
end

create_figure;
axh(n) = subplot(4,7,1);
toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
h = barplot_columns(toplot,'nofig','title', 'Left S1', 'noind', 'noviolin', 'colors', colors_to_plot);
set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
for i = 1:5
    h.errorbar_han{i}.LineWidth = 1;
    h.errorbar_han{i}.CapSize = 0;
end
xlabel(''), ylabel(''); drawnow
clear extracted_roi

% Right S1
for m = 1:5
    extracted_roi{m} = extract_data(r(2),encode_obj(m));
end

axh(n) = subplot(4,7,2);
toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
h = barplot_columns(toplot,'nofig','title', 'Right S1', 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
for i = 1:5
    h.errorbar_han{i}.LineWidth = 1;
    h.errorbar_han{i}.CapSize = 0;
end
xlabel(''), ylabel(''); drawnow

figtitle = 'ROI_encoders_S1_mech.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% COMPACT FOR MAIN FIGURE 
% ------------------------------------------------------------------------
%compact_obj = [OFCMPFC thal_obj_mid thal_obj_vis A_123 V_1234]    
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),compact_obj);
end

create_figure; nplots = size(compact_obj.labels,2); labels = compact_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars','doind', 'noviolin', 'colors', colors_to_plot,'nostars');
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1;
        h.errorbar_han{i}.CapSize = 0;
    end
    xlabel(''), ylabel(''); drawnow
end
%close

figtitle = 'ROI_encoders_COMPACT.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% DISTRIBUTION PLOTS 
% ------------------------------------------------------------------------
create_figure; nplots = size(compact_obj.labels,2); labels = compact_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,6,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    % retain positive values
    %toplot (toplot <=0) = NaN;
    h = barplot_columns(toplot,'title', labels(n), 'colors', colors_to_plot, 'doind', 'noviolin','nofig', 'nostars', 'MarkerAlpha', 0.6);
    set(gca,'LineWidth', 0.75,'YTick', 0:0.3:0.3, 'YLim', [-0.2 0.35],'XTick', 0:0:0, ...
        'box', 'off', 'FontSize',8);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1;
        h.errorbar_han{i}.CapSize = 0;
    end
    xlabel(''), ylabel(''); drawnow
end

figtitle = 'ROI_encoders_COMPACT_dots.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);




% Mechanical is not showing up in these a priori (large) S1s,
archivedir=fullfile(resultsdir,'archive')
load(fullfile(archivedir,'PLS_stat_images.mat'));

% extract from the actual clusters
r = region (select_core_system_nok(2));
r = table(r,'nolegend');

% Collapse across right and left S1, mechano-selective (see Fig 3) 
for m = 1:5
    extracted_roi1{m} = extract_data(r(1),encode_obj(m));
    extracted_roi2{m} = extract_data(r(2),encode_obj(m));
    extr_concat{m}= [extracted_roi1{m}.dat extracted_roi2{m}.dat];
    extracted_roi{m} = mean(extr_concat{m},2);
end

create_figure;
n = 1 
axh(n) = subplot(4,6,n);
toplot = [extracted_roi{1} extracted_roi{2} extracted_roi{3} extracted_roi{4} extracted_roi{5}];
h = barplot_columns(toplot,'title', labels(n), 'colors', colors_to_plot, 'doind', 'noviolin','nofig', 'nostars', 'MarkerAlpha', 0.6);
set(gca,'LineWidth', 0.75,'YTick', 0:0.3:0.3, 'YLim', [-0.2 0.35],'XTick', 0:0:0, ...
    'box', 'off', 'FontSize',8);
for i = 1:5
    h.errorbar_han{i}.LineWidth = 1;
    h.errorbar_han{i}.CapSize = 0;
end
xlabel(''), ylabel(''); drawnow

figtitle = 'ROI_encoders_S1_mech_dots.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);








%% ALL ROIs in Figure, include significance stars 
      
diary on
diaryname = fullfile(['Architecture_barplots_significance_' date '_output.txt']);
diary(diaryname);
create_figure; nplots = size(compact_obj.labels,2); labels = compact_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1;
        h.errorbar_han{i}.CapSize = 0;
    end
    xlabel(''), ylabel(''); drawnow
end

diary off

figtitle = 'ROI_encoders_all_significance.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);

% ----

%% EXTRA 
% ------------------------------------------------------------------------

%% Painpathways atlas 
pain_pathways = load_atlas('painpathways'); 
size(pain_pathways.labels,2);

for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m), pain_pathways);
end

create_figure
nplots = size(pain_pathways.labels,2); % 
labels = pain_pathways.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', 1,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 8);
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_PAINPATHWAYS.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% Audi and Vis by hemisphere 
AV_obj = [A_123 V_1234];

% DISPLAY ROIS
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),AV_obj);
end

create_figure; nplots = size(AV_obj.labels,2); labels = AV_obj.labels

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', 1,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 8);
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_SENS_AV_LR.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% Yeo17 atlas 
yeo17 = load_atlas('yeo17networks');
size(pain_pathways.labels,2);
yeo17.labels = {'CtrlA L' 'CtrlA R' 'CtrlB L'  'CtrlB R'  'CtrlC L' 'CtrlC R ' ...
    'DMN A L'  'DMN A R'  'DMN B L'   'DMN B R'  'DMN C L' 'DMN C R' ...
    'DAN A L' 'DAN A R' 'DAN B L' 'DAN B R' 'Limbic L' 'Limbic R' 'SalVAN A L' 'SalVAN A R' 'SalVAN B L' 'SalVAN B R' ...
    'SM A L' 'SM A R' 'SM B L'  'SM B R' ...
    'TempPar L' 'TempPar R' 'VisPeri L' 'VisPeri R' 'VisCent L' 'Vis Cent R'};

visCent = select_atlas_subset (yeo17, {'VisCent'}, 'flatten');
montage(visCent)

for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m), yeo17);
end

create_figure
nplots = size(yeo17.labels,2); % 
labels = yeo17.labels

for n = 1:nplots
    axh(n) = subplot(5,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', 1,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 8);
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'ROI_encoders_YEO17.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


