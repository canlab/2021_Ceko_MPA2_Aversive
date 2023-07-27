% Load PLS-bootstrapped output  
% -------------------------------------------------------------------------
%
load(fullfile(resultsdir,'PLS_bootstats10000_N55_gm.mat'));

cd(qcdir)

% Display and save pattern maps
% Original code: 
for m=1:length(models)
    
    % create stat img
    bs_stat=statistic_image;
    
    % populate stat img
    % ------------------------------
    % data
    bs_stat.dat=b_Z_coeff(:,m);
    bs_stat.p=b_P_coeff(:,m);
    
    % meta-info
    bs_stat.volInfo=datvol; % pulled from the original dat.volInfo
    bs_stat.removed_voxels=0; % pulled from the original dat.removed_voxels 
    %orthviews(bs_stat)
   
    % save statistical image for further calculations (e.g., conjunctions) 
    pls_bs_statimg(m) = bs_stat;  
end

% % Save at fdr-corr
% for m=1:length(models)
%     
%     % create stat img
%     bs_stat=statistic_image;
%     
% %     % populate stat img
% %     % ------------------------------
% %     % data
%     bs_stat.dat=b_Z_coeff(:,m);
%     bs_stat.p=b_P_coeff(:,m);
% %     
% %     % meta-info
%     bs_stat.volInfo=datvol; % pulled from the original dat.volInfo
%     bs_stat.removed_voxels=0;  %pulled from the original dat.removed_voxels 
% %     %orthviews(bs_stat)
%    
%     bs_stat = threshold (bs_stat, .05, 'fdr');
%     % save statistical image for further calculations (e.g., conjunctions) 
%     pls_bs_statimg_fdr05(m) = bs_stat; 
% end

cd(qcdir)

%% Write bootstrapped files for interpretation and display 

for m=1:length(models) 
    
    % write out images 
    % ------------------------------
    % unthr 
    bs_stat.fullpath=[models{m} '_b10000_unthr.nii'];
    bs_stat.volInfo=datvol
    write(bs_stat, 'overwrite');    
end


for m = 1

    % FDR 
    bs_stat=threshold(bs_stat,.05,'fdr','k',10);
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_FDR05.nii'];
    write(bs_stat, 'overwrite');
    %orthviews(bs_stat);pause(5)
end

    %FDR corr
    bs_stat=threshold(bs_stat,.05,'fdr','k',10);
    % sig field tells us which voxels to use for masking -- if I NAN it I remove information 
    % bs_stat.dat(~bs_stat.sig)=nan;  % won't be able to rethreshold bc I just removed all the values
    
    % resave these without naning sig and see if same
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_FDR05.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)
    
    %001 uncorrected 
    bs_stat=threshold(bs_stat,.001,'unc','k',10);
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_unc001.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)
    
    %01 uncorrected 
    bs_stat=threshold(bs_stat,.01,'unc','k',10);
    bs_stat.dat(~bs_stat.sig)=nan;
    bs_stat.fullpath=[models{m} '_b10000_unc01.nii'];
    write(bs_stat, 'overwrite');
    orthviews(bs_stat);pause(5)  
end