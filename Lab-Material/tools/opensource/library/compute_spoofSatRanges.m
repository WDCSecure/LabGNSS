function [spoof] = compute_spoofSatRanges(gnssMeas,gpsPvt,spoof)
% compute_spoofSatRanges - Computes spoofed satellite nominal ranges, i.e. 
%                          spoofed position minus satellite position range 
%                        - and and their differences from measured ranges.
%
% Syntax:
%   spoof = compute_spoofSatRanges(gnssMeas, gpsPvt, spoof)
%
% Inputs:
%   gnssMeas - Struct containing GNSS measurement data with fields:
%              - Svid: Vector of satellite IDs
%              - PrM : Matrix of measured pseudoranges [epochs x satellites]
%
%   gpsPvt   - Struct containing GNSS PVT solutions with fields:
%              - svPos: Cell array {1 x N}, each cell containing a matrix of satellite data
%                       for a given time epoch, with columns:
%                       [SVID, x, y, z, ..., pseudorange]
%
%   spoof    - Struct containing spoofing parameters, including:
%              - position: Spoofing position in LLA format [lat, lon, alt]
%
% Outputs:
%   spoof    - Updated struct with added fields:
%              - spSv_ranges          : Cell array of spoofed geometric ranges [1 x N]
%              - spSv_ranges_diff     : Difference between spoofed and measured ranges
%                                       (indexed by PVT satellite list)
%              - spSv_ranges_diff_zeros: Difference between spoofed and measured or PVT ranges
%                                        (indexed by gnssMeas.Svid)
%
% Description:
%   This function computes the geometric ranges between a spoofing position and GNSS 
%   satellites observed at each time step. It then compares these spoofed ranges with 
%   measured pseudoranges from gnssMeas and the pseudoranges measured. 
%   This is useful for subsequently cyberspoof the measured pseudoranges by
%   adding the difference between spoofed and measured ranges and therefore
%   obtaining spoofed pseudoranges
%

% Written by Andrea Nardin, PhD
% Dept. Of Electronics and Telecommunications,
% Politecnico di Torino, 2024
% -------------------------------------------------------------------------


% init
N = length(gpsPvt.svPos);
spSv_ranges = cell(1,N);
spSv_ranges_diff = cell(1,N);
spSv_ranges_diff_zeros = cell(1,N);
M = length(gnssMeas.Svid);


% convert spoof pos form LLA to ECEF
% spPos = lla2ecef(spoof.position); % needs aerospace toolbox
spPos = Lla2Xyz(spoof.position);

% extract SV pos and compute ranges for each time
for i = 1:N
    
    % avoid breaking if first set of svPos is empty
    if size(gpsPvt.svPos{i},1)==0 || size(gpsPvt.svPos{i},2)==0
        continue;
    end
    
    spSv_ranges_diff_zeros{i} = zeros(M,1);
    % extract SV pos 
    svPos = gpsPvt.svPos{i}(:,2:4);
    svPosId = gpsPvt.svPos{i}(:,1);
    pvtRanges = gpsPvt.svPos{i}(:,6);

    % compute ranges as geometrical norms
    spSv_ranges{i} = vecnorm((svPos - spPos)'); 

    for j=1:M
        k = find(svPosId==gnssMeas.Svid(j),1);
        if ~isempty(k)
            spSv_ranges_diff{i}(k) = spSv_ranges{i}(k)-gnssMeas.PrM(i,j); % consistent with gpsPvt sat indexing
            spSv_ranges_diff_zeros{i}(j) = spSv_ranges{i}(k)-gnssMeas.PrM(i,j); % consistent with gnssMeas sat indexing
            spSv_ranges_diff_zeros{i}(j) = spSv_ranges{i}(k)-pvtRanges(k);
        end
    end

end

spoof.spSv_ranges = spSv_ranges;
spoof.spSv_ranges_diff = spSv_ranges_diff;
spoof.spSv_ranges_diff_zeros = spSv_ranges_diff_zeros;
end