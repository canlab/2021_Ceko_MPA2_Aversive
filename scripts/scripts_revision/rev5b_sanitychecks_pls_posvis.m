

% This script applies full sample PLS signatures to MPA2 negative visual positive visual 'non-reactive' images 
% 
% this is not the correct approach (should be applying cross-val) but I
% want to check how different the results are. 

% PLS signatures: multiple predictive patterns for aversive experience: General, Mechanical pain,
%         Thermal pain, Aversive Sounds, Visual aversive images


clear all
a_set_up_paths_always_run_first

cd(scriptsrevdir)

%% Prep   

% Load pos images data 
% ----------------------------------------------
clear DAT DATA_OBJ

load(fullfile(resultsrevdir, 'image_names_and_setup.mat'));
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

load(fullfile(resultsrevdir, 'data_objects.mat'));
fprintf('Loaded condition data from results%sDATA_OBJ\n', filesep);



%% Apply to main effects (4 stim modalities) 
% Choose subset of conditions 
k = length(DAT.conditions) % conditions are 2 mod x 4 stim intensities

% All Signatures

printhdr('Extracting all signatures');

% Dot product metric
DAT.SIG_conditions.raw.dotproduct = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions, 'image_set', 'multiaversive');


%% Plot dp
% Plot with error bars 
% -------------------------------------------------------
pexp_color = [0.6 0.8 1]  % posvis 

figtitle=sprintf('Plot_FULLSAMPLEdotpr_negpos_Study1ab');
create_figure(figtitle)

% Gen on neg
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.General_aversive(:,1:4));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,1)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0 0.2], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% Gen on pos
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.General_aversive(:,5:8));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,2)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0 0.2], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% Vis on neg
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Visual(:,1:4));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,3)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0.15 0.35], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);


% Vis on pos
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Visual(:,5:8));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,4)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);

% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0.15 0.35], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

plugin_save_figure

%% -------------------------------------------------------------------------
% Plot Common and Visual with error bars 
% -------------------------------------------------------------------------
pexp_color = [0.6 0.8 1]  % posvis 

figtitle=sprintf('Plot_FULLSAMPLEdotpr_negpos_Study1ab');
create_figure(figtitle)

% Gen on neg
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.General_aversive(:,1:4));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,1)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0 0.2], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% Gen on pos
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.General_aversive(:,5:8));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,2)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0 0.2], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

% Vis on neg
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Visual(:,1:4));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,3)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);
    
% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0.15 0.35], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);


% Vis on pos
clear x y 
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings
y = table2array(DAT.SIG_conditions.raw.dotproduct.Aversive_Visual(:,5:8));
  
clear mY sY
% Plot bins and display error bars 
subplot(3,5,4)

mY = nanmean(y); 
sY = ste(y); 

h = ploterr (x,mY,[],sY); % 'abshhxy', 0);
    
set(h(1), 'color', [0 0 0], 'marker', 'o', 'markerfacecolor',[1 1 1], 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1.5);

set(h(2), 'color', 'k', 'linewidth', 1);

% line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 2, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [0.15 0.35], 'XTick', 0:0.1:0.3,'YTick', 0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

plugin_save_figure





