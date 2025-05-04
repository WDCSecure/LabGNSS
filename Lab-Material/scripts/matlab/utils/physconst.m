function v = physconst(name)
%PHYSCONST Minimal replacement for toolbox physconst
%   This function provides a minimal implementation of the physconst function
%   from MATLAB's Aerospace Toolbox. It returns the value of a specified
%   physical constant.

% Check the input name and return the corresponding constant
switch lower(name)
    case 'lightspeed' % Speed of light in vacuum (m/s)
        v = 299792458;
    otherwise
        % Throw an error if the constant is not recognized
        error('Unknown physical constant "%s".', name);
end
end
