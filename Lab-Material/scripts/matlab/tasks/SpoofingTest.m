clc; clear; close all;

%% 1) Initialize project paths and folder structure
InitProject();               % Add required folders to path, create results folder
p = PathManager();           % Get struct with paths

%% 2) Select dataset and configure input/output
dataset = 'Samsung_A51';
test    = 'Monte_Cappuccini';
[dirName, prFile, outDir] = GetDatasetConfig(dataset, test, p);

% Update output directory
outDir = fullfile(outDir, 'spoofing_test');

% Ensure output directory exists
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

% Control saving of plots and .mat files
saveNominalPlot = true;
saveNominalMat  = true;
saveTask4Plot   = true;
saveTask4Mat    = true;
saveTask5Plot   = true;
saveTask5Mat    = true;
saveTask6Plot   = true;
saveTask6Mat    = true;

%% 3) Load nominal position estimate to obtain true coordinates
fprintf('\nProcessing dataset %s, test %s\n', dataset, test);
spoof0 = spoof_default();
plotADR = false;
figs_nominal = ProcessGnssMeasScript(dirName, prFile, outDir, spoof0, plotADR);

% Immediately save the nominal PVT so it won't get overwritten
if saveNominalMat
    basePvt = fullfile(outDir, [prFile(1:end-4) '_PVT.mat']);
    nominalPvtFile = fullfile(outDir, [prFile(1:end-4) '_nominal_PVT.mat']);
    copyfile(basePvt, nominalPvtFile);
end

% Extract true coordinates (median lat, lon, alt)
% meas = ProcessGnssMeas(ReadGnssLogger(dirName, prFile, SetDataFilter()));
% eph  = GetNasaHourlyEphemeris([], 1e-3*double(meas.allRxMillis(end)), dirName);
% gps0 = GpsWlsPvt(meas, eph, spoof0);
% trueLLA = median(gps0.allLlaDegDegM, 1);
trueLLA = [45.0598616, 7.6971912, 371.85];

%% TASK 4: Small offset from true position
fprintf('\n==== Processing task 4: small offset from true position ====\n');
spoof4 = spoof_task4(trueLLA);
figs4 = ProcessGnssMeasScript(dirName, prFile, outDir, spoof4, plotADR);
fprintf('Task4: spoof position = [%.6f, %.6f, %.2f]\n', spoof4.position);

% Save this task's PVT copy
if saveTask4Mat
    task4PvtFile = fullfile(outDir, [prFile(1:end-4) '_task4_PVT.mat']);
    copyfile(basePvt, task4PvtFile);
end

% Save figures
if saveTask4Plot
    figs4_outDir = fullfile(outDir, 'task4_figures');
    if ~exist(figs4_outDir, 'dir')
        mkdir(figs4_outDir); % Ensure directory exists
    end
    if ~isempty(figs4)
        for i = 1:length(figs4)
            if ishandle(figs4(i))
                saveas(figs4(i), fullfile(figs4_outDir, [prFile(1:end-4) '_task4_figure' num2str(i) '.png']));
            end
        end
    end
end

%% TASK 5: Arbitrary remote spoof position
fprintf('\n==== Processing task 5: arbitrary remote spoof position ====\n');
spoof5 = spoof_task5();
figs5 = ProcessGnssMeasScript(dirName, prFile, outDir, spoof5, plotADR);
fprintf('Task5: spoof position = [%.6f, %.6f, %.2f]\n', spoof5.position);

% Save this task's PVT copy
if saveTask5Mat
    task5PvtFile = fullfile(outDir, [prFile(1:end-4) '_task5_PVT.mat']);
    copyfile(basePvt, task5PvtFile);
end

% Save figures
if saveTask5Plot
    figs5_outDir = fullfile(outDir, 'task5_figures');
    if ~exist(figs5_outDir, 'dir')
        mkdir(figs5_outDir); % Ensure directory exists
    end
    if ~isempty(figs5)
        for i = 1:length(figs5)
            if ishandle(figs5(i))
                saveas(figs5(i), fullfile(figs5_outDir, [prFile(1:end-4) '_task5_figure' num2str(i) '.png']));
            end
        end
    end
end

%% TASK 6: Add spoofing delay
fprintf('\n========== Processing task 6: add spoofing delay ===========\n');
spoof6 = spoof_task6();
figs6 = ProcessGnssMeasScript(dirName, prFile, outDir, spoof6, plotADR);
fprintf('Task6: spoof delay = %d ms\n', spoof6.delay);

% Save this task's PVT copy
if saveTask6Mat
    task6PvtFile = fullfile(outDir, [prFile(1:end-4) '_task6_PVT.mat']);
    copyfile(basePvt, task6PvtFile);
end

% Save figures
if saveTask6Plot
    figs6_outDir = fullfile(outDir, 'task6_figures');
    if ~exist(figs6_outDir, 'dir')
        mkdir(figs6_outDir); % Ensure directory exists
    end
    if ~isempty(figs6)
        for i = 1:length(figs6)
            if ishandle(figs6(i))
                saveas(figs6(i), fullfile(figs6_outDir, [prFile(1:end-4) '_task6_figure' num2str(i) '.png']));
            end
        end
    end
end

fprintf('\n============================================================\n');

fprintf('\nSummarizing results...\n');

%% Summarize and compare results
figure; hold on; grid on;

% Load and plot PVT results
load(nominalPvtFile, 'gpsPvt'); plot(gpsPvt.allLlaDegDegM(:,2), gpsPvt.allLlaDegDegM(:,1), 'k-');
load(task4PvtFile,   'gpsPvt'); plot(gpsPvt.allLlaDegDegM(:,2), gpsPvt.allLlaDegDegM(:,1), 'b--');
load(task5PvtFile,   'gpsPvt'); plot(gpsPvt.allLlaDegDegM(:,2), gpsPvt.allLlaDegDegM(:,1), 'r-.');
load(task6PvtFile,   'gpsPvt'); plot(gpsPvt.allLlaDegDegM(:,2), gpsPvt.allLlaDegDegM(:,1), 'g:');

legend('Nominal', 'Task4', 'Task5', 'Task6');
title('Trajectory Comparison');
xlabel('Longitude (deg)'); ylabel('Latitude (deg)');

% Optionally save comparison figure
if saveNominalPlot
    saveas(gcf, fullfile(outDir, [dataset '_' test '_comparison.png']));
end

fprintf('Results saved in %s\n', outDir);
