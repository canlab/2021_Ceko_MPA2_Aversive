
% Set up paths
% --------------------------------------------------------

% Base directory for whole study/analysis
basedir = '/Users/mace2098/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/';

scriptsdir = '/Applications/Canlab/2021_Ceko_MPA2_Aversive/scripts';

scriptsrevdir = '/Applications/Canlab/2021_Ceko_MPA2_Aversive/scripts/scripts2';

datadir = '/Users/mace2098/Documents/DATA/MPA2/';

behdatadir = fullfile(basedir, 'data/data_behavior');

resultsdir = fullfile(basedir, 'results');
resultsrevdir = fullfile(resultsdir, 'results_revision');

figsavedir = fullfile(resultsdir, 'figures');

% other
qcdir = fullfile(resultsdir, 'qc');
qcfigsavedir = fullfile (qcdir,'figures');
dataobjdir = fullfile(resultsdir, 'results_GLM');

cd(scriptsdir)

% Display helper functions: Called by later scripts

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n**%s**\n%s\n', dashes, str, dashes);
