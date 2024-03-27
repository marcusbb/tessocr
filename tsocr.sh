#!/bin/bash

# Check if Tesseract OCR is installed
if ! command -v tesseract &> /dev/null; then
    echo "Error: Tesseract OCR is not installed. Please install Tesseract OCR before running this script."
    exit 1
fi


temp_dir=$(mktemp -d)
#echo $temp_dir
# Check if the clipboard contains an image and that pngpaste is also installed
if command -v pngpaste &> /dev/null; then
    pngpaste  $temp_dir/image.png
elif command -v xclip &> /dev/null; then
    xclip -selection clipboard -t image/png -o > "$temp_dir/image.png"
else
    echo "Error: Unable to detect clipboard functionality. Please install 'pngpaste'"
    exit 1
fi


# Perform OCR using Tesseract
tesseract "$temp_dir/image.png" "$temp_dir/result" &> /dev/null


# Read the result and store it in the clipboard
if command -v pbcopy &> /dev/null; then
    cat "$temp_dir/result.txt" | pbcopy
    echo "OCR result copied to clipboard."
elif command -v xclip &> /dev/null; then
    cat "$temp_dir/result.txt" | xclip -selection clipboard
    echo "OCR result copied to clipboard."
else
    echo "Error: Unable to copy result to clipboard. Please install 'pbcopy' or 'xclip'."
    exit 1
fi

# Cleanup: Remove temporary directory
rm -rf "$temp_dir"
