% RUNDEMO.M
% This script runs a single demonstration of GNSS processing with spoofing and ADR (Accumulated Delta Range).
% It initializes the project, sets up the demo dataset, configures spoofing parameters, and processes the GNSS
% measurements. The results are saved as figures in the output directory.

clc; close all; clear all;

%% Initialize project paths and folder structure
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

%% Define the dataset and test to run
dataset = 'Samsung_A51';     % Options: 'dataset_b', 'Samsung_A51', 'Xiaomi_11T_Pro'
test    = 'Monte_Cappuccini'; % Specific test for Samsung A51 or Xiaomi 11T Pro (ignored for dataset_b)

%% Configure paths based on the selected dataset and test
[dirName, pr, out] = GetDatasetConfig(dataset, test, p);

%% Configure spoofing parameters
spoof.active   = 0;  % Enable spoofing
spoof.delay    = 0;  % Set spoofing delay to 0 milliseconds
spoof.t_start  = 15; % Start spoofing at 15 seconds
spoof.position = [45.06361,7.679483,347.48]; % Define the spoofed position (latitude, longitude, altitude)

%% Enable ADR (Accumulated Delta Range) plotting
plotADR = 0; % Set to 1 to enable ADR plots

%% Process GNSS measurements with the specified parameters
figs = ProcessGnssMeasScript(dirName, pr, out, spoof, plotADR); % Process GNSS data and generate figures

%% Save the generated figures to the output directory
format = 'both'; % Specify the format: 'png', 'fig', or 'both'
figNamePrefix = sprintf('%s_%s', dataset, test); % Base prefix: "dataset_test"
% SaveFigures(figs, out, figNamePrefix, format); % Save all figures with the specified format
