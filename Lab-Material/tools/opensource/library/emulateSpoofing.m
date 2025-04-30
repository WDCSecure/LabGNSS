function tRxSeconds = emulateSpoofing(gnssRaw,spoof,tRxSeconds)
% emulateSpoofing - Modifies GNSS reception times to simulate spoofing effects.
%
% Syntax:
%   tRxSeconds = emulateSpoofing(gnssRaw, spoof, tRxSeconds)
%
% Inputs:
%   gnssRaw     - Struct containing raw GNSS measurement data with fields:
%                 - allRxMillis: Reception times [ms]
%                 - Svid       : Satellite vehicle IDs
%                 - ReceivedSvTimeUncertaintyNanos: Measurement noise in [ns]
%
%   spoof       - Struct containing spoofing parameters, with fields:
%                 - spSv_ranges_diff_zeros: Cell array of spoofed pseudorange
%                   differences [1 x N], one vector per epoch, indexed by SVID
%                 - delay      : Common time delay introduced by the spoofing system
%                 - t_start    : Start time [s] after which spoofing should be applied
%
%   tRxSeconds  - Vector of original reception times [s] to be modified
%
% Output:
%   tRxSeconds  - Modified reception times [s], spoofed by adding per-satellite
%                 range biases and noise, emulating spoofing effects
%
% Description:
%   This function emulates GNSS spoofing by adjusting the receiver time tags for
%   each satellite measurement. The spoofed reception time includes:
%     - A satellite-dependent delay derived from the pseudorange difference
%       between the spoofing location and the true receiver.
%     - A common spoofing delay applied to all satellites.
%     - A random Gaussian noise term with the same variance as the original 
%       GNSS measurement uncertainty.
%
%   The spoofing is applied only **after** a specified spoof start time (`spoof.t_start`).
%   The pseudorange differences (`spSv_ranges_diff_zeros`) are assumed to be consistent with a stationary spoofer.
%
% Notes:
%   - This function assumes to get difference of spoofed satellite 
%     geometrical ranges (i.e. spoofed position minus satellite position range) 
%     with measured ranges (spoof.spSv_ranges_diff_zeros) from a prior call to `compute_spoofSatRanges`.
%   - A constant spoofing delay alone would be absorbed into receiver clock bias;
%     satellite-dependent differences are necessary to affect position estimation.
%
% It adds to the RX time a pseudorange difference due to the different 
% positions of user and meaconer.
% The result is a bias which is DIFFERENT for each satellite and CONSTANT 
% over time. Adding only a common bias would be estimated into the clock 
% %bias without changing the position estimation (aside from some 
% %relatively small crosscoupling contribution due to the linearization.)

% Written by Andrea Nardin, PhD
% Dept. Of Electronics and Telecommunications,
% Politecnico di Torino, 2024
% -------------------------------------------------------------------------


% init
allRxMilliseconds = double(gnssRaw.allRxMillis);
gnssMeas.FctSeconds = (unique(allRxMilliseconds))*1e-3;
gnssMeas.Svid       = unique(gnssRaw.Svid)'; %all the sv ids found in gnssRaw
N = length(gnssMeas.FctSeconds);
M = length(gnssMeas.Svid);
PrSigmaM    = double(gnssRaw.ReceivedSvTimeUncertaintyNanos)*1e-9*GpsConstants.LIGHTSPEED;

timeSeconds = gnssMeas.FctSeconds-gnssMeas.FctSeconds(1);%elapsed time in seconds
N_spoof = N - sum(timeSeconds >= spoof.t_start); % gives the vector index after which you should start spoofing
 

% Apply spoofing only after a certain time and to all the satellite
for i=1:N %i is index into gnssMeas.FctSeconds and matrix rows
    Pr_diff_spUser = spoof.spSv_ranges_diff_zeros{i}/physconst('lightspeed'); % pseudorange difference due to the different positions of user and meaconer.
    %get index of measurements within 1ms of this time tag
    J = find(abs(gnssMeas.FctSeconds(i)*1e3 - allRxMilliseconds)<1); 
    for j=1:length(J) %J(j) is index into gnssRaw.*
        k = find(gnssMeas.Svid==gnssRaw.Svid(J(j)));
        %k is the index into gnssMeas.Svid and matrix columns
        if i > N_spoof
            % Modify Rxtime to emulate spoofing, adding:
            % - sat dependednt PR difference with respect to PR measured by a spoofer at a given location
            % - common delay introduced by the spoofer (will be estimated as user clk bias)
            % - random noise with same variance of the user PR noise (meas error has been otherwise removed by PR difference estimation method) 
            tRxSeconds(J(j)) = tRxSeconds(J(j)) + Pr_diff_spUser(k) +...
                spoof.delay + PrSigmaM(J(j))*randn/physconst('lightspeed');
        end
    end
end