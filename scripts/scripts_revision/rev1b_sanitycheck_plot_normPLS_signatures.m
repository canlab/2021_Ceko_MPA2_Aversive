
% Prep 
% ----------------------------------------------
pexp_color = [0.2 0.8 1;  % light blue
           1 0.4 1]; % light pink
       
       
figtitle=sprintf('Plots_sanitycheck_NORMPLS_recoded_Study1');
create_figure(figtitle); 

% ----------------------------------------------
% Plot pattern responses 
% ----------------------------------------------
%%
% GenS signature 
pexpnv_GenS = DAT.sanNORMPLSXVAL_GEN_conditions.raw.dotproduct(:,1:4);
pexppv_GenS = DAT.sanNORMPLSXVAL_GEN_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [3.0157    2.7500    2.5600    2.2275];
x(2,:) = [6.0783    6.8914    7.3614    8.0483];

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
% set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [1.5 3], 'XTick', 1:1:4,'YTick', 1:0.5:3,'tickdir', 'out', 'ticklength', [.01 .01]);
% set(gca,'LineWidth', 1,'FontSize', 10);
% % 

% NNV signature 
pexpnv_NNVS = DAT.sanNORMPLSXVAL_NNV_conditions.raw.dotproduct(:,1:4);
pexppv_NNVS = DAT.sanNORMPLSXVAL_NNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [3.0157    2.7500    2.5600    2.2275];
x(2,:) = [6.0783    6.8914    7.3614    8.0483];

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
% set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [-0.1 2.4], 'XTick', 1:1:4,'YTick', 0:0.5:2.5,'tickdir', 'out', 'ticklength', [.01 .01]);
% set(gca,'LineWidth', 1,'FontSize', 10);
% % 

% PNV signature 
pexpnv_PNVS = DAT.sanNORMPLSXVAL_PNV_conditions.raw.dotproduct(:,1:4);
pexppv_PNVS = DAT.sanNORMPLSXVAL_PNV_conditions.raw.dotproduct(:,5:8);

clear x y xx
x(1,:) = [3.0157    2.7500    2.5600    2.2275];
x(2,:) = [6.0783    6.8914    7.3614    8.0483];

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
% set(gca,'box', 'off', 'XLim',[0.8 3.5],'YLim', [-0.1 2.4], 'XTick', 1:1:4,'YTick', 0:0.5:2.5,'tickdir', 'out', 'ticklength', [.01 .01]);
% set(gca,'LineWidth', 1,'FontSize', 10);
% % 

plugin_save_figure

