% Set options used in various core scripts
% --------------------------------------------------------------------
%
% You can change these values on your local computer, but do not commit the
% changed version to the repository.

% prep_2_load_image_data_and_save options  (also prep_3_calc_univariate_contrast_maps_and_save)
% --------------------------------------------------------------------
dofullplot = false;         % default true  Can set to false to save time
omit_histograms = true;     % default false Histograms not useful for large samples 
dozipimages = true;        % default true  Set to false to avoid load on data upload/download when re-running often

% prep_3a_run_second_level_regression_and_save options 
% --------------------------------------------------------------------
dorobust = true;            % robust statistics [true, false] -- default true
myscaling = 'raw';          % 'raw' or 'scaled'

% prep_3b_run_SVMs_on_contrasts_and_save options 
% --------------------------------------------------------------------
dosubjectnorm = false;      % default false     normalize_each_subject_by_l2norm; can help with numerical scaling and inter-subject scaling diffs
dosavesvmstats = true;      % default true      Save statistics and weight map objects for SVM contrasts
dobootstrap = false;         % default false     Takes a lot of time
boot_n = 5000;              % default number of bootstrap samples. Very slow. Recommend 5,000 for final published analysis
parallelstr = 'parallel';   % parallel proc for boot. 'parallel' or 'noparallel'


% prep_3c_run_SVMs_on_contrasts_masked options 
% --------------------------------------------------------------------
% Improved GM mask (Kragel)

maskdir = fullfile(basedir, 'masks');
gm_mask = fullfile(maskdir, 'gm_mask.nii');

% Also uses these from above
% dosavesvmstats = true;      % default true      Save statistics and weight map objects for SVM contrasts
% dobootstrap = false;         % default false     Takes a lot of time
% boot_n = 1000;              % default number of bootstrap samples. Very slow. Recommend 5,000 for final published analysis
% parallelstr = 'noparallel';   % parallel proc for boot. 'parallel' or 'noparallel'
