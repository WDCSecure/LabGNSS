function SaveFigures(figHandles, outDir, prefix)
%SAVEFIGURES Save an array of figure handles to PNG
%   This function saves all figures specified by their handles to PNG files.
%   Each figure is saved with a filename that includes the specified prefix.

% Create the output directory if it does not exist
if ~exist(outDir, 'dir')
    mkdir(outDir); % Create the directory
end

% Iterate through each figure handle
for k = 1:numel(figHandles)
    % Construct the filename for the figure
    fname = fullfile(outDir, sprintf('%s_fig%d.png', prefix, k));
    % Save the figure as a PNG file
    saveas(figHandles(k), fname);
end
end
