function cameg_VisPSD()
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
fh = length(findall(0,'type','figure'));
L = length(Atlas.Scouts);

figure(fh+1);
p1 = plot(10*log10(mpxx(:,2:29)'));
title('PSD');
for i = 1:L, lab{i} = num2str(i); end
clickableLegend(p1,lab, 'plotOptions', {'MarkerSize', 6});

mmpxx = squeeze(mean(mpxx(:,2:29),2));
figure(fh+2);
barh(mmpxx),
for j = 1:L, lab{j} = num2str(j); end
set(gca,'color','none');
title('PSD ');
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
box off

[~, idxp] = sort(mmpxx, 'descend');
idxp = idxp(1:nroi);

figure(fh+1);
hold on 
plot(10*log10(mpxx(idxp,2:29)'),'LineWidth',4);
set(gcf, 'Position', [950   100   700   1200]);
xlim([2,29])

figure(fh+2);
sig_mmpxx = zeros(1,length(mmpxx));
sig_mmpxx(idxp) = mmpxx(idxp);
hold on
h = barh(sig_mmpxx);
set(h, 'FaceColor', 'r')
set(gcf, 'Position', [200   100   700   1200]);
legend('PSD power','PSD power (ROIs)');

id = table([1:nroi]','VariableNames',{'id'});
C = [id,ssROI]

% figure(fh+3);
% barh(mmpxx(idxp));
% set(gcf, 'Position', [200   100   700   1200]);
% legend('PSD power','PSD power (ROIs)');
