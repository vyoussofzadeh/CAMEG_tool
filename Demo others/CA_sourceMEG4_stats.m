close all; clc; clear all


disp('Kids  = 1');
disp('Teens = 2');
disp('All   = 3');
in = input ('Enter group type? ');

disp('----------1');
disp('Age = 1');
disp('EVT = 2');
disp('PPVT = 3');
disp('standard EVT  = 4');
disp('standard PPVT = 5');
disp('Cortical thickness = 6');
in2 = input ('covariate type? ');

load age_all
Age([5,27]) = [];
idx_kid   = find(Age < 10);
idx_teens = find(Age > 10);

load PPVT_all,
load EVT_all
load PPVTstd_all,
load EVTstd_all

if in == 1
    if in2 == 1
        label = 'Age';
        age_kids = Age(idx_kid);
        tar = age_kids;
    elseif in2 == 2
        label = 'EVT';
        EVT_kids = EVT(idx_kid); 
        tar = EVT_kids;
    elseif in2 == 3
        label = 'PPVT';
        PPVT_kids = PPVT(idx_kid);
        tar = PPVT_kids;
    elseif in2 == 4
        label = 'PPVT-std';
        PPVTstd_kids = PPVT_std(idx_kid);
        tar = PPVTstd_kids;
    elseif in2 == 5
        label = 'EVT-std';
        EVTstd_kids = EVT_std(idx_kid);
        tar = EVTstd_kids;
    elseif in2 == 6
        load cameg_ct_Kids
        label = 'CT';
        tar = mean(fCT,1)';
    end
elseif in == 2
    if in2 == 1
        label = 'Age';
        age_teens = Age(idx_teens);
        tar = age_teens;
    elseif in2 == 2
        label = 'EVT';
        EVT_teens = EVT(idx_teens);
        tar = EVT_teens;
    elseif in2 == 3
        label = 'PPVT';
        PPVT_teens = PPVT(idx_teens); 
        tar = PPVT_teens;
    elseif in2 == 4
        label = 'PPVT-std';
        PPVTstd_teens = PPVT_std(idx_teens);
        tar = PPVTstd_teens;
    elseif in2 == 5
        label = 'EVT-std';
        EVTstd_teens = EVT_std(idx_teens);
        tar = EVTstd_teens;
    elseif in2 == 6
        load cameg_ct_Teens
        fCT(:,[5,14]) = [];
        label = 'CT';
        tar = mean(fCT,1)';
    end
elseif in == 3
    if in2 == 1
        label = 'Age';
        tar = Age;
    elseif in2 == 2
        label = 'EVT';
        tar = EVT;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT_all;
    elseif in2 == 4
        label = 'PPVT-std';
        tar = PPVT_std;
    elseif in2 == 5
        label = 'EVT-std';
        tar = EVT_std;
    elseif in2 == 6
        load cameg_ct_all
        label = 'CT';
        tar = mean(fCT,1)';
    end
end

%% Conn mats
if in == 1
    load cameg_ConnKids_mt
elseif in == 2
    load cameg_ConnTeens_mt
elseif in == 3
    load cameg_Connall_mt
end


%% Stats
% Conn  = cat(3,edge{:,in2});
St = zeros(size(Conn,1),size(Conn,2));
for i = 1: size(Conn,1)
    for j = 1: size(Conn,2)
        for k = 1: size(Conn,3)
            t(k)  = Conn(i,j,k);
        end
        [h,p,ci,stats] = ttest(t);
        [r, pcorr] = corr(tar,t');
        pCorr(i,j) = pcorr;
        Corr(i,j) = r;
        St(i,j) = p;
    end
end
figure(1),
subplot 311
imagesc(St);colorbar,title('P significance');
subplot 312
tpCorr = pCorr < 0.01;
imagesc(tpCorr);colorbar,title('P corr < 0.05');
subplot 313
imagesc(Corr);colorbar,title('corr');
set(gcf, 'Position', [800   100   400   1000]);


%% visualisation
cp = con2power(abs(Corr)); n = length(cp);
figure(2)
barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
set(gcf, 'Position', [900   200   500   900]);
box off
set(gca,'color','none');
title('Correlation strength')
ROI

% BrainNet
% cp = cp./max(cp);
cp = con2power(tpCorr);
cameg_datapre_updatesurf(cp);
tmp = zeros(size(tpCorr,1),size(tpCorr,2));
dlmwrite('edge.edge',tmp,'\t');
Mesh = 'E:\My Matlab\My codes\My GitHub\CAMEG\External functions\BrainNet\BrainMesh_ICBM152_smoothed.nv';
Node = 'node.node';
Edge = 'edge.edge';
figure(4)
BrainNet_MapCfg(Mesh,Node,Edge);


pause
close all
% cp = con2power(tpCorr);
cameg_datapre_updatesurf(1./mean(fCT,2)');
tmp = zeros(size(tpCorr,1),size(tpCorr,2));
dlmwrite('edge.edge',tmp,'\t');
Mesh = 'E:\My Matlab\My codes\My GitHub\CAMEG\External functions\BrainNet\BrainMesh_ICBM152_smoothed.nv';
Node = 'node.node';
Edge = 'edge.edge';
figure(4)
BrainNet_MapCfg(Mesh,Node,Edge);
view([95,6])

