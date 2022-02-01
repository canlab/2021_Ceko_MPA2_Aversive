%% Import data from spreadsheet

%% Avoidance ---------------------------------------------------------
%% Import the data

[~, ~, raw] = xlsread(fullfile(behdatadir, 'MPA2_Masterlist_Final_N55.xlsx'),'FINAL','B2:G56');


%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Covars = data(:,1:end);

%% Clear temporary variables
clearvars data raw;

