# Digital Control System for ANT-X 2DoF Quadrotor UAV

**Institution:** Politecnico di Milano  
**Course:** Digital Control Technology for Aeronautics (DCTA)  
**Professor:** Fredy Ruiz   
**Academic Year:** 2025/2026  

---

## Overview
Developed a robust digital control system and performed dynamic model identification for the ANT-X 2DoF quadrotor. Implemented calibrated 1DoF attitude models, advanced time-domain ID, and discrete PID/cascade controllers. Validated via real-time HIL tests using MATLAB, ROS, PX4 and QGroundControl.

---

## Main Topics

### Lab 1: System Identification (1DOF Modeling)
- Time-domain identification of pitch axis dynamics
- Free response analysis (impulse) for natural frequency (ω_n) and damping ratio (ξ)
- Forced response analysis (doublet) for input gain (μ) estimation
- Pure delay (τ) identification from actuator/sensor dynamics
- Model verification and validation with RMSE analysis

### Lab 2: Angular Rate Control
- PID controller design via loop-shaping (continuous-time)
- Backward Euler discretization (T_s = 4 ms)
- Digital implementation with ZOH effects
- Target specifications: ω_c = 15-30 rad/s, φ_m ≥ 45°
- Doublet reference tracking experiments

### Lab 3: Cascade Attitude Control
- Proportional controller design for attitude loop
- Frequency separation approach (ω_c^inner > 5·ω_c^outer)
- Target bandwidth: ω_c = 3-6 rad/s
- Step reference tracking validation
- Performance KPI analysis (rise time, settling time, overshoot)

### Lab 4: Position Control
- PI controller design for velocity loop (ω_c ≈ 3.5 rad/s)
- P controller design for position loop (ω_c ≈ 0.7 rad/s)
- Force-to-attitude reference conversion
- Complete cascade architecture implementation
- Real-time experiments on ANT-X platform

---

## Requirements

- MATLAB 
- Control System Toolbox
- Signal Processing Toolbox
- (Optional) ROS Toolbox for hardware experiments

---

## Hardware Platform

- **Platform:** ANT-X 2DoF Drone (rail-constrained)
- **Software Stack:** MATLAB/Simulink, ROS, PX4 flight stack, QGroundControl 
- **Laboratory:** Aerospace Systems & Control Lab, DAER Department

---

## References

- Course material: *"Digital Control Technology for Aeronautics"*, Prof. Fredy Ruiz, Politecnico di Milano
- ANT-X Platform Documentation: https://www.antx.it/
- Laboratory manual: DCTA Lab Sessions 2025/2026

---

## License

Educational purposes – Politecnico di Milano (2025/2026)

