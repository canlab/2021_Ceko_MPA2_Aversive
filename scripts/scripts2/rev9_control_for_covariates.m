
%% Test effect of covariates 


% 

% load data
cd(scriptsdir)
import_Behav_MPA2
import_Covars_MPA2

cd(scriptsrevdir)
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

diary on
diaryname = fullfile(['rev9_effect_of_covariates_' date '_output.txt']);
diary(diaryname);
% 

% Prep ratings 
mechrat=Pain_Avoid(:,1:4);
thermrat=Pain_Avoid(:,5:8);
audrat=Pain_Avoid(:,9:12);
visrat=Pain_Avoid(:,13:16);

%% Test effect of covariates on Common Model response 

% Common model
gen(:,:,1) = reshape (pexp_xval_dp(1:220,1), 55, 4);
gen(:,:,2) = reshape (pexp_xval_dp(221:440,1), 55, 4);
gen(:,:,3) = reshape (pexp_xval_dp(441:660,1), 55, 4);
gen(:,:,4) = reshape (pexp_xval_dp(661:880,1), 55, 4);

% Restructure for GLM
N = size(gen, 1);
for i = 1:N
    
    % sig response
    X1_1{i} = gen(i, :, 1)';
    X1_2{i} = gen(i, :, 2)';
    X1_3{i} = gen(i, :, 3)';
    X1_4{i} = gen(i, :, 4)';

    % avoidance rating
    Y1{i} = mechrat(i, :)';
    Y2{i} = thermrat(i, :)';
    Y3{i} = audrat(i, :)';
    Y4{i} = visrat(i, :)';
end

X2 = Covars % Session  Sex	Age (demeaned)	Hand Race

