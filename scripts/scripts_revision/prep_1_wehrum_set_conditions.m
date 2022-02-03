%% Set up conditions 
% ------------------------------------------------------------------------
datadir = '/Users/marta/Documents/DATA/MPA2/Study1_Wehrum_2013_Sexual'

DAT = struct();

DAT.subfolders =    {'0137sw-*spmmatdir' '0137sw-*spmmatdir' '0137sw-*spmmatdir' '0137sw-*spmmatdir'};
                                              
DAT.conditions = {'positive' 'negative' 'neutral' 'sexual'}

DAT.conditions = format_strings_for_legend(DAT.conditions);

DAT.structural_wildcard = {};

DAT.functional_wildcard =  {'con_0001.img*' 'con_0002.img*' 'con_0003.img*' 'con_0004.img*'}; 


%% Set Contrasts
% ------------------------------------------------------------------------
DAT.contrasts = [0 1 -1 0; % Neg min Neutral
                 1 0 -1 0; % Pos min Neutral
                 0 0 -1 1]; % Sex min Neutral
          
DAT.contrastnames = {'NegMinNeut' 'PosMinNeut' 'SexMinNeut'};

DAT.contrastnames = format_strings_for_legend(DAT.contrastnames);

mycolors = colorcube_colors(length(DAT.conditions) + size(DAT.contrasts, 1));

DAT.colors = mycolors(1:length(DAT.conditions));
DAT.contrastcolors = mycolors(length(DAT.conditions) + 1:length(mycolors));


disp('SET up conditions, colors, contrasts in DAT structure.');

DAT.between_condition_cons = [];

DAT.between_condition_contrastnames = {};
          
DAT.between_condition_contrastcolors = custom_colors ([.2 .2 .8], [.2 .8 .2], size(DAT.between_condition_cons, 1));
