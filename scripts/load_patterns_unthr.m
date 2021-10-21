
function [image_obj, networknames, imagenames] = load_patterns_unthr

networknames = {'GenS' 'MechS' 'ThermS' 'AudiS' 'VisS'};

imagenames = { 'General_b10000_unthr.nii'...% Ceko et al. in prep 
               'Mechanical_b10000_unthr.nii' ...
              'Thermal_b10000_unthr.nii' ...
               'Sound_b10000_unthr.nii' ...
                'Visual_b10000_unthr.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end