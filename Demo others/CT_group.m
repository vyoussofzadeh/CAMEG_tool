close all; clc; 

files = spm_select(1,'.mat','Select source MEG files');

load(files);

fs = input('Enter sampling frequency e.g. 1200 [Hz]: ');


L = length(Atlas.Scouts);
Value = Value(1:L,:);

for i = 1:L
    roi{i}= Atlas.Scouts(i).Region;
    roi_l{i}= Atlas.Scouts(i).Label;
end


figure,
hl = plot(Time, Value);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities');
for i = 1:L, lab2{i} = num2str(i); end
clickableLegend(hl,lab2, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

in = input('Segment data (yes = 1)?');

if in ==1
    seg = input('Set time intervals e.g., [300,700] ms: ');
    f1 = knnsearch(Time',seg(1)/1e3);
    f2 = knnsearch(Time',seg(2)/1e3);
    
    Value = Value(:,f1:f2);
    Time  = Time(:,f1:f2);
end

clf,
hl = plot(Time, Value);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities');
clickableLegend(hl,roi, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);


B = num2cell(1:L);
ROI = (cell2table([B;roi;roi_l]'))

files = spm_select(1,'.mat','Select cortical thickness file');
load(files);

% L = length(label);

k = 1;
for i = 1:L/2
    CT(k) = CTV.lh(i); lab{k} = ['L ',label{i}]; k = k+1;
    CT(k) = CTV.rh(i); lab{k} = ['R ',label{i}]; k = k+1;
end

figure
barh(CT);    % Plot with errorbars
set(gca,'Ytick', 1:length(CT),'YtickLabel',1:L);
box off
set(gca,'color','none');
title('CT values');
ylabel('ROI');
xlabel('mm');
set(gcf, 'Position', [800   100   500   1200]);

disp('Correlation of MEG sources with cortical thickness');
disp('Magnitude = 1');
disp('Mean       = 2');
disp('max power  = 3');

in = input('operator: ');

if in == 1
    mValue = mean(abs(Value),2);
elseif in == 2
    mValue = mean((Value),2);
elseif in == 2
    mValue = max((abs(Value)'))';
end

% nmValue = mValue./max(mValue);
% nCT = CT./max(CT);

nmValue = zscore(mValue);
nCT = zscore(CT);

clf
% figure
barh([nCT',nmValue]);    % Plot with errorbars
set(gca,'Ytick', 1:length(mValue),'YtickLabel',1:L);
box off
set(gca,'color','none');
title('Mean abs value of sources');
legend({'CT','MEG source mag'})
set(gcf, 'Position', [800   100   500   1200]);

% figure,
% scatter(mValue,CT)
% [r,p] = corr(CT',mValue,'Type','Spearman');
% box off
% set(gca,'color','none');
% title(['correlation, r = ',num2str(r),' (p =', num2str(p),')']);
% ylabel('mm');

figure,
scatter(nmValue,nCT)
[r,p] = corr(nCT',nmValue,'Type','Spearman');
box off
set(gca,'color','none');
title(['correlation, r = ',num2str(r),' (p =', num2str(p),')']);
ylabel('mm');
xlabel('source values')




