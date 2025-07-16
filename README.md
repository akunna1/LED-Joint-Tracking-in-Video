# 🔴🟢🔵 LED-Joint-Tracking-in-Video

## About

This MATLAB project processes a video of moving joints with LED markers to **track and visualize joint movement**. It uses color thresholding to isolate red, green, and blue LEDs, calculates their **centroids**, and overlays their motion on output videos.

## Features

* Custom RGB thresholding for LED detection
* Frame-by-frame centroid tracking
* Cropping to region of interest
* Overlayed visualization of LED motion
* Two output videos:

  * Centroid tracking animation
  * Joined motion of all LEDs

## 🛠 Built With

* MATLAB
* Image Processing Toolbox
* Custom centroid function
* RGB color filtering logic

## Workflow

1. Load and crop video frames
2. Detect LEDs using RGB thresholds
3. Calculate centroids per color
4. Plot centroid paths and save to video
5. Render joined-joint movement in a second video

## 📁 Topics

`data-science` · `matlab` · `video-processing` · `image-analysis` · `centroid-tracking`
