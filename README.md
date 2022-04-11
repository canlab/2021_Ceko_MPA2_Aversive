## Common and stimulus type-specific brain representations of negative affect
[[ ADD LINK TO PAPER WHEN ONLINE ]]

### Summary and requirements 

This repository contains MATLAB code used to develop, evaluate and test in new individuals 
the common and stimulus-type specifc predictive brain models of negative affect, 
using 4 types of aversive stimuli (mechanical pain, thermal pain, aversive sound, aversive pictures) 

- code tested on MATLAB 2019b
- code requires CANLAB core tools and a few other tools, all loaded using a2_mc_set_up_paths.m
(for access to private repos, please contact Marta at marta.ceko@gmail.com)

- input data for these analyses are on Dropbox (for access, contact Marta):
https://www.dropbox.com/sh/r0k5bj4zt5f2aeb/AAD3gZ0uQExQqU4037OWaYC3a?dl=0

        data/data_behavior/ -> excel spreadsheet containing ratings, loaded with import_Behav_MPA2.m
        
        results/data_objects.mat -> 1st-level GLM beta images used for PLS 
        
        results/PLS_crossvalidated_N55_gm.mat -> stats related to cross-validated and full sample PLS models
        
        results/PLS_bootstats10000_N55_gm.mat -> bootstrapped stats 
        
        results/patterns/PLS_CV_patterns -> CV image files (5 per model representing the 5 folds) for use within sample
        
        results/patterns/PLS_patterns -> full sample unthresholded pattern maps for use in independent samples 
        (these are the same maps as available in the public repo: Neuroimaging_Pattern_Masks/Multivariate_signature_patterns/2021_Ceko_MPA2_multiaversive)
        
        results/patterns/PLS_patterns ->  bootstrapped unthr., unc01, unc001, and fdr-05 thresholded maps

### Overview of code: 

#### Behavioral results (Fig. 2A)

#### Brain model development using Partial Least Squares (PLS) 

#### Model evaluation (Fig. 2B, 2C) 

#### Valence test (positive affect stimuli), Fig. 2D 

#### Variance decomposition (Fig. 2E)

#### Univariate maps (Suppl. Fig. 2A)

#### Model encoding maps (= structure coefficients) (Suppl. Fig. 2B) 

#### Core systems (Fig. 3A, 3B; Suppl. Fig. 3) 

#### Local (ROI) representation (Fig. 3C, 3D)

#### Common vs. type-specific importance (Fig. 3E)

####  Organization into pathways (Fig. 4)

#### Validation in independent samples (Fig. 5) 






