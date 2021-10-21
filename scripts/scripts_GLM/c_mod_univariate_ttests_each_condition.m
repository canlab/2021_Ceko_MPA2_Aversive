
% T-tests for each condition separately
% ------------------------------------------------------------------------

k = length(DATA_OBJ);
t = cell(1, k);

for i = 1:k
    
    t{i} = ttest(DATA_OBJ{i});
    t{i} = threshold(t{i}, .001, 'unc');
    
end

o2 = canlab_results_fmridisplay([], 'multirow', length(DATA_OBJ));

for i = 1:k
    
    o2 = addblobs(o2, region(t{i}), 'wh_montages', [2*i-1:2*i]);
    o2 = title_montage(o2, 2*i, DAT.conditions{i});
    
%     figtitle = sprintf('%s_001_unc', DAT.contrastnames{i});
%     fighan = activate_figures(o2); % Find and activate figure associated with existing fmridisplay object o2
%     if ~isempty(fighan)
%         set(fighan{1}, 'Tag', figtitle);
%         plugin_save_figure;             % re-activate the slice montage figure for saving, name, and save
%     else
%         disp('Cannot find figure - Tag field was not set or figure was closed. Skipping save operation.');
%     end
    
end
