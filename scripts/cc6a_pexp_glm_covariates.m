
%% PLS brain patterns (as included in the load_image_set)
% For now, make sure you use this load_image_set version: 
% /Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/scripts/modified_canlabcore_scripts/load_image_set.m
% (will commit to common repo when results are final) 

GenS   = which('General_b10000_unthr.nii')
MechS  = which('Mechanical_b10000_unthr.nii')
ThermS = which('Thermal_b10000_unthr.nii')
AudiS  = which('Sound_b10000_unthr.nii')
VisS   = which('Visual_b10000_unthr.nii')

%% Load data 

% Import 
load(fullfile(resultsdir, 'image_names_and_setup.mat'));

% Import behavior
import_Behav_MPA2;

% Import covariates 
import_Covars_MPA2;
% Gender 1/-1
% Age (demeaned) 
% Hand 1/-1
% Race 1/-1 (white /non-white)
% SessOrder (1/-1) 

%% Test effect of covariates on GenS response 

% Prep GenS
pexpm_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,1:4));
pexpt_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,5:8));
pexpa_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,9:12));
pexpv_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.GenS(:,13:16));
% Prep ratings 
mechrat=Pain_Avoid(:,1:4);
thermrat=Pain_Avoid(:,5:8);
audrat=Pain_Avoid(:,9:12);
visrat=Pain_Avoid(:,13:16);

% Restructure for GLM
N = size(pexpm_GenS, 1);
for i = 1:N
    
    % sig response
    X1_1{i} = pexpm_GenS(i, :)';
    X1_2{i} = pexpt_GenS(i, :)';
    X1_3{i} = pexpa_GenS(i, :)';
    X1_4{i} = pexpv_GenS(i, :)';

    % avoidance rating
    Y1{i} = mechrat(i, :)';
    Y2{i} = thermrat(i, :)';
    Y3{i} = audrat(i, :)';
    Y4{i} = visrat(i, :)';
end
X2 = Covars_Avoid;

