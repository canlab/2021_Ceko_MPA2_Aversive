

% This script applies in-sample PLS signatures to MPA2 positive visual 'non-reactive' images 
% 
% PLS signatures: multiple predictive patterns for aversive experience: General, Mechanical pain,
%         Thermal pain, Aversive Sounds, Visual aversive images


clear all

cd(scriptsrevdir)

%% Prep   

% Load and reorganize aversive data for PLS 
% ------------------------------------------------------------

% Load behavior aversive stim
cd(scriptsdir)
import_Behav_MPA2 

% Load betas aversive stimuli - 55 x 4 x 4
% copied into this dir after creation, dir path hardcoded
load('/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/results/image_names_and_setup.mat');
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

load('/Users/marta/Dropbox (Cognitive and Affective Neuroscience Laboratory)/B_AVERSIVE/results/data_objects.mat');
fprintf('Loaded condition data from results%sDATA_OBJ\n', filesep);

% Specify vars
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';      
ints=rem(1:16,4);ints(ints==0)=4;   

% reorganize into a dat 
for d=1:16
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Pain_Avoid(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end
% %% optional L2 norm 
% dat=rescale(dat, 'l2norm_images')

% reorganize behavior into dat.Y
% ----------------------------------------------
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

%% Load pos images data 
% ----------------------------------------------
clear DAT DATA_OBJ

load(fullfile(resultsrevdir, 'image_names_and_setup.mat'));
fprintf('Loaded DAT from results%simage_names_and_setup.mat\n', filesep);

load(fullfile(resultsrevdir, 'data_objects.mat'));
fprintf('Loaded condition data from results%sDATA_OBJ\n', filesep);


% reorganize pos into a dat2 -
for d=1:4
    
    if d==1
        dat2=DATA_OBJ{5};
    else
        dat2.dat=[dat2.dat DATA_OBJ{d+4}.dat]; % 'd' is kinda important here .... almost gave myself a heart attack
    end
end

dat2.dat(1) % 0.5153
DATA_OBJ{5}.dat(1) % 0.5153

dat2.removed_images=0;
dat2.removed_voxels=0;

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat2=apply_mask(dat2,gm_mask);


%% Estimate and apply cross-val PLS patterns to posvis data

kinds=ceil(subjects/11);  % 5 folds 
[indic, xlevels] = condf2indic(kinds);

for k = 1:5  % for each fold
    
    fprintf('FOLD %d\n----------------------\n', k);
    
    train= kinds~=k; % 4/5
    test= ~train; %  1/5  
    
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)', avers_mat(train,:), 20);
    
    yhat(test,:) = [ones(length(find(test)),1) dat.dat(:,test)'] * b_pls;
    
    cv_pls_intercepts{k} = b_pls(1, :);
   
    % Create an object with all models for this fold
    % -----------------------------------------------
    cv_bpls = fmri_data;             % Note: this only works if the training data space matches the standard default space exactly! It should be ok here.
    cv_bpls.volInfo = dat.volInfo;

    % 5 images for 5 models.  trained on 880*4/5 images
    % -----------------------------------------------
    cv_bpls.dat = b_pls(2:end, :);                      % All models, this fold
    cv_bpls.removed_voxels = dat.removed_voxels;
    cv_bpls.additional_info{1} = cv_pls_intercepts{k};  % Add 5 intercepts for 5 models
    cv_bpls.additional_info{2} = 'Cell 1: 5 intercepts for 5 models';
    cv_bpls.additional_info{3} = indic(:, k);
    cv_bpls.additional_info{4} = 'Indicator for test images in fold; 0 = train, 1 = test';
    cv_bpls.source_notes = sprintf('MPA2 5 models trained with plsregress, fold %d', k);
    
    % Posvis images: Apply to test images 
    % ----------------------------------------------- 
    test_dat2 = get_wh_image(dat2, find(test(1:220))); % 220*1/5 - one cond (posvis), instead of 4 

    % Apply to test data - add intercepts to dot product
    pexp_xval_cs_test_pos = apply_mask(test_dat2, cv_bpls, 'pattern_expression', 'cosine_similarity');
    pexp_xval_dp_test_pos = apply_mask(test_dat2, cv_bpls, 'pattern_expression') + cv_pls_intercepts{k};

    % aggregate into overall
    pexp_xval_cs_pos(test(1:220), :) = pexp_xval_cs_test_pos; 
    pexp_xval_dp_pos(test(1:220), :) = pexp_xval_dp_test_pos;
    
end

%% Reorganize, save
% For each session, Xval patterns for each model are in the 220/1 format
% reshape into 55 x 4
for m = 1:5
    % Posvis
    cs_pos(:,:,m) = reshape(pexp_xval_cs_pos(:,m), 55, 4);
    dp_pos(:,:,m) = reshape(pexp_xval_dp_pos(:,m), 55, 4);
end


% ----------------------------------------------
%% Plot behavior - line plot 
% ----------------------------------------------

pexp_color = [0.9 0.9 0.9];   % posvis

figtitle=sprintf('Plot_Beh_Study1b');
create_figure(figtitle)

lev = [1 2 3 4] % bins (pre-selected levels based on IAPS norm rating ranges)

beh  = [1.078/10	1.891/10	2.361/10	3.048/10]; % to match 'main' rating scale

subplot(3,5,1)

    h = ploterr (lev, beh, [],[]); % 'abshhxy', 0);
    
    set(h(1), 'color', pexp_color, 'marker', 'o', 'markerfacecolor',pexp_color, 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1);
    %set(h(2), 'color', 'k', 'linewidth', 1);
    hold on 

set(gca,'box', 'off', 'XLim',[0.5 4.5],'YLim', [0.05 0.4], 'XTick', 1:1:4,'YTick', 0.1:0.1:0.4,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

plugin_save_figure

%% Plot cross-validated dp
% Plot with error bars 
% -------------------------------------------------------
pexp_color = [0.9 0.9 0.9];   % posvis 

figtitle=sprintf('Plot_PEXPdotpr_per_model_Study1b');
create_figure(figtitle)

clear x  
x  = [0.1078    0.1891    0.2361   0.3048];  % IAPS norm ratings

% old ratings: 1.078	2.047	2.327	3.048

% Plot bins and display error bars 
for m = 1:5
subplot(3,5,m)

h = ploterr (x,nanmean(dp_pos(:,:,m)),[],ste(dp_pos(:,:,m))); % 'abshhxy', 0);
    
set(h(1), 'color', pexp_color, 'marker', 'o', 'markerfacecolor',pexp_color, 'MarkerEdgeColor', 'k', ...
    'markersize', 6, 'linewidth', 1);

set(h(2), 'color', 'k', 'linewidth', 1);
    
line([0 5], [0 0], 'color', [1 .8 .8], 'linewidth', 1, 'linestyle', '-');
set(gca,'box', 'off', 'XLim',[0.05 0.35],'YLim', [-0.05 0.3], 'XTick', 0.1:0.2:0.3,'YTick', -0.1:0.1:0.5,'tickdir', 'out', 'ticklength', [.01 .01]);
set(gca,'LineWidth', 1,'FontSize', 10);

end 

plugin_save_figure

