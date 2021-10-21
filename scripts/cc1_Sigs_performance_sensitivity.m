%% Signature sensitivity 

% How well does sig predict behavior? r observed vs. predicted 
% How accurate is sig in discriminating between beh levels? Accu L1-2-3-4 

% Procedures: 
% -------------------------------------------------------------------------
% Plot observed aversiveness rating (x-axis) vs. predicted rating (=signature response; y-axis):
%  Specific plots (colored) modality rating vs. specific signature
%  General plots (gray) modality rating vs. general signature 

        % Group plots
        % Each subject one line plots

% Calculate r, r2 between predicted and observed
        % across subjects 
        % avg within subjects 

% Calculate accu per stim level


%% Start diary
% 
diaryname = fullfile(diarydir, ['Sig_sensitivity_' date '_output.txt']);
diary(diaryname);


% Predicted behavior (avers_mat - observed, yhat - predicted)
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

%% Calc r values (overall, within, between) and compare to line_plot_.... further down in this script


% see cc1d_obs_pred_wtn_btn_overall



%% Gscatter plots per subject
% ----------------------------------------------------------

figtitle=sprintf('Plot_gscatter_PLSsigs_responses_vs_rating_group');
create_figure(figtitle)
for m=1:4
    % General
    subplot(2,4,m);
    %gscatter(avers_mat(1:220,1),yhat(1:220,1),subject_id,[0.5 0.5 0.5],'o',8,'off');
    gscatter(Y{m},Yfit_Gen{m},subject_id,[0.5 0.5 0.5],'o',8,'off');
    lsline
    set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
    h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', colormod(5,:),'MarkerSize', 6);
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
    
    % Specific
    subplot(2,4,m+4);
    gscatter(Y{m},Yfit_Spec{m},subject_id,colormod(m,:),'o',8,'off');
    lsline
    set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
    h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', colormod(m,:), 'MarkerSize', 6);
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
end

plugin_save_figure


%% Plots across subjects 
% ----------------------------------------------------------

figtitle=sprintf('Plot_scatter_PLSsigs_responses_vs_rating_group');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1));
    %hold on
    plot(Y{m}, Yfit_Gen{m}, 'o', 'MarkerSize', 6, 'MarkerFaceColor', colormod(5,:), 'MarkerEdgeColor', [0 0 0], 'linewidth', 0.5);
    set(gca, 'LineWidth', 1,'box', 'off', 'YTick', 0:0.2:1, 'XLim',[0 1],'YLim', [-0.1 0.9], 'FontSize', 14);
    %line(xlim, xlim, 'linewidth', 4, 'linestyle', ':', 'color', [.5 .5 .5]);

    subplot(2,4,m+4);
    plot(Y{m}, Yfit_Spec{m}, 'o', 'MarkerSize', 6, 'MarkerFaceColor', colormod(m,:), 'MarkerEdgeColor', [0 0 0], 'linewidth', 0.5);
    set(gca, 'LineWidth', 1,'box', 'off', 'YTick', 0:0.2:1, 'XLim',[0 1],'YLim', [-0.1 0.9], 'FontSize', 14);
end
%ylabel('Signature response'); xlabel('Avoidance rating');

plugin_save_figure



%%  plots and r values (overall, within, between) for modality-general and modality-specific signature responses 
% -------------------------------------------------------------------------

% PLOT WITHIN SUBJECTS, NO BINS:  
% -------------------------------------------------------------------------
% 1) Not centered 
% ------------------------------------- %% 

