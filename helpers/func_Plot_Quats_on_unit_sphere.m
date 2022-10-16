%% Plot quaternions on sphere
% Author: Johannes Lachner
% Date: October 4, 2022
%
% TODO: The colors of paths and key quaternions are still set manually. This can
% be automized

function func_Plot_Quats_on_unit_sphere(qq, keys, LineStylo, fig_num, LineWidth)

% Figure settings
redCol = [0.6350 0.0780 0.1840];
yelCol = [0.9290 0.6940 0.1250];
blCol = [0 0.4470 0.7410];

if nargin < 6
    LineWidth = 2;
end

figure(fig_num);
hold on;

% Key data
qq_plot_red = NaN(3, size(qq, 1));
qq_plot_yel = NaN(3, size(qq, 2));
qq_plot_bl = NaN(3, size(qq, 3));
keys_plot_red = NaN(3, size(keys, 1));
keys_plot_yel = NaN(3, size(keys, 2));
keys_plot_bl = NaN(3, size(keys, 3));
for kk = 1:size(qq, 2)
    R = quat2rotm(qq(:, kk)');
    qq_plot_red(:, kk) = R * [1, 0, 0]';
    qq_plot_yel(:, kk) = R * [0, 1, 0]';
    qq_plot_bl(:, kk) = R * [0, 0, 1]';
end
for kk = 1:size(keys, 2)
    R = quat2rotm(keys(:, kk)');
    keys_plot_red(1:3, kk) = R * [1, 0, 0]';
    keys_plot_yel(1:3, kk) = R * [0, 1, 0]';
    keys_plot_bl(1:3, kk) = R * [0, 0, 1]';
end

%% Plot the colored path
path_red = plot3(qq_plot_red(1,:), qq_plot_red(2,:), qq_plot_red(3,:));
set(path_red,'LineWidth',LineWidth,...
    'Color', redCol,...
    'LineStyle', LineStylo);

path_yel = plot3(qq_plot_yel(1,:), qq_plot_yel(2,:), qq_plot_yel(3,:));
set(path_yel,'LineWidth',LineWidth,...
    'Color', yelCol,...
    'LineStyle', LineStylo);

path_yel = plot3(qq_plot_bl(1,:), qq_plot_bl(2,:), qq_plot_bl(3,:));
set(path_yel,'LineWidth',LineWidth,...
    'Color', blCol,...
    'LineStyle', LineStylo);

sqrt(qq_plot_red(1,:).^2 + qq_plot_red(2,:).^2 + qq_plot_red(3,:).^2);
sqrt(qq_plot_yel(1,:).^2 + qq_plot_yel(2,:).^2 + qq_plot_yel(3,:).^2);
sqrt(qq_plot_bl(1,:).^2 + qq_plot_bl(2,:).^2 + qq_plot_bl(3,:).^2);

%% Plot the keys on sphere
% Get points on unit sphere
[x,y,z] = sphere;
start_scale = .08;
int_scale = start_scale/2;

% Red
surf(start_scale * x + keys_plot_red(1,1),...
    start_scale * y + keys_plot_red(2,1),...
    start_scale * z + keys_plot_red(3,1),...
    'FaceColor', redCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_red(1,2),...
    start_scale * y + keys_plot_red(2,2),...
    start_scale * z + keys_plot_red(3,2),...
    'FaceColor', redCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_red(1,3),...
    start_scale * y + keys_plot_red(2,3),...
    start_scale * z + keys_plot_red(3,3),...
    'FaceColor', redCol, 'EdgeColor', 'none');

% Yellow
surf(start_scale * x + keys_plot_yel(1,1),...
    start_scale * y + keys_plot_yel(2,1),...
    start_scale * z + keys_plot_yel(3,1),...
    'FaceColor', yelCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_yel(1,2),...
    start_scale * y + keys_plot_yel(2,2),...
    start_scale * z + keys_plot_yel(3,2),...
    'FaceColor', yelCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_yel(1,3),...
    start_scale * y + keys_plot_yel(2,3),...
    start_scale * z + keys_plot_yel(3,3),...
    'FaceColor', yelCol, 'EdgeColor', 'none');

% Blue
surf(start_scale * x + keys_plot_bl(1,1),...
    start_scale * y + keys_plot_bl(2,1),...
    start_scale * z + keys_plot_bl(3,1),...
    'FaceColor', blCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_bl(1,2),...
    start_scale * y + keys_plot_bl(2,2),...
    start_scale * z + keys_plot_bl(3,2),...
    'FaceColor', blCol, 'EdgeColor', 'none');

surf(start_scale * x + keys_plot_bl(1,3),...
    start_scale * y + keys_plot_bl(2,3),...
    start_scale * z + keys_plot_bl(3,3),...
    'FaceColor', blCol, 'EdgeColor', 'none');







