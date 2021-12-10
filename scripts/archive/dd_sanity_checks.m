%% Sanity checks and decisions for PLS aversive paper 

%% Import data, set figdir
% ------------------------------------------------------------------------
figsavedir = fullfile(resultsdir, 'figures_checks');

% FMRI data object 
load(fullfile(resultsdir, 'data_objects.mat'));

% Behavior - in data/ dir
%import_Behav_MPA2;

subject_id=repmat(1:55,1,4)';
% Contrast maps 
% 1 per stim level per cond - each contrast map is averaged over XX trials for that stim level
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';
ints=rem(1:16,4);ints(ints==0)=4;
for d=1:16;
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Pain_Avoid(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end

% Ratings
avers_mat=condf2indic(modality);
for i=1:size(avers_mat,1)
    avers_mat(i,find(avers_mat(i,:)))=dat.Y(i);
    
end
avers_mat=[dat.Y avers_mat];

%
dat.removed_images=0;
dat.removed_voxels=0;

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 

dat=apply_mask(dat,gm_mask);

%% Run PLS model - OR SKIP AHEAD TO SAVED PLS OUTPUT
% ------------------------------------------------------------------------
% (1) generate x-val estimates 

models = {'GenS' 'MechS' 'ThermS' 'AudS' 'VisS'};
kinds=ceil(subjects/11);
for k=1:5
    train= kinds~=k;
    test= ~train;
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)',avers_mat(train,:),20);
    
    % x-val yhat as dot product 
    yhat(test,:)=[ones(length(find(test)),1) dat.dat(:,test)']*b_pls;
    
    for m=1:length(models)
        cv_bpls=fmri_data;
        cv_bpls.volInfo=dat.volInfo;
        cv_bpls.dat=b_pls(2:end,m);
        cv_bpls.removed_voxels=dat.removed_voxels;
%         cv_bpls.fullpath=[models{m} '_CV' num2str(k)  '.nii'];
%         write(cv_bpls,'overwrite');
%         
        dat.removed_images = 0;
        test_dat=dat;
        test_dat.dat=test_dat.dat(:,test);
        pexp_xval_cs(test,m) = apply_mask(test_dat,cv_bpls,'pattern_expression','cosine_similarity');
        
        % x-val pattern expression as dot product 
        pexp_xval_dp(test,m) = apply_mask(test_dat,cv_bpls,'pattern_expression');
    end
end

% (2) generate full sample estimates 
[xl,yl,xs,ys,b_plsfull,pctvar] = plsregress(dat.dat',avers_mat,20);
yhatfull = [ones(length(find(subjects)),1) dat.dat']*b_plsfull; 
 
% -----------------------------------------------------------------------
%% Saved PLS output is here:

% savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
% save(savefilename, 'yhatfull','pexp_xval_dp','pexp_xval_cs','-append');

load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
% ------------------------------------------------------------------------
%% Plot and evaluate outputs 
% ------------------------------------------------------------------------

% How similar are yhat and pexp_xval_dp? 
% calculate across entire column for each outcome (on- and off-target values)
figtitle = sprintf('Plot_yhat_pexpdp');
create_figure(figtitle);

clear r p
figure;
for m=1:4;
    hold on
    scatter(yhat(:,m), pexp_xval_dp(:,m));
    [r(:,m), p(:,m)] = corr (yhat(:,m), pexp_xval_dp(:,m))
    
%     hold on
%     scatter(pexp_xval_cs(:,m), pexp_xval_dp(:,m));
    [r(:,m+4), p(:,m+4)] = corr (pexp_xval_cs(:,m), pexp_xval_dp(:,m))
end

% 1:4 corr yhat and pexp dp
% 5:8 corr pexp cs and pexp dp
% r =  0.9864    0.9979    0.9972    0.9996    0.9996  0.8973    0.9482    0.9311    0.9662

%plugin_save_figure

%% Plot yhat per stim level and per rating level 

% Define means by intensity: 
% ------------------------------------------------------------------------
for m=1:4  % modality
    for o=1:5 % outcomes (general and 4 x specific)
        clear ratings outcomes
        for i=1:4 % intensity level
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

% Plot corr matrices (pred_outcome_corr) 
figtitle = sprintf('PLS_corr_pred_outcomes');
create_figure(figtitle);
for o=1:5
  subplot(4,5,o);imagesc(pred_outcome_corr(:,:,o)); colorbar  
end
%plugin_save_figure

for o=1:5
    for m=1:4
[r(o,m)]= corr(yhat(1:220,m),yhat(1:220,o))
    end
end

% Plot 
% ------------------------------------------------------------------------
figtitle = sprintf('PLS xval yhat per stim level and per rating level');
create_figure(figtitle);

C={[1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]; ...
   [1 0.2 0.4],[1 0.6 0.2],[0 0.6 0.4],[0 0.4 1]}; 

for m=1:4;
    for o=1:5; 
       
        % Plot outcome (predicted rating) vs. stim level
        subplot(3,5,o); 
        hold on; 
        errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)), 'color', C{o,m},'LineWidth', 1.5);
        set(gca,'LineWidth',1,'box', 'off', 'XTick', 0:2:5,'YTick', 0:0.2:0.4, 'XLim', [0 4.5], 'YLim', [-0.05 0.45], 'FontSize', 10);
        xlabel('stim int'); ylabel('predicted rating');
        
        % Plot outcome vs. observed rating (not artificial 0s for off-target)
        subplot(3,5,o+5);
        hold on;
        % avoidance ratings for all mods are in mean_avers_mat (m,:,1) 
        errorbar(mean_avers_mat(m,:,1), mean_outcomes(m,:,o),ste_outcomes(m,:,o), 'color', C{o,m},'LineWidth', 1.5);    
        set(gca,'LineWidth',1,'box', 'off', 'XTick', .0:0.2:0.6,'YTick', 0:0.2:0.4, 'XLim', [0.15 0.6], 'YLim', [-0.05 0.45], 'FontSize', 10); 
        xlabel('rating'); ylabel('predicted rating');
    end  
