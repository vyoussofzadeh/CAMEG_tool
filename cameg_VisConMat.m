function cameg_VisConMat()
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

load([pwd,'\saved outputs\cameg_matfile.mat']);
figure;
plot_conn(sedge,[],'Conn mat'); 
L = length(sedge);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));


sedge = (sedge.* double(sedge > 0.7.*max(max(sedge))));
figure;
plot_conn(sedge,[],'Thresholded conn mat'); 
L = length(sedge);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));
