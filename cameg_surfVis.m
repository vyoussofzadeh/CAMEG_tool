function cameg_surfVis()
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
Node = [pwd,'\saved outputs\node.node'];
Edge = [pwd,'\saved outputs\edge.edge'];

load([pwd,'\saved outputs\cameg_matfile.mat']);
id = table([1:size(ssROI,1)]','VariableNames',{'id'});
C = [id,ssROI]

EC = [pwd,'\Data\BrainNet option\BN_option7.mat'];

BrainNet_MapCfg(Mesh,Node,Edge, EC);
view([0 -90 0])

load([pwd,'\saved outputs\cameg_datafile.mat']);
idx = findstr(files,'\');
sub = ['Sub: ',files(idx(end-2)+1:idx(end-1)-1)];
display(sub)
title(sub);


