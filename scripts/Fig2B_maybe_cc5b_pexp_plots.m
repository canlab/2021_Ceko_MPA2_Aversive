% run cc0 first

%% PLS brain patterns (as included in the load_image_set)
% For now, make sure you use this load_image_set version: 
% /Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/scripts/modified_canlabcore_scripts/load_image_set.m
% (will commit to common repo when results are final) 

GenS   = which('General_b10000_unthr.nii');
MechS  = which('Mechanical_b10000_unthr.nii');
ThermS = which('Thermal_b10000_unthr.nii');
AudiS  = which('Sound_b10000_unthr.nii');
VisS   = which('Visual_b10000_unthr.nii');

pexp_color = [0.5 0.5 0.5 % gray
            1 0.2 0.4 % red 
            1 0.6 0.2  % orange
            0 0.6 0.4 % green
            0 0.4 1];  % blue

%% Apply PLS patterns and plot

% apply dotproduct and cosine similarity across conditions and contrasts 
% aa1_apply_aversivePLS_signatures.m

% pexp_gens = apply_mask (datM, GenS, 'pattern_expression', 'ignore_missing', 'cosine_similarity');

%% Load data 

% Import DAT 
b_reload_saved_matfiles

% Import behavior
import_Behav_MPA2;


%% Prep and plot data 

create_figure 
% mech pain data 
pexp_gens = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,1:4));
pexp_gens = reshape (pexp_gens, 220,1);

pexp_mchs = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,1:4));
pexp_mchs = reshape (pexp_mchs, 220,1);

pexp_thrms = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,1:4));
pexp_thrms = reshape (pexp_thrms, 220,1);

pexp_auds = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,1:4));
pexp_auds = reshape (pexp_auds, 220,1);

pexp_viss = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,1:4));
pexp_viss = reshape (pexp_viss, 220,1);

clear x y 
x = reshape (Pain_Avoid(:,1:4), 220,1);
y(:,1) = pexp_gens; 
y(:,2) = pexp_mchs;
y(:,3) = pexp_thrms;
y(:,4) = pexp_auds;
y(:,5) = pexp_viss;

subplot(2,4,2)
for yidx = 1:length(pexp_color)
    hold on
    sc = scatter(x,y(:,yidx), 'MarkerFaceColor', pexp_color(yidx,:), 'MarkerEdgeColor',pexp_color(yidx,:))
    sc.MarkerFaceAlpha = 0.5;
    
    % add lsline with corresponding color
     b = regress(y(:, yidx), [ones(length(x'), 1) x]);
     plot(x, b(1) + x'*b(2), 'LineWidth',2,'Color',pexp_color(yidx,:));
end
set(gca,'XLim',[-0.1 1],'YLim', [-0.15 0.25], 'XTick', 0:0.5:1,'YTick', -0.1:0.1:0.2, 'box', 'off');
set(gca,'LineWidth', 1,'FontSize', 18)


% therm pain data 
pexp_gens = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,5:8));
pexp_gens = reshape (pexp_gens, 220,1);

pexp_mchs = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,5:8));
pexp_mchs = reshape (pexp_mchs, 220,1);

pexp_thrms = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,5:8));
pexp_thrms = reshape (pexp_thrms, 220,1);

pexp_auds = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,5:8));
pexp_auds = reshape (pexp_auds, 220,1);

pexp_viss = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,5:8));
pexp_viss = reshape (pexp_viss, 220,1);

clear x y 
x = reshape (Pain_Avoid(:,5:8), 220,1);
y(:,1) = pexp_gens; 
y(:,2) = pexp_mchs;
y(:,3) = pexp_thrms;
y(:,4) = pexp_auds;
y(:,5) = pexp_viss;