end
plugin_save_figure
 

%% Now, plot pattern responses per stim level and per rating level 
% 
% should give very similar plots (slightly different scale) 
% 
% Define means by intensity: 
% ------------------------------------------------------------------------
for m=1:4  % modality
    for o=1:5 % outcomes (general and 4 x specific)
        clear ratings outcomes
        for i=1:4 % intensity level
            ratings(:,i)=avers_mat(modality==m & stim_int==i,o);
            outcomes(:,i)=pexp_xval_dp(modality==m & stim_int==i,o);
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

% Plot
% ------------------------------------------------------------------------
figtitle = sprintf('PLS xval pexp per stim level and per rating level');
create_figure(figtitle);

for m=1:4;
    for o=1:5; 
       
        % Plot outcome (predicted rating) vs. stim level
        h = subplot(3,7,o); 
        hold on; 
        errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)), 'color', C{o,m},'LineWidth', 1.5);
        set(gca,'LineWidth',0.75,'box', 'off', 'XTick', 0:2:5,'YTick', 0:0.2:0.4, 'XLim', [0 4.5], 'YLim', [-0.2 0.35], 'FontSize', 14, 'tickdir', 'out', 'ticklength', [.01 .01]);
        %xlabel('stim int'); ylabel('predicted rating');
        
        % Plot outcome vs. observed rating (not artificial 0s for off-target)
        subplot(3,7,o+7);
        hold on;
        errorbar(mean_avers_mat(m,:,1), mean_outcomes(m,:,o),ste_outcomes(m,:,o), ...
           'o', 'color', 'k', 'linewidth', 1, 'markersize', 7, 'markerfacecolor', C{o,m},'LineWidth', 1);  
        hold on;
        sepplot(mean_avers_mat(m,:,1), mean_outcomes(m,:,o), .75, 'linewidth', 2.5);
        sepplot(mean_avers_mat(m,:,1), mean_outcomes(m,:,o), .75, 'color', 'color', C{o,m}, 'linewidth', 2.5);
        set(gca,'LineWidth',1.5,'box', 'off', 'XTick', 0.2:0.3:0.5,'YTick', 0:0.2:0.4, 'XLim', [0.15 0.6], 'YLim', [-0.2 0.32], 'FontSize', 14, 'tickdir', 'out', 'ticklength', [.01 .01]); 
        %xlabel('rating'); ylabel('predicted rating')
    end  
end
%plugin_save_figure


%% Now, plot pattern responses COS SIM per stim level and per rating level 
% 
% looks worse than dp / yhat
% 
% Define means by intensity: 
% ------------------------------------------------------------------------
for m=1:4  % modality
    for o=1:5 % outcomes (general and 4 x specific)
        clear ratings outcomes
        for i=1:4 % intensity level
            ratings(:,i)=avers_mat(modality==m & stim_int==i,o);
            outcomes(:,i)=pexp_xval_cs(modality==m & stim_int==i,o);
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

% Plot 
% ------------------------------------------------------------------------
figtitle = sprintf('PLS xval pexp COS SIM per stim level and per rating level');
create_figure(figtitle);

for m=1:4;
    for o=1:5; 
       
        % Plot outcome (predicted rating) vs. stim level
        subplot(3,5,o); 
        hold on; 
        errorbar(squeeze(mean_outcomes(m,:,o)),squeeze(ste_outcomes(m,:,o)), 'color', C{o,m},'LineWidth', 1.5);
        %set(gca,'LineWidth',1,'box', 'off', 'XTick', 0:2:5,'YTick', 0:0.2:0.4, 'XLim', [0 4.5], 'YLim', [-0.2 0.35], 'FontSize', 10);
        xlabel('stim int'); ylabel('predicted rating');
        
        % Plot outcome vs. observed rating (not artificial 0s for off-target)
        subplot(3,5,o+5);
        hold on;
        % avoidance ratings for all mods are in mean_avers_mat (m,:,1) 
        errorbar(mean_avers_mat(m,:,1), mean_outcomes(m,:,o),ste_outcomes(m,:,o), 'color', C{o,m},'LineWidth', 1.5);    
        %set(gca,'LineWidth',1,'box', 'off', 'XTick', .0:0.2:0.6,'YTick', 0:0.2:0.4, 'XLim', [0.15 0.6], 'YLim', [-0.2 0.35], 'FontSize', 10); 
        xlabel('rating'); ylabel('predicted rating');
    end  
