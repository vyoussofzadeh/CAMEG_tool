close all; clc; clear all

% example data: cameg_MEGsource_Kids
files = spm_select(1,'.mat','Select source MEG files');
load(files)

L = length(Atlas.Scouts);
msaValue = mean(squeeze(mean(saValue,1)),3);
figure,
hl = plot(Time, msaValue);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('Aanalysing data');
for i = 1:L, lab{i} = num2str(i); end
clickableLegend(hl,lab, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);


%%
freqs{1} = 2:4;
freqs{2} = 4:7;
freqs{3} = 8:12;
freqs{4} = 15:29;
freqs{5} = 1:30;

label = {'Delta','Theta','Alpha','Beta','Full freq'};


Conn = saValue;

nep = size(Conn,1);
nsource = size(Conn,2);
epleng = size(Conn,3);
Subj = size(Conn,4);
nConn = reshape(Conn,[epleng*nep,nsource,Subj]);


% Testing reshape
nConn2 = reshape(nConn,[nep  nsource  epleng  Subj]);
msaValue = mean(squeeze(mean(nConn2,1)),3);
figure,plot(msaValue')

seglen = epleng;

for fq = 1:length(freqs)
    parfor s = 1:Subj
        tmp = nConn(:,:,s);
        [psi, stdpsi, psisum, stdpsisum] = data2psi(tmp,seglen,epleng,freqs{fq});
        npsi = psi./(stdpsi+eps);
        %         tpsi = npsi > 1.96;
        edge{s,fq} = npsi;
        flow{s,fq} = psisum;
    end
    disp([label{fq}, ' freq was computed!']);
end
disp('---------------------');
disp('Conn measures were computed!');

% Average conn
parfor fq = 1:length(freqs)
    tmp  = cat(3,edge{:,fq});
    ave_conn{fq} = {mean(tmp,3)};
end

% visualisation of conn and its magnitude
for i = 1:length(freqs)
    tmp  = cell2mat(ave_conn{1,i});
    figure(1)
    subplot(2,3,i)
    plot_conn(tmp,[], 'npsi'); title(['mean value of ',label{i}]);
    set(gcf, 'Position', [800   100   1200   800]);
    
    cp = con2power(tmp);
    figure(2)
    subplot(1,5,i);
    barh(cp),
    for j = 1:L, lab{j} = num2str(j); end
    
    set(gca,'ytick', 1:length(cp),'ytickLabel',lab);
    box off
    set(gca,'color','none');
    title(['Conn Mag of ',label{i}]);
    set(gcf, 'Position', [900   200   900   900]);
    
end
disp('---------------------');

display('1: Delta');
display('2: Theta');
display('3: Alpha');
display('4: Beta');
display('5: full freq');
in2  = input('Band selection (1-5):');
nedge  = abs(cell2mat(ave_conn{1,in2}));
cp = con2power(nedge); n = length(cp);
figure(3)
subplot 211
FB = label{in2};
plot_conn((nedge),num2cell(1:n), 'npsi'); title(['mean value of ',FB]);
% set(gcf, 'Position', [800   100   1200   800]);
figure(4)
barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
box off
set(gca,'color','none');
set(gcf, 'Position', [900   200   500   900]);
ROI

% Flux
% figure(6)
%
% Fl = flow{2,in2};
% barh(Fl),
% set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
% set(gcf, 'Position', [900   200   500   900]);


if Subj > 1
    %% Stats
    Conn  = cat(3,edge{:,in2});
    St = zeros(size(Conn,1),size(Conn,2));
    for i = 1: size(Conn,1)
        for j = 1: size(Conn,2)
            for k = 1: size(Conn,3)
                t(k)  = Conn(i,j,k);
            end
            [h,p,ci,stats] = ttest(t);
            St(i,j) = stats.tstat;
            St(i,j) = p;
        end
    end
    figure(3),
    subplot 212
    imagesc(St);colorbar,title('P significance');
    set(gcf, 'Position', [800   100   600   1000]);
end

L = strfind(files,'_');
save(['cameg_Conn',files(L(end):end)],'Conn', 'nedge', 'edge', 'Atlas', 'label', 'cp', 'FB', 'ROI');
disp('Data were saved!');



