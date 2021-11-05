% Create a predictive_model subclass of fmri_data 

% This script collects all relevant prediction outputs and adds them to the
% existing fmri_data object (DATA_OBJ)

% (1) load the fmri_data object containing fmri images 
% Note: see prep_1_set_conditions_contrasts_colors.m and
% prep_2_load_image_data_and_save.m for for how to create fmri_data objects

% (2) load PLS outputs created in crossprediction_PLS.m 
% ratings 
% cross-validated models: 
%       fold images (5 folds per model, for 5 models) ===== NEED TO ADD  
%       cv stats: intercepts, beta weights (coefficients), dot prod, cosine sim
%       meta data incl. subject and fold info
% full models: 
%       full sample images ===== NEED TO ADD  
%       full stats: intercepts, beta weights

% (3) load PLS model encoding maps     ===== NEED TO ADD  


% (4) Integrate into one object


cd (scriptsdir) 


% Load fmri_data object with image data
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'data_objects.mat'));


% Load prediction outputs ---- this loads STATS only for now 
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));


% Load model encoding maps 
% -------------------------------------------------------------------------