disp('Not centered -----------------');
figtitle=sprintf('Plot_PLSsigs_responses_obs_pred_ratings_per_subject_NOTCENTERED');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1))
    sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m)
    line_plot_multisubject(YY{m},YYfit_Gen{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
    axis tight;
    
    subplot(2,4,m+4);
    sprintf('Displaying stats for SPECIFIC SIG for modality %3.0f',m)
    line_plot_multisubject(YY{m},YYfit_Spec{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
    axis tight;
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
end

plugin_save_figure

% 2) Centered
% ------------------------------------- %% 

disp('Centered -----------------');
figtitle=sprintf('Plot_PLSsigs_responses_obs_pred_ratings_per_subject_CENTERED');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1));
    sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m);
    line_plot_multisubject(YY{m},YYfit_Gen{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5}, 'center');
    
    set(gca,'LineWidth', 1,'FontSize', 14);
    %set(gca,'LineWidth', 1,'XTick', -0.5:0.5:0.5,'YTick', -0.2:0.2:0.2, 'XLim', [-0.6 0.6], 'YLim', [-0.3 0.3], 'FontSize', 14); 
    %axis tight; 
    
    subplot(2,4,m+4);
    sprintf('Displaying stats for SPECIFIC SIG for modality %3.0f',m);
    line_plot_multisubject(YY{m},YYfit_Spec{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m}, 'center');
    set(gca,'LineWidth', 1,'FontSize', 14);
    %set(gca,'LineWidth', 1,'XTick', -0.5:0.5:0.5,'YTick', -0.2:0.2:0.2, 'XLim', [-0.6 0.6], 'YLim', [-0.3 0.3], 'FontSize', 14); 
    %axis tight; 
end

plugin_save_figure

%%  Within-person classification accuracy
% -------------------------------------------------------------------------
for m=1:4;
    
    % General  
    % -----------------------------
    diffs = cellfun(@diff, YYfit_Gen{m}, 'UniformOutput', false); % successive increases in predicted values with increases in stim intensity
    diffs = cat(2, diffs{:})';
    
    acc_per_subject = sum(diffs > 0, 2) ./ size(diffs, 2);
    acc_per_comparison = (sum(diffs > 0) ./ size(diffs, 1))';
    cohens_d_per_comparison = (mean(diffs) ./ std(diffs))';
    
    fprintf('General signature: Modality %3.0f%\n', m);
    
    fprintf('\nMean acc is : %3.2f%% across all successive 1 stim level increments\n', 100*mean(acc_per_subject));
    
    comparison = {'L1-L2' 'L2-L3' 'L3-L4'}';
    results_table = table(comparison, acc_per_comparison, cohens_d_per_comparison);
    disp(results_table);
    
    % Specific 
    % -----------------------------
        
    clear diffs
    
    diffs = cellfun(@diff, YYfit_Spec{m}, 'UniformOutput', false); % successive increases in predicted values with increases in stim intensity
    diffs = cat(2, diffs{:})';
    
    acc_per_subject = sum(diffs > 0, 2) ./ size(diffs, 2);
    acc_per_comparison = (sum(diffs > 0) ./ size(diffs, 1))';
    cohens_d_per_comparison = (mean(diffs) ./ std(diffs))';
    
    fprintf('Specific signature: Modality %3.0f%\n', m);
    fprintf('\nMean acc is : %3.2f%% across all successive 1 stim level increments\n', 100*mean(acc_per_subject));
    
    comparison = {'L1-L2' 'L2-L3' 'L3-L4'}';
    results_table = table(comparison, acc_per_comparison, cohens_d_per_comparison);
    disp(results_table);
end 



%%  Plot all data and calc r on all data (880 per column)
% -------------------------------------------------------------------------

% 1) Not centered 
% ------------------------------------- %% 