% Sig response pure, no covariates (just double-checking) 
fprintf ('NoCovs Gen on MECH \n');  % p = 0.00001	
stats = glmfit_multilevel(Y1, X1_1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted', 'plot');

fprintf ('NoCovs Gen on THERM \n'); % p = 0.00000	
stats = glmfit_multilevel(Y2, X1_2, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

fprintf ('NoCovs Gen on AUDI \n'); % p = 0.02695
stats = glmfit_multilevel(Y3, X1_3, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

fprintf ('NoCovs Gen on VIS \n'); % p = 0.00028
stats = glmfit_multilevel(Y4, X1_4, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

% -------------------------------------------------------------------------
% OBLIGATORY - Session order, sex, age 
% -------------------------------------------------------------------------
% Effect on predicting Y? 
% ------------------------------------------------------------------------- 
clear stats
stats = {}

fprintf ('GenS on MECH \n'); % NO
stats{1} = glmfit_multilevel(Y1, X1_1, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('GenS on THERM \n'); % NO 
stats{2} = glmfit_multilevel(Y2, X1_2, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('GenS on AUDI \n'); % NO % main effect still sign. p=0.04
stats{3} = glmfit_multilevel(Y3, X1_3, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('GenS on VIS \n'); % NO 
stats{4} = glmfit_multilevel(Y4, X1_4, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

% Effect of Session Order on predicting Y
% -------------------------------------------------------------------------
% Effect of Order - NO
stats{5} = glmfit_multilevel(Y1, X1_1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{6} = glmfit_multilevel(Y2, X1_2, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{7} = glmfit_multilevel(Y3, X1_3, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{8} = glmfit_multilevel(Y4, X1_4, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');

% Effect of Sex on predicting Y
% --------------------------------------------------------------------------
% Effect of Sex - NO
stats{9} = glmfit_multilevel(Y1, X1_1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{10} = glmfit_multilevel(Y2, X1_2, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{11} = glmfit_multilevel(Y3, X1_3, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{12} = glmfit_multilevel(Y4, X1_4, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');

% Effect of Age on predicting Y, nocenter flag, because covariate already
% centered (it doesn't matter much) 
% --------------------------------------------------------------------------
% Effect of Age - NO
stats{13} = glmfit_multilevel(Y1, X1_1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted', 'nocenter');
% Effect of Age - NO
stats{14} = glmfit_multilevel(Y2, X1_2, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted','nocenter');
% Effect of Age - NO
stats{15} = glmfit_multilevel(Y3, X1_3, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted', 'nocenter');
% Effect of Age - NO
stats{16} = glmfit_multilevel(Y4, X1_4, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted', 'nocenter');

% --------------------------------------------------------------------------
% SECONDARY 
% --------------------------------------------------------------------------

% Effect of Hand on predicting Y
% --------------------------------------------------------------------------
clear stats_h
% Effect of Hand - NO
stats_h = glmfit_multilevel(Y1, X1_1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - NO
stats_h = glmfit_multilevel(Y2, X1_2, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - NO 
stats_h = glmfit_multilevel(Y3, X1_3, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - NO
stats_h = glmfit_multilevel(Y4, X1_4, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');

% Effect of Race on predicting Y
% --------------------------------------------------------------------------
clear stats_r
% Effect of Race p = 0.03; but main effect still  <0.001
stats_r = glmfit_multilevel(Y1, X1_1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% Effect of Race -  NO
stats_r = glmfit_multilevel(Y2, X1_2, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% Effect of Race  - NO (0.74) but main effect now p = 0.16
stats_r = glmfit_multilevel(Y2, X1_2, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% % Effect of Race - NO 
stats_r = glmfit_multilevel(Y4, X1_4, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');


for n = 1:size(stats,2); stats_t_slopes{n} = stats{n}.t(:,2); end
for n = 1:size(stats,2); stats_p_slopes{n} = stats{n}.p(:,2); end
clear CovTest_Output
CovTest_Output(:,1) = vertcat(stats_t_slopes{:})
CovTest_Output(:,2) = vertcat(stats_p_slopes{:})


%% Test effect of covariates on Specific Model response 

% Specific models
spec(:,:,1) = reshape (pexp_xval_dp (1:220,2), 55, 4);  % Mech Model
spec(:,:,2) = reshape (pexp_xval_dp (221:440,3), 55, 4); % Therm Model
spec(:,:,3) = reshape (pexp_xval_dp (441:660,4), 55, 4); % Audi Model
spec(:,:,4) = reshape (pexp_xval_dp (661:880,5), 55, 4); % Vis Model

% Restructure for GLM
N = size(gen, 1);
for i = 1:N
    
    % sig response
    X1_1{i} = spec(i, :, 1)';
    X1_2{i} = spec(i, :, 2)';
    X1_3{i} = spec(i, :, 3)';
    X1_4{i} = spec(i, :, 4)';

    % avoidance rating
    Y1{i} = mechrat(i, :)';
    Y2{i} = thermrat(i, :)';
    Y3{i} = audrat(i, :)';
    Y4{i} = visrat(i, :)';
end

X2 = Covars % Session  Sex	Age	Hand Race

% Sig response pure, no covariates (just double-checking) 
fprintf ('NoCovs Mech on MECH \n'); % p = 0.01443	
stats = glmfit_multilevel(Y1, X1_1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

fprintf ('NoCovs Therm on THERM \n'); % p = 0.00000	
stats = glmfit_multilevel(Y2, X1_2, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

fprintf ('NoCovs Audi on AUDI \n'); % p = 0.00470	
stats = glmfit_multilevel(Y3, X1_3, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

fprintf ('NoCovs Visual on VIS \n'); % p = 0.00000	
stats = glmfit_multilevel(Y4, X1_4, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');


% -------------------------------------------------------------------------
% OBLIGATORY - Session order, sex, age 
% -------------------------------------------------------------------------
% Effect on predicting Y? NO
% ------------------------------------------------------------------------- 

clear stats

fprintf ('Mech on MECH \n');  % NO
stats{1} = glmfit_multilevel(Y1, X1_1, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('Therm on THERM \n'); % NO
stats{2} = glmfit_multilevel(Y2, X1_2, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('Audi on AUDI \n');  % age,... who knew , but main effect still sign (p = 0.002)
stats{3} = glmfit_multilevel(Y3, X1_3, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

fprintf ('Visual on VIS \n');  % 
stats{4} = glmfit_multilevel(Y4, X1_4, X2(:,1:3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Order' 'Sex' 'Age'}, 'weighted');

% Effect of Session Order on predicting Y
% -------------------------------------------------------------------------
% Effect of Order - NO
stats{5} = glmfit_multilevel(Y1, X1_1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{6} = glmfit_multilevel(Y2, X1_2, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{7} = glmfit_multilevel(Y3, X1_3, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');
% Effect of Order - NO
stats{8} = glmfit_multilevel(Y4, X1_4, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Order'}, 'weighted');


% Effect of Sex on predicting Y
% --------------------------------------------------------------------------
% Effect of Sex - NO
stats{9} = glmfit_multilevel(Y1, X1_1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{10} = glmfit_multilevel(Y2, X1_2, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{11} = glmfit_multilevel(Y3, X1_3, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');
% Effect of Sex - NO
stats{12} = glmfit_multilevel(Y4, X1_4, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Sex'}, 'weighted');

% Effect of Age on predicting Y -- nocenter flag because covariate is already centered 
% --------------------------------------------------------------------------
% Effect of Age - NO
stats{13} = glmfit_multilevel(Y1, X1_1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted','nocenter');
% Effect of Age - NO
stats{14} = glmfit_multilevel(Y2, X1_2, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted','nocenter');
% Effect of Age - YES, but main effect still highly sign.
stats{15} = glmfit_multilevel(Y3, X1_3, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'},'weighted','nocenter');
% Effect of Age - NO
stats{16} = glmfit_multilevel(Y4, X1_4, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted','nocenter');


% --------------------------------------------------------------------------
% SECONDARY 
% --------------------------------------------------------------------------

% Effect of Hand on predicting Y
% --------------------------------------------------------------------------
% Effect of Hand - n.s., but main p = 0.12
stats_h = glmfit_multilevel(Y1, X1_1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - NO
stats_h = glmfit_multilevel(Y2, X1_2, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - n.s. but main p = 0.08 
stats_h = glmfit_multilevel(Y3, X1_3, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');
% Effect of Hand - NO
stats_h = glmfit_multilevel(Y4, X1_4, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');

% Effect of Race on predicting Y
% --------------------------------------------------------------------------
% Effect of Race n.s.; but main p = 0.15
stats_r = glmfit_multilevel(Y1, X1_1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% Effect of Race -  no
stats_r = glmfit_multilevel(Y2, X1_2, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% Effect of Race  - n.s but main effect now p = 0.09
stats_r = glmfit_multilevel(Y3, X1_3, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
% Effect of Race - NO 
stats_r= glmfit_multilevel(Y4, X1_4, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');

for n = 1:size(stats,2); stats_t_slopes{n} = stats{n}.t(:,2); end
for n = 1:size(stats,2); stats_p_slopes{n} = stats{n}.p(:,2); end
%clear CovTest_Output
CovTest_Output(:,3) = vertcat(stats_t_slopes{:})
CovTest_Output(:,4) = vertcat(stats_p_slopes{:})

CovTest_table = table(CovTest_Output)
writetable(CovTest_table)

diary off

















