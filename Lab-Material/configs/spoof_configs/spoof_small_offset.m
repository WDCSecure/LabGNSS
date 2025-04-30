function cfg = spoof_small_offset()
%SPOOF_SMALL_OFFSET Small lat/lon offset (~100 m)
%   This function defines a spoofing configuration with a small offset
%   in latitude and longitude, approximately 100 meters.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active  = 1;

% Set spoofing parameters
cfg.delay   = 0;  % No delay
cfg.t_start = 15; % Start spoofing at 15 seconds

% Add a small offset to the position (~0.001° ≈ 100 m)
cfg.position = [45.06361+0.001, 7.679483+0.001, 347.48];
end
