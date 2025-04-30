% SPOOFINGTEST.M
% This script performs a sweep of all spoofing configurations on the first Android log file.
% It initializes the project, retrieves the first Android log, and iterates through all spoofing
% configuration files. For each configuration, it processes the GNSS measurements and saves the
% resulting figures to the output directory.

% Initialize global variables and project paths
global;            % Declare global variables (if any)
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

% Retrieve all Android log files from the specified directory
files = dir(fullfile(p.android,'*.txt')); % List all .txt files in the Android logs directory
if isempty(files)                         % Check if no Android logs are found
    error('No Android logs');             % Display an error message and terminate the script
end
log = files(1).name; % Select the first Android log file

% Retrieve all spoofing configuration files
configs = dir(fullfile(p.spoofConf,'*.m')); % List all .m files in the spoof configurations directory

% Iterate through each spoofing configuration
for k=1:numel(configs)
    [~,nm] = fileparts(configs(k).name);   % Extract the file name without extension
    cfg = feval(nm);                       % Evaluate the configuration file to retrieve the spoofing settings
    out = fullfile(p.results,'spoof',nm);  % Define the output directory for results
    figs = ProcessGnssMeasScript(p.android, log, out, cfg); % Process GNSS measurements with the configuration
    SaveFigures(figs, out, ['spoof_' nm]); % Save the generated figures with a prefix
end
