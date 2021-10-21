% Create MFC atlas object
% ----------------------------------------------------------------------
% Parcellation scheme for ACC defined by Vogt (Vogt et al. 2003, 2008)
% Individiual ROI masks created by Kragel and used in Kragel et al. 2018

imgs = { 'pMCC.nii'...% 
               'aMCC.nii'...
              'pgACC.nii'...
               'sgACC.nii' ...
                'vmPFC.nii' ...
                'dmPFC.nii' };
imgs = check_image_names_get_full_path(imgs);

labels = {'pMCC' 'aMCC' 'pgACC' 'sgACC' 'vmPFC' 'dmPFC'};
atlas_obj = atlas (imgs, 'mask', which ('gm_mask.nii'), 'labels', labels, 'space_description', 'MNI152 space', 'references' ,'Kragel et al. 2018, Vogt parcellation scheme Vogt et al. 2003, 2009');

savefile = 'MFC_atlas_object.mat';
save(savefile, 'atlas_obj');