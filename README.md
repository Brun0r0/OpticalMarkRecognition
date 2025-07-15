# Optical Mark Recognition (OMR) in MATLAB

This project implements an Optical Mark Recognition (OMR) system using MATLAB. It automatically detects and identifies filled answer bubbles on scanned multiple-choice exam sheets through image processing techniques.

## Features

- Automatic detection of answer areas
- Skew correction based on reference marks
- Binarization and segmentation
- Analysis of connected components
- Circularity-based recognition of marked answers

## Technologies Used

- MATLAB
- Image Processing Toolbox

## How It Works

1. **Image Input:** Loads scanned `.jpeg` images of answer sheets.
2. **Skew Correction:** Aligns the image using reference marks.
3. **Preprocessing:** Converts to grayscale and applies binarization (e.g., Otsu's method).
4. **Segmentation:** Identifies connected components.
5. **Recognition:** Extracts features like area and circularity to determine filled marks.

## Folder Structure

