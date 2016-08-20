function cameg_datapre_datasubtraction()
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
disp('Reading source data ...')

if nargin == 0
    files = spm_select(2,'.mat','Select source MEG files');
end

for i = 1:size(files,1)
    load(files(i,:));
    Data{i} = Value;
end

fs = input('Enter sampling frequency e.g. 1200 [Hz]: ');

%% Subtraction
Value = Data{2} - Data{1};

for i = 1:size(Value,1)
    roi{i}= Atlas.Scouts(i).Region;
    roi_l{i}= Atlas.Scouts(i).Label;
end

figure, 
hl = plot(Time, Value);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities');
clickableLegend(hl,roi, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

%% Segmenting data
fs = size(Value,2);
in = input('Segment data (yes = 1)?');

if in ==1
    seg = input('Set time intervals e.g., [300,700] ms: ');
    Value = Value(:,floor(seg(1)*fs./1000):floor(seg(2)*fs./1000));
    Time = Time(:,floor(seg(1)*fs./1000):floor(seg(2)*fs./1000));
end
clf, 
hl = plot(Time, Value);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities');
clickableLegend(hl,roi, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

A = (cell2table([roi;roi_l]'))

save cameg_datafile files A Value Time roi

disp('Data was imported!')