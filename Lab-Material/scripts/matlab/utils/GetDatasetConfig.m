function [dirName, pr, out] = GetDatasetConfig(dataset, test, p)
    % GetDatasetConfig - Configures paths and filenames based on the dataset and test
    %
    % Inputs:
    %   dataset - Name of the dataset ('dataset_b', 'Samsung_A51', 'Xiaomi_11T_Pro')
    %   test    - Specific test name (ignored for 'dataset_b')
    %   p       - PathManager object containing project folder structure
    %
    % Outputs:
    %   dirName - Directory path for the dataset
    %   pr      - Pseudorange log file name
    %   out     - Output directory for results

    switch dataset
        case 'dataset_b'
            dirName = fullfile(p.demo, 'dataset_b');
            pr      = 'gnss_log_2025_05_03_10_35_20.txt';
            out     = fullfile(p.results, 'demo', 'dataset_b');

        case 'Samsung_A51'
            dirName = fullfile(p.data, 'Samsung_A51', 'gnss_logs', test);
            switch test
                case 'Piazza_Castello'
                    pr = 'gnss_log_2025_05_03_09_35_52.txt';
                case 'Tram_15_trip_Castello_to_Pescatore'
                    pr = 'gnss_log_2025_05_03_10_00_21.txt';
                case 'Monte_Cappuccini_ascent'
                    pr = 'gnss_log_2025_05_03_10_16_14.txt';
                case 'Monte_Cappuccini'
                    pr = 'gnss_log_2025_05_03_10_35_20.txt';
                case 'Parco_del_Valentino_1'
                    pr = 'gnss_log_2025_05_03_11_12_43.txt';
                case 'Parco_del_Valentino_2'
                    pr = 'gnss_log_2025_05_03_11_20_06.txt';
                case 'Aule_P'
                    pr = 'gnss_log_2025_05_07_12_56_15.txt';
                case 'Aule_P_interference'
                    pr = 'gnss_log_2025_05_08_12_56_13.txt';
                otherwise
                    error('Unknown test for Samsung_A51: %s', test);
            end
            out = fullfile(p.results, 'Samsung_A51', test);

        case 'Xiaomi_11T_Pro'
            dirName = fullfile(p.data, 'Xiaomi_11TPro', 'gnss_logs', test);
            switch test
                case 'Piazza_Castello'
                    pr = 'gnss_log_2025_05_03_09_48_01.txt';
                case 'Tram_15_trip_Castello_to_Pescatore'
                    pr = 'gnss_log_2025_05_03_10_00_21.txt';
                case 'Monte_Cappuccini'
                    pr = 'gnss_log_2025_05_03_10_22_37.txt';
                case 'Parco_del_Valentino_walk'
                    pr = 'gnss_log_2025_05_03_11_01_31.txt';
                case 'Parco_del_Valentino_1'
                    pr = 'gnss_log_2025_05_03_11_13_06.txt';
                case 'Parco_del_Valentino_phone_call'
                    pr = 'gnss_log_2025_05_03_11_20_06.txt';
                otherwise
                    error('Unknown test for Xiaomi_11T_Pro: %s', test);
            end
            out = fullfile(p.results, 'Xiaomi_11T_Pro', test);

        otherwise
            error('Unknown dataset: %s', dataset);
    end
end
