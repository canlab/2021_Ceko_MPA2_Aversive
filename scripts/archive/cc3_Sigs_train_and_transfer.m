%% Visualize T & T 

% Correlation matrix train (x-axis) with test (y-axis) 
% train  = avers_mat
% test  = yhat

%% Load data 

load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

models = {'GenS' 'MechS' 'ThermS' 'AudS' 'VisS'};


%% Plot data as models (panels) for each modality 
% vs. behavior
% 
% %% Can't get it to plot on same plot 
% % ----------------------------------------------------------
% figure;
% subplot(1,2,1)
% [han1] = bin2dplot(YY{1}, YYfit_Spec{1}, 'nbins', 4, 'do_stat')
% [han2] = bin2dplot(YY{1}, YYfit_Spec{2}, 'nbins', 4, 'do_stat')
% 
% for i = 1:4
%     h = bin2dplot(YY{1}, YYfit_Spec{i}, 'nbins', 4, 'do_stat')
%     hold on
% end
% 

%% USE SOME OF THIS: 

%% Colors 
mechanical_color = [1 0.2 0.4]; % red 
thermal_color= [1 0.6 0.2]; % orange
sound_color = [0 0.6 0.4]; % green
negvis_color = [0 0.4 1]; % blue
general_color = [0.5 0.5 0.5]; % gray

%% Define means by intensity
models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};
for m=1:4  % modality
    for o=1:5% outcomes (general and 4 x specific)
        clear ratings outcomes
        for i=1:4% intensity level
            ratings(:,i)=avers_mat(modality==m & stim_int==i,o);
            outcomes(:,i)=yhat(modality==m & stim_int==i,o);
        end

        pred_outcome_corr(:,m,o)=diag(corr(ratings',outcomes'));
       
        mean_outcomes(m,:,o)=mean(outcomes);
        ste_outcomes(m,:,o)=ste(outcomes);
        
        % add mean avers_mat
        mean_avers_mat(m,:,o)=mean(ratings);
        ste_avers_mat(m,:,o)=ste(ratings);
        %     pause(3);
    end
end

%%

%% Plot pattern responses per stim level

% Plots per modality (4 plots)
figtitle = sprintf('PLS per modality per stim level');
create_figure(figtitle);
C={[0.5 0.5 0.5],[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
    [0.5 0.5 0.5],[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
    [0.5 0.5 0.5],[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
    [0.5 0.5 0.5],[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]};
%C2={[1 0.2 0.4],[1 0.6 0.2],[0 0.2 1],[0 0.6 0.4]};
for m=1:4;subplot(1,4,m);
    %errorbar(squeeze(mean_avers_mat(m,:,:)),squeeze(ste_avers_mat(m,:,:)), 'color', C2{m},'LineWidth', 10);
    for o=1:5
        hold on;
       %plot(mean_avers_mat(m,:,o),mean_outcomes(m,:,o))
        errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)));%'color', C{m,o},'LineWidth', 6);
    end   
    %title(['Test data: ' models{1+m}]);
%     xlabel('Stimulus Intensity')
%     ylabel('Predicted Aversiveness')
    %set(gca,'LineWidth', 2,'box', 'off', 'XTick', 1:4,'YTick', 0:0.1:0.4, 'XLim', [.5 4.5], 'YLim', [-0.05 0.43], 'FontSize', 20);
end

%legend(C)
%plugin_save_figure

%% Plot pattern responses per stim level

% Plots per model (5 plots)
figtitle = sprintf('PLS per MODEL per stim level');
create_figure(figtitle);

C={[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]}; 

for m=1:4;
   
    %errorbar(squeeze(mean_avers_mat(m,:,:)),squeeze(ste_avers_mat(m,:,:)), 'color', C2{m},'LineWidth', 10);
    for o=1:5; subplot(3,5,o); % for 4 modalities
        hold on; 
        
        errorbar(mean_outcomes(m,:,o),ste_outcomes(m,:,o), 'color', C{o,m},'LineWidth', 1.5);    
        %errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)), 'color', C{o,m},'LineWidth', 1.5);
       set(gca,'LineWidth',1,'box', 'off', 'XTick', 1:1:4,'YTick', 0:0.2:0.4, 'XLim', [0.5 4.5], 'YLim', [-0.05 0.45], 'FontSize', 10);
    end   
end
%legend(C)

%
plugin_save_figure



%% Plot pattern responses per rating level

