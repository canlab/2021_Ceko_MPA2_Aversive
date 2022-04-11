
%% VARIANCE EXPLAINED VIA MULTIPLE REGRESSION OF WITHIN-MODALITY PLS OUTCOMES 

%% Question:
%% When we let the General and Specific models compete, 
%% how much variance in behavior does each model explain?

% In  regression terms, our predictors are the cross-validated models (yhats) and 
% our response is the observed rating (avers_mat)

% Here, we will look at the 'within modality = block' or 'on-target' ratings 
% (and the associated model values) only, so NOT full columns (for full columns see
% further below under 'Older analyses')

% NOTES: 

% The analysis is run in two main ways: 
% I. PER MODALITY, ACROSS SUBJECTS
% II. PER MODALITY, WITHIN SUBJECTS (start at ~line 350) ---> this is reported in the paper; it decomposes variance
% in each participants separately and then averages the resulting values across participants. 


% In both cases (I. and II.), the analysis is my own replication of the 
% Commonality Analysis (CA) in R (Nimon et al. 2008)
% which calculates the WITHIN-PARTICIPANT variance decomposition. 
% The results are cross-checked against the R package, as reported below. 

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% General approach:
%% Compute and partition variance explained using full and reduced regression models
% -------------------------------------------------------------------------
% For X1 (Gen) and X2 (Spec) predicting Y (ratings):

% (1) Total Variance = R2 from multiple regression (see output 'stats' from regress.m)
%       --- > compute using regress.m

% (2) Single Variance X1 = r2 from single regression -- OR VIA CORRELATION, SEE BELOW
%     Single Variance X2 = r2 from single regression -- OR VIA CORRELATION, SEE BELOW
%       --- > compute using the \ operator .. or do Pearson, see below 

% (3) Unique Variance for X1 = Total V - Single V for X2
%     Unique Variance for X2 = Total V - Single V for X1

% (4) Shared Variance between X1 and X2 = Total V - Unique V(X1) - Unique V(X2)

% -------------------------------------------------------------------------
% Multiple regression intro (from regress.m):
%   B = REGRESS(Y,X) returns the vector B of regression coefficients in the
%   linear model Y = X*B.  X is an n-by-p design matrix, with rows
%   corresponding to observations and columns to predictor variables.  Y is
%   an n-by-1 vector of response observations.

%   X should include a column of ones so that the model contains a constant
%   term.  The F statistic and p value are computed under the assumption
%   that the model contains a constant term, and they are not correct for
%   models without a constant.  The R-square value is one minus the ratio of
%   the error sum of squares to the total sum of squares.  This value can
%   be negative for models without a constant, which indicates that the
%   model is not appropriate for the data.

%% Load files 
% -------------------------------------------------------------------------
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

subject_id=repmat(1:55,1,4)';
% Contrast maps 
% 1 per stim level per cond - each contrast map is averaged over XX trials for that stim level
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';

TablePLS=table(avers_mat, yhat, subjects); % ratings, predicted ratings, subject IDs 

import_Behav_MPA2;

bl=size(subject_id,1); % 220 = 55 subjects x 4 levels 

%% -------------------------------------------------------------------------
%% I. PER MODALITY, ACROSS SUBJECTS 
%% -------------------------------------------------------------------------

%% Define variables for regression 
% -------------------------------------------------------------------------
clear yy yhatGS yhatG yhatS 

% Define Y = avers_mat = observed ratings
% -------------------------------------------------------------------------
yy(:,1) = avers_mat(1:bl,1);
yy(:,2) = avers_mat(bl+1:2*bl,1);
yy(:,3) = avers_mat(2*bl+1:3*bl,1);
yy(:,4) = avers_mat(3*bl+1:4*bl,1);

% Define X = predictors = yhat 
% -------------------------------------------------------------------------
% including intercept (a column of ones) so that the 'stats' output of regress.m 
% behaves correctly and gives me an R2 for multiple regression, 

