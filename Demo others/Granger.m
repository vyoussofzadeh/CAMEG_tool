close all,
clc,
% clear all;

Datafile = spm_select(1,'.mat','Select multi-trial source MEG files');

load(Datafile);

LScouts = length(Atlas.Scouts);
Ltrials = 1;

for i = 1:LScouts
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

p = 20;
[ar, tmpnoisecov] = armorf(Value,1,size(Value,1),p);
ar = - ar;

%% Fieldtrip
cfg             = [];
cfg.ntrials     = Ltrials;
cfg.triallength = 1;
cfg.fsample     = 1200;
cfg.nsignal     = size(Value,1);
cfg.method      = 'ar';
% 
% cfg.params(:,:,1) = [ 0.8    0    0 ; 
%                         0  0.9  0.5 ;
%                       0.4    0  0.5];
%                       
% cfg.params(:,:,2) = [-0.5    0    0 ; 
%                         0 -0.8    0 ; 
%                         0    0 -0.2];
%                         
% cfg.noisecov      = [ 0.3    0    0 ;
%                         0    1    0 ;
%                         0    0  0.2];
% 
% data              = ft_connectivitysimulation(cfg);