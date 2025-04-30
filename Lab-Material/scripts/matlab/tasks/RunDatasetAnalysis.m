% RUNDATASETANALYSIS.M
% This script processes all datasets in the demoFiles directory. For each dataset, it retrieves
% the first pseudorange log file, processes the GNSS measurements, and saves the resulting figures
% to the output directory.

% Declare global variables and initialize project paths
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

% Retrieve all subdirectories in the demoFiles directory
dirs = dir(p.demo); % List all items in the demoFiles directory
dirs = dirs([dirs.isdir] & ~startsWith({dirs.name},'.')); % Filter out non-directories and hidden items

% Iterate through each dataset directory
for i=1:numel(dirs)
    ds = dirs(i).name;                     % Get the name of the dataset directory
    dsPath = fullfile(p.demo, ds);         % Construct the full path to the dataset directory
    files = dir(fullfile(dsPath,'*.txt')); % List all .txt files in the dataset directory
    if isempty(files)                      % Check if no pseudorange log files are found
        warning('No .txt in %s, skipping.', dsPath); % Display a warning and skip this dataset
        continue; % Move to the next dataset
    end
    pr = files(1).name;                            % Select the first pseudorange log file
    out = fullfile(p.results,'demo',ds);           % Define the output directory for results
    figs = ProcessGnssMeasScript(dsPath, pr, out); % Process GNSS measurements for the dataset
    SaveFigures(figs, out, ['demo_' ds]);          % Save the generated figures with a prefix
end