% [1   X1 = Gen   X2 = Spec] for multiple regression:
yhatGS(:,:,1) = [ones(bl,1) yhat(1:bl,1:2)]; % Mech 
yhatGS(:,:,2) = [ones(bl,1) yhat(bl+1:2*bl,[1,3])]; % Therm
yhatGS(:,:,3) = [ones(bl,1) yhat(2*bl+1:3*bl,[1,4])]; % Aud
yhatGS(:,:,4) = [ones(bl,1) yhat(3*bl+1:4*bl,[1,5])]; % Vis

% Correlation between predictors for each modality
for m=1:4
CorrPreds(:,m)=corr(yhatGS(:,2,m),yhatGS(:,3,m)) 
end

% CorrPreds  0.2459    0.8516    0.3460    0.5348
% 

%% (1) Total variance via multiple regression 
% -------------------------------------------------------------------------
clear b stats
for m=1:4;
[b(:,m),~,~,~,stats(:,:,m)]=regress(yy(:,m), yhatGS(:,:,m));
end

% b = 
%     0.0304    0.1194    0.1909    0.0962
%     0.8919    0.5713    0.4742    0.3261
%     0.0682    0.2277   -0.0714    0.3614

% stats contains the R2 statistic, the F-statistic and its p-value, and an estimate of the error variance
% stats(:,:,1) =
%     0.3108   48.9297    0.0000    0.0258
% stats(:,:,2) =
%     0.1560   20.0609    0.0000    0.0495
% stats(:,:,3) =
%     0.0497    5.6698    0.0040    0.0420
% stats(:,:,4) =
%     0.0851   10.0970    0.0001    0.0412

%% (2)  'Single' variance for each X via simple regressions
% ------------------------------------------------------------------------
% least squares regression b = x\y  ---> y = b*x

% Simple regression for GENERAL model
% ------------------------------------------------------------------------
clear b ycalc
for m=1:4;
    b(m)=yhatGS(:,2,m)\yy(:,m);
    ycalc(:,m)=yhatGS(:,2,m)*b(m);
    r2G(m) = 1 - sum((yy(:,m) - ycalc(:,m)).^2)/sum((yy(:,m) - mean(yy(:,m))).^2);
end

% r2G =
%    0.3011861   0.1233491  -0.0301234  -0.0220811
% Here we go again with the negative r2 values ... 

% Simple regression for SPECIFIC model
% ------------------------------------------------------------------------
clear b ycalc
for m=1:4;
    b(m)=yhatGS(:,3,m)\yy(:,m);
    ycalc(:,m)=yhatGS(:,3,m)*b(m);
    r2S(m) = 1 - sum((yy(:,m) - ycalc(:,m)).^2)/sum((yy(:,m) - mean(yy(:,m))).^2);
end
% r2S =
%   -0.1156297   0.0497595  -0.1282398   0.0323917

% How does this compare to r / r2 derived from correlations? 
% ------------------------------------------------------------------------
clear r2
for m=1:4;
[r2(m)]=(corr(yy(:,m),yhatGS(:,2,m))).^2;
[r2(m+4)]=(corr(yy(:,m),yhatGS(:,3,m))).^2; 
end

% r (1-4 are for General, 5-8 are for Specific): 
%    0.5568549   0.3898835   0.2211778   0.2623456   0.1628568   0.3653140   0.0509849   0.2482206
% r2 (1-4 are for General, 5-8 are for Specific): 
%    0.3100874   0.1520092   0.0489196   0.0688252   0.0265223   0.1334543   0.0025995   0.0616135


%% Partition variance into constituents: unique, shared(common)
% ------------------------------------------------------------------------
% (3) Unique Variance for X1 (Gen) = Total V - Single V for X2
%     Unique Variance for X2 (Spec) = Total V - Single V for X1
% (4) Shared Variance between X1 and X2 = Total V - Unique V(X1) - Unique V(X2)

%(1) Total Variance 
% stats(:,1,1) = 0.3108
% stats(:,1,2) = 0.1560 
% stats(:,1,3) = 0.0497    
% stats(:,1,4) = 0.0851   

