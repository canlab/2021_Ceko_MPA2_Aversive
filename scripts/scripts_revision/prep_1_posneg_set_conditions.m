%% Set up conditions 
% ------------------------------------------------------------------------

% conditions = {'C1' 'C2' 'C3' 'etc'};
% structural_wildcard = {'c1*nii' 'c2*nii' 'c3*nii' 'etc*nii'};
% functional_wildcard = {'fc1*nii' 'fc2*nii' 'fc3*nii' 'etc*nii'};
% colors = {'color1' 'color2' 'color3' etc}  One per condition

fprintf('Image data should be in /data folder\n');

DAT = struct();

DAT.subfolders =    {'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' ...
                    'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' ...
                    'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' ...
                    'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/' 'ExperienceSession/MPA2*/'};

                                               
% Names of conditions (see end of file for list of conditions as specified
% in 1st level DSGN.mat file

DAT.conditions = {'Exp_negvis_lv1' 'Exp_negvis_lv2' 'Exp_negvis_lv3' 'Exp_negvis_lv4'...
                  'Exp_posvis_lv1' 'Exp_posvis_lv2' 'Exp_posvis_lv3' 'Exp_posvis_lv4'  } % visual stimuli, IAPS

DAT.conditions = format_strings_for_legend(DAT.conditions);

DAT.structural_wildcard = {};

DAT.functional_wildcard =  {'beta_0013.img' 'beta_0014.img' 'beta_0015.img' 'beta_0016.img' ... %neg vis
                            'beta_0017.img' 'beta_0018.img' 'beta_0019.img' 'beta_0020.img'}; %pos vis


%% Set Contrasts
% ------------------------------------------------------------------------
% There are three ways to set up contrasts, which will be displayed as
% maps, run in SVM analyses (if contrast weights are 1 and -1), and used in
% signature and network analyses.
%
% 1. For within-person contrasts, where each individual has an
% image for each condition being compared, use DAT.contrasts, here.
% Important: You must have the same number of images in each condition
% being compared, and the images must be in the SAME SUBJECT ORDER.
% Contrasts are paired tests across these conditions.
% These contrasts should be used if condition is crossed with participant
% (i.e., within-subject design).
% These will be used in c2_SVM_contrasts.m
%
% 2. If your lists of images for each condition include participants from
% different groups, set up prep1b_...behavioral script, which creates
% DAT.BETWEENPERSON.group and group vectors for each condition and
% contrast. These will be used in c2b_SVM_betweenperson_contrasts.m
%
% 3. If conditions being compared include images for different subjects
% i.e., condition{1} and condition{2} include different individuals, 
% use DAT.between_condition_cons below. These contrasts should be used if 
% subjects are nested within conditions (i.e., between-subject design).
% These will be used in c2c_SVM_between_condition_contrasts.

% Vectors across conditions
DAT.contrasts = [ 1 1 1 1 0 0 0 0;  % main effects per mod
                  0 0 0 0 1 1 1 1; 
                  -3 -1 1 3 0 0 0 0; % linear increase per stim level
                  0 0 0 0 -3 -1 1 3;
                  1 1 1 1 -1 -1 -1 -1;
                  -3 -1 1 3 3 1 -1 -3]; % interaction
                     
                  
DAT.contrastnames = {'NegVis' 'PosVis' ...
                     'NegVisLin' 'PosVisLin' ...
                     'Neg_Pos' 'NegLin_PosLin'};

DAT.contrastnames = format_strings_for_legend(DAT.contrastnames);

% Set Colors
% ------------------------------------------------------------------------

% There are several options for defining colors for conditions and
% contrasts, or enter your own in a cell array of length(conditions) for
% DAT.colors, and size(contrasts, 1) for DAT.contrastcolors
% It is better if contrasts have distinct colors from conditions

% Some options: scn_standard_colors, custom_colors, colorcube_colors, seaborn_colors, bucknerlab_colors

% DAT.colors = scn_standard_colors(length(DAT.conditions));
% DAT.colors = custom_colors(cm(1, :), cm(end, :), length(DAT.conditions));
% DAT.contrastcolors = custom_colors([.2 .2 .8], [.2 .8 .2], length(DAT.contrasts));

mycolors = colorcube_colors(length(DAT.conditions) + size(DAT.contrasts, 1));

DAT.colors = mycolors(1:length(DAT.conditions));
DAT.contrastcolors = mycolors(length(DAT.conditions) + 1:length(mycolors));


disp('SET up conditions, colors, contrasts in DAT structure.');


% Set BETWEEN-CONDITION contrasts, names, and colors
% ------------------------------------------------------------------------
%    If conditions being compared include images for different subjects
%    i.e., condition{1} and condition{2} include different individuals, 
%    enter contrasts in DAT.between_condition_cons below.
%    These will be used in c2c_SVM_between_condition_contrasts.
%    You do not need to have the same number of images in each condition
%    being compared.
%    Contrasts are unpaired tests across these conditions.
%
% Matrix of [n contrasts x k conditions]

DAT.between_condition_cons = [];

DAT.between_condition_contrastnames = {};
          
DAT.between_condition_contrastcolors = custom_colors ([.2 .2 .8], [.2 .8 .2], size(DAT.between_condition_cons, 1));

% DSGN.conditions{1}{end+1} = 'EXP_cond1_L1_event2'; % stimulus_period pressure pain LV1  1
% DSGN.conditions{1}{end+1} = 'EXP_cond1_L2_event2'; % stimulus_period pressure pain LV2  2
% DSGN.conditions{1}{end+1} = 'EXP_cond1_L3_event2'; % stimulus_period pressure pain LV3  3
% DSGN.conditions{1}{end+1} = 'EXP_cond1_L4_event2'; % stimulus_period pressure pain LV4  4
% 
% DSGN.conditions{1}{end+1} = 'EXP_cond2_L1_event2'; % stimulus_period sound LV1  5
% DSGN.conditions{1}{end+1} = 'EXP_cond2_L2_event2'; % stimulus_period sound LV2  6
% DSGN.conditions{1}{end+1} = 'EXP_cond2_L3_event2'; % stimulus_period sound LV3  7
% DSGN.conditions{1}{end+1} = 'EXP_cond2_L4_event2'; % stimulus_period sound LV4  8
% 
% DSGN.conditions{1}{end+1} = 'EXP_cond3_L1_event2'; % stimulus_period heat pain LV1  9
% DSGN.conditions{1}{end+1} = 'EXP_cond3_L2_event2'; % stimulus_period heat pain LV2  10
% DSGN.conditions{1}{end+1} = 'EXP_cond3_L3_event2'; % stimulus_period heat pain LV3  11
% DSGN.conditions{1}{end+1} = 'EXP_cond3_L4_event2'; % stimulus_period heat pain LV4  12 
% 
% DSGN.conditions{1}{end+1} = 'EXP_cond4_L1_event2'; % stimulus_period neg_pic LV1  13
% DSGN.conditions{1}{end+1} = 'EXP_cond4_L2_event2'; % stimulus_period neg_pic LV2  14
% DSGN.conditions{1}{end+1} = 'EXP_cond4_L3_event2'; % stimulus_period neg_pic LV3  15
% DSGN.conditions{1}{end+1} = 'EXP_cond4_L4_event2'; % stimulus_period neg_pic LV4  16
% 
% DSGN.conditions{1}{end+1} = 'EXP_cond5_L1_event2'; % stimulus_period pos_pic LV1  17
% DSGN.conditions{1}{end+1} = 'EXP_cond5_L2_event2'; % stimulus_period pos_pic LV2  18
% DSGN.conditions{1}{end+1} = 'EXP_cond5_L3_event2'; % stimulus_period pos_pic LV3  19
% DSGN.conditions{1}{end+1} = 'EXP_cond5_L4_event2'; % stimulus_period pos_pic LV4  20

