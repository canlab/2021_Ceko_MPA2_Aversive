% load data
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
cd(scriptsrevdir);

% Load ratings from modeltable
rat_all = table2array(modeltable(:,'General'));

% ratings for mech (1), therm (2), audi (3), vis (4)
for n = 1:4   
y_rat(:,:,n) = rat_all(1+((n-1)*220):220+((n-1)*220),1);
end

% predicted ratings 
for n = 1:4
yhat_rat(:,:,n) = pexp_xval_dp(1+((n-1)*220):220+((n-1)*220),1);
end

% group = levels 
group = [ones(55,1);2*ones(55,1);3*ones(55,1);4*ones(55,1)]


%% Confusion matrix per model per target modality 

% function [outclass, err, posterior, logp, coeffs] = classify(sample, training, group, type, prior)

% GENERAL MODEL
% -------------------------------------------------------------------------
% (1) on Mechanical Pain 

% Calculate confusion
[est_class, err, est_posterior, est_logp, coeff] = classify(yhat_rat(:,:,1), y_rat(:,:,1), group, 'linear');
C = confusionmat(group, est_class);

c_table1 = table(C);
c_table1 = splitvars(c_table1, "C", 'NewVariableNames', {'lvl1' 'lvl2' 'lvl3' 'lvl4'});
c_table1.Properties.RowNames = {'lvl1' 'lvl2' 'lvl3' 'lvl4'}';

disp('Confusion matrix (frequency). Rows are true class, column is estimated class.')
disp(c_table1)

c_table2 = table(100 .* (1-C ./ sum(C, 2))); % greater missclassification with greater distance in levels 
c_table2 = splitvars(c_table2, "Var1", 'NewVariableNames', {'lvl1' 'lvl2' 'lvl3' 'lvl4'});
c_table2.Properties.RowNames = {'lvl1' 'lvl2' 'lvl3' 'lvl4'}';

disp('Confusion matrix (frequency). Rows are true class, column is estimated class.')
disp(c_table2)

toplot = table2array(c_table2)


% Plot Confusion
figtitle=sprintf('Confusionmatrix');
create_figure(figtitle);
hold off
%colormap parula(5)
subplot(2,2,1)
h = heatmap (c_table2.Properties.VariableNames, c_table2.Properties.VariableNames, toplot)
h.XLabel = 'True'
h.YLabel = 'Estimated Missclassified '
h.Title = 'General Model on Mech Pain'

plugin_save_figure



c_table2 = table(100 .* (1-C ./ sum(C, 2))); % greater missclassification with greater distance in levels 
c_table2 = splitvars(c_table2, "Var1", 'NewVariableNames', {'lvl1' 'lvl2' 'lvl3' 'lvl4'});
c_table2.Properties.RowNames = {'lvl1' 'lvl2' 'lvl3' 'lvl4'}';

disp('Confusion matrix (frequency). Rows are true class, column is estimated class.')
disp(c_table2)

toplot = table2array(c_table2)


c_table2 = table(100 .* C ./ sum(C, 2)); % greater missclassification with greater distance in levels 
c_table2 = splitvars(c_table2, "Var1", 'NewVariableNames', {'lvl1' 'lvl2' 'lvl3' 'lvl4'});
c_table2.Properties.RowNames = {'lvl1' 'lvl2' 'lvl3' 'lvl4'}';

disp('Confusion matrix (frequency). Rows are true class, column is estimated class.')
disp(c_table2)

toplot = table2array(c_table2)
% Plot Confusion
figtitle=sprintf('Confusionmatrix2');
create_figure(figtitle);
hold off
%colormap parula(5)
subplot(2,2,1)
h = heatmap (c_table2.Properties.VariableNames, c_table2.Properties.VariableNames, toplot)
h.XLabel = 'True'
h.YLabel = 'Estimated'
h.Title = 'General Model on Mech Pain'

plugin_save_figure




%% OLDER STUFF 

%% Calculate accuracy between levels

% gen on mech levels 1-4
gen(:,:,1) = reshape (pexp_xval_dp (1:220,1), 55, 4);

% gen on therm levels 1-4
gen(:,:,2) = reshape (pexp_xval_dp (221:440,1), 55, 4);

% gen on audi levels 1-4
gen(:,:,3) = reshape (pexp_xval_dp (441:660,1), 55, 4);

% gen on visual levels 1-4
gen(:,:,4) = reshape (pexp_xval_dp (661:880,1), 55, 4);

for n = 1:4
G_12{n} = roc_plot([gen(:,2,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_23{n} = roc_plot([gen(:,3,n); gen(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_34{n} = roc_plot([gen(:,4,n); gen(:,3,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_13{n} = roc_plot([gen(:,3,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
G_24{n} = roc_plot([gen(:,4,n); gen(:,2,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 

G_14{n} = roc_plot([gen(:,4,n); gen(:,1,n)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); 
end
% DC for G_12
% 1 = 55, p = 0.59
% 2 = 75, p = 0.003
% 3 = 60, p = 0.17
% 4 = 62, p = 0.105








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