% (2) Single Variance 
% X1 = r2G = 0.3011861   0.1233491  -0.0301234  -0.0220811
% X2 = r2S = -0.1156297   0.0497595  -0.1282398   0.0323917

% (3) Unique Variance (UVG, UVS)
% (4) Shared Variance (SVGS)
% clear UVG UVS SVGS
% for m=1:4;
%     UVG(m) = stats(:,1,m) - r2S(m); % Unique for X1
%     UVS(m) = stats(:,1,m) - r2G(m); % Unique for X2
%     SVGS(m) = stats(:,1,m) - UVG(m) - UVS(m);
% end

% Answers: 
% UVG = 0.4264332   0.1062825   0.1779007   0.0527452
% UVS =  0.0096174   0.0326929   0.0797843   0.1072181
% SVGS = -0.1252471   0.0170666  -0.2080240  -0.0748264

%% Unique and Shared based on single variances defined as correlation r2
% ------------------------------------------------------------------------
% Single variances 
% r2 (1-4 are for General, 5-8 are for Specific): 
%    0.3100874   0.1520092   0.0489196   0.0688252   0.0265223   0.1334543   0.0025995   0.0616135

clear UVG UVS SVGS
for m=1:4;
    UVG(m) = stats(:,1,m) - r2(m+4); % Unique for X1
    UVS(m) = stats(:,1,m) - r2(m); % Unique for X2
    SVGS(m) = stats(:,1,m) - UVG(m) - UVS(m);
end

% Answers: 
% UVG = 0.2842812   0.0225877   0.0470615   0.0235235
% UVS = 0.0007161   0.0040328   0.0007413   0.0163117
% SVGS = 0.0258062   0.1294215   0.0018581   0.0453018

for m=1:4
    Total(1,m)=stats(:,1,m)
end

%% --------------------------------------------------------------------- %%
%% Answers using Commonality Analysis (yhat package in R)
% = SAME OUTPUTS as common/unique calculated via correlation r2 values!

% UVG =  0.2843 0.0226 0.0471 0.0235
% UVS =  0.0007 0.0040  0.0007 0.0163
% SVGS = 0.0258 0.1294 0.0019 0.0453
% Total = 0.3108 0.1560 0.0497 0.0851

%% Plot  --------------------------------------------------------------------- %%
figtitle=sprintf('Plot_PIE_VAREXPLAINED_MULTIPLE_REG');
create_figure(figtitle)

cols = [0.4 0.4 0.4 % Unique to Gen
    1 1 0 % Unique to Spec
    0.8 0.8 0.6] % Shared
    
for m=1:4;
    subplot(2,4,m);
    piedata = double([UVG(1,m) UVS(1,m) SVGS(1,m)])*100; % *100 bc SUM has to be >1 for pie to plot RELATIVE percentage
    h = wani_pie(piedata, 'cols',cols, 'fontsize', 8, 'hole', 'hole_size', 500,'notext');
end

plugin_save_figure;

%% Plot  --------------------------------------------------------------------- %%
figtitle=sprintf('Plot_PIE_WPERCENT_VAREXPLAINED_MULTIPLE_REG');
create_figure(figtitle)

cols = [0.4 0.4 0.4 % Unique to Gen
    1 1 0 % Unique to Spec
    0.8 0.8 0.6] % Shared
    
for m=1:4;
    subplot(2,4,m);
    piedata = double([UVG(1,m) UVS(1,m) SVGS(1,m)])*100; % *100 bc SUM has to be >1 for pie to plot RELATIVE percentage
    h = wani_pie(piedata, 'cols',cols, 'fontsize', 8, 'hole', 'hole_size', 500);
end

plugin_save_figure;

