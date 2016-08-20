function cameg_conn_psi()
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
disp('Connectivity measure, PSI ...')

load([pwd,'\saved outputs\cameg_datafile.mat'])

if mt == 1
    display('Multitrial data ...'); pause(1)
    cameg_conn_psi_mt
elseif mt == 2
    display('Averaged or single trial data ...'); pause(1)
    cameg_conn_psi_ave
end

