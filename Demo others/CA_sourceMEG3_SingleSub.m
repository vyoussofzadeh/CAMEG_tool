close all; clc; clear all

%% load conn
files = spm_select(1,'.mat','Select source MEG files');
load(files)


%% Updating furface file
cameg_datapre_updatesurf(abs(cp))
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

Tr = 5; % P value
tedge = nedge > Tr;
figure(1),
subplot 313
plot_conn(tedge,num2cell(1:n), 'thresholded (p < 0.05) conn mat');
set(gcf, 'Position', [800   100   600   1200]);
% end
dlmwrite('edge.edge',tedge,'\t');

% load('cameg_meshfile');
% Mesh = files;
Mesh = 'E:\My Matlab\My codes\My GitHub\CAMEG\External functions\BrainNet\BrainMesh_ICBM152_smoothed.nv';

Node = 'node.node';
Edge = 'edge.edge';
figure(3)
BrainNet_MapCfg(Mesh,Node,Edge);
view([0 -90 0])
% designmat = []