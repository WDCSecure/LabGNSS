function cfg = spoof_task5()
%SPOOF_TASK5 Arbitrary remote spoof position
%   This function defines a spoofing configuration with an arbitrary
%   remote position.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active  = 1;

% Set spoofing parameters
cfg.delay   = 0;  % No delay
cfg.t_start = 0;  % Start spoofing immediately

% Define an arbitrary spoofed position (e.g., from Google Maps)
cfg.position = [45.059082994353986, 7.698906397795101, 256.77]; % Latitude, Longitude, Altitude
end

% https://maps.app.goo.gl/V2BUWx1ssyZUf8Hu8
% https://latlongdata.com/elevation/
