#!/bin/sh

# Define output directory
OUTPUT_DIR="out"
PDF_FILE='main.pdf'
SECTIONS_DIR="sections"

# Set custom PDF name
CUSTOM_PDF_NAME="GNSSReport_WDCSecure.pdf"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Function to remove PDF files in the root directory
remove_root_pdf() {
    [ -f "$CUSTOM_PDF_NAME" ] && rm -f "$CUSTOM_PDF_NAME"
    printf "\n${GREEN}Removed ${CUSTOM_PDF_NAME} from root directory.${RESET}\n"
}

# Function to clean the output directory
clean_output() {
    if [ -d "$OUTPUT_DIR" ]; then
        rm -rf "$OUTPUT_DIR"/*
        printf "\n${GREEN}Output directory cleaned.${RESET}\n"
    else
        printf "\n${YELLOW}Output directory does not exist, nothing to clean.${RESET}\n"
    fi
    remove_root_pdf
}

# Function to compile a LaTeX file
compile_latex() {
    local TEX_FILE=$1
    local CUSTOM_NAME=$2
    local OUTPUT_PDF=$3
    local COMPILE_BIB=$4
    
    # Ensure the output directory exists
    if [ ! -d "$OUTPUT_DIR" ]; then
        mkdir -p "$OUTPUT_DIR"
        printf "\n${GREEN}Created output directory: $OUTPUT_DIR.${RESET}\n"
    fi

    printf "\n${CYAN}Compiling $TEX_FILE ...${RESET}\n"
    pdflatex -output-directory="$OUTPUT_DIR" "$TEX_FILE"

    if [ "$COMPILE_BIB" = true ]; then
        bibtex "$OUTPUT_DIR/$(basename "$TEX_FILE" .tex)"
        pdflatex -output-directory="$OUTPUT_DIR" "$TEX_FILE"
        pdflatex -output-directory="$OUTPUT_DIR" "$TEX_FILE"
    fi

    pdflatex -output-directory="$OUTPUT_DIR" "$TEX_FILE"

    if [ -f "$OUTPUT_DIR/$OUTPUT_PDF" ]; then
        [ "$CUSTOM_NAME" != "" ] && cp "$OUTPUT_DIR/$OUTPUT_PDF" "./$CUSTOM_NAME"
        printf "\n${GREEN}File $OUTPUT_PDF compiled and copied as $CUSTOM_NAME.${RESET}\n"
    else
        printf "\n${RED}Compilation failed for $TEX_FILE.${RESET}\n"
    fi
}

# Main script logic
case "$1" in
    clean)
        clean_output
        ;;
    main)
        compile_latex "main.tex" "$CUSTOM_PDF_NAME" "$PDF_FILE" false
        ;;
    *)
        compile_latex "main.tex" "$CUSTOM_PDF_NAME" "$PDF_FILE" true
        ;;
esac
