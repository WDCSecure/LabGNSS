function figHandles = ProcessGnssMeasScript(dirName, prFileName, outDir, spoof, plotAccDeltaRange)
%PROCESSGNSSMEASSCRIPT Core GNSS processing & plotting
%   FIGHANDLES = ProcessGnssMeasScript(DIR, PRFILE, OUTDIR, SPOOF, PLOTDX)
%   - DIR: folder with GNSS log and ephemeris
%   - PRFILE: pseudorange log filename
%   - OUTDIR: output folder for saving figures
%   - SPOOF: struct with fields active, delay, t_start, position
%   - PLOTDX: boolean to enable ADR plots
if nargin<5, plotAccDeltaRange = 0; end
if nargin<4, spoof = struct('active',0,'delay',0,'t_start',0,'position',[]); end
if nargin<3, outDir = pwd; end

% 1) Read raw measurements
dataFilter = SetDataFilter();
[gnssRaw, gnssAnalysis] = ReadGnssLogger(dirName, prFileName, dataFilter);
if isempty(gnssRaw)
    warning('No GNSS raw data found in %s', dirName);
    figHandles = [];
    return;
end

% 2) Download or load ephemeris
fctSeconds = 1e-3 * double(gnssRaw.allRxMillis(end));
utcTime = Gps2Utc([], fctSeconds);
eph = GetNasaHourlyEphemeris(utcTime, dirName);
if isempty(eph)
    warning('No ephemeris data found.');
    figHandles = [];
    return;
end

% 3) Generate measurements (with optional spoofing)
if spoof.active
    gnssMeas_tmp = ProcessGnssMeas(gnssRaw);
    gpsPvt_tmp = GpsWlsPvt(gnssMeas_tmp, eph, spoof);
    spoof = compute_spoofSatRanges(gnssMeas_tmp, gpsPvt_tmp, spoof);
    gnssMeas = ProcessGnssMeas(gnssRaw, spoof);
else
    gnssMeas = ProcessGnssMeas(gnssRaw);
end

% 4) Plot pseudoranges and pseudorange rates
h1 = figure; colors = PlotPseudoranges(gnssMeas, prFileName);
h2 = figure; PlotPseudorangeRates(gnssMeas, prFileName, colors);
h3 = figure; PlotCno(gnssMeas, prFileName, colors);

% 5) Compute and plot PVT
gpsPvt = GpsWlsPvt(gnssMeas, eph, spoof);

% Filter out unrealistic jumps
% gpsPvt = FilterPositionOutliers(gpsPvt, 30);  % 30 m/s threshold

h4 = figure; PlotPvt(gpsPvt, prFileName, [], 'Raw Pseudoranges, Weighted Least Squares solution');
h5 = figure; PlotPvtStates(gpsPvt, prFileName);

figHandles = [h1, h2, h3, h4, h5];

% 6) Accumulated Delta Range (ADR)
if plotAccDeltaRange && any(isfinite(gnssMeas.AdrM) & gnssMeas.AdrM ~= 0)
    gnssMeas = ProcessAdr(gnssMeas);
    h6 = figure; PlotAdr(gnssMeas, prFileName, colors);
    adrResid = GpsAdrResiduals(gnssMeas, eph, []);
    h7 = figure; PlotAdrResids(adrResid, gnssMeas, prFileName, colors);
    figHandles = [figHandles, h6, h7];
end

% 7) Geoplot of trajectory
h8 = figure('Name', '[Optional] Plot Positioning Solution on Map');
geoplot(gpsPvt.allLlaDegDegM(:, 1), gpsPvt.allLlaDegDegM(:, 2)), hold on;
for epochIdx = 1:size(gpsPvt.allLlaDegDegM, 1)
    geoplot(gpsPvt.allLlaDegDegM(epochIdx, 1), gpsPvt.allLlaDegDegM(epochIdx, 2), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
    drawnow;
    pause(0.01);
end
figHandles = [figHandles, h8];

% 8) Save all figures to outDir
% SaveFigures(figHandles, outDir, 'GNSS');
end
