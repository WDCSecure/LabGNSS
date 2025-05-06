function cfg = spoof_task4(trueLLA)
%SPOOF_TASK4 Small offset from true position
%   This function defines a spoofing configuration with a small offset
%   from the true position.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active  = 1;

% Set spoofing parameters
cfg.delay   = 0;  % No delay
cfg.t_start = 0;  % Start spoofing immediately

% Add a small offset to the true position
cfg.position = trueLLA + [1e-3, 1e-3, 1e-3];
end
