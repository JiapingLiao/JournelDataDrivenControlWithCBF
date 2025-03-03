# Data-Driven Control Based on Control Barrier Functions with Recursive Feasibility Guarantee

This repository contains the simulation code for our article:  
**"Data-Driven Control Based on Control Barrier Functions with Recursive Feasibility Guarantee."**

## **Simulation Platform**
- MATLAB/Simulink 2024b  
- Required MATLAB Toolboxes:
  - Control System Toolbox
  - Optimization Toolbox
  - Parallel Computing Toolbox
  - Robust Control Toolbox
- Additional toolboxes:
  - Vehicle Dynamics Toolbox (optional)

## **Setup Instructions**
### **1. Install MATLAB/Simulink and Required Toolboxes**
- It is recommended to use **MATLAB/Simulink 2024b**.
- Ensure the following toolboxes are installed:
  - Control System Toolbox
  - Optimization Toolbox
  - Parallel Computing Toolbox
  - Robust Control Toolbox

### **2. Install Additional Toolboxes**
For proper functionality, install the following third-party toolboxes:

- **YALMIP** (for optimization modeling)  
  Download and install from: [YALMIP Official Site](https://yalmip.github.io/download/)  

- **MOSEK** (solver for optimization problems)  
  Download and install from: [MOSEK Official Site](https://www.mosek.com/downloads/)  

- **MPT3 (Multi-Parametric Toolbox 3)** (for set-based computations)  
  Download and install from: [MPT3 Official Site](https://www.mpt3.org/pmwiki.php/Main/Installation)  

---

## **Usage**
1. Open MATLAB and navigate to the repository folder.
2. Run the main simulation script:
   ```matlab
   run('main_simulation.mlx');
