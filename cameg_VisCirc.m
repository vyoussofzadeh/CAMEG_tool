function cameg_VisCirc()
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

disp('Intraconnectivity    = 1');
disp('Interconnectivity    = 2');
disp('Full connectivity    = 3');
in = input('Enter interaction type: ');

[LH, RH] = cameg_LHRHdet(ssROI);

A1 = zeros(size(LH,2),size(RH,2));
A2 = zeros(size(RH,2),size(LH,2));
A3 = zeros(size(LH,2),size(LH,2));
A4 = zeros(size(RH,2),size(RH,2));

sedge_inter  = [sedge(LH,LH)  , A1           ; A2         , sedge(RH,RH)];
sedge_intra  = [A3           , sedge(LH,RH)  ; sedge(RH,LH), A4       ];
sedge_full   = [sedge(LH,LH)  , sedge(LH,RH)  ; sedge(RH,LH), sedge(RH,RH)];

if in == 1
    nsedge = sedge_inter;
elseif in == 2
    nsedge = sedge_intra;
elseif in == 3
    nsedge = sedge_full;
end
nsedge = nsedge';
ntsedge = (nsedge.* double(nsedge > 0.70.*max(max(nsedge))));

L = size(ssROI,1);
myLabel = cell(L,1);
idxp = [LH,RH];
for i = 1:L
    if size(ssROI,2) == 2
        myLabel{i} = ssROI.Label(idxp(i));
    elseif size(ssROI,2) == 3
        myLabel{i} = ssROI.Regions(idxp(i));
    end
end
% if L > 30
%     sedge = (sedge.* double(sedge > 0.85.*max(max(sedge))));
% else
%     sedge = (sedge.* double(sedge > 0.40.*max(max(sedge))));
% end

id = table([1:L]','VariableNames',{'id'});
C = [id,ssROI]

% for i = 1:L
%     R = ssROI.Var2(i);
%     if R{1}(1) == 'L'
%         m(i) = 4;
%     else
%         m(i) = 3;
%     end
% end
%
% % conns at left and right hemisphres
% LH = find(m == 4);
% RH = find(m == 3);

% myColorMap = lines(length(sedge));
myColorMap = colormap(autumn(length(ntsedge)));


% h1 = figure,
% circularGraph(sedge(LH,LH),'Colormap',myColorMap(LH,:),'Label',myLabel(LH));
% % circularGraph(sedge,'Label',myLabel);
% set(gcf, 'Position', [500   100   700   700]);
% set(gca,'color','none');
% set(h1,'name','LH');
%
% h2 = figure,
% circularGraph(sedge(RH,RH),'Colormap',myColorMap(RH,:),'Label',myLabel(RH));
% % circularGraph(sedge,'Label',myLabel);
% set(gcf, 'Position', [500   100   700   700]);
% set(gca,'color','none');
% set(h2,'name','RH');
aflux = aflux([LH,RH]);
h3 = figure,
[~, s_id] = sort(aflux,'ascend');
% myColorMap = myColorMap(s_id,:);


circularGraph(ntsedge,'Colormap',myColorMap,'Label',myLabel);
% circularGraph(sedge,'Label',myLabel);
set(gcf, 'Position', [500   100   700   700]);
set(gca,'color','none');
set(h3,'name','Whole');
colormap autumn;
c = colorbar('southoutside')
caxis([min(aflux),max(aflux)])
ylabel(c,'Connectivity flux (strength)')


% figure,
% hold on
% for i = 1:L
%     barh(i, aflux(i), 'facecolor', myColorMap(s_id(i),:));
% end



