% run cc0 first

%% Plot NPS, SIIPS, PINES on MPA2 data 

% %% Load data 
% a_set_up_paths_always_run_first
% 
% % Import DAT 
% b_reload_saved_matfiles
% 
% % Import behavior
% import_Behav_MPA2;

% Set colors
pexp_color = [1 0.2 0.4 % red
            1 0.6 0.2  % orange
            0 0.6 0.4 % green
            0 0.4 1];  % blue

        
clear x y 
x(:,:,1) = Pain_Avoid(:,1:4);
x(:,:,2) = Pain_Avoid(:,5:8);
x(:,:,3) = Pain_Avoid(:,9:12);
x(:,:,4) = Pain_Avoid(:,13:16);

%% Prep and plot data 

figtitle=sprintf('Plot_nps_siips_pines_Study1');
create_figure(figtitle)

% NPS signature 
pexpm_NPS = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,1:4));
pexpt_NPS = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,5:8));
pexpa_NPS = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,9:12));
pexpv_NPS = table2array(DAT.SIG_conditions.raw.dotproduct.NPS(:,13:16));

y(:,:,1) = pexpm_NPS; 
y(:,:,2) = pexpt_NPS;
y(:,:,3) = pexpa_NPS;
y(:,:,4) = pexpv_NPS;

% Plot bins and display error bars 
clear mX sX mY sY
subplot(3,5,1)
for yyidx = 1:4
       
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), sX(:,:,yyidx), sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

    set(h(2), 'color', 'k', 'linewidth', 1);
    set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end
line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.6],'YLim', [-6 10], 'XTick', 0.2:0.3:0.5,'YTick', -6:3:9,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% SIIPS signature 
pexpm_SIIPS = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,1:4));
pexpt_SIIPS = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,5:8));
pexpa_SIIPS = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,9:12));
pexpv_SIIPS = table2array(DAT.SIG_conditions.raw.dotproduct.SIIPS(:,13:16));

y(:,:,1) = pexpm_SIIPS; 
y(:,:,2) = pexpt_SIIPS;
y(:,:,3) = pexpa_SIIPS;
y(:,:,4) = pexpv_SIIPS;

% Plot bins and display error bars 
clear mX sX mY sY
subplot(3,5,2)
for yyidx = 1:4
       
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), sX(:,:,yyidx), sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

    set(h(2), 'color', 'k', 'linewidth', 1);
    set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end
line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.6],'YLim', [-800 700], 'XTick', 0.2:0.3:0.5,'YTick', -800:400:800,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% PINES signature 
pexpm_PINES = table2array(DAT.SIG_conditions.raw.dotproduct.PINES(:,1:4));
pexpt_PINES = table2array(DAT.SIG_conditions.raw.dotproduct.PINES(:,5:8));
pexpa_PINES = table2array(DAT.SIG_conditions.raw.dotproduct.PINES(:,9:12));
pexpv_PINES = table2array(DAT.SIG_conditions.raw.dotproduct.PINES(:,13:16));

y(:,:,1) = pexpm_PINES; 
y(:,:,2) = pexpt_PINES;
y(:,:,3) = pexpa_PINES;
y(:,:,4) = pexpv_PINES;

% Plot bins and display error bars 
clear mX sX mY sY
subplot(3,5,3)
for yyidx = 1:4
       
    mX (:,:,yyidx) = nanmean(x(:,:,yyidx));
    sX (:,:,yyidx) = ste(x(:,:,yyidx));
    
    
    mY (:,:,yyidx) = nanmean(y(:,:,yyidx));
    sY (:,:,yyidx) = ste(y(:,:,yyidx));
    
    h = ploterr (mX(:,:,yyidx), mY (:,:,yyidx), sX(:,:,yyidx), sY (:,:,yyidx)) % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color(yyidx,:), 'marker', 'o', 'markerfacecolor',pexp_color(yyidx,:), 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

    set(h(2), 'color', 'k', 'linewidth', 1);
    set(h(3), 'color', 'k', 'linewidth', 1);
    
    hold on 
