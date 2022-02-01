%% Selection of ROIs from various CANLAB atlases

%% set up 

working_dir = scriptsdir;
cd(working_dir);

%% define ROI

% ----------------------------------------------------------------------------------
% MIGHT USE SOME OF THESE FOR FINAL SELECTION, FOR NOW SKIP TO NEXT STEP
% ----------------------------------------------------------------------------------
% % My own collections (modified canlab, pain_pathways, Yeo) used defines ROIs displayed in riverplots in the Aversive paper
% roiscriptsdir = fullfile(basedir, 'roi_scripts');
% modgen_full = load(fullfile(roiscriptsdir, 'modgen_full.mat'));
% modgen_compact = load(fullfile(roiscriptsdir, 'modgen_compact.mat'));
% prim_compact = load(fullfile(roiscriptsdir, 'primary_compact.mat'));
% yeo_compact = load(fullfile(roiscriptsdir, 'Yeo17_compact.mat'));

%% THALAMUS, BRAINSTEM
% ------------------------ 
% atlas_obj1 = load_atlas('thalamus_detail'); % Morel atlas - too detailed (77 regions) 
atlas_obj= load_atlas('thalamus'); % 17 labels: {'Pulv'  'LGN'  'MGN'  'VPL'  'VPM'  'Intralam'  'Midline'  'LD'  'VL'  'LP'  'VA'  'VM'  'MD'  'AM'  'AV'  'Hb'  'Hythal'}tha
% trim and keep only relevant sensory/association regions:
% Pain: Sensory (VPL, VPM),  Mediodorsal (association), Intralaminar: Intralam + Midline
% Audi, Vis: MGN, LGN, LGN, Pulv 
vplm = select_atlas_subset(atlas_obj, [{'VPL' 'VPM'}], 'flatten'); 
vpl = select_atlas_subset(atlas_obj, [{'VPL'}], 'flatten'); 
ilthal = select_atlas_subset(atlas_obj, [{'Intralam'  'Midline'}], 'flatten');
md = select_atlas_subset(atlas_obj, [{'MD'}]);
audi = select_atlas_subset(atlas_obj, [{'MGN'}]);
thal_vis = select_atlas_subset(atlas_obj, [{'Pulv' 'LGN'}]);

thal_obj = [vplm ilthal md audi thal_vis];
thal_obj.labels = {'VPLM' 'IL' 'MD' 'MGN' 'Pulv' 'LGN'};

% split all thalamus into L and R 
thal_obj_full = split_atlas_into_contiguous_regions(thal_obj);
thal_obj_full.labels = {'VPLM L' 'VPLM R' 'IL' 'MD'  'MGN L'  'MGN R' 'Pulv L' 'Pulv R'  'LGN L'  'LGN R'};


%  BRAINSTEM 
% -------------------------
atlas_obj = load_atlas('canlab2018_2mm');
rvm = select_atlas_subset(atlas_obj, {'rvm'},'flatten'); % Shen = unimodal 
pag = select_atlas_subset(atlas_obj, {'PAG'},'flatten');
% VTA = select_atlas_subset(atlas_obj, {'VTA'},'flatten'); same pattern
% distribution as the other too; also, not as important as rvm + pag

bs_obj=[rvm pag]
bs_obj.labels = {'RVM' 'PAG'};

figure;o2 = fmridisplay;
o2 = montage(o2, 'sagittal','slice_range', [-6 6], 'spacing', 1);
o2 = addblobs (o2, region(rvm), 'color', [0.6 0.4 0]);
o2 = addblobs (o2, region(pag), 'color', [0.6 0.6 0]);
o2 = addblobs (o2, region(IC), 'color', [0.6 0.8 0.2]);
o2 = addblobs (o2, region(SC), 'color', [0.6 1 0.2]);
figtitle = ['ROI_bs.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;


%% MIDLINE, limbic
% -------------------------------------------------------------------------
% Cingulate - Kragel masks - followed Vogt's cingulate parcellation (Vogt 2003, 2009) 
Cing_atlas = load_atlas(fullfile(roiscriptsdir, 'MFC_atlas_object.mat'));
aMCC = select_atlas_subset(Cing_atlas, {'aMCC'});
aMCC.labels = {'aMCC'};

pMCC = select_atlas_subset(Cing_atlas, {'pMCC'});
pMCC.labels = {'pMCC'};

pgACC = select_atlas_subset(Cing_atlas, {'pgACC'});
pgACC.labels = {'pgACC'};
% Did not include sgACC, does not contribute anything interpretable + no hypothesis 
Cing = select_atlas_subset(Cing_atlas, {'pgACC' 'aMCC' 'pMCC'}, 'flatten');
Cing.labels = {'Cingulate'};

atlas_obj = load_atlas('canlab2018_2mm');
vMPFC=select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '10pp' 'Ctx_OFC'}, 'flatten'); 
% MPFC=select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '8BM' '9m'}, 'flatten');
vMPFC.labels = {'vMPFC'}; % VMPFC / medial OFC 

