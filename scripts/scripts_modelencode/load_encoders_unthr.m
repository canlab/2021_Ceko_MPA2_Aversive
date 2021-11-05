
function [image_obj, networknames, imagenames] = load_encoders_unthr

networknames = {'Common' 'Mech' 'Therm' 'Audi' 'Visual'};

imagenames = { 'General_PLS_model_encoder_unthr.nii'...% Ceko et al. in prep 
               'Mechanical_PLS_model_encoder_unthr.nii'...
              'Thermal_PLS_model_encoder_unthr.nii' ...
               'Sound_PLS_model_encoder_unthr.nii' ...
                'Visual_PLS_model_encoder_unthr.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end
