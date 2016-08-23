function cameg_surfVis()
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



load([pwd,'\saved outputs\cameg_meshfile.mat']);
Mesh = files;

load([pwd,'\saved outputs\cameg_matfile.mat']);
L = size(ssROI,1);

for i = 1:L
    R = ssROI.Var2(i);
    if R{1}(1) == 'L'
        m(i) = 4;
    else
        m(i) = 3;
    end
end

disp('');
disp('-----------------');
disp('1-Both hemisphres (inter- and intra hem conns)');
disp('2-Left hemisphre (inter-hem conns)');
disp('3-Right hemisphre (inter-hem conns)');
disp('                 ');
in = input('Select hemisphre you want 1,2 or 3? ');


% conns at left and right hemisphres
LH = find(m == 4);
RH = find(m == 3);

if in == 1
    idxp2 = idxp;
    if L > 30
        sedge = (sedge.* double(sedge > 0.70.*max(max(sedge))));
    else
        sedge = (sedge.* double(sedge > 0.40.*max(max(sedge))));
    end
elseif in == 2
    sedge = sedge(LH,LH);
     idxp2 = LH;
    if L > 30
        sedge = (sedge.* double(sedge > 0.70.*max(max(sedge))));
    else
        sedge = (sedge.* double(sedge > 0.40.*max(max(sedge))));
    end
elseif in == 3
    sedge = sedge(RH,RH);
    idxp2 = RH;
    if L > 30
        sedge = (sedge.* double(sedge > 0.70.*max(max(sedge))));
    else
        sedge = (sedge.* double(sedge > 0.40.*max(max(sedge))));
    end
end

dlmwrite([pwd,'\saved outputs\edge.edge'],sedge,'\t');
Edge = [pwd,'\saved outputs\edge.edge'];

%% Updating surface file
cameg_datapre_updatesurf(idxp2);
Node = [pwd,'\saved outputs\node.node'];

id = table([1:size(ssROI,1)]','VariableNames',{'id'});
C = [id,ssROI]

EC = [pwd,'\Data\BrainNet option\BN_option7.mat'];

BrainNet_MapCfg(Mesh,Node,Edge, EC);
view([0 -90 0])

load([pwd,'\saved outputs\cameg_datafile.mat']);
idx = findstr(files,'\');
sub = ['Sub: ',files(idx(end-2)+1:idx(end-1)-1)];
display(sub)
title(sub);