dMPFC=select_atlas_subset(atlas_obj, {'8BM' '8BL' '9m' }, 'flatten');
dMPFC.labels = {'dMPFC'};

MPFCfull = select_atlas_subset(atlas_obj, {'10r' '10v' '10d' '10pp' 'Ctx_OFC' '8BM' '8BL' '9m'}, 'flatten');
MPFCfull.labels = {'MPFC'};

lOFC=select_atlas_subset(atlas_obj, {'11' '47'}, 'flatten'); 
lOFC.labels = {'lOFC'};

% VLPFC (neg>pos masked w/ neg>neut & pos>neut; Lindquist et al. 2016 Meta-analysis)
vLPFC = select_atlas_subset(atlas_obj, {'Ctx_44_L' 'Ctx_44_R' 'Ctx_45_L' 'Ctx_45_R' }, 'flatten');
vLPFC.labels = {'vLPFC'};

OFC = select_atlas_subset(atlas_obj, {'Ctx_44_L' 'Ctx_44_R' 'Ctx_45_L' 'Ctx_45_R' '11' '47'}, 'flatten');
OFC.labels = {'OFC'};

OFCMPFC = select_atlas_subset(atlas_obj, {'Ctx_44_L' 'Ctx_44_R' 'Ctx_45_L' 'Ctx_45_R' '11' '47' ...
    '10r' '10v' '10d' '10pp' 'Ctx_OFC' '8BM' '8BL' '9m'}, 'flatten');
OFCMPFC.labels = {'OFCMPFC'};