% Sig response pure, no covariates (just double-checking) 
stats = glmfit_multilevel(Y1, X1_1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% mech:  p	0.00000	0.00010	
stats = glmfit_multilevel(Y2, X1_2, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% therm p	0.00000	0.00000		
stats = glmfit_multilevel(Y3, X1_3, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% aud p	0.00000	0.00012	
stats = glmfit_multilevel(Y4, X1_4, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% vis p	0.00000	0.00000	

% Effect of covariates on predicting Y
% GenS on mechanical pain 
% --------------------------------------------------------------------------
% All covs in the model:
% - each cov n.s.
% Sig Response: p	0.00009	0.05238	

fprintf ('GenS on MECH \n');
stats = glmfit_multilevel(Y1, X1_1, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

% Effect of each covariate separately (all Sig Resp significant) 
stats = glmfit_multilevel(Y1, X1_1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Gender'}, 'weighted');

stats = glmfit_multilevel(Y1, X1_1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Age'}, 'weighted');

stats = glmfit_multilevel(Y1, X1_1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');

stats = glmfit_multilevel(Y1, X1_1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'Race'}, 'weighted');
 
stats = glmfit_multilevel(Y1, X1_1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'},'beta_names', {'X2 Intercept' 'SessOrder'}, 'weighted');


% GenS on thermal pain 
% --------------------------------------------------------------------------
% All covs in the model:
% - each cov n.s.
% Sig Response: p	0.00135	0.00001	

fprintf ('GenS on THERM \n');
stats = glmfit_multilevel(Y2, X1_2, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

% GenS on auditory
% --------------------------------------------------------------------------
% All covs in the model:
% - each cov n.s.
% Sig Response: p	0.00000	0.00977	

fprintf ('GenS on AUD \n');
stats = glmfit_multilevel(Y3, X1_3, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

% GenS on visual 
% --------------------------------------------------------------------------
% All covs in the model:
% - each cov n.s.
% Sig Response: p	0.00000	0.00000 

fprintf ('GenS on VIS \n');
stats = glmfit_multilevel(Y4, X1_4, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');


%% MechS GLM w/ covariates  - sth is weird here

%% MechS signature 
pexpm_MechS = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,1:4));

clear mechrat 
mechrat=Pain_Avoid(:,1:4);

fprintf ('MechS \n')


N = size(pexpm_MechS, 1);
for i = 1:N
    
    % sig response
    X1{i} = pexpm_MechS(i, :)';

    % avoidance rating
    Y{i} = mechrat(i, :)';

end
X2 = Covars_Avoid;

% Sig response of Y 
stats = glmfit_multilevel(Y, X1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');

% what the hell? I guess I see a steeper slope than it actually is
% (Fig 3, plot 2)
% Second Level of Multilevel Model 
% 	Outcome variables:
% 	Sig Resp Intercept	Sig Resp Slope	
% Adj. mean	0.13	0.77	
% 
% 2nd-level B01
% 	Sig Resp Intercept	Sig Resp Slope	
% Coeff	0.13	0.77	
% STE	0.06	0.63	
% t	2.19	1.23	
% Z	1.99	1.17	
% p	0.04705	0.24324	


% Effect of covariates on predicting Y
% -------------------------------------------------------------------------
% All covs in the model:
% Sig Response: p	0.09877	0.93603	

fprintf ('MechS on MECH');
stats = glmfit_multilevel(Y, X1, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');


% Separate models for each cov 
fprintf ('MechS on MECH \n');
stats = glmfit_multilevel(Y, X1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender'}, 'weighted'); 

% Cov >0.05, Sig <0.05
stats = glmfit_multilevel(Y, X1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept''Age'}, 'weighted');

% Cov >0.05, Sig also >0.05
stats = glmfit_multilevel(Y, X1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Hand'}, 'weighted');

% Cov >0.05, Sig <0.05
fprintf ('MechS on MECH \n');
stats = glmfit_multilevel(Y, X1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Race'}, 'weighted');

% Cov >0.05, Sig <0.05
fprintf ('MechS on MECH \n');
stats = glmfit_multilevel(Y, X1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'SessOrder'}, 'weighted');
	

%% Therm GLM w/ covariates
pexpt_ThermS = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,5:8));

N = size(pexpt_ThermS, 1);
for i = 1:N
    
    % sig response
    X1{i} = pexpt_ThermS(i, :)';

    % avoidance rating
    Y{i} = thermrat(i, :)';

end
X2 = Covars_Avoid;

% Sig response of Y 
stats = glmfit_multilevel(Y, X1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% p	0.00000	0.00000	

% Effect of covariates on predicting Y
% all covs in model: p=0.11 sig response
% each cov separate model: sig significant, each cov n.s. 
% --- but see weird behavior with age 

fprintf ('ThermS on THERM');
stats = glmfit_multilevel(Y, X1, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Gender' }, 'weighted');
  
stats = glmfit_multilevel(Y, X1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Age' }, 'weighted');
% % weird -b/c of negative slope?
% X2 Intercept
% 	X1 Intercept	Sig Resp Slope	
% Coeff	0.10	4.05	
% STE	0.13	2.05	
% t	0.79	1.98	
% Z	0.78	1.92	
% p	0.43394	0.05475	
% 
% Age
% 	X1 Intercept	Sig Resp Slope	
% Coeff	0.00	-0.01	
% STE	0.01	0.08	
% t	0.26	-0.06	
% Z	0.26	-0.06	
% p	0.79464	0.94850	
 
stats = glmfit_multilevel(Y, X1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Hand' }, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Race' }, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'SessOrder' }, 'weighted');


%% Aud GLM w/ covariates
pexpa_AudS = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,9:12));

N = size(pexpa_AudS, 1);
for i = 1:N
    
    % sig response
    X1{i} = pexpa_AudS(i, :)';

    % avoidance rating
    Y{i} = audrat(i, :)';

end
X2 = Covars_Avoid;

% Sig response of Y 
stats = glmfit_multilevel(Y, X1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
%p	0.00073	0.00291	

% Effect of covariates on predicting Y
% all covs in model: age almost (p=0.06), sig response n.s.
% covs in separate models: each cov n.s. except age, see below

fprintf ('AudS on AUD \n');
stats = glmfit_multilevel(Y, X1, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,1), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Gender' }, 'weighted');

% age: p=0.04, sig resp = 0.26
stats = glmfit_multilevel(Y, X1, X2(:,2), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Age' }, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,3), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Hand' }, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,4), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'Race' }, 'weighted');

stats = glmfit_multilevel(Y, X1, X2(:,5), ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, 'beta_names', {'X2 Intercept' 'SessOrder' }, 'weighted');


%% Vis GLM w/ covariates
pexpv_VisS = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,13:16));

N = size(pexpv_VisS , 1);
for i = 1:N
    
    % sig response
    X1{i} = pexpv_VisS (i, :)';

    % avoidance rating
    Y{i} = visrat(i, :)';

end
X2 = Covars_Avoid;

% Sig response of Y 
stats = glmfit_multilevel(Y, X1, [], 'names', {'Sig Resp Intercept' 'Sig Resp Slope'},'weighted');
% p	0.54898	0.00000	
	
% Effect of covariates on predicting Y
% all covs in model:  sig response significant, each cov n.s.

fprintf ('VisS on AUD \n');
stats = glmfit_multilevel(Y, X1, X2, ...
  'names', {'X1 Intercept' 'Sig Resp Slope'}, ...
  'beta_names', {'X2 Intercept' 'Gender' 'Age' 'Hand' 'Race' 'SessOrder'}, 'weighted');

