function cfg = spoof_default()
%SPOOF_DEFAULT Default: no spoofing
%   This function defines the default spoofing configuration, which
%   disables spoofing and sets all parameters to their default values.

% Disable spoofing
cfg.active    = 0;

% Set default spoofing parameters
cfg.delay     = 0;  % No delay
cfg.t_start   = 0;  % No spoofing start time
cfg.position  = []; % No spoofed position
end
