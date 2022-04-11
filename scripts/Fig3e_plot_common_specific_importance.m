%% Commonality plot

% Plots importance for common vs. type-specific models 

% (1) using average of pattern weights and str coefficients
% (2) using str coefficients


% % Colors from var explained donuts
% cols = [1 0.8 0.2 % Unique to Gen 
%     0.6 0.2 0 % Unique to Spec 
%     0.8 0.4 0 % Shared 
%     0.85 0.85 0.85] % Unexplained 

% Colors
commcol =  [1 0.8 0.2] 
speccol =  [0.6 0.2 0]

% Data from river plots 
% ---------------------------
savefilename = fullfile(resultsdir, 'sim_matrices.mat');
load(savefilename, 'sim_prims');
load(savefilename, 'sim_gen');

% -----------------------------------------------------------------------
%% Commonality plot using model weights 
% -----------------------------------------------------------------------

% Plot
% ----------------------------
% General
clear piedata 
piedata = sim_gen
piedata(piedata==0) = 0.00001

for i = 1:size(piedata,1)
    percent_gen(i,:) = piedata(i,:)./sum(piedata(i,:))*100
end

%    34.7942    0.0065    0.0065    0.0065   65.1862
%    36.8252   16.4147   46.7564    0.0018    0.0018
%    48.8331    0.0030   41.9838    9.1772    0.0030
%    41.5593    0.0074    0.0074   41.3927   17.0332
%    47.2187    0.0040   16.5382   17.6013   18.6378
%    51.4766    0.0048   12.2023   27.2422    9.0741
%    52.6720    0.0054   24.2592   23.0580    0.0054
%    52.7490    0.0045   45.6128    0.0045    1.6292


% Primary
clear piedata
piedata = sim_prims 
piedata(piedata==0) = 0.00001

for i = 1:size(piedata,1);
    percent_prims(i,:) = piedata(i,:)./sum(piedata(i,:))*100
end

%    51.0775   20.1796   28.7364    0.0032    0.0032
%    25.5239    7.7882   18.9953   47.6906    0.0020
%    15.1356    0.0042    0.0042   84.8518    0.0042
%    14.3344    0.0024    0.0024   85.6583    0.0024
%    24.2905    0.0031    0.0031    0.0031   75.7003
%    19.2600    0.0023    0.0023    0.0023   80.7333

%% Plot
figtitle=sprintf('Commonality_brainregions.png');
create_figure; 
for n=1:size(percent_gen,1)
    scatter(percent_gen(n,1),max(percent_gen(n,2:end)),400, ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',commcol, 'LineWidth', 3);
    axis tight;
end
hold on
for n=1:size(percent_prims,1)
    scatter(percent_prims(n,1),max(percent_prims(n,2:end)),400, ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',speccol, 'LineWidth', 3);
    axis tight;
end
set(gca,'LineWidth', 3, 'XLim', [10 60], 'YLim', [10 90], ...
    'XTick', 10:25:60, 'YTick', 10:40:90, 'FontSize', 30);

line([10 90], [50 50], 'color', [.6 .6 .6], 'linewidth', 3, 'linestyle', '--');
line([35 35], [10 90], 'color', [.6 .6 .6], 'linewidth', 3, 'linestyle', '--');

savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;



