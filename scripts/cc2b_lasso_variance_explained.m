
%% load y and yfit 
%import_Behav_MPA2;
% use avers_mat for beh: 
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

% Load cross-val yfit values
load('/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/results/results_lasso/LASSO_results_allstim_combined_N55_n5000.mat')
yfit_combined=lasso_stats_results{1}.yfit

load('/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/results/results_lasso/LASSO_results_allstim_N55_n5000.mat')
yfit_m=lasso_stats_results{1}.yfit
yfit_t=lasso_stats_results{2}.yfit
yfit_a=lasso_stats_results{3}.yfit
yfit_v=lasso_stats_results{4}.yfit

clear yy yhatGS
bl=size(subject_id,1); % 220 = 55 subjects x 4 levels 


% Define Y = avers_mat = observed ratings
% -------------------------------------------------------------------------
yy(:,1) = avers_mat(1:bl,1);
yy(:,2) = avers_mat(bl+1:2*bl,1);
yy(:,3) = avers_mat(2*bl+1:3*bl,1);
yy(:,4) = avers_mat(3*bl+1:4*bl,1);

% Define X = predictors = yhat 
% -------------------------------------------------------------------------
% including intercept (a column of ones) so that the 'stats' output of regress.m 
% behaves correctly and gives me an R2 for multiple regression, 

% [1   X1 = Gen   X2 = Spec] for multiple regression:
yhatGS(:,:,1) = [ones(bl,1) yfit_combined(1:bl) yfit_m]; % Mech 
yhatGS(:,:,2) = [ones(bl,1) yfit_combined(bl+1:2*bl) yfit_t]; % Therm
yhatGS(:,:,3) = [ones(bl,1) yfit_combined(2*bl+1:3*bl) yfit_a]; % Aud
yhatGS(:,:,4) = [ones(bl,1) yfit_combined(3*bl+1:4*bl) yfit_v]; % Vis
 
%% (1) Total variance via multiple regression 
% -------------------------------------------------------------------------
clear b stats
for m=1:4;
[b(:,m),~,~,~,stats(:,:,m)]=regress(yy(:,m), yhatGS(:,:,m));
end
stats(:,:,1) =
    0.3826   67.2498    0.0000    0.0231
stats(:,:,2) =
    0.1794   23.7149    0.0000    0.0481
stats(:,:,3) =
    0.0508    5.8057    0.0035    0.0419
stats(:,:,4) =
    0.1498   19.1178    0.0000    0.0383

%% (2) Single variances via correlation
% -------------------------------------------------------------------------
 clear r2
for m=1:4;
[r2(m)]=(corr(yy(:,m),yhatGS(:,2,m))).^2;
[r2(m+4)]=(corr(yy(:,m),yhatGS(:,3,m))).^2; 
end   

%     Gen (1-4), Spec (5-8)
% r2 = 0.3663    0.1633    0.0457    0.0873    0.3052    0.1736    0.0356    0.1458  


clear UVG UVS SVGS
for m=1:4;
    UVG(m) = stats(:,1,m) - r2(m+4); % Unique for X1
    UVS(m) = stats(:,1,m) - r2(m); % Unique for X2
    SVGS(m) = stats(:,1,m) - UVG(m) - UVS(m);
end


for m=1:4
    Total(1,m)=stats(:,1,m)
end

% Answers: 
% UVG = 0.0774    0.0058    0.0152    0.0040
% UVS = 0.0163    0.0160    0.0051    0.0625
% SVGS = 0.2889    0.1576    0.0305    0.0833
% Total =  0.3826    0.1794    0.0508    0.1498


% This looks fairly similar to the outputs we get from
% canlab_variance_decomposition 

%% Plot  --------------------------------------------------------------------- %%
figtitle=sprintf('Plot_PIE_LASSO_WPERCENT_VAREXPLAINED_MULTIPLE_REG');
create_figure(figtitle)

cols = [0.4 0.4 0.4 % Unique to Gen (dark gray)
    1 1 0 % Unique to Spec (yellow)
    0.8 0.8 0.6] % Shared (yellowish gray)
    
for m=1:4;
    subplot(2,4,m);
    piedata = double([UVG(1,m) UVS(1,m) SVGS(1,m)])*100; % *100 bc SUM has to be >1 for pie to plot RELATIVE percentage
    h = wani_pie(piedata, 'cols',cols, 'fontsize', 8, 'hole', 'hole_size', 500);
end

plugin_save_figure;



%% Older Analyses
% -------------------------------------------------------------------------
% Prediction r2  predicted - observed not done, should be very similar to
% this: 

%% Refit for shared variance 
% note sure how much sense this makes, bc I cannot directly compare to PLS
% variance explained (across blocks), what I can do for LASSO models is
% more comparable to within-block var explained (which though gives
% non-sensical output for cross-validated PLS models)


% LASSO 'within-blocks'
y = avers_mat(1:220,1);
X = [yfit_combined(1:220) yfit_m];
X_type = {'continuous' 'continuous'};
out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');

