%% Signature sensitivity - within and between in one simple script

% How well does sig predict behavior? r observed vs. predicted 

% (1) within-subject prediction 
%       r = averaged within-subj r values
%       p = bootstrapped r values 

% (2) between-subject prediction 
%       r = across subjects' mean ratings (avg across levels 1-4) 
%       p =  ^ 

% (3) across all observations  
%       r = simply across all obs (220 per modality = 55 subj x 4 levels) 
%       p = across all obs 

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%% Load files 
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

% TablePLS=table(avers_mat, yhat, subjects); % ratings, predicted ratings, subject IDs 
subject_id=repmat(1:55,1,4)'
import_Behav_MPA2;

bl=size(subject_id,1); % 220 = 55 subjects x 4 levels 

%% Reorganize variables  
% -------------------------------------------------------------------------
clear yy yhatGS yhatG yhatS 

% avers_mat = observed ratings
% -------------------------------------------------------------------------
yy(:,1) = avers_mat(1:bl,1);
yy(:,2) = avers_mat(bl+1:2*bl,1);
yy(:,3) = avers_mat(2*bl+1:3*bl,1);
yy(:,4) = avers_mat(3*bl+1:4*bl,1);

% Combine Yhat G and S into one var
% -------------------------------------------------------------------------
yhatGS(:,:,1) = yhat(1:bl,1:2); % Mech 
yhatGS(:,:,2) = yhat(bl+1:2*bl,[1,3]); % Therm
yhatGS(:,:,3) = yhat(2*bl+1:3*bl,[1,4]); % Aud
yhatGS(:,:,4) = yhat(3*bl+1:4*bl,[1,5]); % Vis


%% (1) within-subject 
% Define variables
% -------------------------------------------------------------------------
 
Mech = Pain_Avoid(:,1:4);
Therm = Pain_Avoid(:,5:8);
Aud = Pain_Avoid(:,9:12);
Vis = Pain_Avoid(:,13:16);

YhatGM = reshape (yhat(1:bl,1), 55,4);
YhatSM = reshape (yhat(1:bl,2), 55,4);

YhatGT = reshape (yhat(bl+1:2*bl,1), 55,4);
YhatST = reshape (yhat(bl+1:2*bl,3), 55,4);

YhatGA = reshape (yhat(2*bl+1:3*bl,1), 55,4);
YhatSA = reshape (yhat(2*bl+1:3*bl,4), 55,4);

YhatGV = reshape (yhat(3*bl+1:4*bl,1), 55,4);
YhatSV = reshape (yhat(3*bl+1:4*bl,5), 55,4);

clear Y XG XS XX
for i = 1:55
    
    % avoidance rating
    Y{1}{i} = Mech(i, :)';
    Y{2}{i} = Therm(i, :)';
    Y{3}{i} = Aud(i, :)';
    Y{4}{i} = Vis(i, :)';
   
    % yhat ratings
    XG{1}{i} = YhatGM(i, :)';
    XG{2}{i} = YhatGT(i, :)';
    XG{3}{i} = YhatGA(i, :)';
    XG{4}{i} = YhatGV(i, :)';
    
    XS{1}{i} = YhatSM(i, :)';
    XS{2}{i} = YhatST(i, :)';
    XS{3}{i} = YhatSA(i, :)';
    XS{4}{i} = YhatSV(i, :)';

end

% ------------------------------------------------------------------------
for m=1:4
    [rG_within{m}] = cellfun(@corr, Y{m},XG{m});
    [rS_within{m}] = cellfun(@corr, Y{m},XS{m});
    Avg_rG{m} = nanmean (rG_within{m});
    Avg_rS{m} = nanmean (rS_within{m});
end

% Average within-subj corr pred and observed 
% ------------------------------------------------------------------------
% Avg_rG = [0.4276]    [0.6643]    [0.3125]    [0.4872]
% Avg_rS = [0.2542]    [0.5965]    [0.3830]    [0.6366]
% 
% 
%% P-values derived from boostrapping r values
% ------------------------------------------------------------------------

