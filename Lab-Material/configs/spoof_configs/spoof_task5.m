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
% Piazza Vittorio Veneto, 10121 Torino TO, Italy
cfg.position = [45.06477853118284, 7.695457675370255, 225.04]; % Latitude, Longitude, Altitude
end

% https://maps.app.goo.gl/V2BUWx1ssyZUf8Hu8
% https://latlongdata.com/elevation/
