%% Plots and stats 

% Self-report and stimulus intensity

%%
% caution> SEM! not STE 
% reorganize data in a better way 

% Summarize in one variable 
% ---------------------------------------------- % 
Mech=Pain_Avoid(:,1:4);
Therm=Pain_Avoid(:,5:8);
Aud=Pain_Avoid(:,9:12);
Vis=Pain_Avoid(:,13:16);

avoidance=[Mech Therm Aud Vis] 

x = 1:4; % levels   
y = [mean(Mech); mean(Therm); mean(Aud); mean(Vis)]
e = [ste(Mech); ste(Therm); ste(Aud); ste(Vis)]

%% pretty figure 
figtitle='Beh_rating_per_cond';
create_figure(figtitle);
subplot(4,6,1);
%set(gcf, 'Position', [1   512   268   194]);
% col = [240,59,32;
%       197,27,138]./255;
%   
colormod= [1 0.2 0.4;
            1 0.6 0.2;
            0 0.6 0.4;
            0 0.4 1];
markercol = colormod-.2;
markercol(markercol<0) = 0;


for i =1:4 % lines to plot
    h = errorbar(x, y(i,:), e(i,:), 'o', 'color', 'k', 'linewidth', 1, 'markersize', 6, 'markerfacecolor', colormod(i,:));
    hold on;
    sepplot(x, y(i,:), .75, 'linewidth', 1);
    sepplot(x, y(i,:), .75, 'color', colormod(i,:), 'linewidth', 1);
   % errorbar_width(h, x, [0 0]);
end

line([.5 5], [.06 .06], 'color', [.6 .6 .6], 'linewidth', 0.75, 'linestyle', '--');
line([.5 5], [.17 .17], 'color', [.6 .6 .6], 'linewidth', 0.75, 'linestyle', '--');
line([.5 5], [.35 .35], 'color', [.6 .6 .6], 'linewidth', 0.75, 'linestyle', '--');

set(gca, 'ylim', [0.15 .6], 'xlim', [.5 5],'XTick', 0:1:4, 'linewidth', 0.75, 'tickdir', 'out', 'ticklength', [.02 .02]);
set(gca, 'box', 'off');
%set(gcf, 'position', [1   442   338   264]);

xlabel(''); ylabel(''); set(gca, 'FontSize', 9);
plugin_save_figure


% %% Barplot columns & Stats
% % Barplots for all conds with lines 
% figtitle='intensity_all_barplots';
% create_figure(figtitle);
% namesconditions={'mech' 'therm' 'aud' 'vis'};
% barplot_columns(avoidance, 'nofig', 'names',namesconditions, 'dolines');
% set(gca, 'FontSize', 18);
% xlabel(''); ylabel('Pain Int');
% plugin_save_figure
% 
% plugin_save_figure

%% Stats on aversiveness ratings 
% 
for i = 1:55
    
    % avoidance rating
    Y1{i} = Mech(i, :)';
    Y2{i} = Therm(i, :)';
    Y3{i} = Aud(i, :)';
    Y4{i} = Vis(i, :)';
end

% stim intensity 
X1 = cellfun(@transpose,repmat({1:4},55,1),'UniformOutput', false)';

stats_mech=glmfit_multilevel(Y1, X1, [], 'names', {'Mech Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'boot', 'nresample', 10000, 'noplots');

stats_therm=glmfit_multilevel(Y2, X1, [], 'names', {'Therm Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'boot', 'nresample', 10000, 'noplots');

stats_sound=glmfit_multilevel(Y3, X1, [], 'names', {'Audi Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'boot', 'nresample', 10000, 'noplots');

stats_vis=glmfit_multilevel(Y4, X1, [], 'names', {'Vis Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'boot', 'nresample', 10000, 'noplots');

% same, but t-test
stats_mech=glmfit_multilevel(Y1, X1, [], 'names', {'Mech Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'ttest', 'nresample', 10000, 'noplots');

stats_therm=glmfit_multilevel(Y2, X1, [], 'names', {'Therm Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'ttest', 'nresample', 10000, 'noplots');

stats_sound=glmfit_multilevel(Y3, X1, [], 'names', {'Audi Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'ttest', 'nresample', 10000, 'noplots');

stats_vis=glmfit_multilevel(Y4, X1, [], 'names', {'Vis Rating' 'Stimlevel'}, ...
    'beta_names', {'Intercept', 'Eff of Stimlevel'}, ...
    'weighted', 'ttest', 'nresample', 10000, 'noplots');


% E.g., with one 2nd-level predictor:
% stats = glmfit_multilevel(Y, X1, X2, ...
% 'names', {'Int' 'Temp'}, 'beta_names', {'2nd-level Intercept (overall group effect)' '2nd-lev predictor: Group membership'});
%
%% Are reports matched across the stim levels of diff modalities? 

st = []
for m = 1:4
    st(:,:,m)=[Mech(:,m) Therm(:,m) Aud(:,m) Vis(:,m)];
    anovastats(m,:) = anova1(st(:,:,m));
end

% anovastats =
% 
%     0.0471
%     0.2396
%     0.0013
%     0.0000

% What happens if I remove Therm?
st = []
for m = 1:4
    st(:,:,m)=[Mech(:,m) Aud(:,m) Vis(:,m)];
    anovastats(m,:) = anova1(st(:,:,m));
end

% anovastats =
% 
%     0.0314
%     0.2752
%     0.2933
%     0.3258

%