%% Import data from spreadsheet

%% Avoidance ---------------------------------------------------------
%% Import the data
%[~, ~, raw] = xlsread('/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/Analysis/MPA2_EXP/scripts/PLS_code_MPA/MPA2_Masterlist_Final_N55.xlsx','Avoidance_exp_for_cross','B2:U56');

[~, ~, raw] = xlsread(fullfile(behdatadir, 'MPA2_Masterlist_Final_N55.xlsx'),'Avoidance_exp_for_cross','B2:U56');


% note: ratings in excel tab rearranged to match DAT.conditions order:
% 1) PRESSURE, 2) HEAT, 3) PAINSOUND, 4) NEGPIC, 5) POSPIC

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
%Pain_Avoid = data(:,1:end); % 20 columns (5 stim x 4 levels) 
Pain_Avoid = data(:,1:16);

%% Clear temporary variables
clearvars data raw;

