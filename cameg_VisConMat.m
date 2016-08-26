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

[LH, RH] = cameg_LHRHdet(ssROI);
fsedge   = [sedge(LH,LH), sedge(LH,RH); sedge(RH,LH), sedge(RH,RH)];
flabel = ssROI.Regions([LH,RH]);

figure;
plot_conn(sedge,[],'Conn mat');
axis square
L = length(sedge);
set(gca,'ytick', 1:L,'ytickLabel',flabel);
set(gca,'xtick', 1:L,'xtickLabel',flabel);
set(gcf, 'Position', [900   200   900   900]);


sedge = (sedge.* double(sedge > 0.7.*max(max(sedge))));
figure;
plot_conn(sedge,[],'Thresholded conn mat'); 
L = length(sedge);
axis square
set(gca,'ytick', 1:L,'ytickLabel',flabel);
set(gca,'xtick', 1:L,'xtickLabel',flabel);
set(gcf, 'Position', [900   200   900   900]);
disp('---------------------');