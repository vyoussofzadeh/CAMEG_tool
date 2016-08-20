close all; clc; clear all

%% load conn

disp('Kids  = 1');
disp('Teens = 2');
disp('All   = 3');
in = input ('Enter group type? ');

if in == 1
    load cameg_ConnKids
elseif in == 2
    load cameg_ConnTeens
elseif in == 3
    load cameg_Connall
end

in3  = input('idxp = 1 ?');
if in3 ==1
    cameg_datapre_readsurf_m(idxp)
else
    cameg_datapre_readsurf_m(1:length(cp));    
end

%% Updating furface file
cameg_datapre_updatesurf(abs(cp))
n = length(cp);
%% Conn mat
figure(1)
plot_conn(nedge,num2cell(1:n), 'npsi'); title(['mean value of ',FB]);
set(gcf, 'Position', [800   100   1200   800]);
figure(2)
barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
set(gcf, 'Position', [900   200   500   900]);
ROI

in = input('Thresholding (yes = 1)?');

if in ==1
    thre = input('Set the threshold: ');
    tedge = abs(nedge) > thre;
    figure(3),
    plot_conn(tedge,num2cell(1:n), 'thresholded conn mat');
    set(gcf, 'Position', [800   200   1000   1000]);
end
dlmwrite('edge.edge',tedge,'\t');

%% Graph theory measures
gedge = double(tedge);
G = [];
% G.deg = degrees_und(gedge);
G.str = strengths_und(gedge); 
% [J,J_od,J_id,J_bl] = jdegree(tedge);
% gt = gtom(,5);
G.BC = betweenness_bin(gedge);
% [EBC,BC] = edge_betweenness_bin(gedge);
% Z = module_degree_zscore(W,Ci,flag);
% [f,F] = motif4funct_bin(gedge);
[fc,FC,total_flo] = flow_coef_bd(gedge);
G.total_flo = total_flo;
G.fc = fc;
% [Erange,eta,Eshort,fs] = erange(gedge);
G1 = struct2cell(G);
G2 = vertcat(G1{:});

figure(4)
barh(G2'),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
set(gcf, 'Position', [900   200   500   900]);


% load('cameg_meshfile');
% Mesh = files;
% Node = 'node.node';
% Edge = 'edge.edge';
% BrainNet_MapCfg(Mesh,Node,Edge);
% view([0 -90 0])

% designmat = []