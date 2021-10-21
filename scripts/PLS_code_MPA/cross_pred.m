addpath(genpath('D:\GitHub\'))
addpath(genpath('D:\spm12'))
load('data_objects.mat')
import_Behav_MPA2


%%
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


%% identify modality first?
dat.removed_images=0;
dat.removed_voxels=0;

gm_mask=fmri_data(which('gm_mask.nii')); % Improved mask 
% gm_mask=fmri_data(which('tpm.nii'));
% gm_mask.dat=gm_mask.dat(:,1)>.25;

dat=apply_mask(dat,gm_mask);
%%

kinds=ceil(subjects/11);

for k=1:5
    
    train= kinds~=k;
    test= ~train;
    [xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat(:,train)',avers_mat(train,:),20);
    
    yhat(test,:)=[ones(length(find(test)),1) dat.dat(:,test)']*b_pls;
    
end

%%
[xl,yl,xs,ys,b_pls,pctvar] = plsregress(dat.dat',avers_mat,20);


%% means by intensity
models = {'General' 'Pressure' 'Thermal' 'Sound' 'Visual'};
for m=1:4
    for o=1:5;
        clear ratings outcomes
        for i=1:4
            ratings(:,i)=avers_mat(modality==m & stim_int==i,o);
            outcomes(:,i)=yhat(modality==m & stim_int==i,o);
        end
        
        pred_outcome_corr(:,m,o)=diag(corr(ratings',outcomes'));
        
        mean_outcomes(m,:,o)=mean(outcomes);
        ste_outcomes(m,:,o)=ste(outcomes);
        
        %     pause(3);
    end
end

%%
figtitle = sprintf('PLS_plot_model_stimtype');
create_figure(figtitle);

for m=1:4;subplot(1,4,m);
    plot(squeeze(mean_outcomes(m,:,:)));
    title(['Test data: ' models{1+m}]);
    xlabel('Stimulus Intensity')
    ylabel('Predicted Aversiveness')
end
legend(models)

plugin_save_figure

%% 
figtitle = sprintf('PLS_plot_b_pls_matrix');
create_figure(figtitle);
subplot(1,2,1); imagesc(corr(b_pls)); colorbar; title ('b pls')
subplot (1,2,2); imagesc(corr(b_plsfull)); colorbar,title ('b pls full')

plugin_save_figure

figtitle = sprintf('PLS_plot_b_Z_matrix');
create_figure(figtitle);
imagesc(corr(b_Z_coeff)); colorbar
plugin_save_figure

%%
bs_b=bootstrp(10,@bootpls20dim,dat.dat',avers_mat);
r_bs_b=reshape(bs_b,5000,1+size(dat.dat,1),5);
r_bs_b=r_bs_b(:,2:end,:);

b_mean_coeff = squeeze(nanmean(r_bs_b));
b_ste_coeff = squeeze(nanstd(r_bs_b));
b_ste_coeff(b_ste_coeff == 0) = Inf;
b_Z_coeff = b_mean_coeff ./ b_ste_coeff;
b_P_coeff = 2*normcdf(-1*abs(b_Z_coeff),0,1);


for m=1:5
    bs_stat=statistic_image;
    bs_stat.volInfo=dat.volInfo;
    bs_stat.dat=b_Z_coeff(:,m);
    bs_stat.p=b_P_coeff(:,m);
    bs_stat.removed_voxels=dat.removed_voxels;
    
    bs_stat=threshold(bs_stat,.05,'fdr','k',10);
    % sig field tells us which voxels to use for masking -- if I NAN it I remove information 
    % bs_stat.dat(~bs_stat.sig)=nan;  % won't be able to rethreshold bc I just removed all the values
    bs_stat.fullpath=[models{m} 'FDR05.nii'];
    write(bs_stat);
    orthviews(bs_stat);pause(5)
    
end




%%
masks={'visual','auditory','somatosensory'};
for m=1:3
    
    stim_masked_dat=apply_mask(dat,fmri_data(['ROI_' masks{m} '_MNI.img']));
    
    
    for k=1:5
        
        train= kinds~=k;
        test= ~train;
        [xl,yl,xs,ys,b_pls,pctvar] = plsregress(stim_masked_dat.dat(:,train)',avers_mat(train,:),20);
        
        yhat_modal(m,test,:)=[ones(length(find(test)),1) stim_masked_dat.dat(:,test)']*b_pls;
        
    end
    
end

%% null models

masks={'visual','auditory','somatosensory'};
for m=1:3
    
    stim_masked_dat=apply_mask(dat,fmri_data(['ROI_' masks{m} '_MNI.img']));
    
    for it=1:1000
        n_avers_mat=avers_mat(randperm(length(avers_mat)),:);
        for k=1:5
            
            train= kinds~=k;
            test= ~train;
            [xl,yl,xs,ys,b_pls,pctvar] = plsregress(stim_masked_dat.dat(:,train)',n_avers_mat(train,:),20);
            
            yhat_modal_null(m,test,:)=[ones(length(find(test)),1) stim_masked_dat.dat(:,test)']*b_pls;
            
        end
       
        null_corr(it,m,:)=diag(corr(squeeze(yhat_modal_null(m,:,:)),n_avers_mat));
      it/1000  
    end
    
end



%%
% % if necessary 
% clear toplot 

figure;
toplot(1,:)=diag(corr(yhat,avers_mat));
for m=1:3;
    toplot(m+1,:)=diag(corr(squeeze(yhat_modal(m,:,:)),avers_mat));
    
end

bar(toplot)
legend(models)
ylabel 'Prediction-Outcome Correlation'
set(gca,'XTickLabels',{'Whole-brain' masks{:}})
