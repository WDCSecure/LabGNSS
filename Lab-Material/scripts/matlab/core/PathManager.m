function paths = PathManager()
%PATHMANAGER Define project folder structure
%   This function defines and returns the folder structure for the project.
%   It dynamically determines the root directory and constructs paths for
%   various subdirectories used in the project.

% Get the directory of the current script
scriptDir = fileparts(mfilename('fullpath'));

% Determine the project root directory (three levels up)
projRoot  = fileparts(fileparts(fileparts(scriptDir)));

% Define paths for various subdirectories
paths.core      = fullfile(projRoot,'scripts','matlab','core'); % Core scripts
paths.tasks     = fullfile(projRoot,'scripts','matlab','tasks'); % Task scripts
paths.lib       = fullfile(projRoot,'tools','opensource','library'); % External libraries
paths.demo      = fullfile(projRoot,'tools','opensource','demoFiles'); % Demo datasets
paths.android   = fullfile(projRoot,'data','android_logs'); % Android log files
paths.results   = fullfile(projRoot,'results'); % Results directory
paths.spoofConf = fullfile(projRoot,'configs','spoof_configs'); % Spoofing configurations
paths.utils     = fullfile(paths.core,'utils'); % Utility scripts
end
