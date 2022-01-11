% Train PLS to predict norm ratings of positive and negative images 
% & plot response 

% Prep
cd(scriptsrevdir);

% load images and behavior 
% ----------------------------------------------
load(fullfile(resultsrevdir, 'data_objects.mat')); 

import_sanitycheck_Behav_NEGPOS %

% Specify models 
% ----------------------------------------------
models = {'NGeneral' 'NVisneg' 'NVispos'};   % General here would ideally give us general arousal
%
modality=[];stim_int=[];
subjects=repmat(1:55,1,8)';      
ints=rem(1:8,4);ints(ints==0)=4;   

% reorganize Experience session into a dat 
% ----------------------------------------------
for d=1:8
    
    if d==1
        dat=DATA_OBJ{1};
    else
        dat.dat=[dat.dat DATA_OBJ{d}.dat];
    end
    
    dat.Y=[dat.Y; Norm_negpos(:,d)];
    modality=[modality; ceil(d/4)*ones(55,1)];
    stim_int=[stim_int; ints(d)*ones(55,1)];
end
% %% optional L2 norm 
% dat=rescale(dat, 'l2norm_images')

% reorganize behavior into dat.Y
% ----------------------------------------------
norm_mat=condf2indic(modality);
for i=1:size(norm_mat,1)
    norm_mat(i,find(norm_mat(i,:)))=dat.Y(i);
    
end
norm_mat=[dat.Y norm_mat];

dat.removed_images=0;
dat.removed_voxels=0;

% dat 104388 x 440 single
% nvox = 271633
% n_inmask / wh_inmask = 104388

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
dat=apply_mask(dat,gm_mask);

% dat 63545 x 440 single
% nvox = still 271633  
% n_inmask / wh_inmask = still 104388


kinds=ceil(subjects/11);  % 5 folds 
[indic, xlevels] = condf2indic(kinds);

%%
for k = 1:5  % for each fold
    
    fprintf('FOLD %d\n----------------------\n', k);
    
    train= kinds~=k; % 4/5
    test= ~train; %  1/5
    
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)', norm_mat(train,:), 20);
    
    yhat(test,:) = [ones(length(find(test)),1) dat.dat(:,test)'] * b_pls;
    
    cv_pls_intercepts{k} = b_pls(1, :);
   
    % Create an object with all models for this fold
    % -----------------------------------------------
    cv_bpls = fmri_data;             % Note: this only works if the training data space matches the standard default space exactly! It should be ok here.
    cv_bpls.volInfo = dat.volInfo;

    % 3 images for 3 models.  trained on 440*4/5 images
    % -----------------------------------------------
    cv_bpls.dat = b_pls(2:end, :);                      % All models, this fold
    cv_bpls.removed_voxels = dat.removed_voxels;
    cv_bpls.additional_info{1} = cv_pls_intercepts{k};  % Add 5 intercepts for 5 models
    cv_bpls.additional_info{2} = 'Cell 1: 3 intercepts for 3 models';
    cv_bpls.additional_info{3} = indic(:, k);
    cv_bpls.additional_info{4} = 'Indicator for test images in fold; 0 = train, 1 = test';
    cv_bpls.source_notes = sprintf('MPA2 3 models trained with plsregress, fold %d', k);
    
    % Experience session: Apply to test images 
    % -----------------------------------------------
    test_dat = get_wh_image(dat, find(test));

    % Apply to test data - add intercepts to dot product
    pexp_xval_cs_test = apply_mask(test_dat, cv_bpls, 'pattern_expression', 'cosine_similarity');
    pexp_xval_dp_test = apply_mask(test_dat, cv_bpls, 'pattern_expression') + cv_pls_intercepts{k};

    % aggregate into overall
    pexp_xval_cs(test, :) = pexp_xval_cs_test;
    pexp_xval_dp(test, :) = pexp_xval_dp_test;
end


% Reorganize, save
% Xval patterns for each model are in the 440/1 format
% reshape into 55 x 8
for m = 1:3
    % Experience Session
    cs_E(:,:,m) = reshape(pexp_xval_cs(:,m), 55, 8);
    dp_E(:,:,m) = reshape(pexp_xval_dp(:,m), 55, 8);
end

% append these to DAT

% General Model
DAT.sanNORMPLSXVAL_GEN_conditions.raw.dotproduct = [dp_E(:,:,1)];
DAT.sanNORMPLSXVAL_GEN_conditions.raw.cosine_sim = [cs_E(:,:,1)];

% NEG Norm Vis Specific 
DAT.sanNORMPLSXVAL_NNV_conditions.raw.dotproduct = [dp_E(:,:,2)];
DAT.sanNORMPLSXVAL_NNV_conditions.raw.cosine_sim = [cs_E(:,:,2)];

% POS Norm Vis Specific 
DAT.sanNORMPLSXVAL_PNV_conditions.raw.dotproduct = [dp_E(:,:,3)];
DAT.sanNORMPLSXVAL_PNV_conditions.raw.cosine_sim = [cs_E(:,:,3)];


printhdr('Save results');

savefilename = fullfile(resultsdir, 'image_names_and_setup.mat');
save(savefilename, 'DAT', '-append');
% 


