# Lab GNSS Report

This directory contains the LaTeX source files for the Lab GNSS Report for the **Wireless and Device-to-Device Communication Security** course.

## Structure

The directory is organized as follows:

- `sections/`: contains separate LaTeX files for each section of the report.
- `appendix/`: contains supplementary material and additional information.
- `images/`: stores all images and diagrams included in the report.
- `bibliography/`: holds references and bibliography files.
- `template/`: holds the LaTeX template files.
- `main.tex`: the main LaTeX file that compiles the entire report.
- `compile.sh`: a script to compile the report or clean the build environment.

## Compilation Instructions

To compile the report or clean the output directory, you can use the provided `compile.sh` script.

### First Time Setup

Before using the `compile.sh` script for the first time, make sure it has the necessary execute permissions. Run the following command to grant execute permissions to the script:

```bash
chmod +x compile.sh
```

### Compile Options

The `compile.sh` script provides the following functionalities:

- **Compile the main report**:
  ```bash
  ./compile.sh
  ```
  This compiles the `main.tex`, generating the PDF for the report in the `out` directory.

- **Clean the output directory**:
  ```bash
  ./compile.sh clean
  ```
  This removes all files in the `out` directory and any previously generated PDFs in the project root, ensuring a fresh build environment.

For any issues, please refer to the main project repository or contact the authors.

### Notes

- Ensure all necessary dependencies, including LaTeX and bibliography tools, are installed on your system before running the script.
- The output files are saved in the `out` directory, with the report and appendix PDFs copied to the project root with custom names.
