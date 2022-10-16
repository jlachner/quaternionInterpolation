%% A simple linear interpolator of axis angle
% Author: Johannes Lachner
% Date: October 4, 2022

% Clean up
clc;
close all;

% Include subdirectories
func_addSubfolders('helpers');

% Make a figure
x_lim = [ -1 1 ];
y_lim = [ -1 1 ];
z_lim = [ -1 1 ];
[fig, ax] = func_createFigure(x_lim, y_lim, z_lim);

% Create sphere
[x , y, z ] = sphere;
hold on;
radius = 0.25;
x = x * radius;
y = y * radius;
z = z * radius;
axis equal;
surf(x, y, z, 'FaceColor', [.7 .7 .7])

% Points of intersection between initial coordinate system and sphere surface
p_x_ini = [radius, 0 , 0]';
p_y_ini = [0, radius, 0]';
p_z_ini = [0, 0, radius]';

% Initial transformation
H_0_ini = eye(4);

% Goal transformation
H_0_des = eul2tform(deg2rad( [25, 105, 35] ), 'ZYX');

% Orientation between initial and desired
H_ini_0 = H_0_ini\eye(size(H_0_ini));                            % inverse transformation  
H_ini_des = H_ini_0 * H_0_des;
axang = rotm2axang(H_ini_des(1:3, 1:3));
u = axang(1:3);
theta_goal = axang(4);
theta_ini = 0;

% Plot (space-fixed) axis u
X = [-u(1)/2, u(1)/2]';
Y = [-u(2)/2, u(2)/2]';
Z = [-u(3)/2, u(3)/2]';
plot3(X, Y, Z, 'LineWidth', 4, 'Color', [0.8500 0.3250 0.0980]);

%% Plot data
% Initial key frame
hg_1 = hgtransform('Parent', ax, 'Matrix',  H_0_ini);
[V1,F1,C1] = func_create_VFC_data('CoordinateSys',12);
V1 = 0.4 * V1;
patchTCP1 = patch('Faces', F1,...
    'Vertices' ,V1,...
    'FaceVertexCData', C1,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_1);

% Goal key frame
hg_2 = hgtransform('Parent', ax, 'Matrix', H_0_des);
[V2,F2,C2] = func_create_VFC_data('CoordinateSys',12);
V2 = 0.55 * V2;
patchTCP2 = patch('Faces', F2,...
    'Vertices' ,V2,...
    'FaceVertexCData', C2,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_2);

% Traceplots
tracePlot_x = plot3(NaN, NaN, NaN);
set(tracePlot_x, 'XData', [], 'YData',[], 'ZData', []);
tracePlot_y = plot3(NaN, NaN, NaN);
set(tracePlot_y, 'XData', [], 'YData',[], 'ZData', []);
tracePlot_z = plot3(NaN, NaN, NaN);
set(tracePlot_z, 'XData', [], 'YData',[], 'ZData', []);

%% Simulation
curTime = 0;
Tstep = 2;
dt = 0.005;
while curTime <= Tstep
    tic
 
    % Some random linear interpolator 
    ratio = curTime / Tstep;
    if ratio > 1
        ratio = 1.0;
    end
    theta = theta_ini + ratio * (theta_goal - theta_ini);

    % Convert axis/angle to transformation matrix
    axang(4) = theta;
    H_0_des(1:3, 1:3) = axang2rotm(axang);

    % Update current coordinate system
    set(hg_2, 'Matrix', H_0_des);

    % TRACEPLOTS
    % x-coordinate
    curX_x = get(tracePlot_x, 'XData');
    curY_x = get(tracePlot_x, 'YData');
    curZ_x = get(tracePlot_x, 'ZData');

    p_x = H_0_des(1:3 , 1:3) * p_x_ini;
    set(tracePlot_x, 'XData', [curX_x, p_x(1)], ...
        'YData', [curY_x, p_x(2)], ...
        'ZData', [curZ_x, p_x(3)], 'Color', [0.6350 0.0780 0.1840], 'LineStyle', '-', 'LineWidth', 2 );

    % y-coordinate
    curX_y = get(tracePlot_y, 'XData');
    curY_y = get(tracePlot_y, 'YData');
    curZ_y = get(tracePlot_y, 'ZData');

    p_y = H_0_des(1:3 , 1:3) * p_y_ini;
    set(tracePlot_y, 'XData', [curX_y, p_y(1)], ...
        'YData', [curY_y, p_y(2)], ...
        'ZData', [curZ_y, p_y(3)], 'Color', [0.9290 0.6940 0.1250], 'LineStyle', '-', 'LineWidth', 2 );

    % z-coordinate
    curX_z = get(tracePlot_z, 'XData');
    curY_z = get(tracePlot_z, 'YData');
    curZ_z = get(tracePlot_z, 'ZData');

    p_z = H_0_des(1:3 , 1:3) * p_z_ini;
    set(tracePlot_z, 'XData', [curX_z, p_z(1)], ...
        'YData', [curY_z, p_z(2)], ...
        'ZData', [curZ_z, p_z(3)], 'Color', [0 0.4470 0.7410], 'LineStyle', '-', 'LineWidth', 2 );

    % Update simulation
    drawnow
    curTime = curTime + dt;

    while toc < dt
        % do nothing
    end
end



