% Create a predictive_model subclass of fmri_data 

% This script collects all relevant prediction outputs and adds them to the
% existing fmri_data object (DATA_OBJ)

% (1) load the fmri_data object containing fmri images 
% Note: see prep_1_set_conditions_contrasts_colors.m and
% prep_2_load_image_data_and_save.m for how to create fmri_data objects

% (2) load PLS outputs created in scripts/PLS_code_MPA/crossprediction_PLS.m 
% ratings 
% cross-validated models: 
%       fold niftis (5 folds per model, for 5 models) ===== NEED TO ADD  
%       cv stats: intercepts, beta weights (coefficients), dot prod, cosine sim
%       meta data incl. subject and fold info
% full models: 
%       full sample niftis  ===== NEED TO ADD  
%       full stats: intercepts, beta weights

% (3) load PLS model encoding stats created in scripts/scripts_modelencode/create_model_encoding_maps
% pls_encode_statimg
% pls_encode_statimg_fdr05
% pls_encode niftis ===== NEED TO ADD  


% (4) Integrate into one object


cd (scriptsdir) 

% Load fmri_data object with image data
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'data_objects.mat'));



% Load prediction outputs ---- this loads STATS only for now 
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));


% Load model encoding maps -- TODO: save smaller obj with relevant final
% outputs only --- pls_encoders --- then load that one instead 
% -------------------------------------------------------------------------
SR_resultsdir = fullfile (resultsdir, 'results_modelencode/results');

load(fullfile(SR_resultsdir, 'SR_out.mat'));
% mod_out_rob  --- 1st level structure coefficients per participant
% SR_obj -- 2nd level group maps 
% pls_encoders  -- t-tested group maps 
% It takes a hot minute to load, it is a large file!





