function cameg_datapre_roiupdate()
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

load([pwd,'\saved outputs\cameg_datafile.mat']);

nroi = input('number of ROIs?');
if mt ==1
    mmpxx = squeeze(mean(mpxx(:,2:29),2));
    [~, idxp] = sort(mmpxx, 'descend');
    ssValue_roi = ssValue(:,idxp(1:nroi),:);
elseif mt ==2
    mmpxx = squeeze(mean(mpxx(:,2:29),2));
    [~, idxp] = sort(mmpxx, 'descend');
    ssValue_roi = ssValue(idxp(1:nroi),:);
end
ssROI = sROI(idxp(1:nroi),:);
idxp = idxp(1:nroi);

save([pwd,'\saved outputs\cameg_datafile.mat'], 'files', 'Atlas', 'fs', 'ssValue','ssValue_roi', 'Time', 'idxp','sROI','ssROI', 'mt','mpxx','nroi');
disp('ROIs were updated!');




