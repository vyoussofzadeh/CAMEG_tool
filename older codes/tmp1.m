% function cameg_freqSel()
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

load([pwd,'\saved outputs\cameg_conn.mat']);

L = size(ssROI,1);
fh = length(findall(0,'type','figure'));
% sROI
id = table([1:L]','VariableNames',{'id'});
C = [id,ssROI]

% visualisation of conn and its magnitude
for i = 1:size(freqs,2)
    tmp  = edge{1,i};
    h1 = figure(fh+2);
    subplot(2,3,i)
    plot_conn(tmp,[], 'npsi'); title(['mean value of ',label{i}]);
    set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
    set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));
    set(gcf, 'Position', [800   200   1200   800]);
end
disp('---------------------');

display('1: Delta (2-4)');
display('2: Theta (4-7)');
display('3: Alpha (8-13)');
display('4: Beta (15-29)');
display('5: Whole range (1-29)');
in2  = input('freq band selection (1-5):');

h2 = figure(fh+4);
subplot 411
FB = label{in2};
plot_conn(edge{1,in2},num2cell(1:L), 'npsi'); title(['Conn mat ',FB]);

% h3 = figure(fh+5);
% cp = con2power(abs(edge{1,in2}));
% subplot 121
% barh(cp),
% set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
% box off
% set(gca,'color','none');
% title(['Conn power(abs) ',label{in2}]);


% Flux
for fq = 1:length(freqs)
    tmp  = cat(2,flux{:,fq});
    ave_flux{fq} = {mean(tmp,2)};
end
tmp  = cell2mat(ave_flux{1,in2});
aflux = abs(tmp);
h3 = figure(fh+5);
% subplot 122
barh(aflux),
for j = 1:L, lab{j} = num2str(j); end
set(gca,'ytick', 1:L,'ytickLabel',lab);
box off
set(gca,'color','none');
title(['Flux (abs) ',label{in2}]);
set(gcf, 'Position', [900   200   400   900]);
disp('---------------------');

figure(fh+4);
subplot 412
plot_conn(p{1,in2},[], 'npsi'); title(['P value of ',label{i}]);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));

sig = input('Set the sig level? ');
sedge = edge{1,in2} .* double(p{1,in2} < sig);
sedge = sedge > 0;
figure(fh+4);
subplot 413
plot_conn(sedge,[], 'npsi'); title(['Thresholded value of ',label{i}]);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));

lf = find(aflux > 0.7*max(aflux));
lf_edge = zeros(size(sedge,1),size(sedge,2));
lf_edge(lf,lf) = sedge(lf,lf);
sedge = lf_edge;
subplot 414
plot_conn(sedge,[], 'npsi'); title(['Thresholded (by max flux) value of ',label{i}]);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));

set(gcf, 'Position', [600   200   500   1000]);
% sedge = sedge./max(max(sedge));
% sedge = sedge > 0;
dlmwrite([pwd,'\saved outputs\edge.edge'],sedge,'\t');
save([pwd,'\saved outputs\cameg_matfile.mat'], 'sedge','aflux','idxp','ssROI');

%% Updating surface file
cameg_datapre_updatesurf;

in = input('close the openned figures (yes = 1)?');
if in == 1
    delete(h1)
    delete(h2)
    delete(h3)
end
