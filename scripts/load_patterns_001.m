
function [image_obj, networknames, imagenames] = load_patterns_001

networknames = {'GenS' 'MechS' 'ThermS' 'AudiS' 'VisS'};

imagenames = { 'General_b10000_unc001.nii'...% Ceko et al. in prep 
               'Mechanical_b10000_unc001.nii' ...
              'Thermal_b10000_unc001.nii' ...
               'Sound_b10000_unc001.nii' ...
                'Visual_b10000_unc001.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end