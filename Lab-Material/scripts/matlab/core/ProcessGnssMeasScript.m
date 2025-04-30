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
[gnssRaw,~] = ReadGnssLogger(dirName,prFileName,dataFilter);
if isempty(gnssRaw)
warning('No GNSS raw data found in %s', dirName);
figHandles = [];
return;
end

% 2) Download or load ephemeris
t = Gps2Utc([],1e-3*double(gnssRaw.allRxMillis(end)));
eph = GetNasaHourlyEphemeris(t,dirName);

% 3) Generate measurements (with optional spoofing)
if spoof.active
meas0 = ProcessGnssMeas(gnssRaw);
pvt0  = GpsWlsPvt(meas0,eph,spoof);
spoof = compute_spoofSatRanges(meas0,pvt0,spoof);
gnssMeas = ProcessGnssMeas(gnssRaw,spoof);
else
gnssMeas = ProcessGnssMeas(gnssRaw);
end

% 4) Core plots
h1 = figure; colors = PlotPseudoranges(gnssMeas,prFileName);
h2 = figure; PlotPseudorangeRates(gnssMeas,prFileName,colors);
h3 = figure; PlotCno(gnssMeas,prFileName,colors);

% 5) Compute and plot PVT
pvt = GpsWlsPvt(gnssMeas,eph,spoof);
h4 = figure; PlotPvt(pvt,prFileName,[], 'WLS');
h5 = figure; PlotPvtStates(pvt,prFileName);

figHandles = [h1,h2,h3,h4,h5];

% 6) Accumulated Delta Range (ADR)
adrM = gnssMeas.AdrM;
if plotAccDeltaRange && any(any(isfinite(adrM) & adrM~=0))
gnssMeas = ProcessAdr(gnssMeas);
h6 = figure; PlotAdr(gnssMeas,prFileName,colors);
adrResid = GpsAdrResiduals(gnssMeas,eph,[]);
h7 = figure; PlotAdrResids(adrResid,gnssMeas,prFileName,colors);
figHandles = [figHandles,h6,h7];
end

% 7) Geoplot of trajectory
lla = pvt.allLlaDegDegM;
h8 = figure('Name','Geoplot');
geoplot(lla(:,1),lla(:,2)); hold on;
for k=1:size(lla,1)
geoplot(lla(k,1),lla(k,2),'ro','MarkerSize',4,'MarkerFaceColor','r');
drawnow; pause(0.01);
end
figHandles = [figHandles,h8];

% 8) Save all figures to outDir
% SaveFigures(figHandles,outDir,'GNSS');
end