% Plots per model (5 plots)
figtitle = sprintf('PLS per MODEL per rating level');
create_figure(figtitle);
% C={[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],[0.5 0.5 0.5],; ...
%    [1 0.2 0.4],[1 0.2 0.4],[1 0.2 0.4],[1 0.2 0.4]; ...
%    [1 0.6 0.2],[1 0.6 0.2],[1 0.6 0.2],[1 0.6 0.2]; ...
%     [0 0.6 0.4],[0 0.6 0.4],[0 0.6 0.4],[0 0.6 0.4]; ...
%     [0 0.4 1],[0 0.4 1],[0 0.4 1],[0 0.4 1]};

C={[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]}; 

for m=1:4;
   
    %errorbar(squeeze(mean_avers_mat(m,:,:)),squeeze(ste_avers_mat(m,:,:)), 'color', C2{m},'LineWidth', 10);
    for o=1:5; subplot(3,5,o); % for 4 modalities
        hold on; 
        
        %h = ploterr (mean_avers_mat(m,:,o),ste_avers_mat(m,:,o), mean_outcomes(m,:,o),ste_outcomes(m,:,o)) % 'abshhxy', 0);
        plot(squeeze(mean_avers_mat(m,:,1)),squeeze(mean_outcomes(m,:,o)))
        %errorbar(mean_outcomes(m,:,o),ste_outcomes(m,:,o), 'color', C{o,m},'LineWidth', 1.5);    
        %errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)), 'color', C{o,m},'LineWidth', 1.5);
       set(gca,'LineWidth',1,'box', 'off', 'XTick', .0:0.2:0.6,'YTick', 0:0.2:0.4, 'XLim', [0 0.6], 'YLim', [-0.05 0.45], 'FontSize', 10);
    end   
end
%legend(C)

%
plugin_save_figure

%% 
% Mech plot 
color1 = {[1 0.2 0.4] [1 0.2 0.4]}; % red 
color2 = {[1 0.6 0.2] [1 0.6 0.2]}; % orange
color3 = {[0 0.6 0.4] [0 0.6 0.4]}; % green
color4 = {[0 0.4 1]   [0 0.4 1]}; % blue
%general_color = [0.5 0.5 0.5]; % gray

color1s = {[1 0.2 0.4]}; % red 
color2s = {[1 0.6 0.2]}; % orange
color3s = {[0 0.6 0.4]}; % green
color4s = {[0 0.4 1]}; % blue
%general_color = [0.5 0.5 0.5]; % gray

figure; 
subplot (1,2,1);
[han1, Xbin, Ybin] = line_plot_multisubject_mc(Mech_avers_mat, Mech_yhat, 'n_bins', 4, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color1, 'noind', 'nolines');
[han2, Xbin, Ybin] = line_plot_multisubject_mc(Therm_avers_mat, Mech_yhat, 'n_bins', 4, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color2, 'noind', 'nolines');
[han3, Xbin, Ybin] = line_plot_multisubject_mc(Audi_avers_mat, Mech_yhat, 'n_bins', 4, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color3, 'noind', 'nolines');
[han4, Xbin, Ybin] = line_plot_multisubject_mc(Vis_avers_mat, Mech_yhat, 'n_bins', 4, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color4, 'noind', 'nolines');
axis tight; set(gca, 'FontSize', 14);

subplot (1,2,2);
[han1, Xbin, Ybin] = line_plot_multisubject(Mech_avers_mat, Mech_yhat, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color1s, 'noind', 'nolines');
[han2, Xbin, Ybin] = line_plot_multisubject(Therm_avers_mat, Mech_yhat, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color2s, 'noind', 'nolines');
[han3, Xbin, Ybin] = line_plot_multisubject(Audi_avers_mat, Mech_yhat, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color3s, 'noind', 'nolines');
[han4, Xbin, Ybin] = line_plot_multisubject(Vis_avers_mat, Mech_yhat, 'group_avg_ref_line', 'MarkerTypes', 'o', 'colors', color4s, 'noind', 'nolines');
axis tight; set(gca, 'FontSize', 14);






% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% MATRIX 


%% Regular matrix
clear toplotcorr
[toplotcorr, pcorr]=corr(avers_mat,yhat)

figtitle = sprintf('Cross-prediction effect sizes whole-brain');
create_figure(figtitle);
toplotcorr=toplotcorr(:,2:end)
imagesc(toplotcorr)
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
colormap(cm)
caxis([0 0.75])

%% which of these p-values are significant after FDR-correction? 

