
function [image_obj, networknames, imagenames] = load_pain_pines

networknames = {'NPS' 'SIIPS' 'PINES'};

imagenames = { 'weights_NSF_grouppred_cvpcr.img'...                 % Wager et al. 2013 NPS   - somatic pain
               'nonnoc_v11_4_137subjmap_weighted_mean.nii' ...      % Woo 2017 SIIPS - stim-indep pain
                'Rating_Weights_LOSO_2.nii'};                   % Chang 2015 PINES - neg emo

imagenames = check_image_names_get_full_path(imagenames);

image_obj = fmri_data(imagenames, [], 'noverbose', 'sample2mask');  % loads images with spatial basis patterns

end