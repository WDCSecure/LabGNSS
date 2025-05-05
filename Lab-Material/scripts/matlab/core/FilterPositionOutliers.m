function gpsPvtFiltered = FilterPositionOutliers(gpsPvt, maxSpeed)
    %FILTERPOSITIONOUTLIERS  Remove fixes whose implied speed jump is too large
    %   gpsPvtFiltered = FilterPositionOutliers(gpsPvt, maxSpeed)
    %   - gpsPvt.FctSeconds       Nx1 time vector (s)
    %   - gpsPvt.allLlaDegDegM    Nx3 [lat lon alt]
    %   - maxSpeed (optional)     threshold in m/s (default 30)
    
        if nargin<2, maxSpeed = 30; end
    
        % pull out latitude, longitude, time
        lat = gpsPvt.allLlaDegDegM(:,1);
        lon = gpsPvt.allLlaDegDegM(:,2);
        t   = gpsPvt.FctSeconds;    
    
        N = numel(lat);
        dist = zeros(N,1);
        dt   = [NaN; diff(t)];
    
        R = 6371000;  % Earth radius (m)
    
        for k = 2:N
            dlat = deg2rad(lat(k) - lat(k-1));
            dlon = deg2rad(lon(k) - lon(k-1));
            phi1 = deg2rad(lat(k-1));
            phi2 = deg2rad(lat(k));
            a = sin(dlat/2)^2 + cos(phi1)*cos(phi2)*sin(dlon/2)^2;
            dist(k) = 2 * R * atan2( sqrt(a), sqrt(1 - a) );
        end
    
        speed = dist ./ dt;
    
        keep = speed < maxSpeed;
        keep(1) = true;
    
        % copy only the “kept” rows for every field that has N rows
        gpsPvtFiltered = gpsPvt;
        fn = fieldnames(gpsPvt);
        for i=1:numel(fn)
            v = gpsPvt.(fn{i});
            if size(v,1)==N
                gpsPvtFiltered.(fn{i}) = v(keep,:);
            end
        end
    end
    