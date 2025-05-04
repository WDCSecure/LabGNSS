% RUNANDROIDLOGANALYSIS.M
% This script processes all GNSS logs collected from Android devices. For each log file, it processes
% the GNSS measurements and saves the resulting figures to the output directory.

% Declare global variables and initialize project paths
global;            % Declare global variables (if any)
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

% Retrieve all Android log files from the specified directory
files = dir(fullfile(p.android,'*.txt')); % List all .txt files in the Android logs directory

% Iterate through each Android log file
for i = 1:numel(files)
    fn = files(i).name;                                    % Get the name of the log file
    out = fullfile(p.results,'android',erase(fn,'.txt'));  % Define the output directory for results
    figs = ProcessGnssMeasScript(p.android, fn, out);      % Process GNSS measurements for the log file
    SaveFigures(figs, out, ['android_' erase(fn,'.txt')]); % Save the generated figures with a prefix
end
