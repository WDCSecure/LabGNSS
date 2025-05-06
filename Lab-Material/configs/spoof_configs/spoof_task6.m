function cfg = spoof_task6()
%SPOOF_TASK6 Add spoofing delay
%   This function defines a spoofing configuration with a delay.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active  = 1;

% Set spoofing parameters
cfg.delay   = 50;  % 50 milliseconds delay
cfg.t_start = 0;   % Start spoofing immediately

% Use the same spoofed position as Task 5
cfg.position = [45.059082994353986, 7.698906397795101, 256.77]; % Latitude, Longitude, Altitude
end
