function cameg_DataVis()
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
load([pwd,'\saved outputs\cameg_datafile.mat']);
idx = findstr(files,'\');
sub = ['Subject: ',files(idx(end-2)+1:idx(end-1)-1)];
display(sub)

L = size(ssROI,1);
id = table([1:L]','VariableNames',{'id'});
C = [id,ssROI]

if mt == 1
    maValue = squeeze(mean(ssValue_roi,1));
elseif mt == 2
    maValue = ssValue_roi;
end

h1 = figure;
hl = plot(Time, maValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title(['Ave of source activities,',sub]);
for i = 1:L, lab{i} = num2str(i); end
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
box off
set(gca,'color','none');
set(gcf, 'Position', [800   100   1200   800]);