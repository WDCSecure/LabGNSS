# Lab GNSS Report for the WD2DCS Course

![Polito Logo](resources/logo_polito.jpg)

This repository contains all the materials, scripts, and documentation for the GNSS lab experiment conducted as part of the **Wireless and Device-to-Device Communication Security** course.

## Overview

The GNSS lab focuses on processing raw GNSS measurements collected from Android devices using MATLAB. The lab includes tasks such as pseudorange analysis, weighted least squares (WLS) positioning, spoofing experiments, and ADR (Accumulated Delta Range) analysis. The repository is structured to support both demo datasets and custom Android logs.

## Repository Structure

```
LabGNSS/
├── Lab-Material/                        # MATLAB scripts, datasets, and configurations
├── Report/                              # LaTeX source files for the lab report
├── resources/                           # Additional resources (e.g., links, PDFs, images)
└── README.md                            # This file
```

> [!NOTE]
> The detailed lab report, including all experimental results and analysis, can be found [here](Report/LabGNSS.pdf).

## Lab Objectives & Requirements

The lab aims to:
1. Process raw GNSS measurements from Android devices.
2. Analyze pseudoranges, C/N₀, and WLS positioning.
3. Conduct spoofing experiments and evaluate detection strategies.
4. Generate a detailed lab report documenting the results and analysis.

### Requirements

- **MATLAB R2020a** or later (no additional toolboxes required).
- Internet access for downloading NASA CCDIS ephemeris files (optional).
- GNSSLogger App on Android for collecting raw GNSS measurements.

## Experiment Procedure

1. **Initialize the MATLAB environment**:
   - Run the `InitProject.m` script to set up paths and create the results directory.
2. **Process datasets**:
   - Use `RunDatasetAnalysis.m` to process all tests for Samsung A51 and Xiaomi 11T Pro datasets.
3. **Run a demo**:
   - Use `RunDemo.m` to process a single dataset with optional spoofing and ADR analysis.
4. **Perform spoofing tests**:
   - Use `SpoofingTest.m` to iterate over all spoofing configurations and analyze the results.
5. **Generate the lab report**:
   - Compile the LaTeX source files in the `Report/` directory to produce the final report.

For detailed instructions, refer to the `README.md` files in the subdirectories:
- [**Lab-Material/README.md**](Lab-Material/README.md)
- [**Report/README.md**](Report/README.md)

## Authors

| Name              | GitHub                                                                                                               | LinkedIn                                                                                                                                  | Email                                                                                                            |
| ----------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Andrea Botticella | [![GitHub](https://img.shields.io/badge/GitHub-Profile-informational?logo=github)](https://github.com/Botti01)       | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/andrea-botticella-353169293/) | [![Email](https://img.shields.io/badge/Email-Send-blue?logo=gmail)](mailto:andrea.botticella@studenti.polito.it) |
| Elia Innocenti    | [![GitHub](https://img.shields.io/badge/GitHub-Profile-informational?logo=github)](https://github.com/eliainnocenti) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/eliainnocenti/)               | [![Email](https://img.shields.io/badge/Email-Send-blue?logo=gmail)](mailto:elia.innocenti@studenti.polito.it)    |
| Renato Mignone    | [![GitHub](https://img.shields.io/badge/GitHub-Profile-informational?logo=github)](https://github.com/RenatoMignone) | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/renato-mignone/)              | [![Email](https://img.shields.io/badge/Email-Send-blue?logo=gmail)](mailto:renato.mignone@studenti.polito.it)    |
| Simone Romano     | [![GitHub](https://img.shields.io/badge/GitHub-Profile-informational?logo=github)](https://github.com/sroman0)       | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin)](https://www.linkedin.com/in/simone-romano-383277307/)     | [![Email](https://img.shields.io/badge/Email-Send-blue?logo=gmail)](mailto:simone.romano@studenti.polito.it)     |
