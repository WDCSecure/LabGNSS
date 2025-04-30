function InitProject()
%INITPROJECT Set up MATLAB path and results folder
%   This function initializes the project by adding necessary directories
%   to the MATLAB path and creating the results folder if it does not exist.

% Retrieve the project folder structure
p = PathManager();

% Add library, core, utility, and task directories to the MATLAB path
% The library is added first to ensure its functions take precedence
addpath(p.lib, p.core, p.utils, p.tasks);

% Create the results directory if it does not exist
if ~exist(p.results,'dir')
    mkdir(p.results); % Create the directory
end

% Display a message indicating that the project paths are set
fprintf('Project paths set. Results at %s\n', p.results);
end