% CM, SF, LC, AStr (technically a transitional area but included here (and tiny)  
amy = select_atlas_subset(atlas_obj, {'Amy'}, 'flatten');
amy.labels = {'Amy'}

hippo = select_atlas_subset(atlas_obj, {'Hippocampus'}, 'flatten');
hippo.labels = {'Hipp'}

% bg
atlas_obj = load_atlas('pauli_bg');
Put = select_atlas_subset(atlas_obj, {'Putamen_Pa'}, 'flatten');
Put.labels = {'Put'};

Caud = select_atlas_subset(atlas_obj, {'Caudate_Ca'}, 'flatten');
Caud.labels = {'Caud'};

vStr = select_atlas_subset(atlas_obj, {'V_Striatum'}, 'flatten');  
vStr.labels = {'vStr'};

% INSULA
% ------------------------
% atlas_obj2 = load_atlas('insula'); % Faillenot insula: too finegrained .. 
atlas_obj = load_atlas('canlab2018_2mm');
aINS = select_atlas_subset (atlas_obj, {'Ctx_FOP4' 'Ctx_AVI'  'Ctx_FOP5' 'Ctx_AAIC'}, 'flatten'); % with or without FOP3 same results 
aINS.labels = {'aINS'};
% L + R
aINS_LR = split_atlas_into_contiguous_regions(aINS);
% it is not splitting correctly, do manually: 
aINS_R = select_atlas_subset(aINS_LR,{'aINS_R' 'aINS_R'}, 'flatten');
aINS_R.labels = {'aINS R'};
aINS_L = select_atlas_subset(aINS_LR,{'aINS_L'});
aINS_L.labels = {'aINS L'};

mINS = select_atlas_subset(atlas_obj, {'Ctx_PoI2' 'Ctx_FOP2' 'Ctx_MI_' 'Ctx_FOP3'}, 'flatten'); % MI = anterior mid; Tor's original also includes FOP3
mINS.labels = {'mINS'};
mINS_LR = split_atlas_into_contiguous_regions(mINS);
mINS_LR.labels = {'mINS L' 'mINS R'};

dpINS = select_atlas_subset(atlas_obj, {'Ctx_Ig'}, 'flatten'); 
dpINS.labels = {'dpINS'};
dpINS_LR = split_atlas_into_contiguous_regions(dpINS);
% dpINS = select_atlas_subset(dpINS, 1:2);% clean up - remove small 3rd region in R angular gyrus
dpINS_LR.labels = {'dpINS L' 'dpINS R'};

% RI and Area 52-- auditory 
% PI - ignore, adds nothing
rINS= select_atlas_subset(atlas_obj, {'Ctx_RI'}, 'flatten');
rINS.labels = {'Retro INS'};
INS52= select_atlas_subset(atlas_obj, {'52'}, 'flatten');
INS52.labels = {'Area 52'};
ins_audi = select_atlas_subset(atlas_obj, {'Ctx_RI' '52'}, 'flatten');
ins_audi.labels = {'Audi INS'}

ins_obj_LR = [aINS_L aINS_R mINS_LR dpINS_LR];
ins_obj = [aINS mINS dpINS];

%% Early sensory cortices
% --------------------------------------------------------------------------
% extract all from main atlas (it fails to extract if S2 is from painpathways)
% somatosensory
atlas_obj = load_atlas('canlab2018_2mm');
S1 = select_atlas_subset(atlas_obj, {'Ctx_1_' 'Ctx_2_' 'Ctx_3a_' 'Ctx_3b_'}, 'flatten'); 
S1.labels =  {'S1'};
S1_LR = split_atlas_into_contiguous_regions(S1);
S1_LR.labels = {'S1 L' 'S1 R'};

S2 = select_atlas_subset(atlas_obj, {'_OP1'}, 'flatten'); % when I include OP4 and PF, too much audi
S2.labels = {'S2'};
S2_LR = split_atlas_into_contiguous_regions(S2);
S2_LR.labels = {'S2 L' 'S2 R'};

% auditory: % A1 = Core
A1=select_atlas_subset(atlas_obj, {'Ctx_A1'}, 'flatten');
A1.labels = {'A1'};
A1_LR = split_atlas_into_contiguous_regions(A1);
A1_LR.labels = {'A1 L' 'A1 R'};

% A2 = Belt, A3 = Parabelt
A_23=select_atlas_subset(atlas_obj, {'LBelt' 'MBelt' 'PBelt'}, 'flatten');
A_23.labels = {'A23'};
A_23_LR = split_atlas_into_contiguous_regions(A_23);
A_23_LR.labels = {'A23 L' 'A23 R'};

A_123 = select_atlas_subset(atlas_obj, {'Ctx_A1' 'LBelt' 'MBelt' 'PBelt'}, 'flatten');
A_123.labels={'A123'}; 
 
% Visual
V1 = select_atlas_subset(atlas_obj, {'Ctx_V1'},'flatten');
V1.labels = {'V1'};
V1_LR = split_atlas_into_contiguous_regions(V1);
V1_LR.labels = {'V1 L' 'V1 R'};

V_234 = select_atlas_subset(atlas_obj, {'Ctx_V2' 'Ctx_V3' 'Ctx_V4'}, 'flatten');
V_234.labels = {'V234'};
V_234_LR = split_atlas_into_contiguous_regions(V_234);
V_234_LR.labels = {'V234 L' 'V234 R'};

V_1234 = select_atlas_subset(atlas_obj, {'Ctx_V1' 'Ctx_V2' 'Ctx_V3' 'Ctx_V4'}, 'flatten');
V_1234.labels = {'V1234'};

sense_obj = [S1 S2 A1 A_23 V1 V_234];
sense_obj_LR = [S1_LR S2_LR A1_LR A_23_LR V1_LR V_234_LR];

% Save all into one object 
savefilename = fullfile(resultsdir, 'ROI_obj_to_plot.mat');
save(savefilename, 'thal_obj', '-v7.3');
save(savefilename,  'bs_obj', '-append');
save(savefilename, 'affect_obj', 'affect_compact', 'cc', '-append');
save(savefilename, 'ins_obj', 'ins_obj_LR', 'ins_audi', '-append');
save(savefilename, 'sense_obj', 'sense_obj_LR', '-append');
