function cameg_ConnF()
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
% load cameg_datafile
load([pwd,'\saved outputs\cameg_matfile.mat']);
figure,
barh(aflux),
L = length(aflux);
for j = 1:L, lab{j} = num2str(j); end
set(gca,'ytick', 1:L,'ytickLabel',lab);
box off
set(gca,'color','none');
title('Flux (abs)');
set(gcf, 'Position', [900   200   400   900]);
disp('---------------------');