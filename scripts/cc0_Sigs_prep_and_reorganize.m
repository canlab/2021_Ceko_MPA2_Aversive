%% Prep data

% Data (behavior) 
% -------------------------------------------------------------------------
% Pain_Avoid (55 x 16) = 55 subjects, for each 4 levels of each modality (M 1-4, T 1-4, A 1-4, V 1-4 = 16) 
% dat.Y(880 x 1) = Pain_Avoid rearranged to 1:55 x 4 x 4: 
% 1:55 subjects 1:55 M, L1
% 56:110 subjects 1:55, M, L2
% etc

% Data (behavior) 
% -------------------------------------------------------------------------
% 5 signature responses (yhat; 1 x modality-general and 4 x modality-specific) are derived 
% from PLS (880 x 5 matrix for 55 subjects at 4 stim levels (220) for 4 modalities (observed behavior = avers_mat = 220x4=880) 


%% Load data 

% FMRI data object 
load(fullfile(resultsdir, 'data_objects.mat'));

% Behavior - in data/ dir
import_Behav_MPA2;

%
modality=[];stim_int=[];
subjects=repmat(1:55,1,16)';
ints=rem(1:16,4);ints(ints==0)=4;
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

%%
avers_mat=condf2indic(modality);
for i=1:size(avers_mat,1)
    avers_mat(i,find(avers_mat(i,:)))=dat.Y(i);
    
end
avers_mat=[dat.Y avers_mat];

%%
dat.removed_images=0;
dat.removed_voxels=0;

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 

dat=apply_mask(dat,gm_mask);

% Predicted behavior (avers_mat - observed, yhat - predicted)
load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

% Colors 

colormod= [1 0.2 0.4 % red 
            1 0.6 0.2  % orange
            0 0.6 0.4 % green
            0 0.4 1  % blue
            0.5 0.5 0.5]; % gray

% Colors for line_plot_multisubject
colormods={{[1 0.2 0.4]} {[1 0.6 0.2]} {[0 0.6 0.4]} {[0 0.4 1]} {[0.5 0.5 0.5]}}
%colors_mont={[1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1] [0.5 0.5 0.5]}'
colors_mont={[1 0.2 0.4] [1 0.6 0.2] [0 0.6 0.4] [0 0.4 1] [1 1 0.4]}' % general is yellow

models = {'General' 'Mechanical' 'Thermal' 'Sound' 'Visual'};
modalnames={'Mech' 'Therm' 'Audi' 'Vis'};

%% Reorganize data per modality 

% Across subjects: 
% -------------------------------------------------------------------------
clear Y Yfit_Gen Yfit_Spec

n_mods = length(modalnames);
Y=cell(1, n_mods);
Yfit_Gen=cell(1, n_mods);
Yfit_Spec=cell(1, n_mods);
for m=1:4
        Yget=avers_mat(modality==m);  % aversiveness ratings 
        Y{m}=Yget;
        YfitGget=yhat(modality==m);  % predicted av ratings 
        Yfit_Gen{m}=YfitGget;
        YfitSget=yhat(modality==m,m+1); % spec model is at modality+1 
        Yfit_Spec{m}=YfitSget;
end

% Double-check 
m=1;
Ycalc=Y{m}(end); %% mech stim, last subject, last stim level
Yinp=avers_mat(220,1); %% mech stim, last subj, last stim level
YGcalc=Yfit_Gen{1}(end);
YGinp=yhat(220,1);
YScalc=Yfit_Spec{1}(end);
YSinp=yhat(220,2);

if Ycalc == Yinp & YGcalc == YGinp & YScalc == YSinp
    fprintf ('All good! \n');
else 
    fprintf ('Values do not match, check the code! \n');
end
clear m

% Each subject on their own line
% -------------------------------------------------------------------------
clear YY YYfit_Gen YYfit_Spec
clear subject_id
subject_id=repmat(1:55,1,4)';
for m=1:4;
    for s = 1:length(unique(subject_id));
        YY{m}{s} = Y{m}(subject_id == s);
        YYfit_Gen{m}{s} = Yfit_Gen{m}(subject_id == s);
        YYfit_Spec{m}{s}= Yfit_Spec{m}(subject_id == s);
    end
end

% Double-check
m=1;s=55;
YYcalc=YY{m}{s}; %% mech stim, last subject, last stim level
YYinp=avers_mat(subject_id==55);  %% mech stim, last subj, last stim level
YYGcalc=YYfit_Gen{m}{s};
YYGinp=yhat(subject_id==55);
YYScalc=YYfit_Spec{m}{s};
YYSinptemp=yhat(:,2);
YYSinp=YYSinptemp(subject_id==55);
if YYcalc == YYinp & YYGcalc == YYGinp & YYScalc == YYSinp
    fprintf ('All good! \n');
else 
    fprintf ('Values do not match, check the code! \n');
end
clear m

%% ALL DATAPOINTS: Reorganize data per modality 

% Across subjects: 
% -------------------------------------------------------------------------
for m=1:4
    YG{m} = avers_mat(:,1)
    YS{m} = avers_mat(:,m+1)
    YhatG{m} = yhat(:,1)
    YhatS{m} = yhat(:,m+1)
end

% Each subject on their own line
% -------------------------------------------------------------------------
clear YYS YYS YYhatG YYhatS
subjects=repmat(1:55,1,16)';
for m=1:4;
    for s = 1:length(unique(subjects));
        YYG{m}{s} = YG{m}(subjects == s);
        YYS{m}{s} = YS{m}(subjects == s);
        YYhatG{m}{s} = YhatG{m}(subjects == s);
        YYhatS{m}{s} = YhatS{m}(subjects == s);
    end
end

%% Save reorganized variables 

printhdr('Add to PLS results file');

savefilename=(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));
save(savefilename, 'subjects', 'subject_id', 'modalnames','models', 'colormod', 'colormods','-append');

printhdr('Adding Y and Yfit for on-modalities (n=220) across and within subjects');
save(savefilename, 'Y', 'Yfit_Gen', 'Yfit_Spec', '-append');
save(savefilename, 'YY', 'YYfit_Gen', 'YYfit_Spec', '-append');


printhdr('Adding Y and Yfit for on and off-modalities (n=880) across and within subjects');
save(savefilename, 'YG', 'YS', 'YhatG', 'YhatS', '-append');
save(savefilename, 'YYG', 'YYS', 'YYhatG', 'YYhatS', '-append');
