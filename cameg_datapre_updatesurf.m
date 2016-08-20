function cameg_datapre_updatesurf()
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
disp('Updating surface data ...')

load([pwd,'\saved outputs\cameg_surffile.mat']);
load([pwd,'\saved outputs\cameg_matfile.mat']);

newPosMNI = newPosMNI(idxp,:);
m = m(idxp);
c = c(idxp);
L = L(idxp);
d = d(idxp,:);

node = strcat(num2str([newPosMNI,m,aflux,L]),d);
node(:,end-4:end-3) = char(' ');


dlmwrite([pwd,'\saved outputs\node.node'],node,'delimiter','');


disp('Surface file was updated (weighted by conn flux)!')