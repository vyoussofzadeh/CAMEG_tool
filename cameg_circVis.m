function cameg_circVis()
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

load([pwd,'\saved outputs\cameg_matfile.mat']);

myLabel = cell(size(ssROI,1),1);
for i = 1:size(ssROI,1)
  myLabel{i} = ssROI.Var3(i);
end

sedge = sedge.* double(sedge > 0);
figure,
circularGraph(sedge,'Label',myLabel);
set(gcf, 'Position', [500   100   700   700]);
set(gca,'color','none');

% box off
% set(gca,'color','none');

id = table([1:size(ssROI,1)]','VariableNames',{'id'});
C = [id,ssROI]


