## 2021_Ceko_MPA2_Aversive
## Neural architecture of negative affect: common and stimulus type-specific representations

### Summary and requirements 

This repository contains MATLAB code used to develop, evaluate and test in new individuals the common and stimulus-type specifc predictive brain models of negative affect, using 4 types of aversive stimuli (mechanical pain, thermal pain, aversive sound, aversive picture). 

- code runs ok on MATLAB 2019b
- code requires CANLAB core tools and a few other tools, all loaded using a2_mc_set_up_paths.m
- main inputs and outputs of these analyses are in the 'results' dir on Dropbox (for access, contact Marta at marta.ceko@gmail.com):
https://www.dropbox.com/sh/r0k5bj4zt5f2aeb/AAD3gZ0uQExQqU4037OWaYC3a?dl=0

        data_objects.mat contains 1st-level GLM beta images used for PLS 
        
        PLS_crossvalidated_N55_gm.mat contains stats related to cross-validated and full sample PLS model
        
        PLS_bootstats10000_N55_gm.mat contains bootstrapped stats 
        
        /patterns/PLS_CV_patterns contains CV image files (5 per model representing the 5 folds) for use in the same study sample
        
        /patterns/PLS_patterns contains full sample unthresholded pattern maps for use in independent samples 
        
        /patterns/PLS_patterns also contains bootstrapped unthr., unc01, unc001, and fdr-05 thresholded maps

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






