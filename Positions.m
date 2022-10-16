%% This script should show the linear interpolating of position
% Author: Johannes Lachner
% Date: October 4, 2022

% Clean up
close all;
clear;
clc;

% Include subdirectories
func_addSubfolders('helpers');

% Make a figure
x_lim = [ -1 1 ];
y_lim = [ -1 1 ];
z_lim = [ -1 1 ];
[fig, ax] = func_createFigure(x_lim, y_lim, z_lim);
view(110,10);                                   % aspect ratio

% Traceplots
tracePlot_x = plot3(NaN, NaN, NaN);
set(tracePlot_x, 'XData', [], 'YData',[], 'ZData', []);
tracePlot_y = plot3(NaN, NaN, NaN);
set(tracePlot_y, 'XData', [], 'YData',[], 'ZData', []);
tracePlot_z = plot3(NaN, NaN, NaN);
set(tracePlot_z, 'XData', [], 'YData',[], 'ZData', []);

% Create initial coordinate frame
H_0_ini = eye(4);
H_0 = H_0_ini;
angles_ini = rotm2eul(H_0_ini(1:3, 1:3), 'ZYX');   % Convert transformation matrix to Euler angles
hg_1 = hgtransform('Parent', ax, 'Matrix',  H_0_ini);
[V1,F1,C1] = func_create_VFC_data('CoordinateSys',12);
V1 = 0.4 * V1;
patchTCP1 = patch('Faces', F1,...
    'Vertices' ,V1,...
    'FaceVertexCData', C1,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_1);

% Goal translation
X = 0.35;               % Translation along x
Y = 0.5;                % Translation along y
Z = -0.35;                  % Translation along z
H_0_des = H_0_ini;
H_0_des(1:3, 4) = H_0_ini(1:3, 4) + [X , Y, Z]';

% Create interpolated coordinate frame
hg_2 = hgtransform('Parent', ax, 'Matrix', H_0_des);
[V2,F2,C2] = func_create_VFC_data('CoordinateSys',12);
V2 = 0.55 * V2;
patchTCP2 = patch('Faces', F2,...
    'Vertices' ,V2,...
    'FaceVertexCData', C2,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_2);

% Create goal sphere
hg_3 = hgtransform('Parent', ax, 'Matrix', H_0_des);
[V3,F3,C3] = func_create_VFC_data('Sphere',2);
V3 = 0.05 * V3;
patchTCP2 = patch('Faces', F3,...
    'Vertices' ,V3,...
    'FaceVertexCData', C3,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_3);

%% Simulation
curTime = 0;
Tstep = 2;
dt = 0.005;
while curTime <= Tstep
    tic

    % Linear interpolator of position
    ratio = curTime / Tstep;
    if ratio > 1
        ratio = 1.0;
    end
    H_0(1:3, 4) = H_0_ini(1:3, 4) + ratio * ( H_0_des(1:3, 4) - H_0_ini(1:3, 4) );     

    % Update current coordinate system
    set(hg_2, 'Matrix', H_0);
    
    view([115.52 4.00])

    % TRACEPLOTS
    % x-coordinate
    curX_x = get(tracePlot_x, 'XData');
    curY_x = get(tracePlot_x, 'YData');
    curZ_x = get(tracePlot_x, 'ZData');

    set(tracePlot_x, 'XData', [curX_x, H_0(1, 4)], ...
        'YData', [curY_x, H_0(2, 4)], ...
        'ZData', [curZ_x, H_0(3, 4)], 'Color', [0.6350 0.0780 0.1840], 'LineStyle', '-', 'LineWidth', 2 );

    % Update simulation
    drawnow
    curTime = curTime + dt;

    while toc < dt
        % do nothing
    end
end