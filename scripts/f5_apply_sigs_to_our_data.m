
%% set up  

working_dir = scriptsdir;
cd(working_dir);

colors_to_plot = {[0.6 0 0.8] [1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1]} 

datadir = fullfile(basedir, 'SR_analysis/data');  

%% load data
filedir = what(fullfile(basedir, 'SR_analysis', 'data/reg_rob'));
savefilename = fullfile(datadir, 'model_encode_obj.mat');
load (savefilename, 'encode_obj');

%% apply pain and emo patterns for MPA2 model encoding maps 

clear pexps dat
dat = encode_obj(4);
pexpComm =  apply_all_signatures(dat, 'similarity_metric', 'cosine_similarity', 'image_set', 'mpa2');
pexps = apply_all_signatures(dat, 'similarity_metric', 'cosine_similarity', 'image_set', 'npsplus');
toplot1 = table2array(pexpComm.General_aversive);
toplot2 = table2array(pexps.NPS);
toplot3 = table2array(pexps.SIIPS);
toplot4 = table2array(pexps.PINES);
toplot = [toplot1 toplot2 toplot3 toplot4];

create_figure;
h = barplot_columns(toplot,'nofig', 'nostars');
%set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);


for n = 1:nplots
    axh(n) = subplot(4,7,n);
    toplot = [extracted_roi{1}(n).dat extracted_roi{2}(n).dat extracted_roi{3}(n).dat extracted_roi{4}(n).dat extracted_roi{5}(n).dat];
    h = barplot_columns(toplot,'nofig','title', labels(n), 'nostars', 'noind', 'noviolin', 'colors', colors_to_plot);
    set(gca,'LineWidth', .75,'YTick', 0:0.1:0.1, 'YLim', [0 0.14],'XTick', 0:0:0, 'FontSize', 7);
    for i = 1:5
        h.errorbar_han{i}.LineWidth = 1
        h.errorbar_han{i}.CapSize = 0
    end
    xlabel(''), ylabel(''); drawnow 
end

DAT.SIG_conditions.raw.cosine_sim = apply_all_signatures(DATA_OBJ, 'conditionnames', DAT.conditions, 'similarity_metric', 'cosine_similarity', 'image_set', 'aversive_pls');
DAT.SIG_contrasts.raw.cosine_sim = apply_all_signatures(DATA_OBJ_CON, 'conditionnames', DAT.contrastnames, 'similarity_metric', 'cosine_similarity', 'image_set', 'aversive_pls');

pexpsM = apply_mask(encode_obj(2), pats, 'similarity_metric', 'cosine_similarity');
pexpM_tabl = array2table(pexpsM)

pexpsT = apply_mask(encode_obj(3), pats, 'similarity_metric', 'cosine_similarity');
pexpT_tabl = array2table(pexpsT, 'VariableNames', networknames);

pexpsA = apply_mask(encode_obj(4), pats, 'similarity_metric', 'cosine_similarity');
pexpA_tabl = array2table(pexpsA, 'VariableNames', networknames);

pexpsV = apply_mask(encode_obj(5), pats, 'similarity_metric', 'cosine_similarity');
pexpV_tabl = array2table(pexpsV, 'VariableNames', networknames);














