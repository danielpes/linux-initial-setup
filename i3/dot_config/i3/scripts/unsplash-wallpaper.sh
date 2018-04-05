#!/bin/bash
wget "https://source.unsplash.com/featured/3840x2160/daily/?grayscale" -O ~/Pictures/wallpaper.img
nitrogen --set-scaled ~/Pictures/wallpaper.img
