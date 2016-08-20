clc; clear all;close all;

load cameg_multipletrialconn


display('1: Delta');
display('2: Theta');
display('3: Alpha');
display('4: Beta');
display('5: Full bands');
label = {'Delta','Theta','Alpha','Beta','Full freq'};
in  = input('surface visualisation (1-5):');

% Conn mat
Conn  = cat(3,edge{:,in});

St = zeros(size(Conn,1),size(Conn,2));
for i = 1: size(Conn,1)
    for j = 1: size(Conn,2)
        for k = 1: size(Conn,3)
            tmp(k)  = Conn(i,j,k);
        end
        [h,p,ci,stats] = ttest(tmp);
        St(i,j) = stats.tstat;
%         St(i,j) = 1/p;
    end
end
figure,imagesc(St);colorbar



thre = input('Set the threshold: ');
ttmp = St > thre;

dlmwrite('edge.edge',ttmp,'\t');

load('cameg_meshfile');
Mesh = files;
Node = 'node.node';
Edge = 'edge.edge';

% Power of conn
cp = con2power(ttmp);
figure, barh(cp), 
set(gca,'ytick', 1:length(cp),'ytickLabel',roi);
box off
set(gca,'color','none');
title('Connectivity Strength');
set(gcf, 'Position', [900   200   500   900]);

%% Updating furface file
cameg_datapre_updatesurf(cp)

% figure(3),
BrainNet_MapCfg(Mesh,Node,Edge);title(label{in});
view([-53 4 0])