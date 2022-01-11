%% Import data from spreadsheet

%% Avoidance ---------------------------------------------------------
%% Import the data

[~, ~, raw] = xlsread(fullfile(behdatadir, 'MPA2_Masterlist_Final_N55.xlsx'),'Norm_raw','D2:E49');

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
Norm_scatter = data(:,1:end);

%% Clear temporary variables
clearvars data raw;

