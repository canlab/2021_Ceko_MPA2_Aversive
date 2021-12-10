% Test aversive PLS patterns on additional pleasant datasets

% (1) CHOCOLATE TASTE, GENTLE TOUCH: Soo Ahn Lee & Wani Woo, Cocoanlab
%     - positive (chocolate, light touch)
%     - negative (quinine, capsaicin)  - General might respond = additional validation
% test General, (Mechanical)

% (2) WARM, FRIEND : Kohoutova ML workshop data 
%     - non-negative: warmth
%     - positive: social - friend
%     - negative: heat
%     - negative: social - rejection

% (3) VISUAL: Wehrum et al. 2013 
%     - high arousal (sexual images)
%     -low arousal (non-sexual pleasant images)
%     - no arousal neutral control? 
% test General, Visual

% (4) VISUAL: Kim et al. XXXX
%     - positive / negative // low / high
% Test General, Visual  -- both might respond to neg = additional validation
% need to run 1st level

% (5) AUDITORY: Lepping et al. 2016
%     - positive / negative music
%     - positive / negative non-music
% Test General, (Audi)  -- General might respond to neg = additional validation

%     

%% TASTE, TOUCH: Soo Ahn Lee & Wani Woo, Cocoanlab

% load data 
% -------------------------------------------------------------------------
load('/Users/marta/Documents/DATA/MPA2/34bin_beta/betadat_34bin_58subjs.mat');

% data description
% -------------------------------------------------------------------------
% betadat_34bin: 
% each run (cap, choc, quin, touch) lasts 14.5 mins
% each run is divided into 34 bins, each bin is 25 seconds (34 x 25 = 850 seconds = 14.17 mins) 
% stimulation starts at bin 4 and bin 17

% stimulus durations:
% cap   - 90 sec  --> 90/25 = ca. 3.5 bins
% choc  - 180 sec --> 180/25 = ca. 7 bins
% quin  - 90 (email pic) or 120 (email text)?  checking ...
% touch - 180 sec --> 180/25 = ca. 7 bins

% whfolds: 
% size = 1972 = 58 participants x 35 bins

% analysis 
% -------------------------------------------------------------------------

% apply_sigs
% plot_sigs


