function cfg = spoof_task6()
%SPOOF_TASK6 Add spoofing delay
%   This function defines a spoofing configuration with a delay.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active  = 1;

% Set spoofing parameters
cfg.delay   = 1e-3;  % Delay of 1 ms
cfg.t_start = 50;    % Start spoofing after 50 seconds

% Use the same spoofed position as Task 5
% Piazza Vittorio Veneto, 10121 Torino TO, Italy
cfg.position = [45.06477853118284, 7.695457675370255, 225.04]; % Latitude, Longitude, Altitude
end