%% --------------------------------------------------------------------- %%
%% Using full yhat instead of cross-validated yhat 
% [1   X1 = Gen   X2 = Spec] for multiple regression:
yhatfullGS(:,:,1) = [ones(bl,1) yhatfull(1:bl,1:2)]; % Mech 
yhatfullGS(:,:,2) = [ones(bl,1) yhatfull(bl+1:2*bl,[1,3])]; % Therm
yhatfullGS(:,:,3) = [ones(bl,1) yhatfull(2*bl+1:3*bl,[1,4])]; % Aud
yhatfullGS(:,:,4) = [ones(bl,1) yhatfull(3*bl+1:4*bl,[1,5])]; % Vis

% Total variance = multiple regression
% ------------------------------------------------------------------------
clear b stats
for m=1:4;
[b(:,m),~,~,~,stats(:,:,m)]=regress(yy(:,m), yhatfullGS(:,:,m));
end

% Simple variances via r / r2 from correlations 
% ------------------------------------------------------------------------
clear r2
for m=1:4;
[r2(m)]=(corr(yy(:,m),yhatfullGS(:,2,m))).^2;
[r2(m+4)]=(corr(yy(:,m),yhatfullGS(:,3,m))).^2; 
end

% Partition variance 
clear UVG UVS SVGS % Unique General, Unique Specific, Shared 
% ------------------------------------------------------------------------
for m=1:4;
    UVG(m) = stats(:,1,m) - r2(m+4); % Unique for X1
    UVS(m) = stats(:,1,m) - r2(m); % Unique for X2
    SVGS(m) = stats(:,1,m) - UVG(m) - UVS(m);
end

% UVG = 0.0579    0.0370    0.0389    0.0178
% UVS = 0.0269    0.0100    0.0212    0.0286
% SVGS = 0.8325    0.8755    0.8837    0.8934
% Total = 0.9174    0.9225    0.9438    0.9397 
% 

%% Back to cross-validated: Var explained computations on between-subject correlations

% Why do between-subject? 
% To evaluate the model performance in predicting between-individual variation in negative affect ratings, 
% we computed the predicted average ratings of each condition across individuals. 

clear yyy xG xS
for m=1:4
yyy(:,m)=mean(reshape(yy(:,m),55,4),2);
xG(:,m) = mean(reshape(yhatGS(:,2,m),55,4),2);
xS(:,m) = mean(reshape(yhatGS(:,3,m),55,4),2);
xGS(:,:,m) = [ones(55,1) xG(:,m) xS(:,m)]; 
end

% Total variance via Mutliple reg
clear b stats
for m=1:4;
[b(:,m),~,~,~,stats(:,:,m)]=regress(yyy(:,m), xGS(:,:,m));
end

% Single variances via correlation
clear rb rb2
for m=1:4;
[rb(m) pb(m)]=corr(yyy(:,m),xGS(:,2,m));
[rb(m+4) pb(m+4)]=corr(yyy(:,m),xGS(:,3,m));
[rb2(m)]=(corr(yyy(:,m),xGS(:,2,m))).^2;
[rb2(m+4)]=(corr(yyy(:,m),xGS(:,3,m))).^2; 
end
% 

% rb = 0.5739    0.2433    0.2295    0.1855    0.1244    0.2653    0.0253    0.1508
% pb = 0.0000    0.0734    0.0918    0.1751    0.3655    0.0502    0.8546    0.2719
%    r2 =  0.3294    0.0592    0.0527    0.0344    0.0155    0.0704    0.0006    0.0227
% % 

clear UVG UVS SVGS
for m=1:4;
    UVG(m) = stats(:,1,m) - r2(m+4); % Unique for X1
    UVS(m) = stats(:,1,m) - r2(m); % Unique for X2
    SVGS(m) = stats(:,1,m) - UVG(m) - UVS(m);
end

% Answers: 
% UVG = 0.3151    0.0010    0.0561    0.0157
% UVS = 0.0012    0.0122    0.0040    0.0040
% SVGS = 0.0143    0.0582   -0.0034    0.0187
% Total = 0.3306   0.0714 . 0.0567 . 0.0384


