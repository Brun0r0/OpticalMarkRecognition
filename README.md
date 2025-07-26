# 📝 Optical Mark Recognition (OMR) in MATLAB

This project implements an **Optical Mark Recognition (OMR)** system using MATLAB.  
It automatically detects and identifies filled answer bubbles 🟤 on scanned multiple-choice exam sheets using image processing techniques.

## 🚀 Features

- 🔍 Automatic detection of answer areas  
- 📐 Skew correction using reference marks  
- 🎛️ Grayscale conversion, binarization & segmentation  
- 🧩 Analysis of connected components  
- 🔵 Circularity-based recognition of marked answers

## 🛠️ Technologies Used

- 🧠 MATLAB  
- 🧰 Image Processing Toolbox

## ⚙️ How It Works

1. 📂 **Image Input:** Loads scanned images of the provided template.
2. 📏 **Skew Correction:** Aligns the image using reference marks.
3. 🖤 **Preprocessing:** Converts to grayscale and applies binarization (e.g., Otsu’s method).  
4. 🧱 **Segmentation:** Identifies connected components.
5. 🧠 **Recognition:** Detects filled bubbles based on area and circularity.

## 💬 Process Overview

<div align="center">
  
### Input Image → Rotation → Cropping → Speech Bubbles Detection

<table>
  <tr>
    <td align="center">
      <img src="imgs/input.png" width="150" height="230" alt="Original input image">
      <br>
      <b>📥 Input</b>
      <br>
      <sub>Original image</sub>
    </td>
    <td align="center">
      <img src="imgs/rotated.png" width="150" height="230" alt="Rotated image">
      <br>
      <b>🔄 Rotated</b>
      <br>
      <sub>Auto-corrected orientation</sub>
    </td>
    <td align="center">
      <img src="imgs/cutted.png" width="150" height="230" alt="Cropped image">
      <br>
      <b>✂️ Cropped</b>
      <br>
      <sub>Relevant area extracted</sub>
    </td>
    <td align="center">
      <img src="imgs/bubbles.png" width="150" height="230" alt="Speech bubbles detected">
      <br>
      <b>💭 Detected</b>
      <br>
      <sub>Speech bubbles identified</sub>
    </td>
  </tr>
</table>

</div>

## ▶️ How to Run

1. 📥 Open MATLAB.  
2. 📁 Clone this repository and navigate to the project folder.  
3. 🏃‍♂️ Run `main.m` to start the OMR process.

## 📄 License

This project is for **educational purposes only**. 🎓
