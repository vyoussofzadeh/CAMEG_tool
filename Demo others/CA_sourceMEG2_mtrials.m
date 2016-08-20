close all; clc; clear all

% example data: cameg_MEGsource_Kids
files = spm_select(1,'.mat','Select source MEG files');
load(files)

L = length(Atlas.Scouts);
msaValue = mean(squeeze(mean(saValue,1)),3);
figure(1),
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

label = {'Delta','Theta','Alpha','Beta','Full'};

disp('Kids  = 1');
disp('Teens = 2');
disp('All   = 3');
in = input ('Enter group type? ');

if in == 1
    Conn = saValue;
elseif in == 2
    Conn = saValue;
elseif in == 3
    Conn = saValue;
end

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
    for s = 1:Subj
        tmp = nConn(:,:,s);
        tmp = detrend(tmp,'constant');
        [psi, stdpsi, psisum, stdpsisum] = data2psi(tmp,seglen,epleng,freqs{fq});
        npsi = psi./(stdpsi+eps);
        %         tpsi = npsi > 1.96;
        edge{s,fq} = npsi;
        flux{s,fq} = psisum;
    end
    disp([label{fq}, ' freq was computed!']);
end
disp('---------------------');
disp('Conn measures were computed!');

% Average conn
for fq = 1:length(freqs)
    tmp  = cat(3,edge{:,fq});
    ave_conn{fq} = {mean(tmp,3)};
end

% visualisation of conn and its magnitude
for i = 1:length(freqs)
    tmp  = cell2mat(ave_conn{1,i});
    figure(2)
    subplot(2,3,i)
    plot_conn(tmp,[], 'npsi'); title(['mean value of ',label{i}]);
    set(gcf, 'Position', [800   100   1200   800]);
    
    cp = con2power(tmp);
    figure(3)
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
figure(4)
subplot 211
FB = label{in2};
plot_conn((nedge),num2cell(1:n), 'npsi'); title(['mean value of ',FB]);
% set(gcf, 'Position', [800   100   1200   800]);
figure(5)
barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',num2cell(1:n));
box off
set(gca,'color','none');
title(['Conn power(abs) ',label{in2}]);
set(gcf, 'Position', [900   200   500   900]);
ROI

% Flux
for fq = 1:length(freqs)
    tmp  = cat(2,flux{:,fq});
    ave_flux{fq} = {mean(tmp,2)};
end
tmp  = cell2mat(ave_flux{1,in2});
aflux = abs(tmp);
figure(6)
barh(aflux),
for j = 1:L, lab{j} = num2str(j); end
set(gca,'ytick', 1:length(cp),'ytickLabel',lab);
box off
set(gca,'color','none');
title(['Flux (abs) ',label{in2}]);
set(gcf, 'Position', [900   200   500   900]);
disp('---------------------');

if Subj > 1
    in4 = 1;
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
    figure(4),
    subplot 212
    imagesc(St);colorbar,title('P significance');
    set(gcf, 'Position', [800   100   600   1000]);
else
    in4 = 0;
end

in3  = input('idxp = 1 ?');
disp('Verb  = 1');
disp('noise = 2');
in0  = input('? ');

if in4 == 1
if in0 == 1
    if in3 == 1
        if in == 1
            save cameg_ConnKids_mt  Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        elseif in == 2
            save cameg_ConnTeens_mt  Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        elseif in == 3
            save cameg_Connall_mt Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        end
    else
        if in == 1
            save cameg_ConnKids_mt  Conn nedge edge Atlas label cp FB ROI aflux St flux
        elseif in == 2
            save cameg_ConnTeens_mt  Conn nedge edge Atlas label cp FB ROI aflux St flux
        elseif in == 3
            save cameg_Connall_mt Conn nedge edge Atlas label cp FB ROI aflux St flux
        end
    end
else
    if in3 == 1
        if in == 1
            save cameg_ConnKids_mt_noise  Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        elseif in == 2
            save cameg_ConnTeens_mt_noise  Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        elseif in == 3
            save cameg_Connall_mt_noise Conn nedge edge Atlas label idxp cp FB ROI aflux St flux
        end
    else
        if in == 1
            save cameg_ConnKids_mt_noise  Conn nedge edge Atlas label cp FB ROI aflux St flux
        elseif in == 2
            save cameg_ConnTeens_mt_noise  Conn nedge edge Atlas label cp FB ROI aflux St flux
        elseif in == 3
            save cameg_Connall_mt_noise Conn nedge edge Atlas label cp FB ROI aflux St flux
        end
    end
end
else
    if in0 == 1
    if in3 == 1
        if in == 1
            save cameg_ConnKids_mt  Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        elseif in == 2
            save cameg_ConnTeens_mt  Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        elseif in == 3
            save cameg_Connall_mt Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        end
    else
        if in == 1
            save cameg_ConnKids_mt  Conn nedge edge Atlas label cp FB ROI aflux  flux
        elseif in == 2
            save cameg_ConnTeens_mt  Conn nedge edge Atlas label cp FB ROI aflux  flux
        elseif in == 3
            save cameg_Connall_mt Conn nedge edge Atlas label cp FB ROI aflux  flux
        end
    end
else
    if in3 == 1
        if in == 1
            save cameg_ConnKids_mt_noise  Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        elseif in == 2
            save cameg_ConnTeens_mt_noise  Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        elseif in == 3
            save cameg_Connall_mt_noise Conn nedge edge Atlas label idxp cp FB ROI aflux  flux
        end
    else
        if in == 1
            save cameg_ConnKids_mt_noise  Conn nedge edge Atlas label cp FB ROI aflux  flux
        elseif in == 2
            save cameg_ConnTeens_mt_noise  Conn nedge edge Atlas label cp FB ROI aflux  flux
        elseif in == 3
            save cameg_Connall_mt_noise Conn nedge edge Atlas label cp FB ROI aflux  flux
        end
    end
end
end
disp('Data were saved!');



