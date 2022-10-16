%% Cubic interpolation with slerp
% Author: Johannes Lachner
% Date: October 4, 2022

% Clean up
clc;
close all;

% Include subdirectories
func_addSubfolders('helpers');

% Make a figure
x_lim = [-1, 1];
y_lim = [-1.5, 1.5];
z_lim = [-1, 2];
[fig, ax] = func_createFigure(x_lim, y_lim, z_lim);

% Create sphere
[x , y, z ] = sphere;
hold on;
axis equal;
surf(x, y, z, 'FaceColor', [.7 .7 .7])

%% Supporting points and tangent vectors
no_keys = 3;
no_segs = no_keys-1;

x = NaN(3, no_keys);
q = NaN(4, no_keys);
xS = NaN(3, no_keys);

x(:,1) = deg2rad([0, 0, 0]');
x(:,2) = deg2rad([120, -20, 0]');
x(:,3) = deg2rad([0, 250, -235]');

for cur_key = 1:no_keys
    rot = eul2rotm(x(:,cur_key)', 'XYZ');
    q(:,cur_key) = rotm2quat(rot);
end
q = func_restrictQuatsOnHemisphere(q);

% Angular velocities expressed in spatial coordinate frame
omega(:,1) = [1, 1, 0]' * 0.5;
omega(:,2) = [-1, 0.5, 0]';
omega(:,3) = [2, 0.5, 0]' * 0.5;

%% Plot Initial key frame
hg_1 = hgtransform('Parent', ax, 'Matrix',  eye(4));
[V1,F1,C1] = func_create_VFC_data('CoordinateSys',12);
V1 = 1.5 * V1;
framePlotCubic = patch('Faces', F1,...
    'Vertices' ,V1,...
    'FaceVertexCData', C1,...
    'FaceC', 'flat',...
    'EdgeColor','none', 'Parent', hg_1);

%% C1 cubic interpolation

% Interpolation settings
dt = 0.001;
T = 0:dt:1;

% Initialize quaternions
q00 = q(:,1:end-1);
q01 = NaN(4,no_segs);
q02 = NaN(4,no_segs);
q03 = q(:,2:end);

% Use key angular key velocities to compute control quats
for cur_seg = 1:no_segs
    % Transform key velocities to key systems
    omega_key_n = Quat_mult( Quat_mult( Quat_inv( q(:,cur_seg)) , [0; omega(:,cur_seg)] ) , q(:,cur_seg) );
    omega_key_np1 = Quat_mult( Quat_mult( Quat_inv( q(:,cur_seg+1) ) , [0; omega(:,cur_seg+1)] ) , q(:,cur_seg+1) );

    q01(:,cur_seg) = Quat_mult( q(:,cur_seg) , Quat_exp(1/3 * 1/2 * omega_key_n) );
    q02(:,cur_seg) = Quat_mult( q(:,cur_seg+1) , Quat_exp(-1/3 * 1/2 * omega_key_np1) );
end

q_ges = [];
s_ges = [];

for cur_seg = 1:no_segs
    C = func_CubBez4D([q00(:,cur_seg), q01(:,cur_seg), q02(:,cur_seg), q03(:,cur_seg)], T);
    s_inc = T;
    if cur_seg ~= no_segs        % unless this is the last segment
        C(:,end) = [];           % remove the last element (=first element of next segment)
        s_inc(:,end) = [];
    end
    q_ges = [q_ges, C];
    s_ges = [s_ges, (cur_seg-1) + s_inc];
end

%% Animate cubic interpolation
func_Plot_Quats_on_unit_sphere(q_ges, q, '-', gcf);

pause;                           % wait until the user presses a key

H_0_cur = eye(4);
for cur_step = 1:3:length(s_ges)
    H_0_cur(1:3, 1:3) = quat2rotm(q_ges(:,cur_step)');
    set(hg_1, 'Matrix', H_0_cur)
    drawnow;
    pause(0.01);
end