%% -------------------------------------------------------------------------
%% II. PER MODALITY, WITHIN SUBJECTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -------------------------------------------------------------------------

% ----- THIS IS REPORTED IN THE PAPER -------------------------------------

% Define variables for regression 
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
    
    % for multiple regression
    XX{1}{i}= [ones(4,1) XG{1}{i} XS{1}{i}];
    XX{2}{i}= [ones(4,1) XG{2}{i} XS{2}{i}];
    XX{3}{i}= [ones(4,1) XG{3}{i} XS{3}{i}];
    XX{4}{i}= [ones(4,1) XG{4}{i} XS{4}{i}];
end


% Total variance per subject = multiple regression per subject
% ------------------------------------------------------------------------
clear stats
for m=1:4;
    for i=1:55;
        %[b(:,m),~,~,~,stats(:,i,m)]=regress(YY{m}{i},XX{m}{i})
        [~,~,~,~,stats(:,m,i)] = regress(Y{m}{i},XX{m}{i});
        multreg_per_subject{m}(i)= stats(1,m,i);
    end
end


% Simple variances per subject via r / r2 from correlations per subject
% ------------------------------------------------------------------------
for m=1:4
    [rG_within{m}] = cellfun(@corr, Y{m},XG{m});
    [rS_within{m}] = cellfun(@corr, Y{m},XS{m});
    r2G_within{m} = (rG_within{m}).^2
    r2S_within{m} = (rS_within{m}).^2
end


% Partition variance 
clear UVG UVS SVGS % Unique General, Unique Specific, Shared 
clear mTotal mUVG mUVS mSVGS 
% ------------------------------------------------------------------------
for m=1:4;
    UVG{m} = multreg_per_subject{m} - r2S_within{m};
    UVS{m} = multreg_per_subject{m} - r2G_within{m};
    SVGS{m}= multreg_per_subject{m} - UVG{m} - UVS{m};
    
    mTotal(m) = nanmean(multreg_per_subject{m})
    mUVG(m) = nanmean(UVG{m})
    mUVS(m) = nanmean(UVS{m})
    mSVGS(m) = nanmean(SVGS{m})
end

% mUVG = 0.3252    0.3063    0.3384    0.2066
% mUVS = 0.3428    0.2313    0.2934    0.3215
% mSVGS = 0.0951    0.3223    0.0463    0.2460
% mTotal = 0.7632    0.8599    0.6781    0.7741



%% Plot  --------------------------------------------------------------------- %%
figtitle=sprintf('Plot_PIE_WITHIN_VAREXPLAINED_MULTIPLE_REG');
create_figure(figtitle)

% cols = [0.4 0.4 0.4 % Unique to Gen
%     1 1 0 % Unique to Spec
%     0.8 0.8 0.6 % Shared
%     0 0 0] % Unexplained

cols = [1 0.8 0.2 % Unique to Gen 
    0.6 0.2 0 % Unique to Spec 
    0.8 0.4 0 % Shared 
    0.85 0.85 0.85] % Unexplained 
    
for m=1:4;
    subplot(2,4,m);
    piedata1 = double([abs(mUVG(1,m)) abs(mUVS(1,m)) abs(mSVGS(1,m))]);
    piedata2 = 1-sum(piedata1);
    piedata = [piedata1 piedata2] 
    h = wani_pie(piedata, 'cols',cols, 'fontsize', 8, 'hole', 'hole_size', 500,'notext');
end

plugin_save_figure;

%% Plot  --------------------------------------------------------------------- %%
figtitle=sprintf('Plot_PIE_WITHIN_WPERCENT_VAREXPLAINED_MULTIPLE_REG');
create_figure(figtitle)

cols = [1 0.8 0.2 % Unique to Gen 
    0.6 0.2 0 % Unique to Spec 
    0.8 0.4 0 % Shared 
    0.8 0.8 0.8] % Unexplained 

