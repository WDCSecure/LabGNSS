# Lab-Material GNSS Processing Environment

This directory provides all the resources and a complete MATLAB environment needed to complete the GNSS lab assignment for the **Wireless and Device-to-Device Communication Security** course. It supports processing Android GNSS Logger measurements, including pseudoranges, C/N₀, weighted‑least‑squares PVT, ADR, and spoofing experiments. You can run demo datasets, your own Android logs, and spoofing tests, with all outputs automatically saved under `results/`.

## Dependencies

- **MATLAB R2020a** or later (no additional toolboxes required).  
- Internet access (optional) for NASA CCDIS ephemeris downloads.  
- **GNSSLogger App** on Android (to generate new logs).  
  
## Directory Structure

```
Lab-Material/
├── configs/                              # Experiment configuration files
│   └── spoof_configs/                    # .m scripts returning a spoof struct
├── data/
│   └── android_logs/                     # Place Android .txt logs here
├── results/                              # Auto‑created output figures and data
│   ├── demo/                             # Demo dataset outputs
│   ├── android/                          # Android log outputs
│   ├── spoof/                            # Spoofing test outputs
│   └── custom/                           # Custom experiments
├── scripts/
│   └── matlab/
│       ├── core/                         # Reusable functions & initialization
│       │   ├── InitProject.m
│       │   ├── PathManager.m
│       │   ├── SetDataFilter.m
│       │   ├── SaveFigures.m
│       │   └── utils/                    # Helpers (e.g. physconst.m)
│       └── tasks/                        # Top‑level experiment scripts
│           ├── RunDatasetAnalysis.m
│           ├── RunAndroidLogAnalysis.m
│           ├── RunDemo.m
│           └── SpoofingTest.m
├── tools/
│   └── opensource/
│       ├── library/                      # GNSS‑processing functions from NavSAS/Google
│       └── demoFiles/                    # Provided demo datasets
└── README.md                             # This file
```

## File Roles

### Core utilities (`scripts/matlab/core`)

| File                 | Purpose                                               |
|----------------------|-------------------------------------------------------|
| `PathManager.m`      | Defines all project folder paths                      |
| `InitProject.m`      | Adds paths, creates `results/`                        |
| `SetDataFilter.m`    | Returns default GNSS data‑filter settings             |
| `SaveFigures.m`      | Saves a list of figure handles to PNG files           |
| `utils/physconst.m`  | Replacement for toolbox `physconst('lightspeed')`     |

### Experiment tasks (`scripts/matlab/tasks`)

| Script                    | Function                                                              |
|---------------------------|-----------------------------------------------------------------------|
| `RunDatasetAnalysis.m`    | Process **all** subfolders of `tools/opensource/demoFiles/`           |
| `RunAndroidLogAnalysis.m` | Process all `.txt` in `data/android_logs/`                            |
| `RunDemo.m`               | Single demo run on `dataset_b` with optional spoofing & ADR           |
| `SpoofingTest.m`          | Iterate over all `configs/spoof_configs/*.m` and run spoof scenarios  |

### Configs (`configs/spoof_configs`)

Each `.m` file must return a struct with fields:

```
cfg.active    % 0 or 1
cfg.delay     % seconds
cfg.t_start   % seconds into measurement to start spoof
cfg.position  % [lat, lon, alt]
```

Add new spoof scenarios by dropping a `.m` function here.

### Tools (`tools/opensource/library` & `demoFiles`)

