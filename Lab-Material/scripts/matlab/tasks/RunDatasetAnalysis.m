% RUNDATASETANALYSIS.M
% This script processes all tests for the specified datasets (Samsung_A51 and Xiaomi_11TPro).
% It retrieves the pseudorange log files, processes the GNSS measurements, and saves the results.

%% Initialize project paths and folder structure
InitProject();     % Set up MATLAB paths and results folder
p = PathManager(); % Retrieve project folder structure

%% Define datasets and their corresponding tests
datasets = {
    'Samsung_A51',    {'Piazza_Castello', 'Tram_15_trip_Castello_to_Pescatore', ...
                       'Monte_Cappuccini_ascent', 'Monte_Cappuccini', ...
                       'Parco_del_Valentino_1', 'Parco_del_Valentino_2'};
    'Xiaomi_11T_Pro', {'Piazza_Castello', 'Tram_15_trip_Castello_to_Pescatore', ...
                       'Monte_Cappuccini', 'Parco_del_Valentino_walk', ...
                       'Parco_del_Valentino_1', 'Parco_del_Valentino_phone_call'}
};

%% Iterate through each dataset and its tests
for d = 1:size(datasets, 1)
    dataset = datasets{d, 1}; % Dataset name
    tests = datasets{d, 2};   % List of tests for the dataset
    
    for t = 1:numel(tests)
        test = tests{t}; % Current test name
        
        % Configure paths and filenames for the dataset and test
        [dirName, pr, out] = GetDatasetConfig(dataset, test, p);
        
        % Configure spoofing parameters
        spoof.active   = 0;  % Disable spoofing
        spoof.delay    = 0;  % Set spoofing delay to 0 milliseconds
        spoof.t_start  = 15; % Start spoofing at 15 seconds
        spoof.position = [45.06361, 7.679483, 347.48]; % Define spoofed position
        
        % Enable ADR (Accumulated Delta Range) plotting
        plotADR = 0; % Set to 1 to enable ADR plots
        
        % Process GNSS measurements with the specified parameters
        figs = ProcessGnssMeasScript(dirName, pr, out, spoof, plotADR);
        
        % Save the generated figures to the output directory
        format = 'both'; % Specify the format: 'png', 'fig', or 'both'
        figNamePrefix = sprintf('%s_%s', dataset, test); % Base prefix: "dataset_test"
        SaveFigures(figs, out, figNamePrefix, format);
    end
end
