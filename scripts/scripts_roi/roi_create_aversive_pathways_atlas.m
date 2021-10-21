%% Create aversive pathways atlas object
% ----------------------------------------------------------------------
 
% Regions involved in processing aversive stimuli of multiple modalities 
% (somatosensory, auditory, visual)

% Atlas is split into presumptive unimodal (primary and assoociation cortical, subcortical)
% and modality-general / multi-modal regions (respond to valence regardless of (aversive) stim modality) -
% 
% ---- Modality - General / Multi-modal ----------------------- % 
% Amygdala
% OFC / MPFC 
% aINS 
% aMCC 
% NAc 
% VLPFC 

% ---- Pain (nociceptive processing) ---- % 
% dpINS, S2, S1
% PBN, RVM
% sensory thalamus, intralaminar, MD, hypothalamus

% ---- Auditory (primary processing) ---- % 
% Early A 
% Late A 

% Thal 

% ---- Visual (primary processing) ------ % 
% Early V
% Late V

% Thal 

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

roiscriptsdir = fullfile(basedir, 'roi_scripts')

if ~exist(roiscriptsdir, 'dir'), mkdir(roiscriptsdir); end
cd(roiscriptsdir)

%% Load "CANlab combined 2018" and Pain pathways atlas:
atlas_obj = load_atlas('canlab2018_2mm');
pain_pathways = load_atlas('pain_pathways_atlas_obj.mat');

% Reminder: use 'flatten' (binarizes maps) 



%% Thalamus _ compact
% -------------------------------------------------------------------------
% % sensory thalamus is comprised of VPL and VPM zones = unimodal
% thal_VPLM = select_atlas_subset(pain_pathways, [{'Thal_VPL' 'Thal_VPM'}], 'flatten');
% 
% % sensory thalamus with medial section = unimodal
% thal_VPLMI = select_atlas_subset(atlas_obj, [{'Thal_VPL' 'Thal_VPM' 'Thal_VPI'}], 'flatten');
% thal_VPLMI.labels  = {'Sens'}
% 
% % intralaminar thalamus is comprised of intralaminar and midline groups
% thal_IL = select_atlas_subset(pain_pathways, {'Thal_IL'});
% thal_IL.labels = {'IL'}
% 
% % mediodorsal nucleus is a large 'association' nucleus in the thalamus,
% % connecting to multiple limbic areas (e.g., amygdala)
% thal_MD = select_atlas_subset(pain_pathways, {'MD'});
% thal_MD.labels = {'Assoc'}

% labels do not separate in the merged version (ends up being 1 big area) 

% Thalamus _ full code from script_2018_Wager_combined_atlas.m
% ------------------------------------------------------------------------

%% Morel atlas-based combined atlas regions for thalamus (as in pain pathways)
% 
% % savefile = which('Thalamus_atlas_combined_Morel.mat');
% % 
% % load(savefile, 'thalamus_atlas');
% 
% thalamus_atlas = load(thalamusfile);
% thalamus_atlas = thalamus_atlas.thalamus_atlas;
% 
% % Add labels to make more consistent with other atlases
% for i = 1:length(thalamus_atlas.labels)
%     thalamus_atlas.labels{i} = [ 'Thal_' thalamus_atlas.labels{i}]; 
% end
% 
% save('thalamus_atlas');

%% Multimodal
% -------------------------------------------------------------------------

% aINS / FOP
% -------------------------------------------------------------------------
%ains = select_atlas_subset(atlas_obj, {'Ctx_45' 'Ctx_FOP4' 'Ctx_AVI'  'Ctx_FOP5'}, 'flatten');
ains=select_atlas_subset(pain_pathways, {'aIns'},'flatten'); % this has too much cortex (Ctx_45)
ains.labels = {'ains'};

% is a more liberal aINS warranted? 
% -------------------------------------------------------------------------
% Faillenot ins atlas 2017,
% Frot, Faillenot et al. 2014 intracerebrally recorded LEPs in n=40 epileptic patients  
% aINS = Ant + middle + post short gyrus
% pINS = Ant + Post long gyrus
% Neurosynth, Corradi, Hayes & Northoff