end
plugin_save_figure


%% Data reorganization checks 
% Mech
yhatch = reshape (yhat(:,2), 55, 16);
pexp_xval_g = reshape (pexp_xval_dp(:,2, 55, 16));
yhat_mm = yhatch(:,1:4); % Mech S on mechanical stim
mm = mean (yhat_mm)

% should be the same as the first row of this: 
mean_outcomes(:,:,2) % Ok

aversch = reshape (avers_mat(:,1), 55, 16);
avers_m = aversch(:,1:4);
mam = mean (avers_m) 
% should be the same as first row of this 
mean_avers_mat(:,:,1) % ok 
% and as this (first row are on-target values, others are 0) 
mean_avers_mat(:,:,2) % ok 


%% Cross-corr matrix on pexp g  ACROSS ALL OBS 
% using pexp instead of yhat from now on (very similar, pexp more directly
% comparable to full sample pexp that will be used on other studies)

% x-val GenS on each modality:  
clear x y 
x(:,1) = reshape (Pain_Avoid(:,1:4), 220,1);
x(:,2) = reshape (Pain_Avoid(:,5:8), 220,1);
x(:,3) = reshape (Pain_Avoid(:,9:12), 220,1);
x(:,4) = reshape (Pain_Avoid(:,13:16), 220,1);

y(:,1) = pexp_xval_dp (1:220,1);
y(:,2) = pexp_xval_dp (221:440,1);
y(:,3) = pexp_xval_dp (441:660,1);
y(:,4) = pexp_xval_dp (661:880,1);

