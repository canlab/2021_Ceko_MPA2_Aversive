% run cc0 first
%% Load data 

% Behavior - in data/ dir
import_Behav_MPA2;

% Import DAT 
%b_reload_saved_matfiles
load(fullfile(resultsdir, 'image_names_and_setup.mat'));

load(fullfile(resultsdir, 'PLS_crossvalidated_N55_gm.mat'));

% 
clear x r p
x(:,1) = mean (Pain_Avoid(:,1:4),2);
x(:,2) = mean (Pain_Avoid(:,5:8),2);
x(:,3) = mean (Pain_Avoid(:,9:12),2);
x(:,4) = mean (Pain_Avoid(:,13:16),2);

[r(1), p(1)]=corr(x(:,1),x(:,2)); % M T
[r(2), p(2)]=corr(x(:,1),x(:,3)); % M A
[r(3), p(3)]=corr(x(:,1),x(:,4)); % M V
[r(4), p(4)]=corr(x(:,2),x(:,3)); % T A
[r(5), p(5)]=corr(x(:,2),x(:,4)); % T V
[r(6), p(6)]=corr(x(:,3),x(:,4)); % A V

% r = 
%     0.5569  
%     0.2617  M % A
%     0.3438
%     0.6534
%     0.5635
%     0.6810
% 
% p =
%     0.0000
%     0.0536
%     0.0102
%     0.0000
%     0.0000
%     0.0000

% any level in particular responsible for the relatively low corr M & A? 

clear m t a v rr pp
m(:,1)=Pain_Avoid(:,1);
m(:,2)=Pain_Avoid(:,2);
m(:,3)=Pain_Avoid(:,3);
m(:,4)=Pain_Avoid(:,4);
t(:,1)=Pain_Avoid(:,5);
t(:,2)=Pain_Avoid(:,6);
t(:,3)=Pain_Avoid(:,7);
t(:,4)=Pain_Avoid(:,8);
a(:,1)=Pain_Avoid(:,9);
a(:,2)=Pain_Avoid(:,10);
a(:,3)=Pain_Avoid(:,11);
a(:,4)=Pain_Avoid(:,12);
v(:,1)=Pain_Avoid(:,13);
v(:,2)=Pain_Avoid(:,14);
v(:,3)=Pain_Avoid(:,15);
v(:,4)=Pain_Avoid(:,16);

for l=1:4;
[rr(l,1), pp(l,1)]=corr(m(:,l),t(:,l)); % corr M & T
[rr(l,2), pp(l,2)]=corr(m(:,l),a(:,l)); % corr M & A
[rr(l,3), pp(l,3)]=corr(m(:,l),v(:,l)); 
[rr(l,4), pp(l,4)]=corr(t(:,l),a(:,l));
[rr(l,5), pp(l,5)]=corr(t(:,l),v(:,l));
[rr(l,6), pp(l,6)]=corr(a(:,l),v(:,l));
end

% rr =
% 
%     0.6429    0.2426    0.3633    0.5051    0.4226    0.5822
%     0.5665    0.2981    0.3233    0.5818    0.4959    0.6201
%     0.4866    0.2213    0.3519    0.6678    0.5879    0.6509
%     0.4714    0.2473    0.2842    0.7054    0.5791    0.7199
% 
% pp
% 
% pp =
% 
%     0.0000    0.0743    0.0064    0.0001    0.0013    0.0000
%     0.0000    0.0271    0.0161    0.0000    0.0001    0.0000
%     0.0002    0.1044    0.0084    0.0000    0.0000    0.0000
%     0.0003    0.0687    0.0355    0.0000    0.0000    0.0000


% for i=1:6
%    meanrr(i,:)=mean(rr(:,i));
% end
% 
%     0.5419
%     0.2523
%     0.3307
%     0.6150
%     0.5214
%     0.6433


%% 
clear r
for m=1:4
    for n=1:4
r(n,m)=corr(yhat(:,n),yhat(:,m+1));
    end
end

%    -0.0736    0.5613    0.1434    0.0835
%     1.0000   -0.1715   -0.2682   -0.3015
%    -0.1715    1.0000   -0.3284   -0.3166
%    -0.2682   -0.3284    1.0000   -0.2859

for m=1:4
    for n=1:4
r(n,m)=corr(pexp_xval_dp(:,n),pexp_xval_dp(:,m+1));
    end
end

%    -0.0739    0.5766    0.1435    0.0761
%     1.0000   -0.1659   -0.2725   -0.3025
%    -0.1659    1.0000   -0.3208   -0.3163
%    -0.2725   -0.3208    1.0000   -0.2867