% aINS /
% -------------------------------------------------------------------------
aINS = select_atlas_subset (atlas_obj, {'Ctx_FOP4' 'Ctx_AVI'  'Ctx_FOP5' 'Ctx_AAIC'}, 'flatten');
aINS.labels = {'aINS'};

% mINS 
% -------------------------------------------------------------------------
mINS = select_atlas_subset(atlas_obj, {'Ctx_PoI2' 'Ctx_FOP2' 'Ctx_MI' 'Ctx_FOP3'}, 'flatten');
mINS.labels = {'mINS'};


% amINS
amINS = select_atlas_subset (atlas_obj, {'Ctx_FOP4' 'Ctx_AVI'  'Ctx_FOP5' 'Ctx_AAIC' 'Ctx_FOP3' 'Ctx_MI_' 'Ctx_PoI2' 'Ctx_FOP2'}, 'flatten');
amINS.labels = {'amINS'};

% Cingulate - from Glasser
% -------------------------------------------------------------------------
% Canlab's ACC includes SMA (see Kragel 2018 Nat NS - pain-related cingulate)
% load('pain_pathways_atlas_obj.mat')
% ACC_sma=select_atlas_subset(pain_pathways,{'aMCC_MPFC'}, 'flatten');

% get a more exact dACC
% pMCC = select_atlas_subset(atlas_obj, {'Ctx_33pr_L' 'Ctx_33pr_R' 'Ctx_p24pr_L' 'Ctx_p24pr_R' ...
%      'Ctx_24dv_L' 'Ctx_24dv_R'}, 'flatten');
% pMCC.labels = {'pMCC'};
%   
% aMCC = select_atlas_subset(atlas_obj, {'Ctx_p32pr_L' 'Ctx_p32pr_R' 'Ctx_a32pr_L' 'Ctx_a32pr_R' ...
%     'Ctx_a24pr_L' 'Ctx_a24pr_R' 'Ctx_p24_L' 'Ctx_p24_R' }, 'flatten');
% aMCC.labels = {'aMCC'};
% 
% pACC = select_atlas_subset(atlas_obj, {'Ctx_a24_L' 'Ctx_a24_R' ...
%     'Ctx_p32_L' 'Ctx_p32_R'}, 'flatten'); 
% pACC.labels = {'pACC'};
% 
% sACC = select_atlas_subset(atlas_obj, {'Ctx_p25_L' 'Ctx_p25_R' ...
%    'Ctx_s32_L' 'Ctx_s32_R'}, 'flatten');
% sACC.labels = {'sACC'};


% Cingulate - Kragel masks - followed Vogt's cingulate parcellation (Vogt 2003, 2009) 
% -------------------------------------------------------------------------
% first, create atlas from Kragel masks 

roi_create_MFC_atlas

MFC_atlas = load_atlas('MFC_atlas_object.mat')
aMCC = select_atlas_subset(MFC_atlas, {'aMCC'});
aMCC.labels = {'aMCC'};

pMCC = select_atlas_subset(MFC_atlas, {'pMCC'});
pMCC.labels = {'pMCC'};

apMCC = select_atlas_subset(MFC_atlas, {'aMCC' 'pMCC'}, 'flatten');
apMCC.labels = {'apMCC'};


% Redefine atlas
atlas_obj = load_atlas('canlab2018_2mm');

% vMPFC / OFC 
% -------------------------------------------------------------------------
vMPFC=select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '10pp' 'Ctx_OFC'}, 'flatten'); 
% MPFC=select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '8BM' '9m'}, 'flatten');
vMPFC.labels = {'vMPFC'}; % VMPFC / medial OFC 

dMPFC=select_atlas_subset(atlas_obj, {'8BM' '8BL' '9m'}, 'flatten');
dMPFC.labels = {'dMPFC'};

dvMPFC=select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '10pp' 'Ctx_OFC' '8BM' '8BL' '9m'}, 'flatten'); 
dvMPFC.labels = {'dvMPFC'};

% OFC - 11, 47
% -------------------------------------------------------------------------
lOFC=select_atlas_subset(atlas_obj, {'11' '47'}, 'flatten'); 
lOFC.labels = {'lOFC'};


% VLPFC (neg>pos masked w/ neg>neut & pos>neut; Lindquist et al. 2016 Meta-analysis)
% -------------------------------------------------------------------------
vLPFC = select_atlas_subset(atlas_obj, {'Ctx_44_L' 'Ctx_44_R' 'Ctx_45_L' 'Ctx_45_R'}, 'flatten');
vLPFC.labels = {'vLPFC'};