% MAKE SURE BS = 10,000! 
clear p z 
for m = 1:4;
    x = rG_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(1,m), z(1,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = rS_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(2,m), z(2,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end

% p
%     0.0005    0.0014    0.0004    0.0009
%     0.0043    0.0012    0.0003    0.0011
% 
% z
%     3.4838    3.1639    3.5318    3.3320
%     2.8586    3.2498    3.6002    3.2605


%% RMSE average within-subject
% ------------------------------------------------------------------------

%    rmse(2,m+4) = mean((x(:,m)-y(:,m)).^2).^1/2;

% step by step (cross-checked against @(x) below)
%     [rG_sqerr{m}] = cellfun(@(x) x.^2, rG_err{m},'UniformOutput',false);
%     [rG_msqerr{m}] = cellfun(@mean, rG_sqerr{m},'UniformOutput',false);
%     [rG_rmse1{m}] = cellfun(@sqrt, rG_msqerr{m},'UniformOutput',false);
    %mean_rG_rmse1{m} = nanmean(rG_rmse1{m});

% DOUBLE CHECK THIS: 
clear rG_err rG_rmse mean_rG_rmse
for m=1:4
    [rG_err{m}] = cellfun(@minus, Y{m}, XG{m},'UniformOutput',false);
    [rG_rmse{m}] = cellfun(@(x) sqrt(mean(x.^2)), rG_err{m});
    mean_rG_rmse{m} = nanmean(rG_rmse{m})
    
end

clear rS_err rS_rmse mean_rS_rmse
for m=1:4
    [rS_err{m}] = cellfun(@minus, Y{m}, XS{m}, 'UniformOutput',false);
    [rS_rmse{m}] = cellfun(@(x) sqrt(mean(x.^2)), rS_err{m});
    mean_rS_rmse{m} = nanmean(rS_rmse{m});
end

% If I also want to report NRMSE, I can use goodnessOfFit.m
test2RMSE=goodnessOfFit(testy,testYhat,'NRMSE');
  'NRMSE': FIT(i) = 1 - (norm(XREF(:,i)-X(:,i)))/(norm(XREF(:,i)-mean(XREF(:,i))))

  clear rG_nerr rG_nrmse mean_rG_nrmse
for m=1:4
    [rG_err{m}] = cellfun(@minus, Y{m}, XG{m},'UniformOutput',false);
    [rG_nerr{m}] = cellfun(@norm, rG_err{m} ,'UniformOutput',false);
    [rG_ny{m}] = cellfun(@norm, Y{m},'UniformOutput',false);
    [rG_my{m}] = cellfun(@mean, Y{m},'UniformOutput',false);
    [rG_nymy{m}] = cellfun(@minus, rG_ny{m}, rG_my{m},'UniformOutput',false);
    [rG_nrmse{m}] = cellfun(@(x,y) 1-(x./y), rG_nerr{m}, rG_nymy{m},'UniformOutput',false);
    %mean_rG_nrmse{m} = nanmean(rG_nrmse{m})
    
end

% 

%% (2) Between-subject
% ------------------------------------------------------------------------
clear yyy xG xS
for m=1:4
yyy(:,m)=mean(reshape(yy(:,m),55,4),2);
xG(:,m) = mean(reshape(yhatGS(:,1,m),55,4),2);
xS(:,m) = mean(reshape(yhatGS(:,2,m),55,4),2);
xGS(:,:,m) = [xG(:,m) xS(:,m)]; 
end

clear rb 
for m=1:4;
[rb(m) pb(m)]=corr(yyy(:,m),xGS(:,1,m));
[rb(m+4) pb(m+4)]=corr(yyy(:,m),xGS(:,2,m));
end
% 
% rb = 0.5739    0.2433    0.2295    0.1855    0.1244    0.2653    0.0253    0.1508
% pb = 0.0000    0.0734    0.0918    0.1751    0.3655    0.0502    0.8546    0.2719

% Cross-checked w/ values obtained using line_plot_multisubj
%% (3) Across all obs
% ------------------------------------------------------------------------
clear r
for m=1:4;
    % General 
[r(m), p(m)]=corr(yy(:,m),yhatGS(:,1,m));
    % Specific 
[r(m+4), p(m+4)]=corr(yy(:,m),yhatGS(:,2,m));
end

% r = 0.5569    0.3899    0.2212    0.2623    0.1629    0.3653    0.0510    0.2482
% p = 0.0000    0.0000    0.0010    0.0001    0.0156    0.0000    0.4518    0.0002
% 
 

%% The effect of z-scoring and removing mean on overall correlations
clear r p
for m=1:4
    [wasnan1, Y{m}]= cellfun(@nanremove, Y{m}, 'UniformOutput', false);
    [wasnan1, XG{m}]= cellfun(@nanremove, XG{m}, 'UniformOutput', false);
    [wasnan1, XS{m}]= cellfun(@nanremove, XS{m}, 'UniformOutput', false);
    
    % no transformation of input values
    Yc{m} = cat(1, Y{m}{:});     
    XGc{m} = cat(1, XG{m}{:});
    XSc{m} = cat(1, XS{m}{:});
    
    [r(m,1),p(m,1)]=corr(Yc{m},XGc{m});
    [r(m+4,1),p(m+4,1)]=corr(Yc{m},XSc{m});
   
    % z-scoring
    Yz{m} = cellfun(@scale, Y{m}, 'UniformOutput', false);
    XGz{m} = cellfun(@scale, XG{m}, 'UniformOutput', false);
    XSz{m} = cellfun(@scale, XS{m}, 'UniformOutput', false);
    
    Yzc{m} = cat(1, Yz{m}{:});     
    XGzc{m} = cat(1, XGz{m}{:});
    XSzc{m} = cat(1, XSz{m}{:});
   
    [r(m,2),p(m,2)]=corr(Yzc{m},XGzc{m});
    [r(m+4,2),p(m+4,2)]=corr(Yzc{m},XSzc{m});

    % centering (removing mean) 
    Yc{m} = cellfun(@scale, Y{m}, 'UniformOutput', false);
    XGc{m} = cellfun(@scale, XG{m}, 'UniformOutput', false);
    XSc{m} = cellfun(@scale, XS{m}, 'UniformOutput', false);
    
    Ycc{m} = cat(1, Yc{m}{:});     
    XGcc{m} = cat(1, XGc{m}{:});
    XScc{m} = cat(1, XSc{m}{:});
   
    [r(m,3),p(m,3)]=corr(Ycc{m},XGcc{m});
    [r(m+4,3),p(m+4,3)]=corr(Ycc{m},XScc{m});

end    


%% CROSS-PREDICTIONS - 

%% Reorganize variables  
% -------------------------------------------------------------------------
clear yy yhatGS yhatG yhatS 

% avers_mat = observed ratings
% -------------------------------------------------------------------------
yy(:,1) = avers_mat(1:bl,1);
yy(:,2) = avers_mat(bl+1:2*bl,1);
yy(:,3) = avers_mat(2*bl+1:3*bl,1);
yy(:,4) = avers_mat(3*bl+1:4*bl,1);

% YhatCross for each
% -------------------------------------------------------------------------
clear yhatSC 
yhatSC(:,:,1) = yhat(1:bl, [2:5]); % Mech on self and others 
yhatSC(:,:,2) = yhat(bl+1:2*bl, [2:5]); % Therm on self and others
yhatSC(:,:,3) = yhat(2*bl+1:3*bl, [2:5]); % Audi on self and others
yhatSC(:,:,4) = yhat(3*bl+1:4*bl, [2:5]); % Vis on self and others


%% (1) within-subject 
% Define variables
% -------------------------------------------------------------------------
 
Mech = Pain_Avoid(:,1:4);
Therm = Pain_Avoid(:,5:8);
Aud = Pain_Avoid(:,9:12);
Vis = Pain_Avoid(:,13:16);
% 
% for m=1:4
% YhatSM(:,:,m) = reshape (yhat(1:bl,m+1), 55,4);
% end
YhatSMM = reshape (yhat(1:bl,2), 55,4);
YhatSMT = reshape (yhat(1:bl,3), 55,4);
YhatSMA = reshape (yhat(1:bl,4), 55,4);
YhatSMV = reshape (yhat(1:bl,5), 55,4);

YhatSTM = reshape (yhat(bl+1:2*bl,2), 55,4);
YhatSTT = reshape (yhat(bl+1:2*bl,3), 55,4);
YhatSTA = reshape (yhat(bl+1:2*bl,4), 55,4);
YhatSTV = reshape (yhat(bl+1:2*bl,5), 55,4);

YhatSAM = reshape (yhat(2*bl+1:3*bl,2), 55,4);
YhatSAT = reshape (yhat(2*bl+1:3*bl,3), 55,4);
YhatSAA = reshape (yhat(2*bl+1:3*bl,4), 55,4);
YhatSAV = reshape (yhat(2*bl+1:3*bl,5), 55,4);

YhatSVM = reshape (yhat(3*bl+1:4*bl,2), 55,4);
YhatSVT = reshape (yhat(3*bl+1:4*bl,3), 55,4);
YhatSVA = reshape (yhat(3*bl+1:4*bl,4), 55,4);
YhatSVV = reshape (yhat(3*bl+1:4*bl,5), 55,4);

clear Y XSM XST XSA XSV
for i = 1:55
    
    % avoidance rating
    Y{1}{i} = Mech(i, :)';
    Y{2}{i} = Therm(i, :)';
    Y{3}{i} = Aud(i, :)';
    Y{4}{i} = Vis(i, :)';
   
    % yhat rating XSM
    XSM{1}{i} = YhatSMM(i, :)';
    XSM{2}{i} = YhatSMT(i, :)';
    XSM{3}{i} = YhatSMA(i, :)';
    XSM{4}{i} = YhatSMV(i, :)';
       
    % yhat rating XST
    XST{1}{i} = YhatSTM(i, :)';
    XST{2}{i} = YhatSTT(i, :)';
    XST{3}{i} = YhatSTA(i, :)';
    XST{4}{i} = YhatSTV(i, :)';

    % yhat rating XSA
    XSA{1}{i} = YhatSAM(i, :)';
    XSA{2}{i} = YhatSAT(i, :)';
    XSA{3}{i} = YhatSAA(i, :)';
    XSA{4}{i} = YhatSAV(i, :)';

    % yhat rating XSV
    XSV{1}{i} = YhatSVM(i, :)';
    XSV{2}{i} = YhatSVT(i, :)';
    XSV{3}{i} = YhatSVA(i, :)';
    XSV{4}{i} = YhatSVV(i, :)';
end

% ------------------------------------------------------------------------
for m=1:4
    [rSM_within{m}] = cellfun(@corr, Y{m},XSM{m});
    Avg_rSM{m} = nanmean (rSM_within{m})
    
    [rST_within{m}] = cellfun(@corr, Y{m},XST{m});
    Avg_rST{m} = nanmean (rST_within{m})
    
    [rSA_within{m}] = cellfun(@corr, Y{m},XSA{m});
    Avg_rSA{m} = nanmean (rSA_within{m})
    
    [rSV_within{m}] = cellfun(@corr, Y{m},XSV{m});
    Avg_rSV{m} = nanmean (rSV_within{m})
end

% Average within-subj corr pred and observed 
% -----------------------------------------------------------------------
%    [0.2542]    [0.0394]    [0.1876]    [-0.1183]
%    [-0.0714]    [0.5965]    [0.0760]    [0.2073]
% [0.1660]    [-0.0681]    [0.3830]    [0.0619]
% [-0.0648]    [0.1337]    [0.0633]    [0.6366]

%% P-values derived from boostrapping r values
% ------------------------------------------------------------------------

% MAKE SURE BS = 10,000! 
clear p z 
for m = 1:4;
    x = rSM_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(1,m), z(1,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = rST_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(2,m), z(2,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = rSA_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(3,m), z(3,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
    
    x = rSV_within{m}';
    stat = nanmean (x);
    bootstat = bootstrp(10000, @nanmean, x);
    [p(4,m), z(4,m)] = bootbca_pval(0, @nanmean, bootstat,stat, x);
end

% p =
% 
%   4×4 single matrix
% 
%     0.0023    0.6094    0.0203    0.1339
%     0.3878    0.0012    0.3275    0.0049
%     0.0534    0.3666    0.0003    0.4698
%     0.4611    0.1203    0.4585    0.0009

%% Cross-pred matrix figure 
Avg_r_within = [Avg_rG; Avg_rSM; Avg_rST; Avg_rSA; Avg_rSV];
Avg_r_wtn = cell2mat (Avg_r_within);

%     0.4276    0.6643    0.3125    0.4872
%     0.2542    0.0394    0.1876   -0.1183
%    -0.0714    0.5965    0.0760    0.2073
%     0.1660   -0.0681    0.3830    0.0619
%    -0.0648    0.1337    0.0633    0.6366


models = {'GenS' 'MechS' 'ThermS' 'AudS' 'VisS'};

clear toplot
toplot=Avg_r_wtn

figtitle = sprintf('Cross-prediction for fig');
create_figure(figtitle);
imagesc(toplot);
ylabel 'Observed - Predicted Ratings Corr'
set(gca,'XTick', 1:4, 'XTickLabels', {'Mech' 'Therm' 'Aud' 'Vis'},  'fontsize', 18, 'XTickLabelRotation', 45);
nmodels=5
set(gca,'YDir', 'reverse','YTick', 1:nmodels, 'YTickLabels', models);

colorbar
cm = colormap_tor([1 1 1],[0.6 0 0],[1 0 0]);
colormap(cm)
caxis([0 0.67])

% Transfer loss
TM = Avg_r_wtn % Transfer matrix
for m=1:4
% Gen (1st row)
T_Loss(1,m)= TM(1,m)/TM(m+1,m);
% Spec rows 
T_Loss(2,m)= TM(2,m)/TM(2,1);
T_Loss(3,m)= TM(3,m)/TM(3,2);
T_Loss(4,m)= TM(4,m)/TM(4,3);
T_Loss(5,m)= TM(5,m)/TM(5,4);
end

%     1.6826    1.1136    0.8158    0.7653
%     1.0000    0.1549    0.7382   -0.4654
%    -0.1197    1.0000    0.1275    0.3476
%     0.4333   -0.1779    1.0000    0.1616
%    -0.1017    0.2101    0.0995    1.0000

% T_Loss_Percent 

for m=1:4
% Gen (1st row)
T_LossP(1,m)= ((TM(1,m)/TM(m+1,m))*100)-100;
% Spec rows 
T_LossP(2,m)= ((TM(2,m)/TM(2,1))*100)-100;
T_LossP(3,m)= ((TM(3,m)/TM(3,2))*100)-100;
T_LossP(4,m)= ((TM(4,m)/TM(4,3))*100)-100;
T_LossP(5,m)= ((TM(5,m)/TM(5,4))*100)-100;
end

T_LossP=round(T_LossP)
