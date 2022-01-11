% load data
load(fullfile(resultsrevdir,'Pattexps_Lee.mat'))

cons = [1 -1];

% full baseline
clear x
for n=1:size(toplot,3)
    x(:,:,n) = [caps_pexpstim(:,:,n) caps_pexpbase(:,:,n)];
    convals_c(:,:,n) = x(:,:,n) * cons';
end

clear x
for n=1:size(toplot,3)
    x(:,:,n) = [sweet_pexpstim(:,:,n) sweet_pexpbase(:,:,n)];
    convals_s(:,:,n) = x(:,:,n) * cons';
end

clear x
for n=1:size(toplot,3)
    x(:,:,n) = [touch_pexpstim(:,:,n) touch_pexpbase(:,:,n)];
    convals_t(:,:,n) = x(:,:,n) * cons';
end

totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'Caps-BL' 'Sweet-BL' 'Touch-BL'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns([convals_c(:,:,n) convals_s(:,:,n) convals_t(:,:,n)],'nofig','noind', 'noviolin', 'title', totitle{n}, 'names', binnames, 'colors', seaborn_colors(8));
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1d_CondsMinBL_plot.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


create_figure; nplots = size(toplot,3); 
binnames = {'Caps-BL' 'Sweet-BL' 'Touch-BL'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns([convals_c(:,:,n) convals_s(:,:,n) convals_t(:,:,n)],'nofig','noind', 'title', totitle{n}, 'names', binnames, 'colors', seaborn_colors(8));
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1d_CondsMinBL_violinplot.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


% trimmed baseline
cons = [1 -1];

clear x
for n=1:size(toplot,3)
    x(:,:,n) = [caps_pexpstim(:,:,n) caps_pexpbasetrim(:,:,n)];
    convals_c(:,:,n) = x(:,:,n) * cons';
end

clear x
for n=1:size(toplot,3)
    x(:,:,n) = [sweet_pexpstim(:,:,n) sweet_pexpbasetrim(:,:,n)];
    convals_s(:,:,n) = x(:,:,n) * cons';
end

clear x
for n=1:size(toplot,3)
    x(:,:,n) = [touch_pexpstim(:,:,n) touch_pexpbasetrim(:,:,n)];
    convals_t(:,:,n) = x(:,:,n) * cons';
end

totitle = {'gens' 'mechs' 'therms' 'audis' 'viss' 'nps' 'siips' 'rating'};
create_figure; nplots = size(toplot,3); 
binnames = {'Caps-BL' 'Sweet-BL' 'Touch-BL'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns([convals_c(:,:,n) convals_s(:,:,n) convals_t(:,:,n)],'nofig','noind', 'noviolin', 'title', totitle{n}, 'names', binnames, 'colors', seaborn_colors(8));
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1d_CondsMinB_trim__plot.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);


create_figure; nplots = size(toplot,3); 
binnames = {'Caps-BL' 'Sweet-BL' 'Touch-BL'};

for n = 1:nplots
    axh(n) = subplot(4,5,n);
    barplot_columns([convals_c(:,:,n) convals_s(:,:,n) convals_t(:,:,n)],'nofig','noind', 'title', totitle{n}, 'names', binnames, 'colors', seaborn_colors(8));
    set(gca,'LineWidth', 1, 'FontSize', 8, 'box', 'off'); 
    xlabel(''), ylabel(''); drawnow
end
figtitle = 'rev2_1d_CondsMinBL_ttrim_violinplot.png'
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename);
