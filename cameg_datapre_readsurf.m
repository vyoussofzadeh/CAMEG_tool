function cameg_datapre_readsurf()
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
disp('Reading surface data ...')

if nargin == 0
    files = spm_select(1,'.mat','Select surface file');
end

load(files);

%%
load([pwd,'\saved outputs\cameg_mrifile.mat']);
load(files); 

sMri.Voxsize = Voxsize;
sMri.SCS = SCS;
sMri.NCS = NCS;

for i=1:length(Atlas)
    Atlasa{i} = Atlas(i).Name;
end
cell2table(Atlasa)
sel = input('Select an atlas consistant with the data file (e.g. 6)?');
At = Atlas(sel);

% ROI coordinates
for i = 1:length(At.Scouts)
    A = At.Scouts(i).Seed;
    newPosScs = Vertices(A,:);
    newPosVox = round(cs_convert(sMri, 'scs', 'voxel', newPosScs));
    newPosMNI(i,:) = round((1e3.*cs_convert(sMri, 'voxel', 'mni', newPosVox)),1);
end

% Vertex color: modular information
m = ones(length(At.Scouts),1);
% Left  = 1:2:length(At.Scouts);
% Right = 2:2:length(At.Scouts);
% m(Left) = 4;
% m(Right) = 3;

for i = 1:length(m)
    R = At.Scouts(i).Region;
    if R(1) == 'L'
        m(i) = 4;
    else
        m(i) = 3;
    end
end

% m(1:length(At.Scouts)/2) = 3;
% m(length(At.Scouts)/2+1:end) = 4;

% Vertex size: centrality, T-value, etc information
c = ones(length(At.Scouts),1);

% Vertex label
L = zeros(length(At.Scouts),1);

load([pwd,'\saved outputs\cameg_datafile.mat']) 

B = [];
for i = 1:length(At.Scouts), B{i} = num2str(i); end
d = cell2char(B');
node = strcat(num2str([newPosMNI,m,c,L]),d);
node(:,end-4:end-3) = char(' ');
dlmwrite([pwd,'\saved outputs\node.node'],node,'delimiter','');
save([pwd,'\saved outputs\cameg_surffile.mat'],'files', 'newPosMNI', 'm', 'c', 'L', 'd');

disp('Surface file was imported!')

