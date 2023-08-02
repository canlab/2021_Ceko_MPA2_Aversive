%% Wihin-participant model encoders in ROIs along sensory pathways

% This script plots:

% (1) bar plots of mean within-participant model encoding values across 20 selected ROIs
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
load(fullfile(resultsdir, '/results_modelencode/results/model_encode_obj.mat'));


%load ROIs from saved 
load (fullfile(resultsdir, 'ROI_obj_to_plot.mat'));


%% CREATE COMPACT FOR MAIN FIGURE -- 20 regions
% ------------------------------------------------------------------------
compact_obj = [OFCMPFC thal_obj_mid thal_obj_vis A_123 V_1234]    
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),compact_obj);
end

testregion = atlas2region(brainstem_obj)
for m = 1:5
    extracted_roi{m} = extract_roi_averages(encode_obj(m),affect_obj);
end


%% ALL ROIs in Figure, include significance stars     
diary on
diaryname = fullfile(['Architecture_barplots_significance_' date '_output.txt']);
diary(diaryname);
create_figure; nplots = size(compact_obj.labels,2); labels = compact_obj.labels
clear toplot

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot(:,:,n) = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot(:,:,n),'nofig','title', labels(n), 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1;
        h.errorbar_han{i}.CapSize = 0;
    end
    xlabel(''), ylabel(''); drawnow
end

diary off

%figtitle = 'ROI_encoders_all_significance.png'
%savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


%% DISTRIBUTION PLOTS 
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
clear toplot

for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot(:,:,n) = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot(:,:,n),'nofig','title', labels(n), 'noind', 'noviolin', 'colors', colors_to_plot);
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

