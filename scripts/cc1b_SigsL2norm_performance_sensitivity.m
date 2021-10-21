%% Signature sensitivity 

% How well does sig predict behavior? r observed vs. predicted 
% How accurate is sig in discriminating between beh levels? Accu L1-2-3-4 

% Data (behavior) 
% -------------------------------------------------------------------------
% Pain_Avoid (55 x 16) = 55 subjects, for each 4 levels of each modality (M 1-4, T 1-4, A 1-4, V 1-4 = 16) 
% dat.Y(880 x 1) = Pain_Avoid rearranged to 1:55 x 4 x 4: 
% 1:55 subjects 1:55 M, L1
% 56:110 subjects 1:55, M, L2
%

% Data (behavior) 
% -------------------------------------------------------------------------
% 5 signature responses (yhat; 1 x modality-general and 4 x modality-specific) are derived 
% from PLS (880 x 5 matrix for 55 subjects at 4 stim levels (220) for 4 modalities (observed behavior = avers_mat = 220x4=880) 


% Procedures: 
% -------------------------------------------------------------------------
% Restructure data first, then plot observed aversiveness rating (x-axis) vs. predicted rating (=signature response; y-axis):
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
diaryname = fullfile(diarydir, ['SigL2_sensitivity_' date '_output.txt']);
diary(diaryname);


%% Load data 

% FMRI data object 
load(fullfile(resultsdir, 'data_objects.mat'));

% Behavior - in data/ dir
import_Behav_MPA2;

%
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';
ints=rem(1:16,4);ints(ints==0)=4;
for d=1:16
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Pain_Avoid(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end

% Predicted behavior 
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_L2norm.mat'));

% Colors 
mechanical_color = [1 0.2 0.4]; % red 
thermal_color= [1 0.6 0.2]; % orange
sound_color = [0 0.6 0.4]; % green
negvis_color = [0 0.4 1]; % blue
general_color = [0.5 0.5 0.5]; % gray

models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};

colormod= [1 0.2 0.4
            1 0.6 0.2
            0 0.6 0.4
            0 0.4 1];

%% Reorganize data per modality 

% Across subjects: 
% -------------------------------------------------------------------------
clear ratings outcomes
clear Y Yfit_Gen Yfit_Spec

modalnames={'Mech' 'Therm' 'Audi' 'Vis'};

n_mods = length(modalnames);
Y=cell(1, n_mods);
Yfit_Gen=cell(1, n_mods);
Yfit_Spec=cell(1, n_mods);
for m=1:4
        Yget=avers_mat(modality==m);  % aversiveness ratings 
        Y{m}=Yget;
        YfitGget=yhat(modality==m);  % predicted av ratings 
        Yfit_Gen{m}=YfitGget;
        YfitSget=yhat(modality==m,m+1); % spec model is at modality+1 
        Yfit_Spec{m}=YfitSget;
end

% Double-check 
m=1;
Ycalc=Y{m}(end); %% mech stim, last subject, last stim level
Yinp=avers_mat(220,1); %% mech stim, last subj, last stim level
YGcalc=Yfit_Gen{1}(end);
YGinp=yhat(220,1);
YScalc=Yfit_Spec{1}(end);
YSinp=yhat(220,2);

if Ycalc == Yinp & YGcalc == YGinp & YScalc == YSinp
    fprintf ('All good! \n');
else 
    fprintf ('Values do not match, check the code! \n');
end
clear m

% Each subject on their own line
% -------------------------------------------------------------------------
clear YY YYfit_Gen YYfit_Spec
subject_id=repmat(1:55,1,4)';
for m=1:4;
    for s = 1:length(unique(subject_id));
        YY{m}{s} = Y{m}(subject_id == s);
        YYfit_Gen{m}{s} = Yfit_Gen{m}(subject_id == s);
        YYfit_Spec{m}{s}= Yfit_Spec{m}(subject_id == s);
    end
end

% Double-check
m=1;s=55;
YYcalc=YY{m}{s}; %% mech stim, last subject, last stim level
YYinp=avers_mat(subject_id==55);  %% mech stim, last subj, last stim level
YYGcalc=YYfit_Gen{m}{s};
YYGinp=yhat(subject_id==55);
YYScalc=YYfit_Spec{m}{s};
YYSinptemp=yhat(:,2);
YYSinp=YYSinptemp(subject_id==55);
if YYcalc == YYinp & YYGcalc == YYGinp & YYScalc == YYSinp
    fprintf ('All good! \n');
else 
    fprintf ('Values do not match, check the code! \n');
end
clear m

%% Gscatter plots per subject
% ----------------------------------------------------------

figtitle=sprintf('Plot_L2_gscatter_PLSsigs_responses_vs_rating_group');
create_figure(figtitle)
for m=1:4
    % General
    subplot(2,4,m);
    %gscatter(avers_mat(1:220,1),yhat(1:220,1),subject_id,[0.5 0.5 0.5],'o',8,'off');
    gscatter(Y{m},Yfit_Gen{m},subject_id,[0.5 0.5 0.5],'o',8,'off');
    lsline
    set(gca,'XLim',[-0.1 1],'YLim', [-0.1 1], 'box', 'off');
    h=findobj(gca, 'type', 'line'); set(h, 'MarkerFaceColor', [0.5 0.5 0.5],'MarkerSize', 6);
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

figtitle=sprintf('Plot_L2_scatter_PLSsigs_responses_vs_rating_group');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1));
    %hold on
    plot(Y{m}, Yfit_Gen{m}, 'o', 'MarkerSize', 6, 'MarkerFaceColor', general_color, 'MarkerEdgeColor', [0 0 0], 'linewidth', 0.5);
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

% Colors for line_plot_multisubject
colormods={{[1 0.2 0.4]} {[1 0.6 0.2]} {[0 0.6 0.4]} {[0 0.4 1]}}
colorg={[0.5 0.5 0.5]}
general_color = [0.5 0.5 0.5]; % gray

% 1) Not centered 
% ------------------------------------- %% 

disp('Not centered -----------------');
figtitle=sprintf('Plot_L2_PLSsigs_responses_obs_pred_ratings_per_subject_NOTCENTERED');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1))
    sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m)
    line_plot_multisubject(YY{m},YYfit_Gen{m}, 'nofigure', 'MarkerTypes', 'o','colors', colorg);
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
figtitle=sprintf('Plot_L2_PLSsigs_responses_obs_pred_ratings_per_subject_CENTERED');
create_figure(figtitle)
for m=1:4
    subplot(2,4,m); %+(m-1));
    sprintf('Displaying stats for GENERAL SIG for modality %3.0f',m);
    line_plot_multisubject(YY{m},YYfit_Gen{m}, 'nofigure', 'MarkerTypes', 'o','colors', colorg, 'center');
    
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


diary off

