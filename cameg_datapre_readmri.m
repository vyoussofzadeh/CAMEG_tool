function cameg_datapre_readmri()
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
disp('Reading MRI data ...')

if nargin == 0
    files = spm_select(1,'.mat','Select MRI file');
end

save([pwd,'\saved outputs\cameg_mrifile.mat'],'files');

disp('MRI imported!')