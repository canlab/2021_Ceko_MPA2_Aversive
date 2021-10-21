% Create aversive pathways atlas object
% ----------------------------------------------------------------------
 
% Yeo 17 no laterality
% Laterality


%% Load Yeo17 LH + RH atlas:
atlas_obj = load_atlas('yeo17networks');

% Reminder: use 'flatten' (binarizes maps) 

% N1
Vis_Early=select_atlas_subset(atlas_obj, {'VisPeri'},'flatten');
Vis_Early.labels = {'Visual A'};

% N2
Vis_Assoc=select_atlas_subset(atlas_obj, {'VisCent'},'flatten');
Vis_Assoc.labels = {'Visual B'};

% N3
SomMot_SMA=select_atlas_subset(atlas_obj, {'SomMotA'},'flatten');
SomMot_SMA.labels = {'Som Mot A'};

% N4
SomMot_Aud=select_atlas_subset(atlas_obj, {'SomMotB'},'flatten');
SomMot_Aud.labels = {'Som Mot B'};

% N14 
Aud_Assoc=select_atlas_subset(atlas_obj, {'TempPar'},'flatten'); 
Aud_Assoc.labels = {'Temp Par'}; 

% ------ Attention & Salience ----------------------------------------- %
% N5
pDAN=select_atlas_subset(atlas_obj, {'DorsAttnA'},'flatten');
pDAN.labels = {'Dorsal Att A'};

% N6
aDAN=select_atlas_subset(atlas_obj, {'DorsAttnB'},'flatten');
aDAN.labels = {'Dorsal Att B'};

% N7
VAN=select_atlas_subset(atlas_obj, {'SalVentAttnA'},'flatten');
VAN.labels = {'Salience A'};

% N8
Salience=select_atlas_subset(atlas_obj, {'SalVentAttnB'},'flatten');
Salience.labels = {'Salience B'};

% N9-10
Limbic=select_atlas_subset(atlas_obj, {'Limbic'},'flatten');
Limbic.labels = {'Limbic AB'};

% ------ Fronto Parietal  ------------------------------------------- %
% N12  Dixon et al. 2018 PNAS
FPCNb=select_atlas_subset(atlas_obj, {'ContA'},'flatten');
FPCNb.labels = {'Control A'};

% N13 Dixon et al. 2018 PNAS
FPCNa=select_atlas_subset(atlas_obj, {'ContB'},'flatten');
FPCNa.labels = {'Control B'};

% N11  PCC - Leech et al. 2014 Brain 
FPCN_pcc =select_atlas_subset(atlas_obj, {'ContC'},'flatten');
FPCN_pcc.labels = {'Control C'};

% ------ Default Mode  ------------------------------------------- %
% N15 - PHG, retrosplenial, pIPL
DMN_Memory=select_atlas_subset(atlas_obj, {'DefaultC'},'flatten');
DMN_Memory.labels = {'Default C'};

% N16 
DMN_Core=select_atlas_subset(atlas_obj, {'DefaultA'},'flatten');
DMN_Core.labels = {'Default A'};

% N17 -  'lateral DMN' off-task thought, Turnbull et al. 2019 Nat Comm
DMN_Lat=select_atlas_subset(atlas_obj, {'DefaultB'},'flatten');
DMN_Lat.labels = {'Default B'};

%% Save atlas by network 
Yeo17_compact = [Vis_Early Vis_Assoc SomMot_SMA SomMot_Aud Aud_Assoc ...
    pDAN aDAN VAN Salience FPCNb FPCNa FPCN_pcc DMN_Core DMN_Lat DMN_Memory Limbic]

save Yeo17_compact
