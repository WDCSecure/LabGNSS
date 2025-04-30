% RUNDEMO.M
% This script runs a single demonstration of GNSS processing with spoofing and ADR (Accumulated Delta Range).
% It initializes the project, sets up the demo dataset, configures spoofing parameters, and processes the GNSS
% measurements. The results are saved as figures in the output directory.

% Initialize project paths and folder structure
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

% Define the demo dataset and output directory
demo = 'dataset_b';                      % Name of the demo dataset
dirName = fullfile(p.demo, demo);        % Path to the demo dataset directory
pr = 'gnss_log_2023_03_17_16_54_04.txt'; % Name of the pseudorange log file
out = fullfile(p.results,'demo',demo);   % Define the output directory for results

% Configure spoofing parameters
spoof.active = 1;   % Enable spoofing
spoof.delay = 5e-3; % Set spoofing delay to 5 milliseconds
spoof.t_start = 15; % Start spoofing at 15 seconds
spoof.position = [45.06361,7.679483,347.48]; % Define the spoofed position (latitude, longitude, altitude)

% Enable ADR (Accumulated Delta Range) plotting
plotADR = 1; % Set to 1 to enable ADR plots

% Process GNSS measurements with the specified parameters
figs = ProcessGnssMeasScript(dirName, pr, out, spoof, plotADR); % Process GNSS data and generate figures

% Save the generated figures to the output directory
SaveFigures(figs, out, ['demo_' demo]); % Save figures with a prefix
