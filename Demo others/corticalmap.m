% clc;clear;close all;


path = 'E:\Data analysis\Fsurfer\all\CTL01\CTL01\';

datatype = '*rh.pial';
surf_pial_path_rh = sinead_findfiles (path,datatype);

datatype = '*lh.pial';
surf_pial_path_lh = sinead_findfiles (path,datatype);

% s = SurfStatReadSurf( {surf_pial_path_lh{1}, surf_pial_path_rh{1}} );
s = SurfStatReadSurf( surf_pial_path_lh{1});

load([pwd,'\saved outputs\cameg_matfile.mat']);

L = size(ssROI,1);
for i = 1:L
    R = ssROI.Var2(i);
    if R{1}(1) == 'L'
        m(i) = 4;
    else
        m(i) = 3;
    end
end

% conns at left and right hemisphres
LH = find(m == 4);
RH = find(m == 3);

LH_aflux = aflux(LH);
RH_aflux = aflux(RH);

% create new time, with twice as many sampling times
t_new = linspace(1, numel(LH_aflux),size(s.coord,2));

% interpolate
t = interp1(LH_aflux, t_new);

figure,
SurfStatView( t, s, ['Whole brain cort thick (mm)'] );
SurfStatColormap( 'jet' );




