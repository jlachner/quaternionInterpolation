% Add subfolders to current path

function func_addSubfolders(varargin)
for curFolder = 1:length(varargin)

    % Be careful, MACs and Windows PC have different 
    if ismac || isunix
        % Code to run on Mac platform
        curPath = [pwd,'/',varargin{curFolder}];
    elseif ispc
        % Code to run on Windows platform
        curPath = [pwd,'\',varargin{curFolder}];
    else
        disp('Platform not supported')
    end

    addpath(curPath);
    addpath(genpath(curPath));
    %disp(['Added path: ',curPath]);
end
