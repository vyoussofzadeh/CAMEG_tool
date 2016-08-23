function cameg_datapre_readdata_mt()
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

mt = 1;

disp('Reading source data ...')

if nargin == 0
    files = spm_select(1,'.mat','Select source MEG files');
end

load(files);
disp('-----------------------');
fs = input('Enter sampling frequency e.g. 1200 [Hz]: ');

L = length(Atlas.Scouts);

for i = 1:L
    roi{i}= Atlas.Scouts(i).Region;
    roi_l{i}= Atlas.Scouts(i).Label;
end
ntrl = size(Value,1)./L;
display(['nTrial: ', num2str(ntrl)])
display(['ROIs: ', num2str(L)])

mValue = reshape(Value,[ntrl,size(Value,1)/ntrl,size(Value,2)]);
maValue = squeeze(mean(mValue,1));

%%
h1 = figure,
hl = plot(Time, maValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('Ave of source activities');
for i = 1:L, lab{i} = num2str(i); end
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
box off
set(gca,'color','none');
set(gcf, 'Position', [800   100   1200   800]);

B = num2cell(1:L);
ROI = (cell2table([B;roi;roi_l]'))

% pause
%% Segmenting data
in1 = input('Segment data (yes = 1)?');

if in1 ==1
    seg = input('Set time intervals e.g., [300,700] ms: ');
    f1 = knnsearch(Time',seg(1)/1e3);
    f2 = knnsearch(Time',seg(2)/1e3);
    sValue = mValue(:,:,f1:f2);
    Time  = Time(:,f1:f2);
    saValue = squeeze(mean(sValue,1));
    
    clf,
    hl = plot(Time, saValue);
    xlabel('Time(s)');
    ylabel('Amplitude(AU)');
    title('source activities (selected)');
    clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
    box off
    set(gca,'color','none');
    set(gcf, 'Position', [800   100   1200   800]);
else
    sValue = mValue;
end
%% informed by CT
in2 = input('informing by CT (yes = 1)?');
if in2 ==1
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
else
    ssValue = sValue;
    sROI = ROI;
    idxp = 1:L;
end
%% Spectral analysis
in3 = input('informing by PSD (yes = 1)?');
for i = 1:size(ssValue,1)
    parfor j = 1:size(ssValue,2)
        x = squeeze(ssValue(i,j,:));
        pxx(i,j,:) = pwelch(x',[],[],fs);
    end
end
mpxx = squeeze(mean(pxx,1));
if in3 == 1
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
else
    ssValue_roi = ssValue;
    ssROI = sROI;
    idxp = 1:L;
    nroi = L;
end
%%
save([pwd,'\saved outputs\cameg_datafile.mat'], 'files', 'Atlas', 'fs', 'ssValue','ssValue_roi', 'Time', 'idxp','sROI','ssROI', 'mt','mpxx','nroi');

disp('Data was imported!')
% pause(4),
in4 = input('close the openned figures (yes = 1)?');
if in4 == 1
    delete(h1)
    if in3 == 1
        delete(h2)
        delete(h3)
    end
end
