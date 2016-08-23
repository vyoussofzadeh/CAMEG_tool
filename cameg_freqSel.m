function cameg_freqSel()
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
for i = 1:size(frq,2)
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
disp('-----------------------------------')
% sig = input('Set the sig level? ');


h2 = figure(fh+4);
subplot 311
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
for fq = 1:length(frq)
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
subplot 312
plot_conn(p{1,in2},[], 'npsi'); title(['P value of ',FB]);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));

sedge = edge{1,in2} .* double(p{1,in2} < 5e-2);
% sedge = sedge./max(max(sedge));

% sedge = sedge > 0;
figure(fh+4);
subplot 313
plot_conn(sedge,[], 'npsi'); title(['Thresholded value of ',FB]);
set(gca,'ytick', 1:L,'ytickLabel',num2cell(1:L));
set(gca,'xtick', 1:L,'xtickLabel',num2cell(1:L));

set(gcf, 'Position', [600   200   500   1000]);
% sedge = sedge > 0;
% dlmwrite([pwd,'\saved outputs\edge.edge'],sedge,'\t');
save([pwd,'\saved outputs\cameg_matfile.mat'], 'sedge','aflux','idxp','ssROI');

in = input('close the openned figures (yes = 1)?');
if in == 1
    delete(h1)
    delete(h2)
    delete(h3)
end
