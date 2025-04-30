function cfg = spoof_delay_test()
%SPOOF_DELAY_TEST Test spoofing delay only
%   This function defines a spoofing configuration to test the effect
%   of a delay in the spoofed signal.

% Start with the default spoofing configuration
cfg = spoof_default();

% Enable spoofing
cfg.active    = 1;

% Set spoofing parameters
cfg.delay     = 5e-3; % 5 milliseconds delay
cfg.t_start   = 0;    % Start spoofing immediately
cfg.position  = [45.06361, 7.679483, 347.48]; % No position offset
end
