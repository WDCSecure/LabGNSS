# Lab-Material GNSS Processing Environment

This directory contains all the resources needed to complete the GNSS lab assignment for the **Wireless and Device-to-Device Communication Security** course.

This directory contains a complete MATLAB environment for processing Android GNSS Logger measurements: computing pseudoranges, C/N₀, weighted‑least‑squares PVT, ADR, and spoofing experiments. You can run demo datasets, your own Android logs, and spoofing tests, with all outputs automatically saved under `results/`.

## Dependencies

- **MATLAB R2020a** or later (no additional toolboxes required).
- Internet access (optional) for NASA CCDIS ephemeris downloads.
- GNSSLogger App on Android (to generate new logs).

## Directory Structure

```
Lab-Material/
├── configs/                  # Experiment configuration files
│   └── spoof_configs/        # .m scripts returning a spoof struct
├── data/
│   └── android_logs/         # Place Android .txt logs here
├── results/                  # Auto‑created output figures and data
│   ├── demo/                 # Demo dataset outputs
│   ├── android/              # Android log outputs
│   ├── spoof/                # Spoofing test outputs
│   └── custom/               # Custom experiments
├── scripts/
│   └── matlab/
│       ├── core/             # Reusable functions & initialization
│       │   ├── InitProject.m
│       │   ├── PathManager.m
│       │   ├── SetDataFilter.m
│       │   ├── SaveFigures.m
│       │   └── utils/        # Helpers (e.g. physconst.m)
│       └── tasks/            # Top‑level experiment scripts
│           ├── RunDatasetAnalysis.m
│           ├── RunAndroidLogAnalysis.m
│           ├── RunDemo.m
│           └── SpoofingTest.m
├── tools/
│   └── opensource/
│       ├── library/          # GNSS‑processing functions from NavSAS/Google
│       └── demoFiles/        # Provided demo datasets
└── README.md                 # This file
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
- **Demo datasets**: similar `.txt` logs plus RINEX navigation files (`hourXXXX.xx*`).
- **Directory per dataset**: each dataset folder must contain at least one `.txt` file.

## How to Run

### Initialize environment

```
>> cd /path/to/Lab-Material
>> InitProject
Project paths set. Results at .../Lab-Material/results
```

### Process demo datasets

```
>> RunDatasetAnalysis
```

All demo subfolders under `tools/opensource/demoFiles/` with `.txt` logs will be processed; outputs in `results/demo/<dataset>/`.

### Process your Android logs

```
% Copy your GNSSLogger .txt files into data/android_logs/
>> RunAndroidLogAnalysis
```

Outputs go to `results/android/<logname>/`.

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

--

Enjoy your GNSS processing workflow!
