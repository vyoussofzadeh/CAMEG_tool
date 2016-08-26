function cameg_VisSurf()
% ___________________________________________________________________________
% Connectivity analysis of MEG data (CA-MEG)
%
% Copyright 2016 Cincinnati Children's Hospital Medical Center
% Reference 
% 
% 
% v1.0 Vahab Youssofzadeh 21/07/2016
% email: Vahab.Youssofzadeh@cchmc.org
% ___________________________________________________________________________

load([pwd,'\saved outputs\cameg_meshfile.mat']);
Mesh = files;

load([pwd,'\saved outputs\cameg_matfile.mat']);

disp('Intraconnectivity    = 1');
disp('Interconnectivity    = 2');
disp('Full connectivity    = 3');
in = input('Enter interaction type: ');

[LH, RH] = cameg_LHRHdet(ssROI);

A1 = zeros(size(LH,2),size(RH,2));
A2 = zeros(size(RH,2),size(LH,2));
A3 = zeros(size(LH,2),size(LH,2));
A4 = zeros(size(RH,2),size(RH,2));

sedge_inter  = [sedge(LH,LH)  , A1           ; A2         , sedge(RH,RH)];
sedge_intra  = [A3           , sedge(LH,RH)  ; sedge(RH,LH), A4       ];
sedge_full   = [sedge(LH,LH)  , sedge(LH,RH)  ; sedge(RH,LH), sedge(RH,RH)];

if in == 1
    nsedge = sedge_inter;
elseif in == 2
    nsedge = sedge_intra;
elseif in == 3
    nsedge = sedge_full;
end
nsedge = nsedge';    
ntsedge = (nsedge.* double(nsedge > 0.70.*max(max(nsedge))));
dlmwrite([pwd,'\saved outputs\edge.edge'],ntsedge,'\t');
Edge = [pwd,'\saved outputs\edge.edge'];

%% Updating surface file
idxp = [LH,RH];
cameg_datapre_updatesurf(idxp,5*aflux);
Node = [pwd,'\saved outputs\node.node'];

id = table([1:size(ssROI,1)]','VariableNames',{'id'});
C = [id,ssROI]

EC = [pwd,'\Data\BrainNet option\BN_option8.mat'];

BrainNet_MapCfg(Mesh,Node,Edge, EC);
view([0 -90 0])

load([pwd,'\saved outputs\cameg_datafile.mat']);
idx = findstr(files,'\');
sub = ['Sub: ',files(idx(end-2)+1:idx(end-1)-1)];
display(sub)
title(sub);


