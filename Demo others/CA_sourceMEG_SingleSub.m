close all; clc; clear all

path = spm_select(Inf,'dir','Select folder');


datatype = '*_Mindall.mat';
files = sinead_findfiles (path,datatype);

in = input ('Applying ROI indecies (based on CT analysis) = 1? ');

if in == 1
    disp('Kids  = 1');
    disp('Teens = 2');
    disp('All  = 3');
    in2 = input ('Enter group type? ');
    if in2 == 1
        load cameg_sigROI_all
    elseif in2 == 2
        load cameg_sigROI_all
    elseif in2 == 3
        load cameg_sigROI_all
    end
end

L_trial = 71;
for j = 1:size(files,2)
    path2 = files{1,j}(1:end-12);
    f = dir([path2,'\*_Mindall.mat']);
    load ([path2,'\',f.name]);
    n_source = length(Atlas.Scouts);
    if in ==1
        aValue(:,:,j) = Value(idxp,:);
    else
        aValue(:,:,j) = Value(1:n_source*L_trial,:);
    end
    aTime(:,:,j) = Time;
end

% Average
mValue = reshape(aValue,[71,size(aValue,1)/71,size(aValue,2),size(aValue,3)]);
maValue = mean(squeeze(mean(mValue,1)),3); % Average over trials and subjects
L = size(maValue,1);

figure,
hl = plot(Time, maValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities, average');
for i = 1:n_source, lab{i} = num2str(i); end
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

if in == 1
    for i = 1:L
        roi{i}= Atlas.Scouts(idxp(i)).Region;
        roi_l{i}= Atlas.Scouts(idxp(i)).Label;
    end
else
    for i = 1:L
        roi{i}= Atlas.Scouts(i).Region;
        roi_l{i}= Atlas.Scouts(i).Label;
    end
end

B = num2cell(1:L);
ROI = (cell2table([B;roi;roi_l]'))

%% Segmenting data
in3 = input('Segment data (yes = 1)?');

if in3 ==1
    seg = input('Set time intervals e.g., [300,700] ms: ');
    
    f1 = knnsearch(Time',seg(1)/1e3);
    f2 = knnsearch(Time',seg(2)/1e3);
    
    saValue = mValue(:,:,f1:f2,:);
    Time  = Time(:,f1:f2);
else
    saValue = mValue;
end

msaValue = mean(squeeze(mean(saValue,1)),3);
figure,
hl = plot(Time, msaValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities, average');
for i = 1:L, lab{i} = num2str(i); end
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

in4 = input ('Save data = 1? ');

if in4 == 1
    in5 = input ('Enter subject number? ');
    save(['cameg_MEGsource_sub',num2str(in5),'.mat'],'aValue', 'saValue', 'Time', 'Atlas', 'ROI');
end