- **library/**: GNSS‑processing functions (ReadGnssLogger, ProcessGnssMeas, Plot…, etc.).
- **demoFiles/**: provided datasets (dataset_a, dataset_b, …) containing `.txt` logs, RINEX ephemeris, etc.

## Data Formats

- **Android logs**: GNSSLogger `.txt` pseudorange logs.  
  These logs contain raw GNSS measurements collected from Android devices.
- **Demo datasets**: similar `.txt` logs plus RINEX navigation files (`hourXXXX.xx*`).  
  RINEX files provide satellite ephemeris data required for precise positioning.
- **Directory per dataset**: each dataset folder must contain at least one `.txt` file.  
  Ensure that all required files are placed in the correct directory structure for processing.

## How to Run

### Use the original script

To use the original script, follow these steps:

1. Navigate to the folder containing the script:
   ```
   /LabGNSS/Lab-Material/scripts/matlab/original/
   ```

2. Open the script `ProcessGnssMeasScript_original.m` in MATLAB.

3. Update the following variables in the script to match the log you want to process:
   - `prFileName`: Set this to the name of your GNSS log file (e.g., `gnss_log_2023_03_17_16_54_04.txt`).
   - `dirName`: Set this to the directory containing your GNSS log file.

4. Run the script in MATLAB:
   ```
   >> ProcessGnssMeasScript_original
   ```

The script will process the specified log and generate outputs such as figures and data files. Ensure that the log file is correctly formatted and placed in the specified directory before running the script.

### Initialize environment

Navigate to the Lab-Material folder using one of the following methods:
1. Use the MATLAB command line:
```
>> cd /path/to/Lab-Material
```
2. Use the "Browse for folder" GUI option in MATLAB to select the Lab-Material directory.

Run the `InitProject` script to set up all necessary paths and initialize the environment:
```
>> InitProject
Project paths set. Results at .../Lab-Material/results
```

> [!NOTE]
> If running `InitProject` fails due to missing paths, manually add the required paths first to enable the script to execute.
> 
> <details closed>
> <summary><b>Troubleshooting</b></summary>
> 
> 1. Open MATLAB and navigate to the `scripts/matlab/core` directory.
> 2. Add the required paths manually using the `addpath` command:
>    ```
>    >> addpath(genpath('/path/to/Lab-Material/scripts/matlab'))
>    ```
> 3. Alternatively, you can use the MATLAB GUI:
>    - In the left panel, right-click on the `scripts/matlab` directory (or any subdirectory).
>    - Select **Add to Path** -> **Current Folder**.
> 4. Save the updated paths to ensure they persist across sessions:
>    ```
>    >> savepath
>    ```
> 5. Retry running the `InitProject` script:
>    ```
>    >> InitProject
>    ```
> If the issue persists, verify that all subdirectories under `scripts/matlab` are accessible and contain the necessary files.  
> Additionally, ensure that there are no typos in the directory paths.
> 
> </details>

### Process demo datasets

```
>> RunDatasetAnalysis
```

All demo subfolders under `tools/opensource/demoFiles/` with `.txt` logs will be processed.  
The outputs will be saved in `results/demo/<dataset>/`.  
Ensure that the demo datasets are correctly placed in the `demoFiles` directory before running this script.

### Process your Android logs

```
% Copy your GNSSLogger .txt files into data/android_logs/
>> RunAndroidLogAnalysis
```

This script processes all `.txt` files in the `data/android_logs/` directory.  
The outputs will be saved in `results/android/<logname>/`.  
Make sure the `.txt` files are properly formatted and contain valid GNSS measurements.

### Single‑run demo with spoof/ADR

```
>> RunDemo
```

This runs on `dataset_b` with the built‑in spoof & ADR settings. Modify `RunDemo.m` to change spoof or dataset.

### Spoofing parameter sweep

```
>> SpoofingTest
```

Executes every config in `configs/spoof_configs/` against the first Android log. Results under `results/spoof/<config>/`.

## Customizing

- **Add new dataset**: place folder with `.txt` logs under `tools/opensource/demoFiles/` or `data/android_logs/`.
- **Add new spoof config**: drop `myConfig.m` in `configs/spoof_configs` (function returns `cfg` struct).
- **Adjust filters**: edit `SetDataFilter.m` in `core/`.
- **Save additional outputs**: call `SaveFigures`, or extend `ProcessGnssMeasScript.m`.

## Course Tasks Mapping

| Task                                                                 | Script(s)                                                                         |
|----------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| 1. Download & extract opensource library                             | _manual_                                                                          |
| 2. Analyze raw & PVT on portal datasets; inspect plots; try filters  | `RunDatasetAnalysis.m`                                                            |
| 3. Collect Android logs; analyze; compare open‑sky vs obstructed     | `RunAndroidLogAnalysis.m`                                                         |
| 4. Estimate true position; spoof small offset; observe effects       | `RunDemo.m`, `configs/spoof_configs/spoof_small_offset.m`                         |
| 5. Try different spoof position; propose detection strategy          | Add new config in `configs/spoof_configs/` + `SpoofingTest.m`                     |
| 6. Add spoof delay; study impact                                     | `configs/spoof_configs/spoof_delay_test.m` + `SpoofingTest.m`                     |
| 7. (Optional) interference experiments                               | Create new task script under `tasks/`, e.g. `InterferenceTest.m`                  |
| 8. Prepare lab report (discuss Tasks 3,5,6,7)                        | _manual_                                                                          |

## Next Steps

- Extend `core/utils` for new helper functions.
- Add `CustomFilterTest.m` in `tasks/` to compare different SetDataFilter settings.
- Automate report generation by exporting figures and tables to a LaTeX-friendly folder.

---

Enjoy your GNSS processing workflow!