end
line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.15 0.6],'YLim', [-0.4 0.75], 'XTick', 0.2:0.3:0.5,'YTick', -0.3:0.3:0.9,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

plugin_save_figure

%% Correlation predicted - observed 

clear rr pwithin
clear xx 
yy={}; xx={}
xx{1} = reshape(Pain_Avoid(:,1:4), 220,1); 
xx{2} = reshape(Pain_Avoid(:,5:8), 220,1); 
xx{3} = reshape(Pain_Avoid(:,9:12), 220,1); 
xx{4} = reshape(Pain_Avoid(:,13:16), 220,1); 

% NPS signature 
clear yy
yy{1} = reshape(pexpm_NPS, 220,1);
yy{2} = reshape(pexpt_NPS, 220,1);
yy{3} = reshape(pexpa_NPS, 220,1);
yy{4} = reshape(pexpv_NPS, 220,1);

subject_id=repmat(1:55,1,4)';

clear r_within rstd rste b
u = unique(subject_id);

XX={};YY={};
for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
        b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
      
       [wasnan1, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
       [wasnan1, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    end
    
    % calc r and p within
    [wasnan, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
    [wasnan, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    
    rr(1,m) = nanmean(r_within{m});
    rstd(1,m) = nanstd(r_within{m});
    rste(1,m)=rstd(1,m)/sqrt(size(u,1));
end

clear bw
for m=1:4
bw{m}=b(m,:,2)'
[~, pwithin(1,m)] = ttest(bw{m});
end

% SIIPS
clear yy
yy{1} = reshape(pexpm_SIIPS, 220,1);
yy{2} = reshape(pexpt_SIIPS, 220,1);
yy{3} = reshape(pexpa_SIIPS, 220,1);
yy{4} = reshape(pexpv_SIIPS, 220,1);

clear r_within bw
u = unique(subject_id);

XX={};YY={};
for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
        b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
      
       [wasnan1, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
       [wasnan1, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    end
    
    % calc r and p within
    [wasnan, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
    [wasnan, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    
    rr(2,m) = nanmean(r_within{m});
    rstd(2,m) = nanstd(r_within{m});
    rste(2,m)=rstd(2,m)/sqrt(size(u,1));
end

clear bw
for m=1:4
bw{m}=b(m,:,2)'
[~, pwithin(2,m)] = ttest(bw{m});
end

% PINES
clear yy
yy{1} = reshape(pexpm_PINES, 220,1);
yy{2} = reshape(pexpt_PINES, 220,1);
yy{3} = reshape(pexpa_PINES, 220,1);
yy{4} = reshape(pexpv_PINES, 220,1);

clear r_within bw
u = unique(subject_id);

XX={};YY={};
for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
        b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
      
       [wasnan1, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
       [wasnan1, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    end
    
    % calc r and p within
    [wasnan, XX{m}]= cellfun(@nanremove, XX{m}, 'UniformOutput', false); 
    [wasnan, YY{m}]= cellfun(@nanremove, YY{m}, 'UniformOutput', false);
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    
    rr(3,m) = nanmean(r_within{m});
    rstd(3,m) = nanstd(r_within{m});
    rste(3,m)=rstd(3,m)/sqrt(size(u,1));
end

clear bw
for m=1:4
bw{m}=b(m,:,2)'
[~, pwithin(3,m)] = ttest(bw{m});
end

% rr =
% 
%     0.3882    0.6601    0.2705   -0.0409
%     0.4964    0.4426    0.2003    0.0133
%     0.2166    0.3788    0.2195    0.5813
% 
% pwithin
% 
% pwithin =
% 
%     0.0120    0.0000    0.0024    0.7641
%     0.0007    0.0027    0.5263    0.5824
%     0.0417    0.0030    0.2206    0.0006
