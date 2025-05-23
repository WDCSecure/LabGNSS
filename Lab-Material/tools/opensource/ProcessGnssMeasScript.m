%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%               ProcessGnssMeasScript.m,         %%%%%%%%%%%%%%%%
%%%%%%%%%%% script to read GnssLogger output, compute and plot: %%%%%%%%%%%
%%%%%%%% pseudoranges, C/No, and weighted least squares PVT solution  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: Frank van Diggelen
% Open Source code for processing Android GNSS Measurements
% Modified by Alex Minetto (NavSAS Research Group) 
% Last update: Alex Minetto & Simone Zocca 12-Oct-2021
% Last update: Andrea Nardin 19-Oct-2023
% Spoofing enhancement: Andrea Nardin 10-Mar-2024

% NOTE: Compatible with GNSSLogger App v2.0.0.1
% WARNING: CodeType breaks the code for logs retrieved by GNSSLogger App
% v3.0.0.1



% you can run the data in pseudoranges log files collected through your device by: 
% 1) changing 'dirName = ...' to match the local directory you are using:
% 3) running ProcessGnssMeasScript.m script file (this script) 
clc, close all, clear all
% include library functions (utilities and functions)
addpath('library')


% ***** SETTINGS *********************************************************
%% input data (GNSS logger)
% To add your own data:
% save data from GnssLogger App, and edit dirName and prFileName appropriately
prFileName    = 'gnss_log_2023_03_17_16_54_04.txt';
dirName       = 'demoFiles/dataset_b';

%% true position
param.llaTrueDegDegM = [];
%enter true WGS84 lla, if you know it:
% param.llaTrueDegDegM = [37.422578, -122.081678, -28]; %Charleston Park Test Site

%% Spoofing settings
spoof.active = 0; % [1: spoofing active, 0: spoofing disabled]
spoof.delay = 0; % [s] additional delay introduced by the spoofer [s]
spoof.t_start = 15; % [s] start spoofing time
spoof.position = [45.06361, 7.679483, 347.48]; % spoofed position

%% Plots
plotAccDeltaRange = 0;
plotPseudorangeRate = 1;

%********************* END SETTINGS ***************************************

%% Set the data filter and Read log file
dataFilter = SetDataFilter;
[gnssRaw,gnssAnalysis] = ReadGnssLogger(dirName,prFileName,dataFilter);
if isempty(gnssRaw), return, end


%% Get online ephemeris from Nasa CCDIS service, first compute UTC Time from gnssRaw:
fctSeconds = 1e-3*double(gnssRaw.allRxMillis(end));
utcTime = Gps2Utc([],fctSeconds);
allGpsEph = GetNasaHourlyEphemeris(utcTime,dirName);
if isempty(allGpsEph), return, end

%% process raw measurements, compute pseudoranges:
% Compute synthetic spoofer-sat ranges
if spoof.active
    [gnssMeas_tmp] = ProcessGnssMeas(gnssRaw);
    gpsPvt_tmp = GpsWlsPvt(gnssMeas_tmp,allGpsEph,spoof);
    [spoof] = compute_spoofSatRanges(gnssMeas_tmp,gpsPvt_tmp,spoof);
    % Now consistently spoof the measurements
    [gnssMeas] = ProcessGnssMeas(gnssRaw,spoof);
else
    [gnssMeas] = ProcessGnssMeas(gnssRaw);
end

%% plot pseudoranges and pseudorange rates
h1 = figure;
[colors] = PlotPseudoranges(gnssMeas,prFileName);
if plotPseudorangeRate
    h2 = figure;
    PlotPseudorangeRates(gnssMeas,prFileName,colors);
end
h3 = figure;
PlotCno(gnssMeas,prFileName,colors);

%% compute WLS position and velocity
gpsPvt = GpsWlsPvt(gnssMeas,allGpsEph,spoof);

%% plot PVT results
h4 = figure;
ts = 'Raw Pseudoranges, Weighted Least Squares solution';
PlotPvt(gpsPvt,prFileName,param.llaTrueDegDegM,ts); drawnow;
h5 = figure;
PlotPvtStates(gpsPvt,prFileName);

%% Plot Accumulated Delta Range 
if (any(isfinite(gnssMeas.AdrM) & gnssMeas.AdrM~=0)) 
    [gnssMeas]= ProcessAdr(gnssMeas);
    if plotAccDeltaRange
    h6 = figure;
    PlotAdr(gnssMeas,prFileName,colors);
    [adrResid]= GpsAdrResiduals(gnssMeas,allGpsEph,param.llaTrueDegDegM);drawnow
    end
end

if exist('adrRedis','var') && ~isempty(adrResid)
    h7 = figure;
    PlotAdrResids(adrResid,gnssMeas,prFileName,colors);
end

%% plot PVT on geoplot
h8 = figure('Name','[Optional] Plot Positioning Solution on Map');
geoplot(gpsPvt.allLlaDegDegM(:,1),gpsPvt.allLlaDegDegM(:,2)), hold on

% animated geoplot
for epochIdx = 1:size(gpsPvt.allLlaDegDegM,1)
figure(h8)
geoplot(gpsPvt.allLlaDegDegM(epochIdx,1),gpsPvt.allLlaDegDegM(epochIdx,2),'ro','MarkerSize',4,'MarkerFaceColor','r') 
drawnow
pause(0.01)
end

%% end of ProcessGnssMeasScript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2016 Google Inc.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
