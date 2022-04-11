% THIS SCRIPT ADDS PATHS TO REPOS, SPM, USEFUL OTHER CODE

%% check for updates!
% in terminal
% cd /Applications/Canlab/
% git pull each repo

%% add Python interpreter - 3.5
% created a conda snake with python 3.5 env 
%addpath('/Anaconda3/envs/snakes/bin');

%% add repositories + help_examples
addpath(genpath('/Applications/Canlab/CanlabCore/'));
addpath(genpath('/Applications/Canlab/CANlab_help_examples/'));
%addpath(genpath('/Applications/Canlab/MasksPrivate/Masks_private'));
addpath(genpath('/Applications/Canlab/Neuroimaging_Pattern_Masks'));
addpath(genpath('/Applications/Canlab/MediationToolbox')); % for RB_empirical_bayes_params ...
%addpath(genpath('/Applications/Canlab/Canlab_MKDA_MetaAnalysis'));
addpath(genpath('/Applications/Canlab/ROI_masks_and_parcellations')); % copied from Tor's shared Gdrive folder
addpath(genpath('/Applications/Canlab/2017_kragel_mfc_generalizability_natneurosci/')); 
addpath(genpath('/Applications/Canlab/RobustToolbox/'));
%addpath(genpath('/Applications/aal')); 

%% also add 
% add Wani's core repo
addpath(genpath('/Applications/Canlab/cocoanCORE'));

% Wani's BIDS and preprocessing pipeline
addpath(genpath('/Applications/Canlab/humanfmri_preproc_bids'));

addpath(genpath('/Applications/Canlab/CanlabPrivate/'));
% Lukas 
addpath(genpath('/Applications/Canlab/proj-emosymp/'));

%%  Add ML workshop
addpath(genpath('/Applications/interpret_ml_neuroimaging'));

%% add anne urai's plotting tools
addpath(genpath('/Applications/Canlab/Tools'));

%% add gm mask
masksdir = fullfile(basedir, 'masks');
addpath (genpath(masksdir))
which ('gm_mask.nii');

%% add modified scripts
% 
% modcanlabdir = fullfile(scriptsdir, 'modified_canlabcore_scripts');
% addpath (genpath(modcanlabdir))
% 
% which load_image_set
% fprintf ('FOR NOW USE OWN VERSION - THIS ONE LOADS PLS SIGS! %/n');
% 
% which plugin_save_figure
% fprintf ('IT PROBABLY DOES NOT SAVE PNG SO ENFORCE BELOW %/n');
% %edit plugin_save_figure.m
% f_ext='.png';

%% for masked contrasts 
%% add ROI masks 
addpath(genpath('/Users/marta/Google Drive/ROI_masks_and_parcellations/'));
% addpath(genpath('/Users/martaceko/Downloads/ROI_masks_and_parcellations/Parcellation_images_for_studies'));

%% add spm12
% BUT NOT WITH SUBFOLDERS!
% for now, add spm12 version depending on matlab version

if version('-release') == '2019a';
   addpath /Applications/spm12 
elseif version('-release') ~= '2019a';
   addpath /Applications/Canlab/spm12  % currently canlab-spm12 not functional; wrong MEX file?
end

fprintf ('Which spm am I running? \n');
which spm

%% add wfupickatlas: 
% addpath /Applications/Canlab/spm12/toolbox/wfu_pickatlas;
% which wfu_pickatlas

%% check that jsondecode is on path (MATLAB 2016B and later) 
which jsondecode
%built-in (/Applications/MATLAB_R2016b.app/toolbox/matlab/external/interfaces/json/jsondecode)
which imrect
%/Applications/MATLAB_R2016b.app/toolbox/images/imuitools/imrect.m  % imrect constructor

% use default nanvar if spm's throws an error (but should be fine wih spm 12) 
%addpath /Applications/MATLAB_R2015b.app/toolbox/stats/stats/

