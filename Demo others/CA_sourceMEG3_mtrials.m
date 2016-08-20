close all; clc; clear all

%% load conn
% disp('Kids  = 1');
% disp('Teens = 2');
% disp('All   = 3');
% in = input ('Enter group type? ');
% 
% if in == 1
%     load cameg_ConnKids_mt
% elseif in == 2
%     load cameg_ConnTeens_mt
% elseif in == 3
%     load cameg_Connall_mt
% end

files = spm_select(1,'.mat','Select source MEG files');
load(files)

in3  = input('idxp = 1 ?');
if in3 ==1
    cameg_datapre_readsurf_m(idxp)
else
    cameg_datapre_readsurf_m(1:length(cp));
end

%% Updating furface file
% cameg_datapre_updatesurf(abs(cp))
cameg_datapre_updatesurf(aflux')

n = length(cp);
%% Conn mat
figure(1)
subplot 211
plot_conn(nedge,num2cell(1:n), 'npsi'); title(['mean value of ',FB]);
set(gcf, 'Position', [800   100   1200   800]);
figure(2)
barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
set(gcf, 'Position', [900   200   500   900]);
box off
set(gca,'color','none');
% figure(1)
% subplot 312
% imagesc(St);colorbar,title('P significance');
% set(gcf, 'Position', [800   100   600   1000]);
ROI

% Flux
figure(3)
barh(aflux),
for j = 1:n, lab{j} = num2str(j); end
set(gca,'ytick', 1:length(cp),'ytickLabel',lab);
box off
set(gca,'color','none');
title(['Flux (abs)']);
set(gcf, 'Position', [900   200   500   900]);
disp('---------------------');

if exist('St')
    Tr = 0.01; % P value
    tedge = St < Tr;
else
    Tr = 5; % P value
    tedge = nedge > Tr;
end
figure(1),
subplot 212
plot_conn(tedge,num2cell(1:n), 'thresholded (p < 0.01) conn mat');
set(gcf, 'Position', [800   100   600   1200]);
% end
dlmwrite('edge.edge',tedge,'\t');

% load('cameg_meshfile');
% Mesh = files;
Mesh = 'E:\My Matlab\My codes\My GitHub\CAMEG\External functions\BrainNet\BrainMesh_ICBM152_smoothed.nv';

Node = 'node.node';
Edge = 'edge.edge';
figure(4)
BrainNet_MapCfg(Mesh,Node,Edge);
view([0 -90 0])
% designmat = []