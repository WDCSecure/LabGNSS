function df = SetDataFilter()
%SETDATAFILTER Default GNSS data filter settings
%   This function defines the default thresholds for filtering GNSS data.
%   These thresholds can be adjusted to refine the data processing.

% Minimum satellite elevation angle in degrees
df.minSvElevationDeg = 10; % Satellites below this angle are excluded

% Carrier-to-noise density ratio (C/N0) thresholds in dB-Hz
df.maxCNo_dBHz = Inf; % No upper limit for C/N0
df.minCNo_dBHz = 20;  % Exclude signals with C/N0 below 20 dB-Hz

% Pseudorange thresholds
df.maxPseudorangeM       = 1e7; % Maximum pseudorange in meters
df.maxPseudorangeRateMps = 1e3; % Maximum pseudorange rate in meters per second
end
