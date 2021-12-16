
% Prep 
% ----------------------------------------------
pexp_color = [0.2 0.8 1;  % light blue
           1 0.4 1]; % light pink

figtitle=sprintf('Plot_NORMPEXP_dp_Study1');
create_figure(figtitle)


% Plot behavior
% ----------------------------------------------
lev = [1 2 3 4]
beh(1,:)  = [1.00	1.33	1.52	1.79]; 
beh(2,:) = [1.00	1.81	2.28	2.97];
  
subplot(3,5,1)
for yyidx = 1:2
    h = ploterr (lev, beh(yyidx,:), [],[]); % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    %set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[0.5 4.5],'YLim', [0.5 3.5], 'XTick', 1:1:4,'YTick', 1:0.5:3.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);


% ----------------------------------------------
% plot pattern responses 
% ----------------------------------------------

% GenS signature 
pexpnv_GenS = DAT.NORMPLSXVAL_GEN_conditions.raw.dotproduct(:,1:4);
pexppv_GenS = DAT.NORMPLSXVAL_GEN_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:)  = [1.00	1.33	1.52	1.79]; 
x(2,:) = [1.00	1.81	2.28	2.97];

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
subplot(3,5,2)
for yyidx = 1:2
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (x(yyidx,:), mY (:,:,yyidx), [], sY (:,:,yyidx)); % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[1 3],'YLim', [1 2.5], 'XTick', 1:0.5:3,'YTick', 1:0.5:2.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);


% NNV signature 
pexpnv_NNVS = DAT.NORMPLSXVAL_NNV_conditions.raw.dotproduct(:,1:4);
pexppv_NNVS = DAT.NORMPLSXVAL_NNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:)  = [1.00	1.33	1.52	1.79]; 
x(2,:) = [1.00	1.81	2.28	2.97];

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
subplot(3,5,3)
for yyidx = 1:2
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (x(yyidx,:), mY (:,:,yyidx), [], sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);
    set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 
end 
set(gca,'box', 'off', 'XLim',[1 3],'YLim', [-0.1 1.5], 'XTick', 1:0.5:3,'YTick', 0:0.5:1.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);


% PNV signature 
pexpnv_PNVS = DAT.NORMPLSXVAL_PNV_conditions.raw.dotproduct(:,1:4);
pexppv_PNVS = DAT.NORMPLSXVAL_PNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:)  = [1.00	1.33	1.52	1.79]; 
x(2,:) = [1.00	1.81	2.28	2.97];

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
set(gca,'box', 'off', 'XLim',[1 3],'YLim', [-0.1 2.2], 'XTick', 1:0.5:3,'YTick', 0:0.5:2,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

plugin_save_figure

% stats: 

% Avg_rG
%     {[0.4811]}    {[0.7936]}
% 
% Avg_rN
%     {[0.5981]}    {[-0.3758]}
% 
% Avg_rP
%  {[-0.1447]}    {[0.7484]}

% p 
%     0.0007    0.0017
%     0.0017    0.0000
%     0.0409    0.0019
% 
% z
%     3.3837    3.1467
%     3.1460   -4.0939
%    -2.0445    3.1050
%
