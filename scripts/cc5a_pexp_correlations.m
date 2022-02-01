% run cc0 first

%% Load data 

% % Import DAT 
% b_reload_saved_matfiles

% Import behavior
import_Behav_MPA2;


%% GenS signature 
pexpm_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.General_aversive(:,1:4));
pexpm_GenS = reshape (pexpm_GenS, 220,1);

pexpt_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.General_aversive(:,5:8));
pexpt_GenS = reshape (pexpt_GenS, 220,1);

pexpa_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.General_aversive(:,9:12));
pexpa_GenS = reshape (pexpa_GenS, 220,1);

pexpv_GenS = table2array(DAT.SIG_conditions.raw.cosine_sim.General_aversive(:,13:16));
pexpv_GenS = reshape (pexpv_GenS, 220,1);

clear x y 
x(:,1) = reshape (Pain_Avoid(:,1:4), 220,1);
x(:,2) = reshape (Pain_Avoid(:,5:8), 220,1);
x(:,3) = reshape (Pain_Avoid(:,9:12), 220,1);
x(:,4) = reshape (Pain_Avoid(:,13:16), 220,1);

y(:,1) = pexpm_GenS; 
y(:,2) = pexpt_GenS;
y(:,3) = pexpa_GenS;
y(:,4) = pexpv_GenS;

fprintf ('GenS \n');
[r, p]= corr(x(:,1), y(:,1))
[r, p]= corr(x(:,2), y(:,2))
[r, p]= corr(x(:,3), y(:,3))
[r, p]= corr(x(:,4), y(:,4))

%
%% MechS signature 
pexpm_MechS = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,1:4));
pexpm_MechS = reshape (pexpm_MechS, 220,1);

pexpt_MechS = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,5:8));
pexpt_MechS = reshape (pexpt_MechS, 220,1);

pexpa_MechS = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,9:12));
pexpa_MechS = reshape (pexpa_MechS, 220,1);

pexpv_MechS = table2array(DAT.SIG_conditions.raw.cosine_sim.MechS(:,13:16));
pexpv_MechS = reshape (pexpv_MechS, 220,1);

clear y 
y(:,1) = pexpm_MechS; 
y(:,2) = pexpt_MechS;
y(:,3) = pexpa_MechS;
y(:,4) = pexpv_MechS;

fprintf ('MechS \n');
[r, p]= corr(x(:,1), y(:,1))
[r, p]= corr(x(:,2), y(:,2))
[r, p]= corr(x(:,3), y(:,3))
[r, p]= corr(x(:,4), y(:,4))

%% ThermS signature 
pexpm_ThermS = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,1:4));
pexpm_ThermS = reshape (pexpm_ThermS, 220,1);

pexpt_ThermS = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,5:8));
pexpt_ThermS = reshape (pexpt_ThermS, 220,1);

pexpa_ThermS = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,9:12));
pexpa_ThermS = reshape (pexpa_ThermS, 220,1);

pexpv_ThermS = table2array(DAT.SIG_conditions.raw.cosine_sim.ThermS(:,13:16));
pexpv_ThermS = reshape (pexpv_ThermS, 220,1);

clear y 
y(:,1) = pexpm_ThermS; 
y(:,2) = pexpt_ThermS;
y(:,3) = pexpa_ThermS;
y(:,4) = pexpv_ThermS;

fprintf ('ThermS \n');
[r, p]= corr(x(:,1), y(:,1))
[r, p]= corr(x(:,2), y(:,2))
[r, p]= corr(x(:,3), y(:,3))
[r, p]= corr(x(:,4), y(:,4))

%% AudS signature 
pexpm_AudS = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,1:4));
pexpm_AudS = reshape (pexpm_AudS, 220,1);

pexpt_AudS = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,5:8));
pexpt_AudS = reshape (pexpt_AudS, 220,1);

pexpa_AudS = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,9:12));
pexpa_AudS = reshape (pexpa_AudS, 220,1);

pexpv_AudS = table2array(DAT.SIG_conditions.raw.cosine_sim.AudS(:,13:16));
pexpv_AudS = reshape (pexpv_AudS, 220,1);

clear y
y(:,1) = pexpm_AudS; 
y(:,2) = pexpt_AudS;
y(:,3) = pexpa_AudS;
y(:,4) = pexpv_AudS;

fprintf ('AudS \n');
[r, p]= corr(x(:,1), y(:,1))
[r, p]= corr(x(:,2), y(:,2))
[r, p]= corr(x(:,3), y(:,3))
[r, p]= corr(x(:,4), y(:,4))


%% VisS signature 
pexpm_VisS = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,1:4));
pexpm_VisS = reshape (pexpm_VisS, 220,1);

pexpt_VisS = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,5:8));
pexpt_VisS = reshape (pexpt_VisS, 220,1);

pexpa_VisS = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,9:12));
pexpa_VisS = reshape (pexpa_VisS, 220,1);

pexpv_VisS = table2array(DAT.SIG_conditions.raw.cosine_sim.VisS(:,13:16));
pexpv_VisS = reshape (pexpv_VisS, 220,1);

clear y 
y(:,1) = pexpm_VisS; 
y(:,2) = pexpt_VisS;
y(:,3) = pexpa_VisS;
y(:,4) = pexpv_VisS;

fprintf ('VisS \n');
[r, p]= corr(x(:,1), y(:,1))
[r, p]= corr(x(:,2), y(:,2))
[r, p]= corr(x(:,3), y(:,3))
[r, p]= corr(x(:,4), y(:,4))
%