# TUG-IMU Analysis

**Timed Up and Go (TUG) test signal-processing toolbox for MATLAB®**

> Rapid extraction of mobility metrics (sit-to-stand, gait cycles, step count, total time) from raw inertial measurements recorded at ≈100 Hz with a LifeSignal/Antelope smart‑shirt or any IMU exported in the same HDF5 layout.

---

## 📦 Repository overview

| File | Role |
|------|------|
| `life_importfile.m` | Low‑level HDF5 reader that loads accelerometer, gyroscope & magnetometer channels and returns them as double‑precision matrices together with a POSIX‑derived `datetime` vector. |
| `sorgente.m` | **Main analysis pipeline** – filters the signals, detects artefacts, segments the TUG phases *(sit ↔ stand, walking, turning)*, counts steps and produces publication‑ready plots. |
| `untitled.m` | Experimental scratchpad for algorithm prototyping – kept for reference. |
| `TUG test.h5` | Example dataset (≈100 Hz, 98 s) to let you try the pipeline out‑of‑the‑box. |


---

## Quick start

1. **Clone** the repo and open it in **MATLAB® R2022b or later** (earlier releases will probably work too).  
2. Install the *Signal Processing Toolbox* (only dependency).  
3. Run:

```matlab
>> sorgente              % analysis & plots
```

4. Inspect the figures, or adapt the code to export the metrics to CSV/JSON.

---

## How it works

1. **Import**  
   `life_importfile.m` reads the three‑axis accelerometer, gyroscope and magnetometer streams (`/ACCELEROMETER_3D/…/x/v`) together with their timestamps and converts them into SI units.

2. **Pre‑processing**  
   A moving‑average filter (window size adjustable in the script) smooths the raw data; gravity is removed from the accelerometer signal.

3. **Phase segmentation & events**  
   Threshold‑based logic on the x‑axis gyroscope identifies:  
   - Start of **sit‑to‑stand**  
   - End of **stand‑to‑sit**  
   Turning points are detected via envelope peaks.

4. **Step counting**  
   Peaks in the high‑pass filtered envelope of the accelerometer modulus yield the number of gait cycles.

5. **Output & visualisation**  
   The script produces stacked time‑series plots annotated with the detected events and prints a concise summary in the command window *(total TUG time, steps, cadence, stride time).*  


---

## Configuration

| Parameter | Location | Default | Meaning |
|-----------|----------|---------|---------|
| `k` | `life_importfile.m` | `4` | Std‑dev multiplier for the gyroscope event threshold. |
| `win` | `sorgente.m` | `15` samples | Moving‑average window length. |


---

## 📣 Citation

If you use this toolbox in academic work, please cite it as:

```bibtex
@misc{tug_imu_matlab_2025,
  author       = {simonc999},
  title        = {Timed Up and Go (TUG) IMU Analysis Toolbox},
  year         = {2025},
  howpublished = {\url{https://github.com/simonc999/TUG-IMU-Analysis}}
}
```

---

