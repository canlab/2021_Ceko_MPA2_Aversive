signatures_to_plot = {'MechPLS' 'ThermPLS' 'AudiPLS' 'VisualPLS' 'GeneralPLS'};  % aversive stimuli
myscaling = 'raw';                                       % 'raw' or 'scaled'
mymetric = 'dotproduct';                                 % 'dotproduct' or 'cosine_sim'

diaryname = fullfile(resultsdir, ['aa_PLSsigs_conditions_' date '_output.txt']);
diary(diaryname);

plugin_PLS_signature_condition_contrast_plot_aversive


diary off
