function cameg_datapre_ROIdet_PSD()
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
L = length(Atlas.Scouts);
fs = input('Enter sampling frequency e.g. 1200 [Hz]: ');

disp('Computing PSD ...')
for i = 1:size(ssValue,1)
    parfor j = 1:size(ssValue,2)
        x = squeeze(ssValue(i,j,:));
        pxx(i,j,:) = pwelch(x',[],[],fs);
    end
end
disp('PSD was computed!')

mpxx = squeeze(mean(pxx,1));

h2 = figure;
plot(10*log10(mpxx(:,2:29)'));
title('PSD');

mmpxx = squeeze(mean(mpxx(:,2:29),2));
h3 = figure;
barh(mmpxx),
for j = 1:L, lab{j} = num2str(j); end
set(gca,'color','none');
title('PSD ');
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
box off
set(gcf, 'Position', [900   200   700   900]);
%%
nroi = input('number of ROIs (e.g., 5)?');
[~, idxp] = sort(mmpxx, 'descend');
ssValue_roi = ssValue(:,idxp(1:nroi),:);
ssROI = sROI(idxp(1:nroi),:);
idxp = idxp(1:nroi);

save([pwd,'\saved outputs\cameg_datafile.mat'], 'files', 'Atlas', 'ssValue','ssValue_roi', 'Time', 'idxp','sROI','ssROI', 'mt','mpxx','nroi');