for m=1:4;
    subplot(2,4,m);
    piedata1 = double([abs(mUVG(1,m)) abs(mUVS(1,m)) abs(mSVGS(1,m))]);
    piedata2 = 1-sum(piedata1);
    piedata = [piedata1 piedata2] 
    h = wani_pie(piedata, 'cols',cols, 'fontsize', 8, 'hole', 'hole_size', 500);
end

plugin_save_figure;







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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OLDER ANALYSES 
%% Prediction r2  predicted - observed 

% Full columns 
% mech
r2(1,1) = (corr(yhat(:,1),avers_mat(:,1))).^2 % Gen on gen
r2(1,2) = (corr(yhat(:,1),avers_mat(:,2))).^2 % Gen on mech % shared variance 
r2(1,3) = (corr(yhat(:,2),avers_mat(:,1))).^2 % Mech on gen % shared variance 
r2(1,4) = (corr(yhat(:,2),avers_mat(:,2))).^2 % Mech on mech 

% therm
r2(2,1) = (corr(yhat(:,1),avers_mat(:,1))).^2
r2(2,2) = (corr(yhat(:,1),avers_mat(:,3))).^2
r2(2,3) = (corr(yhat(:,3),avers_mat(:,1))).^2
r2(2,4) = (corr(yhat(:,3),avers_mat(:,3))).^2

% audi
r2(3,1) = (corr(yhat(:,1),avers_mat(:,1))).^2
r2(3,2) = (corr(yhat(:,1),avers_mat(:,4))).^2
r2(3,3) = (corr(yhat(:,4),avers_mat(:,1))).^2
r2(3,4) = (corr(yhat(:,4),avers_mat(:,4))).^2

% vis
r2(4,1) = (corr(yhat(:,1),avers_mat(:,1))).^2
r2(4,2) = (corr(yhat(:,1),avers_mat(:,5))).^2
r2(4,3) = (corr(yhat(:,5),avers_mat(:,1))).^2
r2(4,4) = (corr(yhat(:,5),avers_mat(:,5))).^2

% r2
%     0.1568    0.0002    0.0007    0.3372
%     0.1568    0.0968    0.0898    0.4087
%     0.1568    0.0087    0.0005    0.5271
%     0.1568    0.0015    0.0011    0.5463

%% Plot 

figtitle=sprintf('Plot_pie_var_explained_r2');
create_figure(figtitle)

% Mech 
subplot(2,4,1);
colsm = [0.5 0.5 0.5 % Gen
    1 0.2 0.4        % Specific 
    0.4 0.0 0.6      % Shared
    0.9 0.9 0.9];
piedata1 = double([r2(1,1) r2(1,4) r2(1,2)]); % Gen, Spec, Shared
% piedata1 = double([out_w.variables.unique_var_explained(:,1:2) out_w.variables.shared_var_explained 1-out_w.full_model.var_explained_full_model]);
piedata2 = 1 - sum (piedata1); 
piedata = [piedata1 piedata2];
h = wani_pie(piedata, 'cols',colsm, 'fontsize', 8, 'hole', 'hole_size', 500);

% Therm 
subplot(2,4,2);
colst = [0.5 0.5 0.5
    1 0.6 0.2
    1 0.0 0.0
    0.9 0.9 0.9];
piedata1 = double([r2(2,1) r2(2,4) r2(2,2)]); % Gen, Spec, Shared
% piedata1 = double([out_w.variables.unique_var_explained(:,1:2) out_w.variables.shared_var_explained 1-out_w.full_model.var_explained_full_model]);
piedata2 = 1 - sum (piedata1); 
piedata = [piedata1 piedata2];
h = wani_pie(piedata, 'cols',colst, 'fontsize', 8, 'hole', 'hole_size', 500);

% Audi 
subplot(2,4,3);
colsa = [0.5 0.5 0.5
    0 0.6 0.4
    0 0.2 0.2
    0.9 0.9 0.9];
