% NOTES:
% - standard folders and variable names are created by this script
%
% - in "prep_" scripts: 
%   image names, conditions, contrasts, colors, global gray/white/CSF
%   values are saved automatically in a DAT structure
% 
% - extracted fmri_data objects are saved in DATA_OBJ variables
% - contrasts are estimated and saved in DATA_OBJ_CON variables
%
% - files with these variables are saved and loaded automatically when you
%   run the scripts
%   meta-data saved in image_names_and_setup.mat
%   image data saved in data_objects.mat
%
% - you only need to run the prep_ scripts once.  After that, use 
%   b_reload_saved_matfiles.m to re-load saved files
% 
% - when all scripts working properly, run z_batch_publish_analyses.m
%   to create html report.  customize by editing z_batch_list_to_publish.m
%
% - saved in results folder:
%   figures
%   html report with figures and stats, in "published_output"

% Set up paths
% --------------------------------------------------------

% Base directory for whole study/analysis
% %basedir = '/Users/marta/Google Drive/A_Multi_lab_world_map/Ceko_MPA2';
basedir = '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/';

scriptsdir = '/Applications/Canlab/2021_Ceko_MPA2_Aversive/scripts';

scriptsrevdir = '/Applications/Canlab/2021_Ceko_MPA2_Aversive/scripts/scripts_revision';

datadir = '/Users/marta/Documents/DATA/MPA2/';

% collaborative: 
% behdatadir = '/Users/marta/Documents/DATA/MPA2/Behavior/data_behavior';
behdatadir = fullfile(basedir, 'data/data_behavior');

resultsdir = fullfile(basedir, 'results');
resultsrevdir = fullfile(basedir, 'results_revision');

figsavedir = fullfile(resultsdir, 'figures');

cd(scriptsdir)

% Display helper functions: Called by later scripts

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n**%s**\n%s\n', dashes, str, dashes);
