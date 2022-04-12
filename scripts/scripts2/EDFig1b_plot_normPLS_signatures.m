%% ED Figure 1b

% This script plots behavior and PLS models trained in: 
% prep_2_train_normPLS_mormratings.m

a_set_up_paths_always_run_first

% Prep 
% ----------------------------------------------
pexp_color = [0.2 0.8 1;  % light blue
           1 0.4 1]; % light pink


import_Behav_NEGPOS_scatter

load(fullfile(resultsrevdir, 'data_objects.mat')); 

load(fullfile(resultsdir, 'image_names_and_setup.mat'));

% ----------------------------------------------
% Plot behavior - scatter w. valence / arousal 
% ----------------------------------------------
%%
len = 24
col_lim = [0.2 0.6 1;   % neg blue 
           1 1 1;     % neutral
           1 0 1];    % pos pink

col_neg = [linspace(col_lim(1,1),col_lim(2,1),len)', ...
           linspace(col_lim(1,2),col_lim(2,2),len)', ...
           linspace(col_lim(1,3),col_lim(2,3),len)'];
       
col_pos = [linspace(col_lim(2,1),col_lim(3,1),len)', ...
           linspace(col_lim(2,2),col_lim(3,2),len)', ...
           linspace(col_lim(2,3),col_lim(3,3),len)'];

col_all = [col_neg; col_pos];

figtitle=sprintf('Plots_NORMPLS_recoded_Study1');
create_figure(figtitle); 

subplot(3,5,1);
scatter(Norm_scatter(23:end,2),Norm_scatter(23:end,1),40, Norm_scatter(23:end,1),'filled', 'LineWidth', 0.5, 'MarkerEdgeColor',[0 0 0]);
hold on
scatter(Norm_scatter(1:22,2),Norm_scatter(1:22,1),40, Norm_scatter(1:22,1),'filled', 'LineWidth', 0.5, 'MarkerEdgeColor',[0 0 0]);
colormap(col_all);
axis tight
set(gca,'LineWidth', 1, 'XLim', [3.3 7.6], 'YLim', [0.5 8.5], ...
    'XTick', 0:2.5:10, 'YTick', 0:2.5:10, 'FontSize', 10);

% ----------------------------------------------
% Plot behavior - line plot 
% ----------------------------------------------

lev = [1 2 3 4] % bins (pre-selected levels based on IAPS norm rating ranges)

% true raw ratings -- confusing, because negative ratings are 'flipped' - high rating at low stim level
% beh(1,:)  = [3.016	2.750	2.560	2.228]; 
% beh(2,:) = [6.078	6.891	7.361	8.048];

% so I recoded them and flipped them - scale is 1 - 9, 5 is 'neutral',
% i.e., 6 -> 9 = 1 -> 4 pleasant
%       4 -> 1 = 1 -> 4 unpleasant

beh(1,:) = [1.984	2.250	2.440	2.773];
beh(2,:) = [1.078	1.891	2.361	3.048];

subplot(3,5,2)
for yyidx = 1:2
    h = ploterr (lev, beh(yyidx,:), [],[]); % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    %set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[0.5 4.5],'YLim', [.5 3.5], 'XTick', 1:1:4,'YTick', 0:1:4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% ----------------------------------------------
%% Plot pattern responses 
% ----------------------------------------------

% GenS signature 
pexpnv_GenS = DAT.rawNORMPLSXVAL_GEN_conditions.raw.dotproduct(:,1:4);
pexppv_GenS = DAT.rawNORMPLSXVAL_GEN_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [1.984	2.250	2.440	2.773];
x(2,:) = [1.078	1.891	2.361	3.048];

y(:,:,1) = pexpnv_GenS; 
y(:,:,2) = pexppv_GenS;

% Get corr 
% ----------------------------------------------
for m = 1:2
    xx(:,:,m)  = repmat(x(m,:), 55,1); 
    
    for i = 1:55
        Y{m}{i} = xx(i,:,m)'; % IASP rating
        XG{m}{i} = y(i,:,m)'; %  % yhat ratings
    end
    
    [rG_within{m}] = cellfun(@corr, Y{m},XG{m});
    Avg_rG{m} = nanmean (rG_within{m})
end 

% bootstrap 10,000 to obtain p values
clear p z xxx
for m = 1:2
    xxx = rG_within{m}';
    stat = nanmean (xxx);
    bootstat = bootstrp(10000, @nanmean, xxx);
    [p(1,m), z(1,m)] = bootbca_pval(0, @nanmean, bootstat,stat, xxx)
end

% Plot with error bars 
% -------------------------------------------------------
clear mY sY
subplot(3,5,3)
for yyidx = 1:2
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (x(yyidx,:), mY (:,:,yyidx), [], sY (:,:,yyidx)); % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [1.5 3], 'XTick', 1:1:4,'YTick', 1:0.5:3,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);
% 

% NNV signature 
pexpnv_NNVS = DAT.rawNORMPLSXVAL_NNV_conditions.raw.dotproduct(:,1:4);
pexppv_NNVS = DAT.rawNORMPLSXVAL_NNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [1.984	2.250	2.440	2.773];
x(2,:) = [1.078	1.891	2.361	3.048];

y(:,:,1) = pexpnv_NNVS; 
y(:,:,2) = pexppv_NNVS;

% Get corr 
% ----------------------------------------------
for m = 1:2
    xx(:,:,m)  = repmat(x(m,:), 55,1); 
    
    for i = 1:55
        Y{m}{i} = xx(i,:,m)'; % IASP rating
        XN{m}{i} = y(i,:,m)'; %  % yhat ratings
    end
    
    [rN_within{m}] = cellfun(@corr, Y{m},XN{m});
    Avg_rN{m} = nanmean (rN_within{m})
end 

% bootstrap 10,000 to obtain p values
clear xxx
for m = 1:2
    xxx = rN_within{m}';
    stat = nanmean (xxx);
    bootstat = bootstrp(10000, @nanmean, xxx);
    [p(2,m), z(2,m)] = bootbca_pval(0, @nanmean, bootstat,stat, xxx)
end

% Plot with error bars 
% -------------------------------------------------------
clear mY sY
subplot(3,5,4)
for yyidx = 1:2
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (x(yyidx,:), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [-0.1 2.4], 'XTick', 1:1:4,'YTick', 0:0.5:2.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);
% 

% PNV signature 
pexpnv_PNVS = DAT.rawNORMPLSXVAL_PNV_conditions.raw.dotproduct(:,1:4);
pexppv_PNVS = DAT.rawNORMPLSXVAL_PNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [1.984	2.250	2.440	2.773];
x(2,:) = [1.078	1.891	2.361	3.048];

y(:,:,1) = pexpnv_PNVS; 
y(:,:,2) = pexppv_PNVS;

% Get corr 
% ----------------------------------------------
for m = 1:2
    xx(:,:,m)  = repmat(x(m,:), 55,1); 
    
    for i = 1:55
        Y{m}{i} = xx(i,:,m)'; % IASP rating
        XP{m}{i} = y(i,:,m)'; %  % yhat ratings
    end
    
    [rP_within{m}] = cellfun(@corr, Y{m},XP{m});
    Avg_rP{m} = nanmean (rP_within{m})
end 

% bootstrap 10,000 to obtain p values
clear xxx
for m = 1:2
    xxx = rP_within{m}';
    stat = nanmean (xxx);
    bootstat = bootstrp(10000, @nanmean, xxx);
    [p(3,m), z(3,m)] = bootbca_pval(0, @nanmean, bootstat,stat, xxx)
end

% Plot with error bars 
% -------------------------------------------------------
clear mY sY
% Plot bins and display error bars 
subplot(3,5,5)
for yyidx = 1:2
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (x(yyidx,:), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    set(h(2), 'color', 'k', 'linewidth', 1); 
    hold on 
end 
set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [-0.1 2.4], 'XTick', 1:1:4,'YTick', 0:0.5:2.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);
% 

%plugin_save_figure

% stats - updated and dc 01/17/22 

% Avg_rG
%     {[0.5803]}    {[0.6846]}
% 
% Avg_rN
%     {[0.4907]}    {[-0.4190]}
% 
% Avg_rP
%  {[-0.1077]}    {[0.7514]}

% p 
%     0.0013    0.0014
%     0.0010    0.0000
%     0.1216    0.0019
% 
% z
%     3.2104    3.2024
%     3.2829   -4.1620
%    -1.5482    3.1045