clear r p
r = [];
p = [];
clear rmse
for m=1:4
    [r(1,m), p(1,m)]= corr(x(:,m), y(:,m));
    rmse(1,m) = mean((x(:,m)-y(:,m)).^2).^1/2;
    [r(1,m+4), p(1,m+4)]= corr(x(:,m), y(:,m));
    rmse(1,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% Mech 
clear y 
y(:,1) = pexp_xval_dp (1:220,2); % MechS predicting mech ratings
y(:,2) = pexp_xval_dp (221:440,2); % MechS predicting 0s for therm pain
y(:,3) = pexp_xval_dp (441:660,2); % MechS predicting 0s for av audi
y(:,4) = pexp_xval_dp (661:880,2); % MechS predicting 0s for av visual

for m=1:4
    [r(2,m), p(2,m)]= corr(x(:,m), y(:,1)); 
    rmse(2,m) = mean((x(:,m)-y(:,1)).^2).^1/2;
    [r(2,m+4), p(2,m+4)]= corr(x(:,m), y(:,m));
    rmse(2,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% Therm
clear y 
y(:,1) = pexp_xval_dp (1:220,3);
y(:,2) = pexp_xval_dp (221:440,3); % ThermS on thermal ratings 
y(:,3) = pexp_xval_dp (441:660,3);
y(:,4) = pexp_xval_dp (661:880,3);

for m=1:4
    [r(3,m), p(3,m)]= corr(x(:,m), y(:,2));
    rmse(3,m) = mean((x(:,m)-y(:,2)).^2).^1/2;
    [r(3,m+4), p(3,m+4)]= corr(x(:,m), y(:,m));
    rmse(3,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% AudS 
clear y 
y(:,1) = pexp_xval_dp (1:220,4);
y(:,2) = pexp_xval_dp (221:440,4);
y(:,3) = pexp_xval_dp (441:660,4); % AudS on audi ratings 
y(:,4) = pexp_xval_dp (661:880,4);

for m=1:4
    [r(4,m), p(4,m)]= corr(x(:,m), y(:,3));
    rmse(4,m) = mean((x(:,m)-y(:,3)).^2).^1/2;
    [r(4,m+4), p(4,m+4)]= corr(x(:,m), y(:,m));
    rmse(4,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% VisS 
clear y 
y(:,1) = pexp_xval_dp (1:220,5);
y(:,2) = pexp_xval_dp (221:440,5);
y(:,3) = pexp_xval_dp (441:660,5);
y(:,4) = pexp_xval_dp (661:880,5); % VisS on vis ratings 

for m=1:4
    [r(5,m), p(5,m)]= corr(x(:,m), y(:,4));
    rmse(5,m) = mean((x(:,m)-y(:,4)).^2).^1/2;
    [r(5,m+4), p(5,m+4)]= corr(x(:,m), y(:,m));
    rmse(5,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

%% Cross-corr matrix x-val pexp on-target predictions 
% Cross-corr PLS-derived Sig for on-target mod vs. true ratings 
clear toplot
r_on = r (:,1:4)
p_on = p (:,1:4)
toplot=r_on

figtitle = sprintf('Cross-prediction xval pexp on');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
colormap(cm)
caxis([0 0.6])

%plugin_save_figure;

%% Cross-corr matrix x-val pexp on- and off-target predictions 
% Cross-corr PLS-derived Sig for on-target mod vs. true ratings 
clear toplot
r_on = r (:,5:8)
p_on = p (:,5:8)
toplot=r_on

figtitle = sprintf('Cross-prediction xval pexp on and off');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
colormap(cm)
caxis([0 0.6])

%plugin_save_figure;

%% Cross-corr matrix rmse pexp on-target predictions 
% Cross-corr PLS-derived Sig for on-target mod vs. true ratings 
clear toplot

toplot = 1-rmse(:,1:4)

figtitle = sprintf('Cross-prediction 1-rmse pexp on');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
colormap(cm)
caxis([0.94 0.9799])

plugin_save_figure;


%% Cross-corr matrix rmse pexp on- and off-target predictions 
% Cross-corr PLS-derived Sig for on-target mod vs. true ratings 
clear toplot

toplot = rmse(:,5:8)

figtitle = sprintf('Cross-prediction rmse pexp on and off');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
%cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
cm = colormap_tor([0.6 0 0],[1 1 1],[1 0 0]);
colormap(cm)
%caxis([0.86 0.98])
caxis([0.020 0.135])

plugin_save_figure;


%% Avg within-subj correlations using pexp dp 

%% FOR CLEANER, MORE ELEGANT AND MORE COMPLETE CODE (boostrapping r-values) 
%% SEE cc1d_obs_pred_wtn_btn_overall.m  
%% 

% x-val GenS on each modality:  
clear xx yy
xx{1} = reshape (Pain_Avoid(:,1:4), 220,1);
xx{2} = reshape (Pain_Avoid(:,5:8), 220,1);
xx{3} = reshape (Pain_Avoid(:,9:12), 220,1);
xx{4} = reshape (Pain_Avoid(:,13:16), 220,1);

% yy{1} = pexp_xval_dp (1:220,1);
% yy{2} = pexp_xval_dp (221:440,1);
% yy{3} = pexp_xval_dp (441:660,1);
% yy{4} = pexp_xval_dp (661:880,1);

yy{1} = yhat (1:220,1);
yy{2} = yhat (221:440,1);
yy{3} = yhat (441:660,1);
yy{4} = yhat (661:880,1);

%
clear r_within rr b rstd rste
u = unique(subject_id);

for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
        %b(j, :, m) = b_fun(XX{m}{j}, YY{m}{j});
        b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
    end
    
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    
    % RMSE:  work in progress -----------------------
%    [r_rmse{m}] = cellfun(@mean, XX{m}-YY{m});
%    rmse(2,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2  
    %[rmse{m}] = mean((x(:,m)-y(:,m)).^2).^1/2
    
    rr(1,m) = nanmean(r_within{m});
    rstd(1,m) = nanstd(r_within{m});
    rste(1,m)= rstd(1,m)/sqrt(size(u,1));
end

clear bw
for m=1:4
bG{m}=b(m,:,2)';
[~, pwithin(1,m)] = ttest(bG{m});
end

% Mech
clear yy
% yy{1} = pexp_xval_dp (1:220,2);
% yy{2} = pexp_xval_dp (221:440,2);
% yy{3} = pexp_xval_dp (441:660,2);
% yy{4} = pexp_xval_dp (661:880,2);

yy{1} = yhat(1:220,2);
yy{2} = yhat(221:440,2);
yy{3} = yhat(441:660,2);
yy{4} = yhat(661:880,2);

clear r_within b

for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
       b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
    end
    
    % calc r and p within
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    rr(2,m) = nanmean(r_within{m});
    rstd(2,m) = nanstd(r_within{m});
    rste(2,m)=rstd(2,m)/sqrt(size(u,1));
end

for m=1:4
bM{m}=b(m,:,2)';
[~, pwithin(1,m)] = ttest(bM{m});
end

% Therm
clear yy
% yy{1} = pexp_xval_dp (1:220,3);
% yy{2} = pexp_xval_dp (221:440,3);
% yy{3} = pexp_xval_dp (441:660,3);
% yy{4} = pexp_xval_dp (661:880,3);

yy{1} = yhat(1:220,3);
yy{2} = yhat(221:440,3);
yy{3} = yhat(441:660,3);
yy{4} = yhat(661:880,3);

clear r_within b

for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
         
        b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
    end
    
    % calc r and p within
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    rr(3,m) = nanmean(r_within{m});
    rstd(3,m) = nanstd(r_within{m});
    rste(3,m)=rstd(3,m)/sqrt(size(u,1));
end

for m=1:4
bT{m}=b(m,:,2)';
[~, pwithin(1,m)] = ttest(bT{m});
end

% Audi
clear yy
% yy{1} = pexp_xval_dp (1:220,4);
% yy{2} = pexp_xval_dp (221:440,4);
% yy{3} = pexp_xval_dp (441:660,4);
% yy{4} = pexp_xval_dp (661:880,4);

yy{1} = yhat(1:220,4);
yy{2} = yhat(221:440,4);
yy{3} = yhat(441:660,4);
yy{4} = yhat(661:880,4);


clear r_within b

for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
       b(m,j,:)= glmfit(XX{m}{j},YY{m}{j});
    end
    
    % calc r and p within
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    rr(4,m) = nanmean(r_within{m});
    rstd(4,m) = nanstd(r_within{m});
    rste(4,m)=rstd(4,m)/sqrt(size(u,1));
end

for m=1:4
bA{m}=b(m,:,2)';
[~, pwithin(1,m)] = ttest(bA{m});
end

% Vis
clear yy
% yy{1} = pexp_xval_dp (1:220,5);
% yy{2} = pexp_xval_dp (221:440,5);
% yy{3} = pexp_xval_dp (441:660,5);
% yy{4} = pexp_xval_dp (661:880,5);

clear yy
yy{1} = yhat(1:220,5);
yy{2} = yhat(221:440,5);
yy{3} = yhat(441:660,5);
yy{4} = yhat(661:880,5);

clear r_within b

for m=1:4
    for j = 1:length(u)
        XX{m}{j} = xx{m}(subject_id == u(j));
        YY{m}{j} = yy{m}(subject_id == u(j));
        
       b(m,j,:)= glmfit(XX{m}{j},YY{m}{j}); 
    end
    
    % calc r and p within
    [r_within{m}] = cellfun(@corr, XX{m},YY{m});
    rr(5,m) = nanmean(r_within{m});
    rstd(5,m) = nanstd(r_within{m});
    rste(5,m)=rstd(5,m)/sqrt(size(u,1));
end

for m=1:4
bV{m}=b(m,:,2)';
[~, pwithin(1,m)] = ttest(bV{m});
end

%% Boostrap betas to obtain pvalues 
clear p z 
% GenS
for m = 1:4;
    x = bG{m};
    stat = mean (x);
    bootstat = bootstrp(1000, @mean, x);
    [p(1,m), z(1,m)] = bootbca_pval(0, @mean, bootstat,stat, x);
end

% MechS
for m = 1:4
    x = bM{m};
    stat = mean (x);
    bootstat = bootstrp(1000, @mean, x);
    [p(2,m), z(2,m)] = bootbca_pval(0, @mean, bootstat,stat, x);
end

% ThermS 
for m = 1:4
    x = bT{m}
    stat = mean (x);
    bootstat = bootstrp(1000, @mean, x);
    [p(3,m), z(3,m)] = bootbca_pval(0, @mean, bootstat,stat, x);
end

% AudS
for m = 1:4
    x = bA{m}
    stat = mean (x);
    bootstat = bootstrp(1000, @mean, x);
    [p(4,m), z(4,m)] = bootbca_pval(0, @mean, bootstat,stat, x);
end

% VisS
for m = 1:4
    x = bV{m}
    stat = mean (x);
    bootstat = bootstrp(1000, @mean, x);
    [p(5,m), z(5,m)] = bootbca_pval(0, @mean, bootstat,stat, x);
end

% rr 
%     0.4276    0.6643    0.3125    0.4872
%     0.2542    0.0103    0.0776    0.0125
%     0.1496    0.5965    0.0748    0.0608
%     0.0922    0.1122    0.3830    0.0196
%    -0.0013    0.2299   -0.0135    0.6366

% rste
%     0.0663    0.0589    0.0729    0.0631
%     0.0831    0.0926    0.0805    0.0812
%     0.0819    0.0605    0.0776    0.0878
%     0.0828    0.0843    0.0598    0.0760
%     0.0807    0.0813    0.0796    0.0548

% pwithin = ttest on betas (?) 
%     0.0004    0.0000    0.0121    0.1252
%     0.0553    0.8756    0.7713    0.8991
%     0.1652    0.0000    0.1970    0.9865
%     0.7168    0.3514    0.0014    0.2805
%     0.3324    0.0997    0.4349    0.0000

% p (boot) = bootstrap on betas 
%     0.0000    0.0001    0.0001    0.1493
%     0.0568    0.8508    0.7444    0.8921
%     0.1003    0.0006    0.2090    0.9940
%     0.6815    0.2816    0.0002    0.2845
%     0.2309    0.0461    0.3887    0.0002

% ---- % SAME VALUES WITH yhat -----

%% Cross-corr PLS-derived Sig for on-target mod vs. true ratings 
clear toplot

toplot = rr

figtitle = sprintf('Cross-prediction r-within pexp on and off');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
%cm = colormap_tor([0.6 0 0],[1 1 1],[1 0 0]);
colormap(cm)
%caxis([0.86 0.98])
caxis([0.0 0.7])

plugin_save_figure;

% avg r_within values: 
%     0.4276    0.6643    0.3125    0.4872
%     0.2542    0.0103    0.0776    0.0125
%     0.1496    0.5965    0.0748    0.0608
%     0.0922    0.1122    0.3830    0.0196
%    -0.0013    0.2299   -0.0135    0.6366


%% Cross-corr matrix on pexp COS SIM
% using pexp instead of yhat from now on (very similar, pexp more directly
% comparable to full sample pexp that will be used on other studies)

% x-val GenS on each modality:  
clear x y 
x(:,1) = reshape (Pain_Avoid(:,1:4), 220,1);
x(:,2) = reshape (Pain_Avoid(:,5:8), 220,1);
x(:,3) = reshape (Pain_Avoid(:,9:12), 220,1);
x(:,4) = reshape (Pain_Avoid(:,13:16), 220,1);

y(:,1) = pexp_xval_cs (1:220,1);
y(:,2) = pexp_xval_cs (221:440,1);
y(:,3) = pexp_xval_cs (441:660,1);
y(:,4) = pexp_xval_cs (661:880,1);

clear r p
r = [];
p = [];
clear rmse
for m=1:4
    [r(1,m), p(1,m)]= corr(x(:,m), y(:,m));
    rmse(1,m) = mean((x(:,m)-y(:,m)).^2).^1/2;
    [r(1,m+4), p(1,m+4)]= corr(x(:,m), y(:,m));
    rmse(1,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% Mech 
clear y 
y(:,1) = pexp_xval_cs (1:220,2); % MechS predicting mech ratings
y(:,2) = pexp_xval_cs (221:440,2); % MechS predicting 0s for therm pain
y(:,3) = pexp_xval_cs (441:660,2); % MechS predicting 0s for av audi
y(:,4) = pexp_xval_cs (661:880,2); % MechS predicting 0s for av visual

for m=1:4
    [r(2,m), p(2,m)]= corr(x(:,m), y(:,1)); 
    rmse(2,m) = mean((x(:,m)-y(:,1)).^2).^1/2;
    [r(2,m+4), p(2,m+4)]= corr(x(:,m), y(:,m));
    rmse(2,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% Therm
clear y 
y(:,1) = pexp_xval_cs (1:220,3);
y(:,2) = pexp_xval_cs (221:440,3); % ThermS on thermal ratings 
y(:,3) = pexp_xval_cs (441:660,3);
y(:,4) = pexp_xval_cs (661:880,3);

for m=1:4
    [r(3,m), p(3,m)]= corr(x(:,m), y(:,2));
    rmse(3,m) = mean((x(:,m)-y(:,2)).^2).^1/2;
    [r(3,m+4), p(3,m+4)]= corr(x(:,m), y(:,m));
    rmse(3,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% AudS 
clear y 
y(:,1) = pexp_xval_cs (1:220,4);
y(:,2) = pexp_xval_cs (221:440,4);
y(:,3) = pexp_xval_cs (441:660,4); % AudS on audi ratings 
y(:,4) = pexp_xval_cs (661:880,4);

for m=1:4
    [r(4,m), p(4,m)]= corr(x(:,m), y(:,3));
    rmse(4,m) = mean((x(:,m)-y(:,3)).^2).^1/2;
    [r(4,m+4), p(4,m+4)]= corr(x(:,m), y(:,m));
    rmse(4,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

% VisS 
clear y 
y(:,1) = pexp_xval_cs (1:220,5);
y(:,2) = pexp_xval_cs (221:440,5);
y(:,3) = pexp_xval_cs (441:660,5);
y(:,4) = pexp_xval_cs (661:880,5); % VisS on vis ratings 

for m=1:4
    [r(5,m), p(5,m)]= corr(x(:,m), y(:,4));
    rmse(5,m) = mean((x(:,m)-y(:,4)).^2).^1/2;
    [r(5,m+4), p(5,m+4)]= corr(x(:,m), y(:,m));
    rmse(5,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;
end

%% Correlation between signatures 

% will re-define pattern values here again
% GenS for eaach modality 
clear xx yy y X
xx(:,1) = yhat (1:220,1);
xx(:,2) = yhat(221:440,1);
xx(:,3) = yhat(441:660,1);
xx(:,4) = yhat (661:880,1);

% Specific sigs for each modality
yy(:,1) = yhat (1:220,2); % Mech 
yy(:,2) = yhat (221:440,3); % Therm
yy(:,3) = yhat (441:660,4); % Aud
yy(:,4) = yhat (661:880,5); % Vis

% Gen X Spec
corr(xx(:,1),yy(:,1)) % Mech
corr(xx(:,2),yy(:,2)) % Therm
corr(xx(:,3),yy(:,3)) % Aud
corr(xx(:,4),yy(:,4)) % Vis


clear xx yy y X
% Gen model output
xx = yhat (:,1);

% Specific model outputs
yy(:,1) = yhat(:,2); % Mech 
yy(:,2) = yhat(:,3); % Therm
yy(:,3) = yhat(:,4); % Aud
yy(:,4) = yhat(:,5); % Vis

% correlation Gen & Spec
for m=1:4
[r(m), p(m)] = corr(xx,yy(:,m)) 
end

% --- very similar values with dp
% among modality-specific models
corr(yy(:,1),yy(:,2))
corr(yy(:,1),yy(:,3))
corr(yy(:,1),yy(:,4))
corr(yy(:,2),yy(:,3))
corr(yy(:,2),yy(:,4))
corr(yy(:,3),yy(:,4)) 
% all negative correlations 

% ---------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------
% ---------------------------------------------------------------------------------
%% Variance explained - consensus reached (maybe) 
%% in cc2_variance_explained.m

% ----- 
% will define values here again
clear xx yy y X
xx(:,1) = pexp_xval_dp (1:220,1);
xx(:,2) = pexp_xval_dp (221:440,1);
xx(:,3) = pexp_xval_dp (441:660,1);
xx(:,4) = pexp_xval_dp (661:880,1);

% Specific sigs for each modality
yy(:,1) = pexp_xval_dp (1:220,2); % Mech 
yy(:,2) = pexp_xval_dp (221:440,3); % Therm
yy(:,3) = pexp_xval_dp (441:660,4); % Aud
yy(:,4) = pexp_xval_dp (661:880,5); % Vis

% Overall 
figtitle=sprintf('Plot_pie_VarExpl_Overall_Study1');
create_figure(figtitle)
% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = x(:,m); % behavior
    clear X 
    X = [xx(:,m) yy(:,m)]; % pattern expression values for GenS and specific S
    r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'prediction_r2', 'noplots');
end

% can't plot since most of the var explained values are negative  

% BUT if we try this with full sample pattern weights, then we get
% sensible (positive) variance explained numbers 
% -cosine similarity only though! 

% read Poldrack's paper/python walk through on this - fairly
% straightforward explanation of why variance can be NEGATIVE when calc on
% cross-val estimates.  

%% Variance explained within 

% will define pattern values here again
% GenS for each modality 
clear xx yy y X
xx(:,1) = pexp_xval_dp (1:220,1);
xx(:,2) = pexp_xval_dp (221:440,1);
xx(:,3) = pexp_xval_dp (441:660,1);
xx(:,4) = pexp_xval_dp (661:880,1);

% Specific sigs for each modality
yy(:,1) = pexp_xval_dp (1:220,2); % Mech 
yy(:,2) = pexp_xval_dp (221:440,3); % Therm
yy(:,3) = pexp_xval_dp (441:660,4); % Aud
yy(:,4) = pexp_xval_dp (661:880,5); % Vis

figtitle=sprintf('Plot_pie_VarExpl_within_Study1');
create_figure(figtitle)
% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (within) for modality %d', m);
    y = x(:,m); % behavior
    clear X 
    X = [xx(:,m) yy(:,m) subject_id]; % pattern expression values for GenS and specific S
    r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'prediction_r2', 'noplots');
end

%% Var explained within - full column
% will define pattern values here again
% GenS for eaach modality 
clear xx yy y X
xx = pexp_xval_dp (:,1);

% Specific sigs for each modality
yy(:,1) = pexp_xval_dp (:,2); % Mech 
yy(:,2) = pexp_xval_dp (:,3); % Therm
yy(:,3) = pexp_xval_dp (:,4); % Aud
yy(:,4) = pexp_xval_dp (:,5); % Vis

% behavior
y(:,1) = avers_mat (:,2); % Mech 
y(:,2) = avers_mat (:,3); % Therm
y(:,3) = avers_mat (:,4); % Aud
y(:,4) = avers_mat (:,5); % Vis

% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [xx yy(:,m) subjects]; % subjects = 880 
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

%% Same thing with yhat 

xx = yhat(:,1);

% Specific sigs for each modality
yy(:,1) = yhat(:,2); % Mech 
yy(:,2) = yhat (:,3); % Therm
yy(:,3) = yhat (:,4); % Aud
yy(:,4) = yhat (:,5); % Vis

% behavior
y(:,1) = avers_mat (:,2); % Mech 
y(:,2) = avers_mat (:,3); % Therm
y(:,3) = avers_mat (:,4); % Aud
y(:,4) = avers_mat (:,5); % Vis

% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [xx yy(:,m) subjects]; % subjects = 880 
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

%% One x variable
% -------------------------------------------------------------------------
% General
fprintf('General variance explained (within) for modality %d', m);
y_in = y(:,1); % behavior
clear X
X = [xx subjects]; % subjects = 880
X_type = {'continuous' 'categorical'};
out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');

% Specific
for m=1:4
    fprintf('Specific variance explained (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [yy(:,m) subjects]; % subjects = 880 
    X_type = {'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

%% One x variable, per block
clear xx yy y X
xx(:,1) = yhat (1:220,1);
xx(:,2) = yhat (221:440,1);
xx(:,3) = yhat (441:660,1);
xx(:,4) = yhat (661:880,1);

% Specific sigs for each modality
yy(:,1) = yhat (1:220,2); % Mech 
yy(:,2) = yhat (221:440,3); % Therm
yy(:,3) = yhat (441:660,4); % Aud
yy(:,4) = yhat (661:880,5); % Vis

% behavior
y(:,1) = reshape (Pain_Avoid(:,1:4), 220,1);
y(:,2) = reshape (Pain_Avoid(:,5:8), 220,1);
y(:,3) = reshape (Pain_Avoid(:,9:12), 220,1);
y(:,4) = reshape (Pain_Avoid(:,13:16), 220,1);

% General
for m=1:4
    fprintf('General variance explained (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X
    X = [xx(:,m) subject_id]; % subjects = 220
    X_type = {'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

% Specific
for m=1:4
    fprintf('Specific variance explained (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [yy(:,m) subject_id]; % subjects = 220 
    X_type = {'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

%% Overall - Full columns
% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [xx yy(:,m)];
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

% ok with specific model only? 
% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [yy(:,m)];
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end

for m=1
    fprintf('Variance decomposition (within) for modality %d', m);
    y_in = y(:,m); % behavior
    clear X 
    X = [yy(:,m)];
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous'};
    out_w=canlab_variance_decomposition(y_in, X, X_type, 'prediction_r2', 'noplots');
end
% can't plot since most of the var explained values are negative  

% BUT if we try this with full sample pattern weights, then we get
% sensible (positive) variance explained numbers 


%% Variance explained using cs

% will define pattern values here again
% GenS for eaach modality 
clear xx yy y X
xx(:,1) = pexp_xval_cs (1:220,1);
xx(:,2) = pexp_xval_cs (221:440,1);
xx(:,3) = pexp_xval_cs (441:660,1);
xx(:,4) = pexp_xval_cs (661:880,1);

% Specific sigs for each modality
yy(:,1) = pexp_xval_cs (1:220,2); % Mech 
yy(:,2) = pexp_xval_cs (221:440,3); % Therm
yy(:,3) = pexp_xval_cs (441:660,4); % Aud
yy(:,4) = pexp_xval_cs (661:880,5); % Vis

figtitle=sprintf('Plot_pie_VarExpl_Overall_Study1');
create_figure(figtitle)
% -------------------------------------------------------------------------
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = x(:,m); % behavior
    clear X 
    X = [xx(:,m) yy(:,m)]; % pattern expression values for GenS and specific S
    r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'prediction_r2', 'noplots');
end

% can't plot since most of the var explained values are negative  

% BUT if we try this with full sample pattern weights, then we get
% sensible (positive) variance explained numbers 


%% Cross-corr on full sample pexp 
% Completed apply_signatures with unthresholded full-sample weight map for each modality

load(fullfile(resultsdir, 'image_names_and_setup.mat'));

% define : 
pexp_full_g = table2array(DAT.SIG_conditions.raw.dotproduct.GenS(:,1:16));
pexp_full_g = reshape (pexp_full_g, 880, 1);  

pexp_full_m = table2array(DAT.SIG_conditions.raw.dotproduct.MechS(:,1:16));
pexp_full_m = reshape (pexp_full_m, 880, 1); 

pexp_full_t = table2array(DAT.SIG_conditions.raw.dotproduct.ThermS(:,1:16));
pexp_full_t = reshape (pexp_full_t, 880, 1); 

pexp_full_a = table2array(DAT.SIG_conditions.raw.dotproduct.AudS(:,1:16));
pexp_full_a = reshape (pexp_full_a, 880, 1); 

pexp_full_v = table2array(DAT.SIG_conditions.raw.dotproduct.VisS(:,1:16));
pexp_full_v = reshape (pexp_full_v, 880, 1); 

% x-val GenS on each modality:  
clear x y 
x(:,1) = reshape (Pain_Avoid(:,1:4), 220,1);
x(:,2) = reshape (Pain_Avoid(:,5:8), 220,1);
x(:,3) = reshape (Pain_Avoid(:,9:12), 220,1);
x(:,4) = reshape (Pain_Avoid(:,13:16), 220,1);

y(:,1) = pexp_full_g(1:220,1);
y(:,2) = pexp_full_g(221:440,1);
y(:,3) = pexp_full_g(441:660,1);
y(:,4) = pexp_full_g(661:880,1);

clear r p
r = []; p = [];
for m=1:4
    [r(1,m), p(1,m)]= corr(x(:,m), y(:,m));
end

% MechS
clear y
y(:,1) = pexp_full_m(1:220,1);
y(:,2) = pexp_full_m(221:440,1);
y(:,3) = pexp_full_m(441:660,1);
y(:,4) = pexp_full_m(661:880,1);

for m=1:4
    [r(2,m), p(2,m)]= corr(x(:,m), y(:,m));
end

% ThermS
clear y
y(:,1) = pexp_full_t(1:220,1);
y(:,2) = pexp_full_t(221:440,1);
y(:,3) = pexp_full_t(441:660,1);
y(:,4) = pexp_full_t(661:880,1);

for m=1:4
    [r(3,m), p(3,m)]= corr(x(:,m), y(:,m));
end

%AudS
clear y
y(:,1) = pexp_full_a(1:220,1);
y(:,2) = pexp_full_a(221:440,1);
y(:,3) = pexp_full_a(441:660,1);
y(:,4) = pexp_full_a(661:880,1);

for m=1:4
    [r(4,m), p(4,m)]= corr(x(:,m), y(:,m));
end

%VisS
clear y
y(:,1) = pexp_full_v(1:220,1);
y(:,2) = pexp_full_v(221:440,1);
y(:,3) = pexp_full_v(441:660,1);
y(:,4) = pexp_full_v(661:880,1);

for m=1:4
    [r(5,m), p(5,m)]= corr(x(:,m), y(:,m));
end

% r =
% 
%     0.9415    0.9492    0.9523    0.9453
%     0.9234   -0.0447    0.3522    0.0490
%     0.2956    0.9322    0.1691    0.1623
%     0.4397    0.4527    0.9436    0.1176
%     0.0300    0.0842    0.1007    0.9551
% 
% 
% p =
% 
%     0.0000    0.0000    0.0000    0.0000
%     0.0000    0.5093    0.0000    0.4698
%     0.0000    0.0000    0.0120    0.0160
%     0.0000    0.0000    0.0000    0.0817
%     0.6585    0.2137    0.1365    0.0000


