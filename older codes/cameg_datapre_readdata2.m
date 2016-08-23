function cameg_datapre_readdata()
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

disp('-----------------------');
disp('1: Single-subject (multi-trial data)');
disp('2: Averaged sources (single-trial data)');
in = input('Please enter?');

if in == 1
    cameg_datapre_readdata_mt
elseif in == 2
    cameg_datapre_readdata_ave
end