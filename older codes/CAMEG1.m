function fig = CAMEG()
% ___________________________________________________________________________
% Connectivity analysis of MEG data (CA-MEG)
%
% Copyright 2016 Cincinnati Children's Hospital Medical Center
% Reference
%
%
% v1.0 Vahab Youssofzadeh 21/07/2016
% Email: Vahab.Youssofzadeh@cchmc.org
% ___________________________________________________________________________
clc, close all

p = mfilename('fullpath');
cd(fileparts(p));
display('your current working path is,')
cd

r = 100;
col = [0.6020 0.8072 0.6014];
f = figure(...
    'Color',[1 1 1], ...
    'PaperPosition',[18 180 576 432], ...
    'PaperUnits','points', ...
    'Position',[850 650 390 280], ...
    'Tag','Main', ...
    'NumberTitle','off', ...
    'DoubleBuffer','on', ...
    'Visible','on', ...
    'MenuBar','none', ...
    'Color',[0.8 0.8 0.8],...
    'NumberTitle','off',...
    'Name','CA-MEG v.1', ...
    'ToolBar','none');

h = uicontrol('Parent',f, ...
    'Units','points', ...
    'BackgroundColor',[1 1 1], ...
    'FontSize',11, ...
    'ListboxTop',0, ...
    'Position',[16 r 280 36], ...
    'String',['                      CA-MEG                           ';
    '      (Connectivity analysis of MEG data)              '], ...
    'Style','text', 'backgroundcolor',[0.8 0.8 0.8],...
    'Tag','StaticText5');

f1 = uimenu('Label','Data prepration');
% f11 = uimenu(f1,'Label','MRI ...',...
%     'Callback','cameg_datapre_readmri');
f11 = uimenu(f1,'Label','MEG sources ...', ...
    'Callback','cameg_datapre_readdata');
f12 = uimenu(f1,'Label','MRI ...', ...
    'Callback','cameg_datapre_readmri');
f13 = uimenu(f1,'Label','Surface ...', ...
    'Callback','cameg_datapre_readsurf');
f14 = uimenu(f1,'Label','Mesh ...', ...
    'Callback','cameg_datapre_readmesh');
f15 = uimenu(f1,'Label','Cort thickness (optional) ...', ...
    'Callback','cadsum_datapre_CT');

% f12 = uimenu(f1,'Label','Import');
% uimenu(f12,'Label','MEG sources ...', ...
%     'Callback','cameg_datapre_readdata');
% uimenu(f12,'Label','MRI ...', ...
%     'Callback','cameg_datapre_readmri');
% uimenu(f12,'Label','surface ...', ...
%     'Callback','cameg_datapre_readsurf');
% uimenu(f12,'Label','Mesh ...', ...
%     'Callback','cameg_datapre_readmesh');
% uimenu(f12,'Label','cort thickness (optional) ...', ...
%     'Callback','cadsum_datapre_CT');

f2 = uimenu('Label','Process');
f21 = uimenu(f2,'Label','Compute conn');
uimenu(f21,'Label','PSI (phase slope index)', ...
    'Callback','cameg_conn_psi');

f3 = uimenu('Label','Visualisation');
% f31 = uimenu(f3,'Label','Surface (BrainNet)');
% uimenu(f31,'Label','brainNet ...', ...
%     'Callback','cameg_surfVis');
f31 = uimenu(f3,'Label','Surface (BrainNet)',...
    'Callback','cameg_surfVis');
f32 = uimenu(f3,'Label','Data (sources)', ...
    'Callback','cameg_DataVis');
f33 = uimenu(f3,'Label','Con Mat', ...
    'Callback','cameg_ConMatVis');


h5 = uicontrol('Parent',f, ...
    'Units','points', ...
    'BackgroundColor',col, ...
    'Position',[72 r-15 166 16], ...
    'String','Close', ...
    'CallBack', 'cameg_closeall');

if nargout > 0, fig = f0; end


%% Junk
% f3 = uimenu('Label','Exit');
% f31 = uimenu(f3,'Label','Surface Vis');
% uimenu(f31,'Label','brainNet ...', ...
%     'Callback','cameg_datapre_readsurf');

% uimenu(f12,'Label','MRI ...', ...
%     'Callback','cameg_datapre_readmri');
% uimenu(f12,'Label','surface ...', ...
%     'Callback','cameg_datapre_readsurf');
% uimenu(f12,'Label','cort thickness (optional) ...', ...
%     'Callback','cadsum_datapre_CT');


% uimenu(f,'Label','Import MEG sources','Callback','cameg_datapre_readdata');
% uimenu(f,'Label','Import MRI','Callback','cameg_datapre_readmri');
% uimenu(f,'Label','Import surface','Callback','cameg_datapre_readsurf');
% uimenu(f,'Label','Import mesh','Callback','cameg_datapre_readmesh');
% uimenu(f,'Label','Import cort thickness (optional)','Callback','cadsum_datapre_CT');
%
%
% f = uimenu('Label','Compute & plot connectivity');
% uimenu(f,'Label','Phase Slope Index (PSI)','Callback','cameg_conn_psi');
%
% f = uimenu('Label','Data & Surface visualisation');
% uimenu(f,'Label','Surface visualisation','Callback','cameg_surfVis');



% h1 = uicontrol('Parent',f0, ...
% 	'Units','points', ...
% 	'BackgroundColor',col, ...
% 	'Position',[72 85+r 166 16], ...
% 	'String','Data prepration', ...
% 	'CallBack','cameg_datapre;');
% h2 = uicontrol('Parent',f0, ...
% 	'Units','points', ...
% 	'BackgroundColor',col, ...
% 	'Position',[72 60+r 166 16], ...
% 	'String','Compute & plot connectivity', ...
% 	'CallBack','cameg_conn;');
% h3 = uicontrol('Parent',f0, ...
% 	'Units','points', ...
% 	'BackgroundColor',col, ...
% 	'Position',[72 35+r 166 16], ...
% 	'String','Surface visualisation', ...
% 	'CallBack','cameg_surfVis');
% h4 = uicontrol('Parent',f0, ...
% 	'Units','points', ...
% 	'BackgroundColor',col, ...
% 	'Position',[72 10+r 166 16], ...
% 	'String','Data and conn mat visualisation', ...
% 	'CallBack','cameg_DataVis');

% h6 = uicontrol('Parent',f0, ...
% 	'Units','points', ...
% 	'BackgroundColor',[1 1 1], ...
% 	'FontSize',11, ...
% 	'ListboxTop',0, ...
% 	'Position',[16 100+r 280 36], ...
% 	'String',['                      CA-MEG                           ';
%               '      (Connectivity analysis of MEG data)              '], ...
% 	'Style','text', ...
% 	'Tag','StaticText5');