% adapted from plot_correlation_matrix: 
    % FDR-correct p-values across unique elements of the matrix
    
    trilp = tril(pcorr, -1);
    wh = logical(tril(ones(size(pcorr)), -1)); % Select off-diagonal values (lower triangle) 
    % both triangles are valid data in my case (n x m matrix, not n x n)
    % but doesn't matter for FDR calculation
    trilp = double(trilp(wh));             % Vectorize and enforce double
    trilp(trilp < 10*eps) = 10*eps;        % Avoid exactly zero values
    fdrthr = FDR(trilp, 0.05);
    if isempty(fdrthr), fdrthr = -Inf; end
    sig = pcorr < fdrthr;
    
% fdrthr =
% 
%     0.0098  


% Display corr values on matrix
textStrings = num2str(toplotcorr(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:4,1:5);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center', 'Fontsize', 20);
            
            
plugin_save_figure;

%% Regular matrix no Gen 
clear toplotcorr
[toplotcorr, pcorr]=corr(avers_mat,yhat)

figtitle = sprintf('Cross-prediction No Gen v2 effect sizes whole-brain');
create_figure(figtitle);
subplot(2,2,1)
toplotcorr=toplotcorr(2:end,2:end)
imagesc(toplotcorr)
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 14, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', {'MechS' 'ThermS' 'AudS' 'VisS'});

colorbar
%cm = colormap_tor([1 1 1], [0.4 0 0], [0.6 0.2 0]);
cm = colormap_tor([1 1 1], [1 0 0]);
colormap(cm)

colormap(cm)
caxis([0 0.75])


% adapted from plot_correlation_matrix: 
%     FDR-correct p-values across unique elements of the matrix
%     
    trilp = tril(pcorr, -1);
    wh = logical(tril(ones(size(pcorr)), -1)); 
    trilp = double(trilp(wh));             % Vectorize and enforce double
    trilp(trilp < 10*eps) = 10*eps;        % Avoid exactly zero values
    fdrthr = FDR(trilp, 0.05);
    if isempty(fdrthr), fdrthr = -Inf; end
    sig = pcorr < fdrthr;
    
% fdrthr =
% 
%     0.0095 

% Display corr values on matrix
textStrings = num2str(toplotcorr(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:4,1:4);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center', 'Fontsize', 12, 'Color', [0 0 0]);  
            
plugin_save_figure;


%% Regular matrix incl combined stimuli
clear toplotcorr
[toplotcorr, pcorr]=corr(avers_mat,yhat);

figtitle = sprintf('Cross-prediction all 5 effect sizes whole-brain');
create_figure(figtitle);
%toplotcorr=toplotcorr(:,2:end)
imagesc(toplotcorr)
ylabel 'Observed - Predicted Ratings Corr'

set(gca,'XTick', 1:5, 'XTickLabels', {'All' 'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', {'GenS' 'MechS' 'ThermS' 'AudS' 'VisS'});


colorbar
cm = colormap_tor([1 1 1], [1 0 0]);
colormap(cm)
caxis([0 0.75]);

% adapted from plot_correlation_matrix: 
%     FDR-correct p-values across unique elements of the matrix
%     
    trilp = tril(pcorr, -1);
    wh = logical(tril(ones(size(pcorr)), -1)); 
    trilp = double(trilp(wh));             % Vectorize and enforce double
    trilp(trilp < 10*eps) = 10*eps;        % Avoid exactly zero values
    fdrthr = FDR(trilp, 0.05);
    if isempty(fdrthr), fdrthr = -Inf; end
    sig = pcorr < fdrthr;
    
% fdrthr =
% 
%     0.0095 


% Display corr values on matrix
textStrings = num2str(toplotcorr(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:5,1:5);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center', 'Fontsize', 20);
plugin_save_figure;


%% ON-modality: Regular matrix incl combined 
clear toplotcorr pcorr
subject=repmat((1:55)',16,1);
stimulus=[repmat(ones(55,1),4,1); repmat(2*ones(55,1),4,1); repmat(3*ones(55,1),4,1); repmat(4*ones(55,1),4,1)];

% cross-prediction correlation
for j=1:size(yhat,2) 
    for i=1:length(stims)  %test
        [toplotcorr(i,j),pcorr(i,j)]=corr(avers_mat(stimulus==i), yhat(stimulus==i,j))
    end
   
   % pearson(i+1,j)=corr(yh(:,j),dat.Y);
   % pearson(i+1,j)=corr(yhat(:,j),avers_mat);
end

figtitle = sprintf('Cross-prediction off-mods whole-brain');
create_figure(figtitle);
%toplotcorr=toplotcorr(:,2:end)
%D=padarray(toplotcorr, [0 1],0, 'pre')
toplotcorr=toplotcorr';
imagesc(toplotcorr);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1], [1 0 0]);
colormap(cm)
caxis([0 0.6])

% adapted from plot_correlation_matrix: 
    % FDR-correct p-values across unique elements of the matrix
    
    trilp = tril(pcorr, -1);
    wh = logical(tril(ones(size(pcorr)), -1)); % Select off-diagonal values (lower triangle) 
    % both triangles are valid data in my case (n x m matrix, not n x n)
    % but doesn't matter for FDR calculation
    trilp = double(trilp(wh));             % Vectorize and enforce double
    trilp(trilp < 10*eps) = 10*eps;        % Avoid exactly zero values
    fdrthr = FDR(trilp, 0.05);
    if isempty(fdrthr), fdrthr = -Inf; end
    sig = pcorr < fdrthr;
    fdrthr
    
% toplotcorr =
% 
%   4×5 single matrix
% 
%     0.5569    0.1629    0.4196    0.2702   -0.2245
%     0.3899    0.0579    0.3653    0.0032   -0.0764
%     0.2212    0.2324    0.0602    0.0510   -0.1246
%     0.2623   -0.1224    0.2124   -0.1383    0.2482
% 
% 
% pcorr =
% 
%   4×5 single matrix
% 
%     0.0000    0.0156    0.0000    0.0000    0.0008
%     0.0000    0.3929    0.0000    0.9620    0.2591
%     0.0010    0.0005    0.3738    0.4518    0.0652
%     0.0001    0.0700    0.0015    0.0405    0.0002
%     
%     
% fdrthr =
% 
%     0.0015

% Display corr values on matrix
textStrings = num2str(toplotcorr(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:4,1:5);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
                'HorizontalAlignment', 'center', 'Fontsize', 20);
plugin_save_figure;

%% step-by-step to check values 
subject_id = subjects 

[rcorr_a, pcorr_a]=corr(avers_mat(1:length(subject_id),1),yhat(1:length(subject_id),1)) % gen on mech
[rcorr_b, pcorr_b]=corr(avers_mat(1*length(subject_id)+1:2*length(subject_id),1), yhat(length(subject_id)+1:2*length(subject_id),1)) % gen on therm
[rcorr_c, pcorr_c]=corr(avers_mat(2*length(subject_id)+1:3*length(subject_id),1),yhat(2*length(subject_id)+1:3*length(subject_id),1)) % gen on aud
[rcorr_d, pcorr_d]=corr(avers_mat(3*length(subject_id)+1:4*length(subject_id),1),yhat(3*length(subject_id)+1:4*length(subject_id),1)) % gen on vis

tempm=[rcorr_a rcorr_b rcorr_c rcorr_d]

% 0.5569    0.3899    0.2212    0.2623

%% Corr Average GenS x single modalities 
gens_mean = reshape (yhat (:,1), 220, 4);
gensm = mean (gens_mean,2)

[rcorr_a(m), pcorr_a(m)]=corr(avers_mat(1:length(subject_id),1),gensm) % gen on mech
[rcorr_b(m), pcorr_b(m)]=corr(avers_mat(1*length(subject_id)+1:2*length(subject_id),1), gensm) % gen on therm
[rcorr_c(m), pcorr_c(m)]=corr(avers_mat(2*length(subject_id)+1:3*length(subject_id),1), gensm) % gen on aud
[rcorr_d(m), pcorr_d(m)]=corr(avers_mat(3*length(subject_id)+1:4*length(subject_id),1), gensm)

tempm=[rcorr_a rcorr_b rcorr_c rcorr_d]

% 0.3228    0.4400    0.1388    0.1801


% %% Tor matrix 
% 
% colorbar
% cm = colormap_tor([0 0 1], [1 0 0], [1 1 1]);
% colormap(cm)
% caxis([-1 1])
% 
% figure; 
% %plot_correlation_matrix(toplotcorr) % this returns wrong matrix, since the
% %script runs correlation before plotting 
% plot_correlation_matrix(yhat,avers_mat);
% 
% %legend(models)
% ylabel 'Prediction-Outcome Correlation'
% set(gca,'XTick', 1:5, 'XTickLabels', {'All' 'M' 'T' 'A' 'V'});
% nmodels=5
% set(gca,'YTick', 1:nmodels, 'YTickLabels', models);
