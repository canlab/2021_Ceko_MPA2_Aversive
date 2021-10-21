
function [image_obj, networknames, imagenames] = load_encoders_thr

networknames = {'Common' 'Mech' 'Therm' 'Audi' 'Visual'};

imagenames = { 'General_PLS_model_encoder_FDR05.nii'...% Ceko et al. in prep 
               'Mechanical_PLS_model_encoder_FDR05.nii'...
              'Thermal_PLS_model_encoder_FDR05.nii' ...
               'Sound_PLS_model_encoder_FDR05.nii' ...
                'Visual_PLS_model_encoder_FDR05.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end
