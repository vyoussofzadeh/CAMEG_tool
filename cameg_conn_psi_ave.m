function cameg_conn_psi_ave(Value)
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
load([pwd,'\saved outputs\cameg_datafile.mat'])

% msaValue = squeeze(mean(ssValue_roi,1));

disp('Connectivity measure, PSI ...')
frq{1} = 2:4;
frq{2} = 4:7;
frq{3} = 8:13;
frq{4} = 15:29;
frq{5} = 30:70;
frq{6} = 1:13;
% 
label = {'Delta (2-4)','Theta (4-7)','Alpha (8-13)','Beta (15-29)','Gamma (30-70)','Custom (1-13)'};

% ntrl = size(ssValue_roi,1);
ns   = size(ssValue_roi,1); % number of sources

% display(['nTrial: ', num2str(ntrl)])
display(['ROIs: ', num2str(ns)])
display('PSI prams ...');
epleng = size(ssValue_roi,2);
display(['Epoch length: ', num2str(epleng), ' samples, corresponding to ', num2str(epleng/fs), ' sec'])
seglen = epleng;
display(['Segment length: ', num2str(seglen), ' samples, corresponding to ', num2str(seglen/fs), ' sec'])

% rsValue = reshape(ssValue_roi,[epleng*ntrl,ns]);

for fq = 1:length(frq)
    [psi, stdpsi, psisum, ~] = data2psi(ssValue_roi',seglen,epleng,frq{fq});
    npsi = psi;
    p{fq} = 2*normcdf(-abs(npsi));
    edge{fq} = npsi;
    flux{fq} = psisum;
    disp([label{fq}, ' freq was computed!']);
end
disp('---------------------');
save([pwd,'\saved outputs\cameg_conn.mat'], 'edge','flux','p','label','frq','ssROI','idxp');
disp('Conn mats were computed and saved!');



