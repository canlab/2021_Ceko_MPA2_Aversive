% load data
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
cd(scriptsrevdir);


% predicted ratings 
for n = 1:4
yhat_rat(:,:,n) = pexp_xval_dp(1+((n-1)*220):220+((n-1)*220),1);
end

%% Calculate accuracy between levels

% Predicted ratings
for n = 1:4 
gen(:,:,n) = reshape (pexp_xval_dp(1+((n-1)*220):220+((n-1)*220),1), 55, 4);
end 

for n = 1:4
G_21{n} = roc_plot([gen(:,2,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_31{n} = roc_plot([gen(:,3,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_41{n} = roc_plot([gen(:,4,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_12{n} = roc_plot([gen(:,1,n); gen(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_32{n} = roc_plot([gen(:,3,n); gen(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_42{n} = roc_plot([gen(:,4,n); gen(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_13{n} = roc_plot([gen(:,1,n); gen(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_23{n} = roc_plot([gen(:,2,n); gen(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_43{n} = roc_plot([gen(:,4,n); gen(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_14{n} = roc_plot([gen(:,1,n); gen(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_24{n} = roc_plot([gen(:,2,n); gen(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_34{n} = roc_plot([gen(:,3,n); gen(:,4,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

end

%% Build confusion matrix GM
clear GM

% General model on mech pain
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

% General model on therm pain
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

% General model on audi
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


% General model on audi
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
% General model on mech pain
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

% General model on therm pain
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

% General model on audi
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
pGM(2,3)=1; pGM(2,4)=1;
pGM3=round(pGM,3)


% General model on audi
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
figtitle=sprintf('Confmatrix_Gen1');
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
figtitle=sprintf('Confmatrix_Gen2');
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













%%

specmodel(:,:,1) = reshape (pexp_xval_dp (1:220,2), 55, 4);
specmodel(:,:,2) = reshape (pexp_xval_dp (221:440,3), 55, 4);
specmodel(:,:,3) = reshape (pexp_xval_dp (441:660,4), 55, 4);
specmodel(:,:,4) = reshape (pexp_xval_dp (661:880,5), 55, 4);

for n = 1:4
model_12{n} = roc_plot([specmodel(:,2,n); specmodel(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  
model_23{n} = roc_plot([specmodel(:,3,n); specmodel(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  
model_34{n} = roc_plot([specmodel(:,4,n); specmodel(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  

model_13{n} = roc_plot([specmodel(:,3,n); specmodel(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  
model_24{n}= roc_plot([specmodel(:,4,n); specmodel(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

model_14{n} = roc_plot([specmodel(:,4,n); specmodel(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  
end 

%% Build accu matrices
clear GM SM GMp SMp
% General model matrix 
for n = 1:4
GM(n,1)= G_12{n}.accuracy*100;
GM(n,2)= G_23{n}.accuracy*100;
GM(n,3)= G_34{n}.accuracy*100;

GM(n,4)= G_13{n}.accuracy*100;
GM(n,5)= G_24{n}.accuracy*100;

GM(n,6)= G_14{n}.accuracy*100;
end
GM = round (GM);

% Specific models matrix
for n = 1:4
SM(n,1)= model_12{n}.accuracy*100;
SM(n,2)= model_23{n}.accuracy*100;
SM(n,3)= model_34{n}.accuracy*100;

SM(n,4)= model_13{n}.accuracy*100;
SM(n,5)= model_24{n}.accuracy*100;

SM(n,6)= model_14{n}.accuracy*100;
end
SM = round (SM);

% Gen p
for n = 1:4
GMp(n,1)= G_12{n}.accuracy_p;
GMp(n,2)= G_23{n}.accuracy_p;
GMp(n,3)= G_34{n}.accuracy_p;

GMp(n,4)= G_13{n}.accuracy_p;
GMp(n,5)= G_24{n}.accuracy_p;

GMp(n,6)= G_14{n}.accuracy_p;
end
GMp = round (GMp, 3)

% Spec p
for n = 1:4
SMp(n,1)= model_12{n}.accuracy_p;
SMp(n,2)= model_23{n}.accuracy_p;
SMp(n,3)= model_34{n}.accuracy_p;

SMp(n,4)= model_13{n}.accuracy_p;
SMp(n,5)= model_24{n}.accuracy_p;

SMp(n,6)= model_14{n}.accuracy_p;
end
SMp = round (SMp, 3);

%% Plot accumatrices
figtitle=sprintf('Accumatrix');
create_figure(figtitle);
hold off
colormap parula(5)

subplot(2,2,1)
xvalues = {'1 vs. 2','2 vs. 3','3 vs. 4','1 vs. 3','2 vs. 4','1 vs. 4'};
yvalues = {'Mech', 'Therm', 'Audi' , 'Vis'}
h = heatmap (xvalues, yvalues, GM)
h.XLabel = 'Stim level pairs'
h.YLabel = 'Modality'
h.Title = 'Accuracy between levels '

subplot(2,2,2)
xvalues = {'1 vs. 2','2 vs. 3','3 vs. 4','1 vs. 3','2 vs. 4','1 vs. 4'};
yvalues = {'Mech', 'Therm', 'Audi' , 'Vis'}
h = heatmap (xvalues, yvalues, SM)
h.XLabel = 'Stim level pairs'
h.YLabel = 'Modality'
h.Title = 'Accuracy between levels '
colormap parula(5)

subplot(2,2,3)
xvalues = {'1 vs. 2','2 vs. 3','3 vs. 4','1 vs. 3','2 vs. 4','1 vs. 4'};
yvalues = {'Mech', 'Therm', 'Audi' , 'Vis'}
h = heatmap (xvalues, yvalues, GMp)
h.XLabel = 'Stim level pairs'
h.YLabel = 'Modality'
h.Title = 'P-value'

subplot(2,2,4)
xvalues = {'1 vs. 2','2 vs. 3','3 vs. 4','1 vs. 3','2 vs. 4','1 vs. 4'};
yvalues = {'Mech', 'Therm', 'Audi' , 'Vis'}
h = heatmap (xvalues, yvalues, SMp)
h.XLabel = 'Stim level pairs'
h.YLabel = 'Modality'
h.Title = 'P-value'

plugin_save_figure










%% VIA CONFUSIONMAT FUNCTION - which I am doing wrong 
% group = levels 
group = [ones(55,1);2*ones(55,1);3*ones(55,1);4*ones(55,1)];


% predicted ratings COMMON model
for n = 1:4
yhat_rat(:,:,n) = pexp_xval_dp(1+((n-1)*220):220+((n-1)*220),1);
end

scatter(yhat_rat(:,:,1), group);


%% Confusion matrix per model per target modality 

% function [outclass, err, posterior, logp, coeffs] = classify(sample, training, group, type, prior)

% GENERAL MODEL
% -------------------------------------------------------------------------
% (1) on Mechanical Pain 

% Calculate confusion
[est_class, err, est_posterior, est_logp, coeff] = classify(yhat_rat(:,:,1), yhat_rat(:,:,1), group, 'linear');
C = confusionmat(group, est_class);

c_table1 = table(C);
c_table1 = splitvars(c_table1, "C", 'NewVariableNames', {'lvl1' 'lvl2' 'lvl3' 'lvl4'});
c_table1.Properties.RowNames = {'lvl1' 'lvl2' 'lvl3' 'lvl4'}';

disp('Confusion matrix (frequency). Rows are true class, column is estimated class.')
disp(c_table1)

% Plot Confusion
figtitle=sprintf('Confusionmatrix');
create_figure(figtitle);

subplot(2,2,1)
toplot = table2array(c_table1)
toplot = round(toplot)
cm = confusionchart(toplot)
cm.Title = 'Common Model on Mech Pain'

subplot(2,2,2)
toplot = table2array(c_table1)
h = confusionchart(toplot)
h = heatmap (c_table2.Properties.VariableNames, c_table2.Properties.VariableNames, toplot)
h.Title = 'Common Model on Mech Pain'

plugin_save_figure



%% confusionmat on rank order


% Predicted ratings
for n = 1:4 
gen(:,:,n) = reshape (pexp_xval_dp(1+((n-1)*220):220+((n-1)*220),1), 55, 4);
end 

gen1=gen(:,:,1);
sortgen1=sort(gen1,2);





