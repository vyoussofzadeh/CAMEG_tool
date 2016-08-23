function cameg_datapre_ROIdet_CT()
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

%% Spectral analysis
load([pwd,'\saved outputs\cameg_datafile.mat']);
load([pwd,'\saved outputs\cameg_CT_all.mat']);

sROI = ROI(idxp,:);
id = table([1:length(idxp)]','VariableNames',{'id'});
C = [id,sROI]
ssValue = sValue(:,idxp,:);

ssaValue = squeeze(mean(ssValue,1));

clf,
hl = plot(Time, ssaValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities (selected)');
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
box off
set(gca,'color','none');
set(gcf, 'Position', [800   100   1200   800]);


save([pwd,'\saved outputs\cameg_datafile.mat'], 'files', 'Atlas', 'ssValue','ssValue_roi', 'Time', 'idxp','sROI','ssROI', 'mt','mpxx','nroi');





