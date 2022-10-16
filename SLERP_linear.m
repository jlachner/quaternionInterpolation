%% Interpolation with slerp to show displacements of body-fixed coordinate frames
% Author: Johannes Lachner
% Date: October 4, 2022

% Clean up
close all;
clear;
clc;

% Include subdirectories
func_addSubfolders('helpers');

% Make a figure
x_lim = [-1, 1.5];
y_lim = [-1, 1.5];
z_lim = [-0.5, 1];
[fig, ax] = func_createFigure(x_lim, y_lim, z_lim);

% Initialize interpolated transformation matrices
H_0_cur1 = eye(4);
H_0_cur2 = eye(4);

% Initial and final coordiantes for coordinate frame 1
H_0_ini1 = eye(4);                                                       % Initial transformation of frame 1 is identity
q1_ini = quaternion(H_0_ini1(1:3, 1:3), 'rotmat', 'frame');              % Initial orientation of frame 1 is identity

q1_goal = quaternion([35, 0, 0],'eulerd','ZYX','frame');                 % Goal orientation frame 1
p1_goal = [0 , 0, 0.5]';                                                 % Goal translation frame 1 (along z)
H_0_goal1 = quat2tform(q1_goal);
H_0_goal1(1:3, 4) = p1_goal;

% Initial and final coordiantes for coordinate frame 2
H_0_ini2 = eul2tform(deg2rad( [12, -4, 13] ), 'ZYX');
H_0_ini2(1, 4) = 0.3;                                                    % Move along long side of box
H_0_ini2(2, 4) = 1;                                                      % Move along depth of box
H_0_ini2(3, 4) = 0.15;                                                   % Move along height of box
q2_ini = quaternion([12, -4, 13],'eulerd','ZYX','frame');  

% x = A\b is computed differently than x = inv(A)*b
H_0_ini1_inv = H_0_ini1\eye(size(H_0_ini1));
H_1_2 = H_0_ini1_inv * H_0_ini2;                                        % Transformation between two coordinate frames

H_0_goal2 = H_0_goal1 * H_1_2;
q2_goal = quaternion(H_0_goal2(1:3, 1:3)', 'rotmat', 'frame');           % Goal orientation of frame 2            
p2_goal = H_0_goal2(1:3, 4);                                             % Goal translation of frame 2

%% Plot data: Coordinate frames and boxes

% Draw interpolated coordinate frame 1
hg_1 = hgtransform('Parent', ax, 'Matrix', H_0_ini1);
[V1,F1,C1] = func_create_VFC_data('CoordinateSys',12);
V1 = 0.35 * V1;
patchTCP1 = patch('Faces', F1,...
    'Vertices' ,V1,...
    'FaceVertexCData', C1,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_1);

% Draw interpolated coordinate frame 2
hg_2 = hgtransform('Parent', ax, 'Matrix', H_1_2);
[V2,F2,C2] = func_create_VFC_data('CoordinateSys',12);
V2 = 0.35 * V2;
patchTCP2 = patch('Faces', F2,...
    'Vertices' ,V2,...
    'FaceVertexCData', C2,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_2);

% Create box and set parent hg_1 (interpolated coordinate frame 1)
hg_1B = hgtransform('Parent', hg_1, 'Matrix', eye(4));
[v1,f1,c1] = func_create_VFC_data('Box', 12);
patchBox1 = patch('Vertices',v1,...
    'Faces',f1,...
    'FaceVertexCData',c1,...
    'FaceColor','flat',...
    'Parent', hg_1B);

% Create box and set parent hg_2 (interpolated coordinate frame 2)
hg_2B = hgtransform('Parent', hg_2, 'Matrix', inv(H_0_ini2));
[v2,f2,c2] = func_create_VFC_data('Box', 14);
patchBox2 = patch('Vertices',v2,...
    'Faces',f2,...
    'FaceVertexCData',c2,...
    'FaceColor','r',...
    'Parent', hg_2B);



%% Simulation
curTime = 0;
Tstep = 1;
dt = 0.005;
step = 1;
while curTime <= Tstep
    tic

    % Interpolate quaternions
    quat1 = slerp(q1_ini, q1_goal, curTime);
    quat2 = slerp(q2_ini, q2_goal, curTime);

    % Linear interpolator of position
    ratio = curTime / Tstep;
    if ratio > 1
        ratio = 1.0;
    end
    p_0_1 = H_0_ini1(1:3, 4) + ratio * ( p1_goal - H_0_ini1(1:3, 4) );
    p_0_2 = H_0_ini2(1:3, 4) + ratio * ( p2_goal - H_0_ini2(1:3, 4) );

    % Convert to transformation matrix
    H_0_cur1(1:3, 1:3) = quat2rotm(quat1);
    H_0_cur1(1:3, 4) = p_0_1;
    H_0_cur2(1:3, 1:3) = quat2rotm(quat2);
    H_0_cur2(1:3, 4) = p_0_2;

    % Update key frame
    set(hg_1, 'Matrix', H_0_cur1);
    set(hg_2, 'Matrix', H_0_cur2);

    % Safe one arbitrary transformation matrix to show different 
    % in-between poses
    if step == (Tstep/dt)/4
        H_0_safe1 = H_0_cur1;
        H_0_safe2 = H_0_cur2;
    end

    % Update simulation
    curTime = curTime + dt;
    step = step + 1;

    drawnow;
  
    while toc < dt
        % do nothing
    end
end

%% Draw in-between pose
 
% In-between pose coordinate frame 1
hg_1ib = hgtransform('Parent', ax, 'Matrix', H_0_safe1);
[V3,F3,C3] = func_create_VFC_data('CoordinateSys',12);
V3 = 0.35 * V3;
patchTCP = patch('Faces', F3,...
    'Vertices' ,V3,...
    'FaceVertexCData', C3,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_1ib);

% Create box and set parent hg_1ib
hg_1B_ib = hgtransform('Parent', hg_1ib, 'Matrix', eye(4));
[v4,f4,c4] = func_create_VFC_data('Box', 12);
patchBox_ib1 = patch('Vertices',v4,...
    'Faces',f4,...
    'FaceVertexCData',c4,...
    'FaceColor','flat',...
    'Parent', hg_1B_ib);

% In-between pose coordinate frame 2
hg_2ib = hgtransform('Parent', ax, 'Matrix', H_0_safe2);
[V3,F3,C3] = func_create_VFC_data('CoordinateSys',12);
V3 = 0.35 * V3;
patchTCP = patch('Faces', F3,...
    'Vertices' ,V3,...
    'FaceVertexCData', C3,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_2ib);

% Create box and set parent hg_2ib
hg_2B_ib = hgtransform('Parent', hg_2ib, 'Matrix', inv(H_0_ini2));
[v4,f4,c4] = func_create_VFC_data('Box', 12);
patchBox_ib2 = patch('Vertices',v4,...
    'Faces',f4,...
    'FaceVertexCData',c4,...
    'FaceColor','r',...
    'Parent', hg_2B_ib);