subplot(2,4,2)
for yidx = 1:length(pexp_color)
    hold on
    sc = scatter(x,y(:,yidx), 'MarkerFaceColor', pexp_color(yidx,:), 'MarkerEdgeColor',pexp_color(yidx,:))
    sc.MarkerFaceAlpha = 0.5;
    
    % add lsline with corresponding color
     b = regress(y(:, yidx), [ones(length(x'), 1) x]);
     plot(x, b(1) + x'*b(2), 'LineWidth',2,'Color',pexp_color(yidx,:));
end
set(gca,'XLim',[-0.1 1],'YLim', [-0.15 0.25], 'XTick', 0:0.5:1,'YTick', -0.1:0.1:0.2, 'box', 'off');
set(gca,'LineWidth', 1,'FontSize', 18)

% av sound data 
pexp_gens = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,9:12));
pexp_gens = reshape (pexp_gens, 220,1);

pexp_mchs = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,9:12));
pexp_mchs = reshape (pexp_mchs, 220,1);

pexp_thrms = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,9:12));
pexp_thrms = reshape (pexp_thrms, 220,1);

pexp_auds = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,9:12));
pexp_auds = reshape (pexp_auds, 220,1);

pexp_viss = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,9:12));
pexp_viss = reshape (pexp_viss, 220,1);

clear x y 
x = reshape (Pain_Avoid(:,9:12), 220,1);
y(:,1) = pexp_gens; 
y(:,2) = pexp_mchs;
y(:,3) = pexp_thrms;
y(:,4) = pexp_auds;
y(:,5) = pexp_viss;

subplot(2,4,3)
hold on
for yidx = 1:length(pexp_color)
    sc = scatter(x,y(:,yidx), 'MarkerFaceColor', pexp_color(yidx,:), 'MarkerEdgeColor',pexp_color(yidx,:))
    sc.MarkerFaceAlpha = 0.5;
    
    % add lsline with corresponding color
     b = regress(y(:, yidx), [ones(length(x'), 1) x]);
     plot(x, b(1) + x'*b(2), 'LineWidth',2,'Color',pexp_color(yidx,:));
end
set(gca,'XLim',[-0.1 1],'YLim', [-0.15 0.25], 'XTick', 0:0.5:1,'YTick', -0.1:0.1:0.2, 'box', 'off');
set(gca,'LineWidth', 1,'FontSize', 18)

%  av vis data 
pexp_gens = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,13:16));
pexp_gens = reshape (pexp_gens, 220,1);

pexp_mchs = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,13:16));
pexp_mchs = reshape (pexp_mchs, 220,1);

pexp_thrms = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,13:16));
pexp_thrms = reshape (pexp_thrms, 220,1);

pexp_auds = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,13:16));
pexp_auds = reshape (pexp_auds, 220,1);

pexp_viss = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,13:16));
pexp_viss = reshape (pexp_viss, 220,1);

clear x y 
x = reshape (Pain_Avoid(:,13:16), 220,1);
y(:,1) = pexp_gens; 
y(:,2) = pexp_mchs;
y(:,3) = pexp_thrms;
y(:,4) = pexp_auds;
y(:,5) = pexp_viss;

