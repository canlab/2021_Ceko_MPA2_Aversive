
function [image_obj, networknames, imagenames] = load_cing_regions

networknames = {'pMCC' 'aMCC' 'pgACC' 'sgACC'};

imagenames = { 'pMCC.nii'...% 
               'aMCC.nii'...
              'pgACC.nii'...
               'sgACC.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end