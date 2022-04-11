%% Fig 6c

% this script creates the summmary matrix in Fig 6c


% Studies 

% Study 1   mech 
%           therm
%           audi
%           vis
% Study 2   mech
%           audi
% Study 3   therm
%           audi
%           emo audi
% Study 4   vis
% Study 5   vis
% Study 6   therm
% Study 1b posvis
% Study 5b  posvis
% Study 6b  warm

study1 = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];
study2 = [1 1 1 1 1; 1 1 1 1 1]
study3  = [1 2 1 1 1; 0 2 1 1 1; 0 2 1 1 1];
study3  = [1 2 1 1 1; 0 2 1 1 1; 0 1 1 1 1];
study4 = [1 2 1 1 1];
study5 = [1 1 1 2 1];
study6 = [1 1 1 1 1];
study1b = [1 1 1 1 1];
study5b = [1 1 1 1 1];
study6b = [1 1 1 1 1];

summarystudies = [study1; study2; study3; study4; study5; study6; study1b; study5b; study6]

%% Plot summary performance 
figtitle=sprintf('Summary_performance');
create_figure(figtitle);
hold off
subplot (1,2,1);
xvalues = {'Common', 'Mechanical','Thermal', 'Auditory','Visual'};
yvalues = {'1: Mech', '1: Therm', '1: Audi', '1: Vis', '2: Mech', '2: Audi', ...
    '3: Therm', '3: Audi', '3: EmoAud','4: Vis', '5: Vis', '6: Therm',  ...
     '1b: PosVis', '5b: PosVis', '6b: Warm'};
h = heatmap (xvalues, yvalues, summarystudies,'CellLabelColor','none');
h.YLabel = 'Studies (1 - 6b): Stimuli'
h.XLabel = 'Models'
colormap parula(8);

plugin_save_figure