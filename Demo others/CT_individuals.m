close all; clc; clear all

files = spm_select(1,'.mat','Select cortical thickness file');
load(files);

L = 2*length(label);

CT = zeros(1,L);
CT(1:2:L) = CTV.lh;
CT(2:2:L) = CTV.rh;

k = 1;
for i = 1:L/2
    lab{k} = ['L ',label{i}]; k = k+1;
    lab{k} = ['R ',label{i}]; k = k+1;
end

figure
barh(CT);
set(gca,'Ytick', 1:length(CT),'YtickLabel',1:L);
box off
set(gca,'color','none');
title('CT values, group average');
ylim([1,L])
ylabel('ROI');
xlabel('mm');
set(gcf, 'Position', [500   100   500   1200]);
title('CT')

fCT = zeros(L,size(fCTV.lh,2));

for i = 1:size(fCTV.lh,2)
    fCT(1:2:L,i) = fCTV.lh(:,i);
    fCT(2:2:L,i) = fCTV.rh(:,i);
end

figure,
barh(fCT); box off, set(gca,'color','none');
for i = 1:size(fCTV.lh,2), leg{i} = ['sub ',num2str(i)]; end
legend(leg)
ylabel('ROI')
xlabel('mm')
ylim([1,L])
title('CT, average')
set(gca,'Ytick', 1:length(CT),'YtickLabel',1:L);
set(gcf, 'Position', [500   100   500   1200]);

B = num2cell(1:L);
ROI = (cell2table([B;lab]'));
ROI.Properties.VariableNames{'Var1'} = 'ROI';
ROI.Properties.VariableNames{'Var2'} = 'Label';

disp('Kids  = 1');
disp('Teens = 2');
disp('All   = 3');
in = input ('Enter group type? ');


disp('Age = 1');
disp('EVT = 2');
disp('PPVT = 3');
disp('standard EVT  = 4');
disp('standard PPVT = 5');
in2 = input ('covariate type? ');

load age_all
idx_kid   = find(Age < 10);
idx_teens = find(Age > 10);

age_kids = Age(idx_kid);
age_teens = Age(idx_teens);

load PPVT_all,
PPVT_kids = PPVT(idx_kid);
PPVT_teens = PPVT(idx_teens);

load EVT_all
EVT_kids = EVT(idx_kid);
EVT_teens = EVT(idx_teens);

load PPVTstd_all,
PPVTstd_kids = PPVT_std(idx_kid);
PPVTstd_teens = PPVT_std(idx_teens);

load EVTstd_all
EVTstd_kids = EVT_std(idx_kid);
EVTstd_teens = EVT_std(idx_teens);


if in == 1
    if in2 == 1
        label = 'Age';
        tar = age_kids;
    elseif in2 == 2
        label = 'EVT';
        tar = EVT_kids;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT_kids;
    elseif in2 == 4
        label = 'PPVT-std';
        tar = PPVTstd_kids;
    elseif in2 == 5
        label = 'EVT-std';
        tar = EVTstd_kids;
    end
elseif in == 2
    if in2 == 1
        label = 'Age';
        tar = age_teens;
    elseif in2 == 2
        label = 'EVT';
        tar = EVT_teens;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT_teens;
    elseif in2 == 4
        label = 'PPVT-std';
        tar = PPVTstd_teens;
    elseif in2 == 5
        label = 'EVT-std';
        tar = EVTstd_teens;
    end
elseif in == 3
    if in2 == 1
        label = 'Age';
        tar = Age;
    elseif in2 == 2
        label = 'EVT';
        tar = EVT;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT;
    elseif in2 == 3
        label = 'PPVT';
        tar = PPVT_all;
    elseif in2 == 4
        label = 'PPVT-std';
        tar = PPVT_std;
    elseif in2 == 5
        label = 'EVT-std';
        tar = EVT_std;
    end
end

%% Correlation of CT with targets
for i = 1:size(ROI,1)
    [r,p] = corr(fCT(i,:)',tar,'Type','Spearman');
    rCT(i) = r;
    pCT(i) = p;
end
stat = cell2table(num2cell([rCT;pCT])');
stat.Properties.VariableNames{'Var1'} = 'Corr';
stat.Properties.VariableNames{'Var2'} = 'P';
stat_report = [ROI,stat];
display(stat_report)

figure,
barh(rCT);
set(gca,'Ytick', 1:length(CT),'YtickLabel',1:L);
box off
set(gca,'color','none');
title(['corr ', '(',label,',CT)']);
ylim([1,L])
ylabel('ROI');
xlabel('correlation');
set(gcf, 'Position', [500   100   500   1200]);

idxp = find(pCT < 0.05);

rCT_sig = zeros(1,length(rCT));
rCT_sig(idxp) = rCT(idxp);
hold on
h = barh(rCT_sig);
set(h, 'FaceColor', 'r')
legend('non-sig','sig (p <0.05)')

m = mean(fCT,1)';
[r,p] = corr(m,tar,'Type','Spearman');
figure,
scatter(m,tar);
box off
set(gca,'color','none');
title(['correlation, r = ',num2str(r),' (p =', num2str(p),')']);
ylabel(label);
xlabel('CT')
legend('Subject')

if in == 3
    idx_kid = find(Age < 10);
    m1 = m;
    m1(idx_kid) = NaN;
    
    tar1 = tar;
    tar1(idx_kid) = NaN;
    
    hold on
    h = scatter(m1,tar1);
    legend('kids','teens')
end

sig_ROI = ROI(idxp,:)

%%
if in == 1
    save([pwd,'\saved outputs\cameg_CT_Kids.mat'], 'idxp', 'label', 'ROI', 'tar', 'fCT');
elseif in == 2
    save([pwd,'\saved outputs\cameg_CT_Teens.mat'], 'idxp', 'label', 'ROI', 'tar', 'fCT');
elseif in == 3
    save([pwd,'\saved outputs\cameg_CT_all.mat'], 'idxp', 'label', 'ROI', 'tar', 'fCT');
end