piedata1 = double([r2(3,1) r2(3,4) r2(3,2)]); % Gen, Spec, Shared
% piedata1 = double([out_w.variables.unique_var_explained(:,1:2) out_w.variables.shared_var_explained 1-out_w.full_model.var_explained_full_model]);
piedata2 = 1 - sum (piedata1); 
piedata = [piedata1 piedata2];
h = wani_pie(piedata, 'cols',colsa, 'fontsize', 8, 'hole', 'hole_size', 500);

% Vis
colsv = [0.5 0.5 0.5 
    0 0.4 1 
    0 0 0.8 
    0.9 0.9 0.9];
subplot(2,4,4)
piedata1 = double([r2(4) r2(4,4) r2(4,2)]); % Gen, Spec, Shared
piedata2 = 1 - sum (piedata1); 
piedata = [piedata1 piedata2];
h = wani_pie(piedata, 'cols',colsv, 'fontsize', 8, 'hole', 'hole_size', 500);

%plugin_save_figure;


%% Refit for shared variance 

% full column
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = avers_mat(:,m+1); % behavior
    clear X 
    X = [yhat(:,1) yhat(:,m+1)]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end

% Within-subject - shared var makes little sense (bc it calcs shared
% across models AND subj?) 
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = avers_mat(:,m+1); % behavior
    clear X 
    X = [yhat(:,1) yhat(:,m+1) subjects]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous' 'categorical'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end
% % Mech 
% Total y variance = 0.0208, full-model residual variance = 0.0138
% Full model variance explained: 0.3388
% Variance shared across variables and not explained uniquely: -0.0034
% Variance explained by each variable:
%                  Type          Total        Unique  
%     Var_1    'continuous'    -0.0009684    0.0023828
%     Var_2    'continuous'       0.33641      0.33976
% 
% % Therm
% Total y variance = 0.0407, full-model residual variance = 0.0240
% Full model variance explained: 0.4107
% Variance shared across variables and not explained uniquely: 0.0932
% Variance explained by each variable:
%                  Type         Total       Unique 
%     Var_1    'continuous'    0.095814    0.002651
%     Var_2    'continuous'     0.40806      0.3149
% 
% % Audi
% Total y variance = 0.0286, full-model residual variance = 0.0135
% Full model variance explained: 0.5261
% Variance shared across variables and not explained uniquely: 0.0079
% Variance explained by each variable:
%                  Type          Total        Unique   
%     Var_1    'continuous'    0.0075327    -0.00041536
%     Var_2    'continuous'      0.52655         0.5186
% 
% % Vis
% Total y variance = 0.0262, full-model residual variance = 0.0119
% Full model variance explained: 0.5458
% Variance shared across variables and not explained uniquely: 0.0003
% Variance explained by each variable:
%                  Type          Total         Unique  
%     Var_1    'continuous'    0.00034823    2.3005e-05
%     Var_2    'continuous'       0.54578       0.54545

%% Per block
clear y yhatG yhatS
% Beh
yy(:,1) = avers_mat (1:220,1);
yy(:,2) = avers_mat (221:440,1);
yy(:,3) = avers_mat (441:660,1);
yy(:,4) = avers_mat (661:880,1);

% Gen
yhatG(:,1) = yhat (1:220,1); % Mech 
yhatG(:,2) = yhat (221:440,1); % Therm
yhatG(:,3) = yhat (441:660,1); % Aud
yhatG(:,4) = yhat (661:880,1); % Vis

% Spec
yhatS(:,1) = yhat (1:220,2); % Mech 
yhatS(:,2) = yhat (221:440,3); % Therm
yhatS(:,3) = yhat (441:660,4); % Aud
yhatS(:,4) = yhat (661:880,5); % Vis

% per block
for m=1:4
    fprintf('Variance decomposition (overall) for modality %d', m);
    y = yy(:,m); % behavior
    clear X 
    X = [yhatG(:,m) yhatS(:,m)]; % pattern expression values for GenS and specific S
    %r = corr(X) % are outcomes very correlated?
    X_type = {'continuous' 'continuous'};
    out_w=canlab_variance_decomposition(y, X, X_type, 'noplots');
end


