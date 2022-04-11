clear all
a_set_up_paths_always_run_first


% load data
cd(scriptsdir)
import_Behav_MPA2

cd(scriptsrevdir)
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

pexp_color = [1 0.2 0.4;  % red-pink
           1 0.6 0.2;
           0 0.6 0.4;
           0 0.4 1];

%% Plot data - with x and y errorbars and correct intercept(!)
figtitle=sprintf('Plot_XVALPEXPdotpr_per_model_Study1');
create_figure(figtitle)

% GENERAL MODEL
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4); 
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

y(:,:,1) = reshape (pexp_xval_dp (1:220,1), 55, 4);
y(:,:,2) = reshape (pexp_xval_dp (221:440,1), 55, 4);
y(:,:,3) = reshape (pexp_xval_dp (441:660,1), 55, 4);
y(:,:,4) = reshape (pexp_xval_dp (661:880,1), 55, 4);

clear mX sX mY sY
% Plot bins and display error bars 
subplot(2,5,1)
for yyidx = 1:4
      
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 5, 'linewidth', 0.75);

    set(h(2), 'color', 'k', 'linewidth', 0.75);
    %set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end 

%line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.56],'YLim', [-0.04 0.43], 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% MECHANICAL MODEL 
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4); 
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

y(:,:,1) = reshape (pexp_xval_dp (1:220,2), 55, 4);
y(:,:,2) = reshape (pexp_xval_dp (221:440,2), 55, 4);
y(:,:,3) = reshape (pexp_xval_dp (441:660,2), 55, 4);
y(:,:,4) = reshape (pexp_xval_dp (661:880,2), 55, 4);

clear mX sX mY sY
% Plot bins and display error bars 
subplot(2,5,2)
for yyidx = 1:4
      
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 5, 'linewidth', 0.75);

    set(h(2), 'color', 'k', 'linewidth', 0.75);
    %set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end 
%line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.56],'YLim', [-0.04 0.43], 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% THERMAL MODEL
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4); 
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

y(:,:,1) = reshape (pexp_xval_dp (1:220,3), 55, 4);
y(:,:,2) = reshape (pexp_xval_dp (221:440,3), 55, 4);
y(:,:,3) = reshape (pexp_xval_dp (441:660,3), 55, 4);
y(:,:,4) = reshape (pexp_xval_dp (661:880,3), 55, 4);

clear mX sX mY sY
% Plot bins and display error bars 
subplot(2,5,3)
for yyidx = 1:4
      
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx),[], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 5, 'linewidth', 0.75);

    set(h(2), 'color', 'k', 'linewidth', 0.75);
    %set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end 
%line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.56],'YLim', [-0.04 0.43], 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% AUDI MODEL
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4); 
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

y(:,:,1) = reshape (pexp_xval_dp (1:220,4), 55, 4);
y(:,:,2) = reshape (pexp_xval_dp (221:440,4), 55, 4);
y(:,:,3) = reshape (pexp_xval_dp (441:660,4), 55, 4);
y(:,:,4) = reshape (pexp_xval_dp (661:880,4), 55, 4);

clear mX sX mY sY
% Plot bins and display error bars 
subplot(2,5,4)
for yyidx = 1:4
      
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 5, 'linewidth', 0.75);

    set(h(2), 'color', 'k', 'linewidth', 0.75);
    %set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end 
%line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.56],'YLim', [-0.04 0.43], 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% VISUAL MODEL
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4); 
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

y(:,:,1) = reshape (pexp_xval_dp (1:220,5), 55, 4);
y(:,:,2) = reshape (pexp_xval_dp (221:440,5), 55, 4);
y(:,:,3) = reshape (pexp_xval_dp (441:660,5), 55, 4);
y(:,:,4) = reshape (pexp_xval_dp (661:880,5), 55, 4);

clear mX sX mY sY
% Plot bins and display error bars 
subplot(2,5,5)
for yyidx = 1:4
      
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 5, 'linewidth', 0.75);

    set(h(2), 'color', 'k', 'linewidth', 0.75);
    %set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end 
%line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.56],'YLim', [-0.04 0.43], 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

%
plugin_save_figure

%