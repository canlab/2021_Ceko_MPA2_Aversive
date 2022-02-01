%% Apply PLS signatures and save
%
% This script extracts signature responses and saves them
%
% signaturenames is any of those from load_image_set('npsplus') (data scaling) is 'raw' or 'scaled', using DATA_OBJ or DATA_OBJsc
% (similarity metric) is 'dotproduct' or 'cosine_sim'
% 
% Each of by_condition and contrasts contains a data table whose columns are conditions or contrasts, with variable names based on DAT.conditions
% or DAT.contrastnames, but with spaces replaced with underscores.

%% Prep & Notes to self

% a_set_up_paths_always_run_first
b_reload_saved_matfiles
% If the load_image_set.m in this folder is not on the path: 
% rerun a2_mc_set_up_paths.m

% add signatures to load_image_set as needed 


%% Apply to main effects (4 stim modalities) 
% Choose subset of conditions 
k = length(DAT.conditions) % conditions are 4 modalities x 4 stim intensities

% All Signatures

printhdr('Extracting all signatures');

% Dot product metric
DAT.SIG_conditions.raw.dotproduct = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions, 'image_set', 'multiaversive');
DAT.SIG_contrasts.raw.dotproduct = apply_all_signatures(DATA_OBJ_CON, 'conditionnames', DAT.contrastnames, 'image_set', 'multiaversive');

% Cosine similarity
DAT.SIG_conditions.raw.cosine_sim = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions, 'similarity_metric', 'cosine_similarity', 'image_set', 'multiaversive');
DAT.SIG_contrasts.raw.cosine_sim = apply_all_signatures(DATA_OBJ_CON, 'conditionnames', DAT.contrastnames, 'similarity_metric', 'cosine_similarity', 'image_set', 'multiaversive');

% Scaled images.  
% apply_all_signatures will do scaling as well, but we did this in image
% loading, so use those here

% % Dot product metric
% DAT.SIG_AVPLS_conditions.scaled.dotproduct = apply_all_signatures(DATA_OBJsc, 'conditionnames', DAT.conditions, 'image_set', 'aversive_pls');
% DAT.SIG_AVPLS_contrasts.scaled.dotproduct = apply_all_signatures(DATA_OBJ_CONsc, 'conditionnames', DAT.contrastnames, 'image_set', 'aversive_pls');
% 
% % Cosine similarity
% DAT.SIG_AVPLS_conditions.scaled.cosine_sim = apply_all_signatures(DATA_OBJsc, 'conditionnames', DAT.conditions, 'similarity_metric', 'cosine_similarity', 'image_set', 'aversive_pls');
% DAT.SIG_AVPLS_contrasts.scaled.cosine_sim = apply_all_signatures(DATA_OBJ_CONsc, 'conditionnames', DAT.contrastnames, 'similarity_metric', 'cosine_similarity', 'image_set', 'aversive_pls');
% 


% Save

printhdr('Save results');

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
save(savefilename, 'DAT', '-append');


