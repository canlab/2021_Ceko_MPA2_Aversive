
function [image_obj, networknames, imagenames] = load_SR_maps_thr

networknames = {'GenS' 'MechS' 'ThermS' 'AudiS' 'VisS'};
% 
% imagenames = { 'General_SRwtn_ttest_FDR05_on_rob_betas.nii'...% Ceko et al. in prep 
%                'Mechanical_SRwtn_ttest_FDR05_on_rob_betas.nii'...
%               'Thermal_SRwtn_ttest_FDR05_on_rob_betas.nii' ...
%                'Sound_SRwtn_ttest_FDR05_on_rob_betas.nii' ...
%                 'Visual_SRwtn_ttest_FDR05_on_rob_betas.nii'};
 
% Saved these maps in the main /scripts/results/patterns dir under a more
% findable name: 

 imagenames = { 'General_PLS_model_encoder_FDR05.nii'...% Ceko et al. in prep 
               'Mechanical_PLS_model_encoder_FDR05.nii'...
              'Thermal_PLS_model_encoder_FDR05.nii' ...
               'Sound_PLS_model_encoder_FDR05.nii' ...
                'Visual_PLS_model_encoder_FDR05.nii'};

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end
