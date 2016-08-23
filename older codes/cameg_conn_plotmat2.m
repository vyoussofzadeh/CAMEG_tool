function cameg_conn_plotmat()
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

load cameg_file
load(files)



plot_conn(n,npsi,roi, 'npsi');
thre = 10;
[conn_label,conn_roi] = find_lab_conn(npsi,thre, roi, roi_l);
edge = npsi > thre;
dlmwrite('npsi.edge',edge,'\t');

disp('Connectivity file was saved!')