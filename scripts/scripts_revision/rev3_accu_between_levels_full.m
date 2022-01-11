% load data
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm_TEST.mat'));
% loaded TEST file because that one contains matrix of cross-val dps (not
% separated by fold as in the newly saved file) 

cd(scriptsrevdir)

%% Calculate accuracy between levels

gen(:,:,1) = reshape (pexp_xval_dp (1:220,1), 55, 4);
gen(:,:,2) = reshape (pexp_xval_dp (221:440,1), 55, 4);
gen(:,:,3) = reshape (pexp_xval_dp (441:660,1), 55, 4);
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
% 1 = 55, p = 0.6
% 2 = 75, p = 0.003
% 3 = 60, p = 0.17
% 4 = 62, p = 0.1

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