y = avers_mat(221:440,1);
X = [yfit_combined(221:440) yfit_t];
X_type = {'continuous' 'continuous'};
out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');

y = avers_mat(441:660,1);
X = [yfit_combined(441:660) yfit_a];
X_type = {'continuous' 'continuous'};
out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');

y = avers_mat(661:880,1);
X = [yfit_combined(661:880) yfit_v];
X_type = {'continuous' 'continuous'};
out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');


% % Mech
% ____________________________________________________________________________________________________________________________________________
% Total y variance = 0.0371, full-model residual variance = 0.0231
% Full model variance explained: 0.3770
% Variance shared across variables and not explained uniquely: 0.2885
% ____________________________________________________________________________________________________________________________________________
% Variance explained by each variable:
%                  Type         Total      Unique 
%     Var_1    'continuous'     0.3634    0.074934
%     Var_2    'continuous'    0.30202    0.013557
% 
% % Therm
% _________________________________________________________________________________________________________________________________________
% Total y variance = 0.0581, full-model residual variance = 0.0481
% Full model variance explained: 0.1718
% Variance shared across variables and not explained uniquely: 0.1575
% ____________________________________________________________________________________________________________________________________________
% Variance explained by each variable:
%                  Type         Total      Unique  
%     Var_1    'continuous'     0.1595    0.0019778
%     Var_2    'continuous'    0.16982     0.012303
% 
% % Audi 
% ______________________________________________________________________________________________________________________________________
% Total y variance = 0.0438, full-model residual variance = 0.0419
% Full model variance explained: 0.0420
% Variance shared across variables and not explained uniquely: 0.0304
% ____________________________________________________________________________________________________________________________________________
% Variance explained by each variable:
%                  Type         Total        Unique  
%     Var_1    'continuous'    0.041279      0.010851
%     Var_2    'continuous'    0.031191    0.00076306
% 
% % Visual
% ____________________________________________________________________________________________________________________________________________
% Total y variance = 0.0447, full-model residual variance = 0.0383
% Full model variance explained: 0.1420
% Variance shared across variables and not explained uniquely: 0.0830
% ____________________________________________________________________________________________________________________________________________
% Variance explained by each variable:
%                  Type         Total        Unique  
%     Var_1    'continuous'    0.083116    7.1743e-05
%     Var_2    'continuous'      0.1419      0.058853
% 


% full column
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = avers_mat(:,m+1); % behavior
    clear X 
    X = [yhat(:,1) yhat(:,m+1)]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end

% Within-subject - shared var makes little sense (bc it calcs shared
% across models AND subj?) 
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = avers_mat(:,m+1); % behavior
    clear X 
    X = [yhat(:,1) yhat(:,m+1) subjects]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end
% % Mech 
% Total y variance = 0.0208, full-model residual variance = 0.0138
% Full model variance explained: 0.3388
% Variance shared across variables and not explained uniquely: -0.0034
% Variance explained by each variable:
%                  Type          Total        Unique  
%     Var_1    'continuous'    -0.0009684    0.0023828
%     Var_2    'continuous'       0.33641      0.33976
% 
% % Therm
% Total y variance = 0.0407, full-model residual variance = 0.0240
% Full model variance explained: 0.4107
% Variance shared across variables and not explained uniquely: 0.0932
% Variance explained by each variable:
%                  Type         Total       Unique 
%     Var_1    'continuous'    0.095814    0.002651
%     Var_2    'continuous'     0.40806      0.3149
% 
% % Audi
% Total y variance = 0.0286, full-model residual variance = 0.0135
% Full model variance explained: 0.5261
% Variance shared across variables and not explained uniquely: 0.0079
% Variance explained by each variable:
%                  Type          Total        Unique   
%     Var_1    'continuous'    0.0075327    -0.00041536
%     Var_2    'continuous'      0.52655         0.5186
% 
% % Vis
% Total y variance = 0.0262, full-model residual variance = 0.0119
% Full model variance explained: 0.5458
% Variance shared across variables and not explained uniquely: 0.0003
% Variance explained by each variable:
%                  Type          Total         Unique  
%     Var_1    'continuous'    0.00034823    2.3005e-05
%     Var_2    'continuous'       0.54578       0.54545

%% Per block
clear xx yy
% Beh
xx(:,1) = avers_mat (1:220,1);
xx(:,2) = avers_mat (221:440,1);
xx(:,3) = avers_mat (441:660,1);
xx(:,4) = avers_mat (661:880,1);

% Gen
yyy(:,1) = yhat (1:220,1); % Mech 
yyy(:,2) = yhat (221:440,1); % Therm
yyy(:,3) = yhat (441:660,1); % Aud
yyy(:,4) = yhat (661:880,1); % Vis

% Spec
yy(:,1) = yhat (1:220,2); % Mech 
yy(:,2) = yhat (221:440,3); % Therm
yy(:,3) = yhat (441:660,4); % Aud
yy(:,4) = yhat (661:880,5); % Vis

% per block
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = xx(:,m); % behavior
    clear X 
    X = [yyy(:,m) yy(:,m)]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end

