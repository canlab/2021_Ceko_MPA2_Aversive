%% Import data from spreadsheet

%% Avoidance ---------------------------------------------------------
%% Import the data

[~, ~, raw] = xlsread(fullfile(behdatadir, 'MPA2_Masterlist_Final_N55.xlsx'),'Norm_ratings_unflipped','B2:I56');

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
%Pain_Avoid = data(:,1:end); % 20 columns (5 stim x 4 levels) 
Norm_posneg = data(:,1:end);

%% Clear temporary variables
clearvars data raw;

