# BCI-IV-Dataset-IIa-Processing-MATLAB

MATLAB pipeline to preprocess BCI Competition IV — Dataset IIa and extract class-wise motor imagery epochs.

**Author:** Dr. Muhamed Jishad T K.

---

## What this repo contains

- `src/class_extract.m` — main MATLAB function that:
  - Loads subject `.mat` files `A0xT.mat` and `A0xE.mat`
  - Applies bandpass filtering to EEG data
  - Extracts task-related epochs for motor imagery classes (4 classes)
  - Returns `CLS` struct with per-class epoch cells and metadata

> The function preserves your original pipeline and parameters (band limits, epoch timing). It is Windows-friendly and uses `fullfile` for paths.

---

## Requirements

- MATLAB R2018b or later (function uses standard MATLAB syntax; an `arguments` block is used — recommended R2019b+).  
- Signal Processing Toolbox (for `designfilt`, `filtfilt`).  
- Place BCI dataset files (e.g. `A01T.mat`, `A01E.mat`) in `data/BCICIV_2a_mat/` (repo root).

---

## Windows Quickstart (recommended)

1. Clone the repo and open MATLAB.
2. Set current folder to repo root in MATLAB.
3. Add `src` to path if not automatically:
   ```matlab
   addpath(fullfile(pwd,'src'));
