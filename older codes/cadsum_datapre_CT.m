function cadsum_datapre_CT()
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
disp('Reading CT file ...')

if nargin == 0
    files = spm_select(1,'.mat','Select cortical thickness file');
end

load(files);

L = length(label);

k = 1;
for i = 1:L
    CT(k) = CTV.lh(i); lab{k} = ['L ',label{i}]; k = k+1; 
    CT(k) = CTV.rh(i); lab{k} = ['R ',label{i}]; k = k+1; 
end
% load cameg_surffile    

figure
barh(CT);    % Plot with errorbars
% legend(lab)
% errorbar(mTh',stdTh','rx')
set(gca,'Ytick', 1:length(CT),'YtickLabel',lab);
box off
set(gca,'color','none');
title('CT values');
set(gcf, 'Position', [800   100   500   1200]);


% CT = 
save cameg_CTfile CT lab

disp('CT was importaed and saved!')