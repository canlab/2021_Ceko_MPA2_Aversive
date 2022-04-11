% run cc0 first


%% Apply PLS patterns and plot

% apply dotproduct and cosine similarity across conditions and contrasts 
% aa1_apply_aversivePLS_signatures.m

%% Load data 
%a_set_up_paths_always_run_first

% Import DAT 
b_reload_saved_matfiles

% Import behavior
cd(scriptsdir) 
import_Behav_MPA2;

% add plot_y_yfit
addpath /Users/marta/'Dropbox (Cognitive and Affective Neuroscience Laboratory)'/B_AVERSIVE/Analysis/MPA2_EXP/scripts/tops_figure_2_ex/tops_functions/

% add cross val estimates 
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

%% -----------------------------------------------------------------------
% GenS signature 
clear p z pp zz
xxx{1} = Pain_Avoid(:,1:4)'; % Mech 
xxx{2} = Pain_Avoid(:,5:8)'; % Therm
xxx{3} = Pain_Avoid(:,9:12)'; % Aud  
xxx{4} = Pain_Avoid(:,13:16)'; % Vis

clear yyy
yyy{1} = reshape(pexp_xval_dp (1:220,1),55,4)';
yyy{2} = reshape(pexp_xval_dp (221:440,1),55,4)';
yyy{3} = reshape(pexp_xval_dp (441:660,1),55,4)';
yyy{4} = reshape(pexp_xval_dp (661:880,1),55,4)';

%
figtitle=sprintf('Plot_individ_slopes');
create_figure(figtitle);

clear x
for m=1:4
    subplot(5,6,m);
    out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25, 'xyline', 1);

    set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
    set(gca, 'XTick', -0.5:0.5:1,'YTick', -2:0.2:2, 'ylim', [-0.2 0.6])
    set(gca,'LineWidth', 1,'FontSize', 10);
    
    x = out(m).b;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(1,m), z(1,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = out(m).r;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [pp(1,m), zz(1,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end
%
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% MechS signature 

clear yyy
yyy{1} = reshape(pexp_xval_dp (1:220,2),55,4)';
yyy{2} = reshape(pexp_xval_dp (221:440,2),55,4)';
yyy{3} = reshape(pexp_xval_dp (441:660,2),55,4)';
yyy{4} = reshape(pexp_xval_dp (661:880,2),55,4)';

clear x
for m=1:4
    subplot(5,6,m+6);
    out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);

    set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
    set(gca, 'XTick', -0.5:0.5:1,'YTick', -0.2:0.2:0.6, 'ylim', [-0.2 0.6])
    set(gca,'LineWidth', 1,'FontSize', 10);
    
    x = out(m).b;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(2,m), z(2,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = out(m).r;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [pp(2,m), zz(2,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Therm signature 
clear yyy
yyy{1} = reshape(pexp_xval_dp (1:220,3),55,4)';
yyy{2} = reshape(pexp_xval_dp (221:440,3),55,4)';
yyy{3} = reshape(pexp_xval_dp (441:660,3),55,4)';
yyy{4} = reshape(pexp_xval_dp (661:880,3),55,4)';


clear x
for m=1:4
    subplot(5,6,m+12);
    out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);

    set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
    set(gca, 'XTick', -0.5:0.5:1,'YTick', -0.4:0.4:2, 'ylim', [-0.4 1])
    set(gca,'LineWidth', 1,'FontSize', 10);
    
    x = out(m).b;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(3,m), z(3,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = out(m).r;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [pp(3,m), zz(3,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Aud signature 
clear yyy
yyy{1} = reshape(pexp_xval_dp (1:220,4),55,4)';
yyy{2} = reshape(pexp_xval_dp (221:440,4),55,4)';
yyy{3} = reshape(pexp_xval_dp (441:660,4),55,4)';
yyy{4} = reshape(pexp_xval_dp (661:880,4),55,4)';

clear x
for m=1:4
    subplot(5,6,m+18);
    out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);

    set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
    set(gca, 'XTick', -0.5:0.5:1,'YTick', -2:0.2:2, 'ylim', [-0.1 0.6])
    set(gca,'LineWidth', 1,'FontSize', 10);
    
    x = out(m).b;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(4,m), z(4,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = out(m).r;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [pp(4,m), zz(4,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Vis signature 
clear yyy
yyy{1} = reshape(pexp_xval_dp (1:220,5),55,4)';
yyy{2} = reshape(pexp_xval_dp (221:440,5),55,4)';
yyy{3} = reshape(pexp_xval_dp (441:660,5),55,4)';
yyy{4} = reshape(pexp_xval_dp (661:880,5),55,4)';

clear x
for m=1:4
    subplot(5,6,m+24);
    out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);

    set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
    set(gca, 'XTick', -0.5:0.5:1,'YTick', -2:0.2:2, 'ylim', [-0.2 0.6])
    set(gca,'LineWidth', 1,'FontSize', 10);
    
    x = out(m).b;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(5,m), z(5,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = out(m).r;
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [pp(5,m), zz(5,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end
%
plugin_save_figure


% p =
% 
%     0.0000    0.0000    0.0003    0.2080
%     0.0804    0.8971    0.7433    0.9046
%     0.1201    0.0000    0.1910    0.9992
%     0.6953    0.3226    0.0000    0.3197
%     0.2483    0.0396    0.2990    0.0000
% 
% pp
% 
% pp =
% 
%     0.0006    0.0015    0.0004    0.0008
%     0.0045    0.9039    0.3419    0.8807
%     0.0734    0.0012    0.3550    0.5017
%     0.2700    0.1795    0.0003    0.8041
%     0.9728    0.0103    0.9163    0.0012




% % -------------------------------------------------------------------------
% % -------------------------------------------------------------------------
% % NPS signature 
% clear yyy
% yyy{1} = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,1:4))';
% yyy{2} = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,5:8))';
% 
% for m=1:2
%     subplot(4,6,m+2+2+2+2+2+2);
%     out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);
% 
%     set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
%     set(gca, 'XTick', -0.5:0.5:1,'YTick', -10:10:20, 'ylim', [-5 15])
%     set(gca,'LineWidth', 1,'FontSize', 10);
%     
%     x = out(m).b
%     stat = nanmean (x)
%     bootstat = bootstrp(10000, @nanmean, x)
%     [p(6,m), z(6,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x)
% end
% 
% % -------------------------------------------------------------------------
% % -------------------------------------------------------------------------
% % SIIPS signature 
% clear yyy
% yyy{1} = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,1:4))';
% yyy{2} = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,5:8))';
% 
% for m=1:2
%     subplot(4,6,m+2+2+2+2+2+2+2);
%     out(m) = plot_y_yfit(xxx{m},yyy{m}, 'data_alpha', 1, 'line_alpha', 0.7, 'dotsize', 25);
% 
%     set(gca, 'tickdir', 'out', 'TickLength', [.01 .01], 'linewidth', 1.5, 'fontsize', 10);
%     set(gca, 'XTick', -0.5:0.5:1,'YTick', -1000:1000:2000, 'ylim', [-500 2000])
%     set(gca,'LineWidth', 1,'FontSize', 10);
%     
%     x = out(m).b
%     stat = nanmean (x)
%     bootstat = bootstrp(10000, @nanmean, x)
%     [p(7,m), z(7,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x)
% end


