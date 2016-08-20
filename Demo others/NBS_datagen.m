close all; clc; clear all

%% load conn

disp('Kids  = 1');
disp('Teens = 2');
disp('All   = 3');
in = input ('Enter group type? ');

if in == 1
    
    load cameg_ConnKids
    display('---------');
    display('Delta = 1');
    display('Theta = 2');
    display('Alpha = 3');
    display('Beta  = 4');
    display('all   = 5');
    in2 = input ('Enter freq type? ');
    
    nedge = cat(3,edge{:,in2});
    save cameg_NBS_conn nedge
    
    % Design mat
    design =  zeros(size(Conn,3),2);
    design(1:15,1)   = 1; % Kids
    design(14:end,2) = 1; % Teens
    save cameg_NBS_design design
    
    % ROI MNI coordinates
    load cameg_surffile
    COG = newPosMNI;
    %     save cameg_NBS_MNIcor COG
    %     csvwrite('cameg_NBS_COG.txt',COG)
    
    fid = fopen('cameg_NBS_COG.txt','w');
    % fprintf(fid, '%f %f %f \n', COG);
    fprintf(fid,'%6.2f %6.2f %6.2f\n',COG);
    fclose(fid);
    
    % node label
    for i = 1:length(L),nodeLabels{i}= Atlas.Scouts(i).Label; end
    csvwrite('cameg_NBS_nodelabel.txt',nodeLabels')
    
elseif in == 2
    
    
elseif in == 3
    
    load cameg_Connall
    display('---------');
    display('Delta = 1');
    display('Theta = 2');
    display('Alpha = 3');
    display('Beta  = 4');
    display('all   = 5');
    in2 = input ('Enter freq type? ');
    
    nedge = cat(3,edge{:,in2});
    save cameg_NBS_conn nedge
    %%
    m = mean(nedge,3);
    figure,
    imagesc(m);
    colorbar
    cp = (con2power(m));
    figure,
    barh(abs(cp)),
%     set(gca,'ytick', 1:length(cp),'ytickLabel',roi);
    box off
    set(gca,'color','none');
    title('Connectivity Strength');
    set(gcf, 'Position', [900   200   500   900]);
    
    for i = 1:length(L)
        roi{i}= Atlas.Scouts(i).Region;
        roi_l{i}= Atlas.Scouts(i).Label;
    end
    %%
    % Design mat
    load age_all
    Age([5,27]) = [];
    design =  zeros(length(Age),2);
    id_kids = find(Age < 10);     id_teens = find(Age > 10);
    design(id_kids,1)   = 1; % Kids
    design(id_teens,2)  = 1; % Teens
    
%     design(1:15,1)   = 1; % Kids
%     design(14:end,2) = 1; % Teens
    save cameg_NBS_design design
    
    % ROI MNI coordinates
    load cameg_surffile
    COG = newPosMNI;
    %     save cameg_NBS_MNIcor COG
    %     csvwrite('cameg_NBS_COG.txt',COG)
    
    fid = fopen('cameg_NBS_COG.txt','w');
    % fprintf(fid, '%f %f %f \n', COG);
    fprintf(fid,'%6.2f %6.2f %6.2f\n',COG);
    fclose(fid);
    
    % node label
    for i = 1:length(L),nodeLabels{i}= Atlas.Scouts(i).Label; end
    csvwrite('cameg_NBS_nodelabel.txt',nodeLabels')
    
end

% designmat = []