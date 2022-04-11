% load data
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
cd(scriptsrevdir);

%% Calculate accuracy between levels

%%

spec(:,:,1) = reshape (pexp_xval_dp (1:220,2), 55, 4);
spec(:,:,2) = reshape (pexp_xval_dp (221:440,3), 55, 4);
spec(:,:,3) = reshape (pexp_xval_dp (441:660,4), 55, 4);
spec(:,:,4) = reshape (pexp_xval_dp (661:880,5), 55, 4);


for n = 1:4
G_21{n} = roc_plot([spec(:,2,n); spec(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_31{n} = roc_plot([spec(:,3,n); spec(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_41{n} = roc_plot([spec(:,4,n); spec(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_12{n} = roc_plot([spec(:,1,n); spec(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_32{n} = roc_plot([spec(:,3,n); spec(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_42{n} = roc_plot([spec(:,4,n); spec(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_13{n} = roc_plot([spec(:,1,n); spec(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_23{n} = roc_plot([spec(:,2,n); spec(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_43{n} = roc_plot([spec(:,4,n); spec(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_14{n} = roc_plot([spec(:,1,n); spec(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_24{n} = roc_plot([spec(:,2,n); spec(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_34{n} = roc_plot([spec(:,3,n); spec(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

end

%% Build confusion matrix SM
clear GM

% Spec model on mech pain
n = 1;
GM(1,1) = 0; GM(2,2) = 0; GM(3,3) = 0; GM(4,4) = 0;
GM(1,2)= G_21{n}.accuracy*100;
GM(1,3)= G_31{n}.accuracy*100;
GM(1,4)= G_41{n}.accuracy*100;

GM(2,1)= G_12{n}.accuracy*100;
GM(2,3)= G_32{n}.accuracy*100;
GM(2,4)= G_42{n}.accuracy*100; 

GM(3,1)= G_13{n}.accuracy*100;
GM(3,2)= G_23{n}.accuracy*100;
GM(3,4)= G_43{n}.accuracy*100;

GM(4,1)= G_14{n}.accuracy*100;
GM(4,2)= G_24{n}.accuracy*100;
GM(4,3)= G_34{n}.accuracy*100;

GM1 = round (GM);
GM1 = triu(GM1);
GM1(GM1==0)=nan;

% Spec model on therm pain
n = 2; clear GM
GM(1,1) = 0; GM(2,2) = 0; GM(3,3) = 0; GM(4,4) = 0;
GM(1,2)= G_21{n}.accuracy*100;
GM(1,3)= G_31{n}.accuracy*100;
GM(1,4)= G_41{n}.accuracy*100;

GM(2,1)= G_12{n}.accuracy*100;
GM(2,3)= G_32{n}.accuracy*100;
GM(2,4)= G_42{n}.accuracy*100; 

GM(3,1)= G_13{n}.accuracy*100;
GM(3,2)= G_23{n}.accuracy*100;
GM(3,4)= G_43{n}.accuracy*100;

GM(4,1)= G_14{n}.accuracy*100;
GM(4,2)= G_24{n}.accuracy*100;
GM(4,3)= G_34{n}.accuracy*100;

GM2 = round (GM);
GM2 = triu(GM2);
GM2(GM2==0)=nan;

% Spec model on audi
n = 3; clear GM
GM(1,1) = 0; GM(2,2) = 0; GM(3,3) = 0; GM(4,4) = 0;
GM(1,2)= G_21{n}.accuracy*100;
GM(1,3)= G_31{n}.accuracy*100;
GM(1,4)= G_41{n}.accuracy*100;

GM(2,1)= G_12{n}.accuracy*100;
GM(2,3)= G_32{n}.accuracy*100;
GM(2,4)= G_42{n}.accuracy*100; 

GM(3,1)= G_13{n}.accuracy*100;
GM(3,2)= G_23{n}.accuracy*100;
GM(3,4)= G_43{n}.accuracy*100;

GM(4,1)= G_14{n}.accuracy*100;
GM(4,2)= G_24{n}.accuracy*100;
GM(4,3)= G_34{n}.accuracy*100;

GM3 = round (GM);
GM3 = triu(GM3);
GM3(GM3==0)=nan;


% Spec model on vis
n = 4; clear GM
GM(1,1) = 0; GM(2,2) = 0; GM(3,3) = 0; GM(4,4) = 0;
GM(1,2)= G_21{n}.accuracy*100;
GM(1,3)= G_31{n}.accuracy*100;
GM(1,4)= G_41{n}.accuracy*100;

GM(2,1)= G_12{n}.accuracy*100;
GM(2,3)= G_32{n}.accuracy*100;
GM(2,4)= G_42{n}.accuracy*100; 

GM(3,1)= G_13{n}.accuracy*100;
GM(3,2)= G_23{n}.accuracy*100;
GM(3,4)= G_43{n}.accuracy*100;

GM(4,1)= G_14{n}.accuracy*100;
GM(4,2)= G_24{n}.accuracy*100;
GM(4,3)= G_34{n}.accuracy*100;

GM4 = round (GM);
GM4 = triu(GM4);
GM4(GM4==0)=nan;


%% Build confusion matrix pvalues 
clear GM pGM
% Spec model on mech pain
n = 1;
pGM(1,1) = 1; pGM(2,2) = 1; pGM(3,3) = 1; pGM(4,4) = 1;
pGM(1,2)= G_21{n}.accuracy_p;
pGM(1,3)= G_31{n}.accuracy_p;
pGM(1,4)= G_41{n}.accuracy_p;

pGM(2,1)= G_12{n}.accuracy_p;
pGM(2,3)= G_32{n}.accuracy_p;
pGM(2,4)= G_42{n}.accuracy_p; 

pGM(3,1)= G_13{n}.accuracy_p;
pGM(3,2)= G_23{n}.accuracy_p;
pGM(3,4)= G_43{n}.accuracy_p;

pGM(4,1)= G_14{n}.accuracy_p;
pGM(4,2)= G_24{n}.accuracy_p;
pGM(4,3)= G_34{n}.accuracy_p;

pGM = triu(pGM);
pGM(pGM==1)=nan;
pGM(2,1)=nan; pGM(3,1)=nan;pGM(4,1)=nan;
pGM(3,2)=nan; pGM(4,2)=nan;pGM(4,3)=nan;
pGM1=round(pGM,3)

% Spec model on therm pain
n = 2; clear pGM
pGM(1,1) = 1; pGM(2,2) = 1; pGM(3,3) = 1; pGM(4,4) = 1;
pGM(1,2)= G_21{n}.accuracy_p;
pGM(1,3)= G_31{n}.accuracy_p;
pGM(1,4)= G_41{n}.accuracy_p;

pGM(2,1)= G_12{n}.accuracy_p;
pGM(2,3)= G_32{n}.accuracy_p;
pGM(2,4)= G_42{n}.accuracy_p; 

pGM(3,1)= G_13{n}.accuracy_p;
pGM(3,2)= G_23{n}.accuracy_p;
pGM(3,4)= G_43{n}.accuracy_p;

pGM(4,1)= G_14{n}.accuracy_p;
pGM(4,2)= G_24{n}.accuracy_p;
pGM(4,3)= G_34{n}.accuracy_p;

pGM = triu(pGM);
pGM(pGM==1)=nan;
pGM(2,1)=nan; pGM(3,1)=nan;pGM(4,1)=nan;
pGM(3,2)=nan; pGM(4,2)=nan;pGM(4,3)=nan;
pGM2=round(pGM,3)

% Spec model on audi
n = 3; clear pGM
pGM(1,1) = 1; pGM(2,2) = 1; pGM(3,3) = 1; pGM(4,4) = 1;
pGM(1,2)= G_21{n}.accuracy_p;
pGM(1,3)= G_31{n}.accuracy_p;
pGM(1,4)= G_41{n}.accuracy_p;

pGM(2,1)= G_12{n}.accuracy_p;
pGM(2,3)= G_32{n}.accuracy_p;
pGM(2,4)= G_42{n}.accuracy_p; 

pGM(3,1)= G_13{n}.accuracy_p;
pGM(3,2)= G_23{n}.accuracy_p;
pGM(3,4)= G_43{n}.accuracy_p;

pGM(4,1)= G_14{n}.accuracy_p;
pGM(4,2)= G_24{n}.accuracy_p;
pGM(4,3)= G_34{n}.accuracy_p;

pGM = triu(pGM);
pGM(pGM==1)=nan;
pGM(2,1)=nan; pGM(3,1)=nan;pGM(4,1)=nan;
pGM(3,2)=nan; pGM(4,2)=nan;pGM(4,3)=nan;
pGM3=round(pGM,3)


% Spec model on vis
n = 4; clear pGM
pGM(1,1) = 1; pGM(2,2) = 1; pGM(3,3) = 1; pGM(4,4) = 1;
pGM(1,2)= G_21{n}.accuracy_p;
pGM(1,3)= G_31{n}.accuracy_p;
pGM(1,4)= G_41{n}.accuracy_p;

pGM(2,1)= G_12{n}.accuracy_p;
pGM(2,3)= G_32{n}.accuracy_p;
pGM(2,4)= G_42{n}.accuracy_p; 

pGM(3,1)= G_13{n}.accuracy_p;
pGM(3,2)= G_23{n}.accuracy_p;
pGM(3,4)= G_43{n}.accuracy_p;

pGM(4,1)= G_14{n}.accuracy_p;
pGM(4,2)= G_24{n}.accuracy_p;
pGM(4,3)= G_34{n}.accuracy_p;

pGM = triu(pGM);
pGM(pGM==1)=nan;
pGM(2,1)=nan; pGM(3,1)=nan;pGM(4,1)=nan;
pGM(3,2)=nan; pGM(4,2)=nan;pGM(4,3)=nan;
pGM4=round(pGM,3)

%% Plot
figtitle=sprintf('Confmatrix_Spec1');
create_figure(figtitle);
hold off

subplot(2,2,1)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, GM1,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'
colormap parula(5)

subplot(2,2,2)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, GM2,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'
colormap parula(5)

subplot(2,2,3)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, pGM1,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'

subplot(2,2,4)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, pGM2,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'

plugin_save_figure


%% Plot
figtitle=sprintf('Confmatrix_Spec2');
create_figure(figtitle);
hold off

subplot(2,2,1)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, GM3,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'
colormap parula(5)

subplot(2,2,2)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, GM4,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'
colormap parula(5)

subplot(2,2,3)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, pGM3,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'

subplot(2,2,4)
xvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
yvalues = {'lvl 1','lvl 2','lvl 3','lvl 4'};
h = heatmap (xvalues, yvalues, pGM4,'MissingDataColor', 'w','GridVisible', 'off')
h.XLabel = 'True'
h.YLabel = 'Predicted'

plugin_save_figure