% Amygdala
% -------------------------------------------------------------------------
% CM, SF, LC, AStr (technically a transitional area but included here (and tiny)  
amy = select_atlas_subset(atlas_obj, {'Amy'}, 'flatten');


% % PAG 
% % -------------------------------------------------------------------------
PAG = select_atlas_subset(pain_pathways, {'Bstem_PAG'},'flatten');
PAG.labels = {'PAG'};


% Habenula + Hypothalamus 
% -------------------------------------------------------------------------
Hb = select_atlas_subset(atlas_obj, {'Haben'}, 'flatten'); % A bit larger and both hemi than Thal_Hb
Hythal =  select_atlas_subset(atlas_obj, {'Hythal'}, 'flatten');

% Putamen anterior
% -------------------------------------------------------------------------
Put = select_atlas_subset(atlas_obj, {'Putamen_Pa_L' 'Putamen_Pa_R'}, 'flatten');
Put.labels = {'Put'};

% NAc
% -------------------------------------------------------------------------
NAc = select_atlas_subset(atlas_obj, {'NAC_L' 'NAC_R'}, 'flatten');  
NAc.labels = {'NAc'};

% vStr
% -------------------------------------------------------------------------
vStr = select_atlas_subset(atlas_obj, {'Striatum'}, 'flatten');  
vStr.labels = {'vStr'};
    

% Brainstem
% -------------------------------------------------------------------------
pbn = select_atlas_subset(atlas_obj, {'pbn'}); % Shen = unimodal
rvm = select_atlas_subset(atlas_obj, {'rvm'}); % Shen = unimodal 


%% Cortical pain areas -  same areas as in Tor's Pain Pathways 
% S1 (unimodal)  -- Glasser 2016: S1 = 3a,3b,1,2
% Note: Glasser et al labels area 5 (5m, 5L, 5mv) as higher sensory / motor
% -------------------------------------------------------------------------
S1 = select_atlas_subset(atlas_obj, {'Ctx_1_' 'Ctx_2_' 'Ctx_3a_' 'Ctx_3b_'}, 'flatten'); 
%S1=select_atlas_subset(pain_pathways,{'s1_handplus'}, 'flatten'); % equal to
S1.labels = {'S1'};

M1 = select_atlas_subset(atlas_obj, {'Ctx_4_'}, 'flatten'); 
M1.labels = {'M1'};

% Somatomotor
SM = select_atlas_subset(atlas_obj, {'Ctx_1_' 'Ctx_2_' 'Ctx_3a_' 'Ctx_3b_'  'Ctx_4_'}, 'flatten'); 
SM.labels = {'SM'};
% S2 (unimodal) 
% -------------------------------------------------------------------------
%s2 = select_atlas_subset(atlas_obj, {'_OP4' 'Ctx_PFcm'}, 'flatten');
S2=select_atlas_subset(pain_pathways, {'S2'}, 'flatten');
S2.labels = {'S2'};


% S2 / dpINS (unimodal) - this is more S2/pINS, the 'purer' pINS is below
% -------------------------------------------------------------------------
% Steps from create_pain_pathways_brainnetwork
% did not remove that small region in R angular gyrus
S2dpins = select_atlas_subset(atlas_obj, {'_OP4' 'Ctx_PFcm' '_OP1' 'Ctx_RI' '_OP2' 'Ctx_Ig'}, 'flatten'); %
% dpins = select_atlas_subset(dpins, 1:2);

% rename for ease of viz
S2dpins.labels = {'S2 dpINS'};

S2dpins_noRI = select_atlas_subset(atlas_obj, {'_OP4' 'Ctx_PFcm' '_OP1' '_OP2' 'Ctx_Ig'}, 'flatten'); %
% dpins = select_atlas_subset(dpins, 1:2);

% rename for ease of viz
S2dpins_noRI.labels = {'S2INS noRI'};

%% Auditory pathway

% Brainstem
% -------------------------------------------------------------------------
% Cochlear nucleus
% Superior olive
% Inferior colliculus

% Thalamus MGN
% -------------------------------------------------------------------------
thal_MGN = select_atlas_subset(atlas_obj, {'Thal_MGN'}, 'flatten');
thal_MGN.labels = {'MGN'}


% Early auditory (see Glasser for description) 
% -------------------------------------------------------------------------
A1=select_atlas_subset(atlas_obj, {'Ctx_A1'}, 'flatten');
A1.labels = {'A1'};
% wiki: A1 = Core

A_23=select_atlas_subset(atlas_obj, {'LBelt' 'MBelt' 'PBelt'}, 'flatten');
A_23.labels = {'A_23'};
% wiki: A2 = Belt, A3 = Parabelt

% keep RI separate 
A_RI =select_atlas_subset(atlas_obj, {'Ctx_RI'}, 'flatten')
A_RI.labels = {'A_RI'};   

% Note: I did not include RI here (GLasser did) 

% Association (see Glasser for description) 
% -------------------------------------------------------------------------
% This region includes eight areas that we identify as A4, A5, STSdp, STSda,
% STSvp, STSva, STGa, and TA2
A_Assoc=select_atlas_subset(atlas_obj, {'A4_L' 'A4_R' 'A5_L' 'A5_R' ...
    'TA2_L' 'TA2_R' 'STSdp_L' 'STSdp_R' 'STSda_L' 'STSda_R'}, 'flatten');
A_Assoc.labels = {'A_Assoc'};
% -----
% TPJ / SMG, temppole? some stuff in VLPFC (language only?)


%% Visual pathway

% Thalamus
% -------------------------------------------------------------------------
% LGN (unimodal)
thal_LGN = select_atlas_subset(atlas_obj, {'Thal_LGN'}, 'flatten');
thal_LGN.labels = {'LGN'}

% Pulvinar (association)
% -------------------------------------------------------------------------
thal_Pulv = select_atlas_subset(atlas_obj, {'Thal_Pulv'}, 'flatten'); % Association 
thal_Pulv.labels = {'Pulv'}


% V1,V2 
% -------------------------------------------------------------------------
V1=select_atlas_subset(atlas_obj, {'Ctx_V1_L' 'Ctx_V1_R'},'flatten');
V1.labels = {'V1'};

V2=select_atlas_subset(atlas_obj, {'Ctx_V2_L' 'Ctx_V2_R'}, 'flatten');
V2.labels = {'V2'};
% 
% V1V2 = select_atlas_subset(atlas_obj, {'Ctx_V1_L' 'Ctx_V1_R' 'Ctx_V2_L' 'Ctx_V2_R'}, 'flatten');
% V1V2.labels = {'V1V2'};

% Vis extra-striate
% -------------------------------------------------------------------------
V_234 =select_atlas_subset(atlas_obj, {'Ctx_V2' 'Ctx_V3' 'Ctx_V4'}, 'flatten');
V_234.labels = {'V_234'};

% 'Higher visual areas' in Glasser 2016 not included:
% Dorsal Stream (n = 6): V3A,V3B,V6,V6A, V7, IPS1
% Ventral Stream (n = 7): V8, VVC, PIT, FFC, VMV1-3
% MT+ complex & friends (n = 9): V3CD, LO1-3, V4t, MT, MST, PH

%% Save pathways

% Modality-general pathway (compact)
% -------------------------------------------------------------------------

modgen_compact = [amy aINS apMCC vMPFC dMPFC lOFC vLPFC vStr]; % n = 8
modgen_full = [amy aINS mINS aMCC pMCC vMPFC dMPFC lOFC vLPFC vStr]; % n = 10

save('modgen_compact');
save('modgen_full');


% Unimodal pathway (compact) 
% -------------------------------------------------------------------------
%primary_compact = [S1 S2dpins A_Early A_Assoc V1V2 V_345];


primary_compact = [S1 S2dpins A1 A_23 V1 V_234];

save('primary_compact');


% pain vs. aud (compact) 
% -------------------------------------------------------------------------

retroins = [S2dpins_noRI A_RI];

save('retroins');

% % Cingulate 
% % -------------------------------------------------------------------------
% Cing_Glasser = [pMCC aMCC pACC sACC]
% % save Cing_atlas
% 
% % Visual yeo
% % -------------------------------------------------------------------------
% Vis_yeo = [V_Early V_Assoc]

