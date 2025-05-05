function SaveFigures(figHandles, outDir, prefix, format)
    %SAVEFIGURES Save an array of figure handles to specified formats
    %   This function saves all figures specified by their handles to PNG and/or MATLAB FIG files.
    %   Each figure is saved in a subdirectory based on the specified format ('png', 'fig', or 'both').
    
    % Validate the format input
    validFormats = {'png', 'fig', 'both'};
    if ~ismember(format, validFormats)
        error('Invalid format. Choose from "png", "fig", or "both".');
    end
    
    % Create subdirectories based on the format
    if strcmp(format, 'png') || strcmp(format, 'both')
        pngDir = fullfile(outDir, 'png');
        if ~exist(pngDir, 'dir')
            mkdir(pngDir);
        end
    end
    if strcmp(format, 'fig') || strcmp(format, 'both')
        figDir = fullfile(outDir, 'fig');
        if ~exist(figDir, 'dir')
            mkdir(figDir);
        end
    end
    
    % Iterate through each figure handle
    for k = 1:numel(figHandles)
        if strcmp(format, 'png') || strcmp(format, 'both')
            % Save as PNG
            pngName = fullfile(pngDir, sprintf('%s_fig%d.png', prefix, k)); % Append figN
            saveas(figHandles(k), pngName);
        end
        if strcmp(format, 'fig') || strcmp(format, 'both')
            % Save as MATLAB FIG
            figName = fullfile(figDir, sprintf('%s_fig%d.fig', prefix, k)); % Append figN
            saveas(figHandles(k), figName);
        end
    end
    end
    