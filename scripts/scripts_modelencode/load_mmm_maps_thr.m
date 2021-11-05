 
function [image_obj, networknames, imagenames] = load_mmm_maps_thr

networknames = {'GenS' 'MechS' 'ThermS' 'AudiS' 'VisS'};

imagenames = { 'General_ROB_wtn_minus_maxothers_FDR05.nii'...% Ceko et al. in prep 
               'Mechanical_ROB_wtn_minus_maxothers_FDR05.nii'...
              'Thermal_ROB_wtn_minus_maxothers_FDR05.nii' ...
               'Sound_ROB_wtn_minus_maxothers_FDR05.nii' ...
                'Visual_ROB_wtn_minus_maxothers_FDR05.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end
