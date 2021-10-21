% load data
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));


%% Calculate accuracy between levels

% figtitle=sprintf('Plot_PEXPdotpr_avgline_per_model_Study1');
% create_figure(figtitle)

% GenS signature 
% overall performs worse between consecutive levels for auditory and
% visual, comparable for mechanical, a bit better for thermal
% than modality-specific signatures

gen_m = pexp_xval_dp (1:220,1);
gen_m = reshape (gen_m, 55, 4);
gen_t = pexp_xval_dp (221:440,1);
gen_t = reshape (gen_t, 55, 4);
gen_a = pexp_xval_dp (441:660,1);
gen_a = reshape (gen_a, 55, 4);
gen_v = pexp_xval_dp (661:880,1);
gen_v = reshape (gen_v, 55, 4);

gen_m = yhat (1:220,1);
gen_m = reshape (gen_m, 55, 4);
gen_t = yhat (221:440,1);
gen_t = reshape (gen_t, 55, 4);
gen_a = yhat(441:660,1);
gen_a = reshape (gen_a, 55, 4);
gen_v = yhat (661:880,1);
gen_v = reshape (gen_v, 55, 4);

% 
roc_gen_m_L41 = roc_plot([gen_m(:,4); gen_m(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');
roc_gen_t_L41 = roc_plot([gen_t(:,4); gen_t(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');
roc_gen_a_L41 = roc_plot([gen_a(:,4); gen_a(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');
roc_gen_v_L41 = roc_plot([gen_v(:,4); gen_v(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');

% % between levels 
% roc_gen_m_L21 = roc_plot([gen_m(:,2); gen_m(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 55, p = 0.6
% roc_gen_m_L32 = roc_plot([gen_m(:,3); gen_m(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 51, p = 1
% roc_gen_m_L43 = roc_plot([gen_m(:,4); gen_m(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 65, p = 0.03
% 
% roc_gen_t_L21 = roc_plot([gen_t(:,2); gen_t(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 75, p = 0.003
% roc_gen_t_L32 = roc_plot([gen_t(:,3); gen_t(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 78, p < 0.001
% roc_gen_t_L43 = roc_plot([gen_t(:,4); gen_t(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 73, p = 0.001
% 
% roc_gen_a_L21 = roc_plot([gen_a(:,2); gen_a(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 60, p = 0.17
% roc_gen_a_L32 = roc_plot([gen_a(:,3); gen_a(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 49, p = 1
% roc_gen_a_L43 = roc_plot([gen_a(:,4); gen_a(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 55, p = 0.6
% 
% roc_gen_v_L21 = roc_plot([gen_v(:,2); gen_v(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 62, p = 0.1
% roc_gen_v_L32 = roc_plot([gen_v(:,3); gen_v(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 67, p = 0.01
% roc_gen_v_L43 = roc_plot([gen_v(:,4); gen_v(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 60, p = 0.17


% MechS
mech = pexp_xval_dp (1:220,2);
mech = reshape (mech, 55, 4);

roc_mech_L41 = roc_plot([mech(:,4); mech(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');  % Accuracy:	 65% +- 6.4% (SE), P = 0.030029

% roc_mech_L21 = roc_plot([mech(:,2); mech(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 53, p = 0.79
% roc_mech_L32 = roc_plot([mech(:,3); mech(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 64, p = 0.06
% roc_mech_L43 = roc_plot([mech(:,4); mech(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 58, p = 0.28

%% doublecheck that it is the same with yhat 
mech = yhat (1:220,2);
mech = reshape (mech, 55, 4);

roc_mech_L41 = roc_plot([mech(:,4); mech(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % Accuracy:	 65% +- 6.4% (SE), P = 0.030029


% ThermS
therm = pexp_xval_dp (221:440,3);
therm = reshape (therm, 55, 4);

roc_therm_L41 = roc_plot([therm(:,4); therm(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');

% roc_therm_L21 = roc_plot([therm(:,2); therm(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 85, p < 0.001
% roc_therm_L32 = roc_plot([therm(:,3); therm(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 67, p = 0.01
% roc_therm_L43 = roc_plot([therm(:,4); therm(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 73, p = 0.001

% AudiS
audi = pexp_xval_dp (441:660,4);
audi = reshape (audi, 55, 4);

roc_audi_L41 = roc_plot([audi(:,4); audi(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');

roc_audi_L21 = roc_plot([audi(:,2); audi(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 58, p = 0.28
roc_audi_L32 = roc_plot([audi(:,3); audi(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 55, p = 0.59
roc_audi_L43 = roc_plot([audi(:,4); audi(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 67, p = 0.01


% VisS
vis = pexp_xval_dp (661:880,5);
vis = reshape (vis, 55, 4);

roc_vis_L41 = roc_plot([vis(:,4); vis(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot');

% roc_vis_L21 = roc_plot([vis(:,2); vis(:,1)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 84, p < 0.001
% roc_vis_L32 = roc_plot([vis(:,3); vis(:,2)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 75, p = 0.003
% roc_vis_L43 = roc_plot([vis(:,4); vis(:,3)], [true(55,1);false(55,1)], 'twochoice', 'noplot'); % 47, p = 0.79

% just to DC: basically the same result when using yhat  
