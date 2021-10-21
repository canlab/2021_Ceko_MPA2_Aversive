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

% NOTES:
% s56 is missing for two beta images
% moved into excluded folder

% Set up paths
% --------------------------------------------------------

% Base directory for whole study/analysis
%basedir = '/Users/marta/Google Drive/A_Multi_lab_world_map/Ceko_MPA2';
basedir = '/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/UNIV_analysis';
%basedir = '/Users/torwager/Dropbox (Dartmouth College)/A2_IN_PREP/2020_Ceko_MPA1_MPA2_PainMem_B_AVERSIVE/Analysis/MPA2_EXP';

origdatadir='/Users/marta/Google Drive/DATA_ANALYSIS/Ceko_MPA2/data/';
datadir = origdatadir

cd(basedir)

%datadir = fullfile(basedir, 'data');
resultsdir = fullfile(basedir, 'results');
scriptsdir = fullfile(basedir, 'scripts');
figsavedir = fullfile(resultsdir, 'figures');

diarydir=fullfile(resultsdir, 'diaries');

addpath(scriptsdir)

if ~exist(resultsdir, 'dir'), mkdir(resultsdir); end
if ~exist(figsavedir, 'dir'), mkdir(figsavedir); end
if ~exist(diarydir, 'dir'), mkdir(diarydir); end
% You may need this, but now should be in CANlab Private repository
% g = genpath('/Users/tor/Documents/matlab_code_external/spider');
% addpath(g)

% Display helper functions: Called by later scripts

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n**%s**\n%s\n', dashes, str, dashes);
