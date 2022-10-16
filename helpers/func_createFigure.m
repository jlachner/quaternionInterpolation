function [plotFig,plotAx] = func_createFigure(varargin)
%   Function creates a figure if there is none existant
%   There is a figure and axis created. Once they exist the camera position
%   is saved when this function is called again. It allows to zoom and turn
%   the view during a moving animation.

if nargin == 0
    % choose default values
    xLim = [-0.5, 0.9]; yLim = [-0.8, 0.9]; zLim = [-0.2, 1.6];
    axDim = 3;
elseif nargin == 2 || isempty(varargin{3})
    % it's a 2D plot
    xLim = varargin{1}; yLim = varargin{2};
    axDim = 2;
elseif nargin == 3
    % it's a 3D plot
    xLim = varargin{1}; yLim = varargin{2}; zLim = varargin{3};
    axDim = 3;
elseif nargin == 4
    xLim = varargin{1}; yLim = varargin{2}; zLim = varargin{3};
    axDim = 3;
else
    error('expected either no axes limits, xy limts, or xyz limits: 0, 2, or 3 parameters');
end
 
if nargin <4
    % check if axes exists
    plotFig = findobj('type', 'figure','tag', 'plotFig');
    plotAx = findobj('type', 'axes','tag', 'plotAx'); 
else
    plotFig = varargin{4};
    plotAx = [];
end

if ~isempty(plotAx)
    % if there is one, store the current camera setting, then clear it
    disp('Found existing plotAx, keeping the current view and axis limits');
    p = campos(plotAx);
    t = camtarget(plotAx);
    u = camup(plotAx);
    va = camva(plotAx);
    
    cla(plotAx);
    
    hold(plotAx, 'on');
    
    campos(plotAx, p);
    camtarget(plotAx, t);
    camup(plotAx, u);
    camva(plotAx, va);
    
    if axDim == 3
        axes(plotAx);
        lighting gouraud; % cla also deleted the light
        lightObj = light('Tag','lightObj');
    end
    
else
    %     clf % otherwise this will clear the GUI and delete all objects!
    if nargin < 4
        plotFig = figure(1);
    end


    set(plotFig, 'tag', 'plotFig');
    set(plotFig,'Color',[1,1,1]);
    plotAx = axes('tag','plotAx');        
        
    hold on;
    axis equal;
    axis manual;

    set(plotAx, 'XLim', xLim, 'YLim', yLim);
       
    if axDim == 2
        xlabel('X'); ylabel('Y');      
    else
        xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
        set(plotAx, 'ZLim', zLim);
        
        daspect([1,1,1]);
        lighting gouraud;
        lightObj = light('Tag','lightObj'); 
    
        view(135,30);
    end
    
    grid on;
    
end

% Create plot objects in plotAx. If axes existed before, cla deleted them
axes(plotAx);
if axDim == 2    
    tracePlot = plot(NaN, NaN); 
    set(tracePlot, 'XData', [], 'YData',[]);
    
    fAPlot = plot(NaN, NaN); 
    set(fAPlot, 'XData', [], 'YData',[]);
    
    fCurPlot = plot(NaN, NaN); 
    set(fCurPlot, 'XData', [], 'YData',[]);
    
    ftestPlot = plot(NaN, NaN); 
    set(ftestPlot, 'XData', [], 'YData',[]);
    
else
    tracePlot = plot3(NaN, NaN, NaN); 
    set(tracePlot, 'XData', [], 'YData',[], 'ZData', []);
  
    fAPlot = plot3(NaN, NaN, NaN); 
    set(fAPlot, 'XData', [], 'YData',[], 'ZData', []);
    
    fCurPlot = plot3(NaN, NaN, NaN); 
    set(fCurPlot, 'XData', [], 'YData',[], 'ZData', []);

    ftestPlot = plot3(NaN, NaN, NaN); 
    set(ftestPlot, 'XData', [], 'YData',[], 'ZData', []);
    
end

set(tracePlot, 'Color','r','LineStyle','-', 'LineWidth', 1.2 ,'Parent', plotAx,'tag','tracePlot');
set(fAPlot, 'Color','r', 'LineStyle', '-', 'Parent' , plotAx, 'tag', 'fAPlot');
set(fCurPlot, 'Color','g', 'LineStyle', '-', 'Parent' , plotAx, 'tag', 'fCurPlot');
set(ftestPlot, 'Color','b', 'LineStyle', ':', 'Parent' , plotAx, 'tag', 'ftestPlot');

