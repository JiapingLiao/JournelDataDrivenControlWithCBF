# JournelDataDrivenControlWithCBF

This repository contains the simulation code for our paper **"Data-Driven Control Based on Control Barrier Functions with Recursive Feasibility Guarantee"**.

## **Related Tools and Software**

### **Simulation Platform**
- MATLAB/Simulink **2024b** (recommended)
  
### **Required MATLAB Toolboxes**
The following MATLAB toolboxes are required to run the simulations:
- **Control System Toolbox**
- **Optimization Toolbox**
- **Parallel Computing Toolbox**
- **Robust Control Toolbox**
- **Automated Driving Toolbox**

### **Additional Required Toolboxes**
Please manually install the following toolboxes:
- **YALMIP**: [Download Here](https://yalmip.github.io/download/)
- **MOSEK**: [Download Here](https://www.mosek.com/downloads/)
- **MPT3**: [Installation Guide](https://www.mpt3.org/pmwiki.php/Main/Installation)

---

## **Setup Instructions**
Follow the steps below to set up the simulation environment:

1. Install **MATLAB/Simulink** (**2024b** recommended) along with the required toolboxes listed above.
2. Install the additional toolboxes (YALMIP, MOSEK, and MPT3) by following the provided links.
3. Download the current repository.
4. Navigate to the `ACC` folder and run `ACC_Run.mlx` (this file internally calls `ACC_Draw` to generate the plots).
5. Navigate to the `LK` folder and run `LK_Run.mlx` (this file internally calls `LK_Draw` to generate the plots).

---

## **Additional Information**
If you encounter any issues, please check the respective toolbox documentation or contact the authors for assistance.