disp('Not centered -----------------');
figtitle=sprintf('Plot_PLSsigs_880_responses_obs_pred_ratings_per_subject_NOTCENTERED');
create_figure(figtitle)
for m=1:4
    subplot(2,5,1); %+(m-1))
    sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m)
    line_plot_multisubject(YYG{1},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
    axis tight;
    
    subplot(2,5,m+1);
    sprintf('Displaying stats for SPECIFIC SIG for modality %3.0f',m)
    line_plot_multisubject(YYS{m},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
    axis tight;
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
end

for m=1
    
    subplot(2,5,m+1);
    sprintf('Displaying stats for SPECIFIC SIG for modality %3.0f',m)
    line_plot_multisubject(YYS{m},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
    axis tight;
    set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
end


plugin_save_figure

%% Gscatter plot all data (880 per column) -- for the sensitivity Figure - nicer plots 
% ----------------------------------------------------------
% --- IN PROGRESS ----
% figtitle=sprintf('Gscatter_PLSsigs_880_responses_obs_pred_ratings_per_subject');
% create_figure(figtitle)
% for m=1:4
%     % General
%     subplot(2,5,1); %+(m-1))
%     line_plot_multisubject(YYG{1},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%     axis tight;
%     
%     
%     subplot(2,5,1); %+(m-1))
%     gscatter(YYG{1},YYhatG{1},subject_id,[0.5 0.5 0.5],'o',8,'off'); 
%     lsline
%     set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
%     h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', colormod(5,:),'MarkerSize', 6);
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%     
%     subplot(2,4,m);
%     %gscatter(avers_mat(1:220,1),yhat(1:220,1),subject_id,[0.5 0.5 0.5],'o',8,'off');
%     gscatter(Y{m},Yfit_Gen{m},subject_id,[0.5 0.5 0.5],'o',8,'off');
%     lsline
%     set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
%     h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', colormod(5,:),'MarkerSize', 6);
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%     
%     % Specific
%     subplot(2,4,m+4);
%     gscatter(Y{m},Yfit_Spec{m},subject_id,colormod(m,:),'o',8,'off');
%     lsline
%     set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
%     h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', colormod(m,:), 'MarkerSize', 6);
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
% end


% %% 
% disp('Not centered -----------------');
% figtitle=sprintf('Plot_PLSsigs_880_specificity_across_modalities');
% create_figure(figtitle);
% 
% %     subplot(2,5,1); %+(m-1))
% %     sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m)
% %     line_plot_multisubject(YYG{1},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colorg);
% %     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
% %     axis tight;
%     
%     % General model tested on each modality 
%     subplot(2,5,1);
%     sprintf('Displaying stats for GENERAL SIG for modality 1')
%     line_plot_multisubject(YYS{1},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%     
%     subplot(2,5,2);
%     sprintf('Displaying stats for GENERAL SIG for modality 2')
%     line_plot_multisubject(YYS{2},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%        
%     subplot(2,5,3);
%     sprintf('Displaying stats for GENERAL SIG for modality 3')
%     line_plot_multisubject(YYS{3},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{5});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%    
%     subplot(2,5,4);
%     sprintf('Displaying stats for GENERAL SIG for modality 4')
%     line_plot_multisubject(YYS{4},YYhatG{1}, 'nofigure', 'MarkerTypes', 'o','colors',  colormods{5});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
% 
% for m=1:4 
%     
%     subplot(2,5,1);
%     sprintf('Displaying stats on MECH for SPECIFIC SIG %3.0f',m)
%     line_plot_multisubject(YYS{1},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%     
%     subplot(2,5,2);
%     sprintf('Displaying stats on THERM for SPECIFIC SIG %3.0f',m)
%     line_plot_multisubject(YYS{2},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%        
%     subplot(2,5,3);
%     sprintf('Displaying stats on AUD for SPECIFIC SIG %3.0f',m)
%     line_plot_multisubject(YYS{3},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
%    
%     subplot(2,5,4);
%     sprintf('Displaying stats on VIS for SPECIFIC SIG %3.0f',m)
%     line_plot_multisubject(YYS{4},YYhatS{m}, 'nofigure', 'MarkerTypes', 'o','colors', colormods{m});
%     axis tight;
%     set(gca,'LineWidth', 1,'XTick', 0:0.5:1,'YTick', 0:0.2:0.8, 'XLim', [0 1], 'YLim', [0 0.8], 'FontSize', 14);
% end
% 
% 
% diary off