subplot(2,4,4)
hold on
for yidx = 1:length(pexp_color)
    sc = scatter(x,y(:,yidx), 'MarkerFaceColor', pexp_color(yidx,:), 'MarkerEdgeColor',pexp_color(yidx,:))
    sc.MarkerFaceAlpha = 0.5;
    
    % add lsline with corresponding color
     b = regress(y(:, yidx), [ones(length(x'), 1) x]);
     plot(x, b(1) + x'*b(2), 'LineWidth',2,'Color',pexp_color(yidx,:));
     
    % work on this: 
     % h = ploterr(x, y(:, yidx), [], std (y(:, yidx))

     
end
set(gca,'XLim',[-0.1 1],'YLim', [-0.15 0.25], 'XTick', 0:0.5:1,'YTick', -0.1:0.1:0.2, 'box', 'off');
set(gca,'LineWidth', 1,'FontSize', 18)

%% Plot bins and display error bars 

%    **'n_bins':**
%        pass in the number of point "bins".  Will divide each subj's trials
%        into bins, get the avg X and Y per bin, and plot those point

% bin 

colormods={{[0.5 0.5 0.5]} {[1 0.2 0.4]} {[1 0.6 0.2]} {[0 0.6 0.4]} {[0 0.4 1]}}
XX = reshape(x, 55,4)
YY = zeros (55,4,5)
%%

create_figure;
subplot(2,2,1)
for yyidx = 1:size(y,2) 
    YY(:,:,yyidx) = reshape (y(:,yyidx), 55, 4)
    
    mX = nanmean(XX) 
    sX = ste(XX)     
    
    mY (:,:,yyidx) = nanmean(YY(:,:,yyidx));
    sY (:,:,yyidx) = ste(YY(:,:,yyidx));
    
    % display error bars 
    % hh = ploterr(x, y, xerr, yerr, varargin)
    
    h = ploterr (mX, mY (:,:,yyidx), sX, sY (:,:,yyidx)) % 'abshhxy', 0);
    
    % h(1) = data, h(2,3) are errorbars
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', '.', 'markersize', 10, 'linewidth', 2);
    set(h(2), 'color', 'k', 'linewidth', 2);
    set(h(3), 'color', 'k', 'linewidth', 2);
    
    hold on 
    
    % this removes caps but am doing sth wrong, come back to it later when
    % h1 = errorbar (mX, sX, 'LineWidth',2,'Color',pexp_color(yyidx,:), 'CapSize', 0)
%     hold on
%     h2 = errorbar (mY (:,:,yyidx), sY (:,:,yyidx), 'horizontal', 'LineWidth',2,'Color',pexp_color(yyidx,:), 'CapSize', 0)
%     hold on    

end 
set(gca,'box', 'off', 'XLim',[0.15 0.45],'YLim', [-0.05 0.1]) % 'XTick', 0:0.5:1,'YTick', -0.1:0.1:0.2, 'box', 'off');
set(gca,'LineWidth', 1,'FontSize', 18)

%%

subplot(4,7,6); % rather than a square plot, make it thinner
hold on;
% if we want each bar to have a different color, loop
for b = 1:size(dat, 2),
    bar(b, mean(dat(:,b)), 'FaceColor',  colors(b, :), 'EdgeColor', 'none', 'BarWidth', 0.6);
end





%%
yfitg_m=mean(yfitg)
yfitm_m=mean(yfitm)
yfitt_m=mean(yfitt)
yfita_m=mean(yfita)
yfitv_m=mean(yfitv)

colormod= [1 0.2 0.4 % red 
            1 0.6 0.2  % orange
            0 0.6 0.4 % green
            0 0.4 1  % blue
            0.5 0.5 0.5]; 

col_m = [1 0.2 0.4];
col_g = [0.5 0.5 0.5];
cols = [col_m; col_g];

out = plot_specificity_box(yfitm_m', yfitg_m', 'color', cols);
set(gcf, 'position', [697   565   204   187]);

col_t = [1 0.6 0.2];
cols = [col_m; col_t];

out = plot_specificity_box(yfitm_m', yfitt_m', 'color', cols);
set(gcf, 'position', [697   565   204   187]);

col_a = [0 0.6 0.4];
cols = [col_m; col_a];

out = plot_specificity_box(yfitm_m', yfita_m', 'color', cols);
set(gcf, 'position', [697   565   204   187]);

col_v = [0 0.4 1];
cols = [col_m; col_v];

out = plot_specificity_box(yfitm_m', yfitv_m', 'color', cols);
set(gcf, 'position', [697   565   204   187]);



%% 

% yval = reshape(datM.Y, 55, 4)'; % observed avoidance ratings 
% yfitg = reshape(pexp_gens, 55, 4)'; % signature response = predicted ratings 
% yfitm = reshape(pexp_mchs, 55, 4)'; % signature response = predicted ratings 
% yfitt = reshape(pexp_thrms, 55, 4)'; % signature response = predicted ratings 
% yfita = reshape(pexp_auds, 55, 4)'; % signature response = predicted ratings 
% yfitv = reshape(pexp_viss, 55, 4)'; % signature response = predicted ratings 




