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
% ----------------------------
% Pattern weights
savefilename = fullfile(resultsdir, 'sim_matrices.mat');
load(savefilename, 'sim_prims');
load(savefilename, 'sim_gen');

% Model encoding maps 
% ----------------------------
savefilename = fullfile(SR_resultsdir, 'sim_matrices_SR.mat');
load(savefilename, 'sim_prims_SR');
load(savefilename, 'sim_gen_SR');

% -----------------------------------------------------------------------
%% Commonality plot using average of model weights and str coefficients
% -----------------------------------------------------------------------

% Average of the two
catgen = cat(3, sim_gen, sim_gen_SR);
meangen = mean(catgen,3);

catprims = cat(3, sim_prims, sim_prims_SR);
meanprims = mean(catprims,3);

% Plot
% ----------------------------
% General
clear piedata 
piedata = meangen
piedata(piedata==0) = 0.00001

for i = 1:size(piedata,1)
    percent_gen(i,:) = piedata(i,:)./sum(piedata(i,:))*100
end


%    35.5253    0.0050    7.7242    0.7396   56.0059
%    25.9018   20.9293   46.0272    3.1989    3.9428
%    35.5392    5.3753   41.4653    7.6461    9.9741
%    33.7943    5.8937   13.9415   24.3093   22.0612
%    32.3367    5.6220   28.9902   13.3507   19.7003
%    24.8042   17.7482   17.8062   14.3480   25.2935
%    23.1724   20.0442   29.8535   19.0830    7.8469
%    38.8202    0.0038   47.2334    5.4890    8.4536 


%    18.3626   44.7177   26.1381    6.1362    4.6455
%    14.8506   24.9370   30.9058   29.3053    0.0013
%    20.2474    2.2886   11.7429   65.7180    0.0030
%    20.7854    1.6702    3.9310   73.6116    0.0018
%    20.7804    1.8661    8.1983   16.1795   52.9757
%    22.0184    2.2222   11.5145   10.9405   53.3045

% Primary
clear piedata
piedata = meanprims 
piedata(piedata==0) = 0.00001

for i = 1:size(piedata,1);
    percent_prims(i,:) = piedata(i,:)./sum(piedata(i,:))*100
end

%    35.5253    0.0050    7.7242    0.7396   56.0059
%    25.9018   20.9293   46.0272    3.1989    3.9428
%    35.5392    5.3753   41.4653    7.6461    9.9741
%    33.7943    5.8937   13.9415   24.3093   22.0612
%    32.3367    5.6220   28.9902   13.3507   19.7003
%    24.8042   17.7482   17.8062   14.3480   25.2935
%    23.1724   20.0442   29.8535   19.0830    7.8469
%    38.8202    0.0038   47.2334    5.4890    8.4536 

%% Plot
figtitle=sprintf('Commonality_brainregions.png');
create_figure;
for n=1:size(percent_gen,1)
    scatter(percent_gen(n,1),max(percent_gen(n,2:end)),250,'filled', ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',commcol, 'LineWidth', 1);
    axis tight;
end
hold on
for n=1:size(percent_prims,1)
    scatter(percent_prims(n,1),max(percent_prims(n,2:end)),250,'filled', ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',speccol, 'LineWidth', 1);
    axis tight;
end
set(gca,'LineWidth', 1, 'XLim', [10 50], 'YLim', [20 80],'FontSize', 20);

line([0 100], [50 50], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');
line([30 30], [0 100], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');

savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;


% -----------------------------------------------------------------------
%% Commonality plot using str coefficients
% -----------------------------------------------------------------------

meangen = sim_gen_SR

meanprims = sim_prims_SR


% General
clear piedata 
piedata = meangen
piedata(piedata==0) = 0.00001

% calculate relative percentage of each model in the ROI --- 
% 5 models competing, sum of all 5 in each ROI = 100 %
for i = 1:size(piedata,1)
    percent_gen(i,:) = piedata(i,:)./sum(piedata(i,:))*100;
end

%    19.4639   43.2398   17.7505   15.1089    4.4368 % amygdala, 
%    17.1080   23.4450   21.4300   38.0156    0.0013
%    11.2415    2.6353    3.2856   82.8341    0.0036
%    10.3095    2.1990    2.2937   85.1957    0.0021
%    17.6869    0.0025    0.0025    8.3533   73.9548
%    12.2852    0.0017    2.2476   11.8240   73.6415
%    22.4651   25.9502   29.6250   10.8442   11.1155
%    37.2408    0.0031   47.1499    1.8999   13.7063

% Primary
clear piedata
piedata = meanprims 
piedata(piedata==0) = 0.00001

for i = 1:size(piedata,1);
    percent_prims(i,:) = piedata(i,:)./sum(piedata(i,:))*100
end

%% Plot
figtitle=sprintf('Commonality_brainregions_SRonly.png');
create_figure;

% plot relative contribution of gen model against specific model with max contribution 
% e.g., for 
for n=1:size(percent_gen,1)
    scatter(percent_gen(n,1),max(percent_gen(n,2:end)),250,'filled', ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',commcol, 'LineWidth', 1);
    axis tight;
end
hold on
for n=1:size(percent_prims,1)
    scatter(percent_prims(n,1),max(percent_prims(n,2:end)),250,'filled', ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',speccol, 'LineWidth', 1);
    axis tight;
end
set(gca,'LineWidth', 1, 'XLim', [0 40], 'YLim', [20 90],'FontSize', 20);

line([0 100], [50 50], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');
line([30 30], [0 100], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');

%savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; close;





