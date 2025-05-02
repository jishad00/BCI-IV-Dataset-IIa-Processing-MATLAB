# EEG Motor Imagery Classification (BCI Competition IV Dataset IIa)  
**MATLAB-based preprocessing pipeline for EEG data from motor imagery tasks.**  

## Description  
This project preprocesses EEG data from the [BCI Competition IV Dataset IIa](http://www.bnci-horizon-2020.eu/database/data-sets), focusing on:  
- **Bandpass filtering** (8–30 Hz) to isolate sensorimotor rhythms.  
- **Epoch extraction** by class labels (left/right hand, feet, tongue).  

## Technologies  
- **MATLAB** (Signal Processing Toolbox recommended)  
- **EEG Data**: BCI Competition IV Dataset IIa  

## Setup & Usage  
1. **Download the dataset**:  
   - Obtain `BCICIV_2a_mat.zip` from the [BNCI Horizon 2020 website](http://www.bnci-horizon-2020.eu/database/data-sets).  
2. **Run the script**:  
   - Place the dataset files (e.g., `A01T.mat`) and `class_extract.m` in the same directory.  
   - Execute in MATLAB:  
     ```matlab
     run('class_extract.m');
     ```  
3. **Output**:  
   - Filtered EEG signals and epochs separated by class (stored in MATLAB workspace variables). 
