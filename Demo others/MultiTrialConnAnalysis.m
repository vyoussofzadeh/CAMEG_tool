clear all;close all; clc;

Datafile = spm_select(1,'.mat','Select multi-trial source MEG files');

load(Datafile);

LScouts = length(Atlas.Scouts);
Ltrials = size(Value,1)/LScouts;

nValue = reshape(Value,LScouts,Ltrials,size(Value,2));


%% plot average of source activities
mScout  = squeeze(mean(nValue,2));

for i = 1:LScouts
    roi{i}= Atlas.Scouts(i).Region;
    roi_l{i}= Atlas.Scouts(i).Label;
end

figure,
hl = plot(Time, mScout);
xlabel('Time(s)');
ylabel('Amplitude(AU)');
title('source activities');
clickableLegend(hl,roi, 'plotOptions', {'MarkerSize', 6});
set(gcf, 'Position', [800   100   1200   800]);

%%
freqs{1} = 2:4;
freqs{2} = 4:7;
freqs{3} = 8:12;
freqs{4} = 15:29;
freqs{5} = 1:30;

label = {'Delta','Theta','Alpha','Beta','Full freq'};

seglen = size(Value,2);
epleng = [];

for fq = 1:length(freqs)
    parfor L = 1:Ltrials
        tmp = squeeze(nValue(:,L,:))';
        [psi, stdpsi, ~, ~] = data2psi(tmp,seglen,epleng,freqs{fq});
        npsi = abs(psi./(stdpsi+eps));
        edge{L,fq} = npsi;
    end
    disp([label{fq}, ' freq was computed!']);
end
disp('---------------------');
disp('Conn measures were computed!');
save cameg_multipletrialconn edge roi

% Average conn
parfor fq = 1:length(freqs)
    tmp  = cat(3,edge{:,fq});
    avgCell{fq} = {mean(tmp,3)};
end

for i = 1:length(freqs)
    tmp  = cell2mat(avgCell{1,i});
    figure(2)
    subplot(2,3,i)
    plot_conn(tmp,[], 'npsi'); title(['mean value of ',label{i}]);
    set(gcf, 'Position', [800   100   1200   800]);

%     tmp2  = cell2mat(stdCell{1,i});
%     figure(3)
%     subplot(2,3,i)
%     plot_conn(tmp2,[], 'npsi'); title(['std value of ',label{i}]);
%     set(gcf, 'Position', [800   100   1200   800]);
end
disp('---------------------');

display('1: Delta');
display('2: Theta');
display('3: Alpha');
display('4: Beta');
display('5: Full bands');
in  = input('surface visualisation (1-5):');

thre = input(['Set the threshold for ',label{in},': ']);
tmp  = cell2mat(avgCell{1,in});
ttmp = tmp > thre;

dlmwrite('edge.edge',ttmp,'\t');

load('cameg_meshfile');
Mesh = files;
Node = 'node.node';
Edge = 'edge.edge';

% Power of conn
cp = con2power(ttmp);
figure, barh(cp),
set(gca,'ytick', 1:length(cp),'ytickLabel',roi);
box off
set(gca,'color','none');
title('Connectivity Strength');
set(gcf, 'Position', [900   200   500   900]);

%% Updating furface file
cameg_datapre_updatesurf(cp)

figure(4),
BrainNet_MapCfg(Mesh,Node,Edge);title(label{in});
view([-90 0 0])

% in = input('Thresholding (yes = 1)?');
%
%
% if in ==1
%     for i = 1:length(freqs)
%         %         tmp  = cell2mat(avgCell{1,i});
%         %           figure(3)
%         %     subplot(2,2,i)
%         %     plot_conn(tmp,[], 'npsi'); title(label{i})
%         disp('---------------------');
%
%         thre = input(['Set the threshold for ',label{i},': ']);
%         tmp  = cell2mat(avgCell{1,i});
%         ttmp{i} = tmp > thre;
%         figure(3)
%         subplot(2,2,i)
%         plot_conn(ttmp{i},[], 'npsi'); title(label{i});
%         set(gcf, 'Position', [800   100   1200   800]);
%     end
% end
%
% load('cameg_meshfile');
% Mesh = files;
% Node = 'node.node';
% Edge = 'edge.edge';
% for i = 1:length(freqs)
%     tmp = ttmp{i};
%     dlmwrite('edge.edge',tmp,'\t');
% %     figure,
%     BrainNet_MapCfg(Mesh,Node,Edge);title(label{i});
%     view([0 -90 0])
%     pasue
% end

%             subplot(2,2,i)
%             h{i}  = plot_conn(edge{i},[], 'nPSI'); title(label{i});
%             set(gcf, 'Position', [800   100   800   700]);

% TF = process_compress_sym('Expand', TF, length(RowNames));
%
% TF1 = reshape(TF, sqrt(size(TF,1)),sqrt(size(TF,1)),size(TF,3));
%
% figure,
% for i = 1:length(Freqs)
%     tmp = squeeze(TF1(:,:,i));
%     subplot(2,2,i)
%     plot_conn(tmp,[], 'npsi'); title(Freqs(i,1))
% end
% Freqs
%
% figure,
% load('cameg_meshfile');
% Mesh = files;
% Node = 'node.node';
% Edge = 'edge.edge';
% for i = 1:length(Freqs)
%     tmp = squeeze(TF1(:,:,i));
%     edge{i} = tmp > 0.9;
%     subplot(2,2,i)
%     plot_conn(edge{i},[], 'npsi'); title(Freqs(i,1));
% end
%
% display('1: Delta');
% display('2: Theta');
% display('3: Alpha');
% display('4: Beta');
% in  = input('surface visualisation (1-4):');
% dlmwrite('edge.edge',edge{in},'\t');
% figure,
% BrainNet_MapCfg(Mesh,Node,Edge);title(Freqs(in,1));
% view([0 -90 0])