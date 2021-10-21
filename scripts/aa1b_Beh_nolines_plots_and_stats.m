%% Plots and stats 

% Self-report and stimulus intensity

%%
% caution> SEM! not STE 
% reorganize data in a better way 

% import_Behav_MPA2.m
% Summarize in one variable 
% ---------------------------------------------- % 
Mech = Pain_Avoid (:,1:4);
Therm = Pain_Avoid (:,5:8);
Aud = Pain_Avoid (:,9:12);
Vis = Pain_Avoid (:,13:16);
avoidance=[Mech Therm Aud Vis] 

x = 1:4; % levels   
y = [mean(Mech); mean(Therm); mean(Aud); mean(Vis)]
e = [ste(Mech); ste(Therm); ste(Aud); ste(Vis)]

%% pretty figure 
figtitle='Beh_nolines_rating_per_cond';
create_figure(figtitle);
subplot(4,5,1);
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
    sepplot(x, y(i,:), .75, 'linewidth',1);
    sepplot(x, y(i,:), .75, 'color', colormod(i,:), 'linewidth', 1);
   % errorbar_width(h, x, [0 0]);
end
% 
% line([.5 5], [.06 .06], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');
% line([.5 5], [.17 .17], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');
% line([.5 5], [.35 .35], 'color', [.6 .6 .6], 'linewidth', 1, 'linestyle', '--');

set(gca, 'ylim', [0.15 0.6], 'xlim', [.5 4.5],'XTick', 0:1:4, 'YTick', 0.2:0.2:0.6, 'linewidth', 1, 'tickdir', 'out', 'ticklength', [.02 .02]);
set(gca, 'box', 'off');
%set(gcf, 'position', [1   442   338   264]);

xlabel(''); ylabel(''); set(gca, 'FontSize', 9);
plugin_save_figure

