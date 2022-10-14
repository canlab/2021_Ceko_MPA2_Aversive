## Common and stimulus-type-specific brain representations of negative affect

### Summary and requirements 

This repository contains code and data related to [Ceko et al. 2022](https://www.nature.com/articles/s41593-022-01082-w) to develop, evaluate and validate in new individuals 
common and stimulus-type specifc predictive brain models of negative affect, using 4 types of aversive stimuli (mechanical pain, thermal pain, aversive sound, aversive pictures) 

- code tested on MATLAB 2019b
- code requires CANLAB core tools and a few other tools, all loaded using a2_mc_set_up_paths.m

- code is in /scripts, unless otherwise noted

- [Full sample unthresholded PLS pattern maps for use in independent samples](https://github.com/canlab/Neuroimaging_Pattern_Masks/tree/master/Multivariate_signature_patterns/2021_Ceko_MPA2_multiaversive)

- input data for some of the analyses is on Dropbox (to discuss access, contact Marta at marta.ceko@gmail.com):
  - data/data_behavior/ -> excel spreadsheet containing ratings, loaded with import_Behav_MPA2.m
        [Dropbox Link](https://www.dropbox.com/s/ddwxxm5tmjqbqsk/MPA2_Masterlist_Final_N55.xlsx?dl=0)
        
- results/ 
  - [Dropbox Link](https://www.dropbox.com/sh/r0k5bj4zt5f2aeb/AAD3gZ0uQExQqU4037OWaYC3a?dl=0)
        results/data_objects.mat -> 1st-level GLM beta images used for PLS 
        
        results/PLS_crossvalidated_N55_gm.mat -> stats related to cross-validated and full sample PLS models
        
        results/PLS_bootstats10000_N55_gm.mat -> bootstrapped stats 
        
        results/patterns/PLS_CV_patterns -> CV image files (5 per model representing the 5 folds) for use within sample
        
        results/patterns/PLS_patterns -> Full sample bootstr. PLS pattern maps - like the link above but with more options: unthr, unc01, unc001,fdr-05)

### Overview of main code to create Figures (/scripts): 

#### Figure 2

- Fig2a_behavior_plots.m
- Fig2b .... Model evaluation
  - cleaning up ...
- Fig2c .... Crosspred matrix
  - cleaning up ...
- Fig2d .... Variance decomposition
  - cleaning up ...

#### Figure 3

- Fig3a3b_display_maps.m
- Fig3c3d_riverplots_roi.m

#### Figure 4

- Fig4_plot_figure_architecture.m

#### Figure 5 

- Fig5 ..... Validation in independent samples
  - cleaning up ....

#### Figure 6

- Fig6a .. positive stimuli Study1
  - cleaning up ....
- scripts2/Fig6b_plot_ind_datasets_Warm_Wehrum.m
- scripts2/Fig6c_summary_performance.m

#### Extended Data Figure 1  
- scripts2/EDFig1b_plot_normPLS_signatures.m
- scripts2/EDFig1c_display_maps.m
- scripts2/EDFig1d_roiplots_univariate.m
- scripts2/EDFig1d1e_roiplots_and_3D_encoders.m







