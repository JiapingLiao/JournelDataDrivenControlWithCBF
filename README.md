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
3. Download `Journal_DataDrivenControlWithCBF.zip` and extract it to obtain the folders `LK` and `ACC`.
4. Navigate to the `LK` folder and make sure it is the working directory. Then run `LK_Run.mlx` (The plotting code is in a separate mlx file, and `LK_Run` will call it).
5. Navigate to the `ACC` folder and make sure it is the working directory. Then run `ACC_Run.mlx` (The plotting code is in a separate mlx file, and `ACC_Run` will call it).
   
   (Note: Both the `LK` and `ACC` folders contain a file named `File.mat`, which stores the simulation data from the paper. You can directly load these files and use the plotting files to generate plots.)

---
## **Features**
### **Simulation Results For Lane-Keeping Problem**

1. Lateral displacement and front wheel steering angle. The red dashed lines indicate the safe region for states and control constraints. The top and bottom comparisons illustrate scenarios with and without the control invariant set. The trajectories originate from the vertices of the control invariant set $\mathcal{X}$ and \(\mathcal{Z}\).
<p align="center">
<table>
    <tr>
        <td align="center" style="background-color: #f0f0f0;">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK3.jpg" width="400"><br>
            <b style="background-color: #f0f0f0;">Case 1: Lateral Displacement</b>
        </td>
        <td align="center" style="background-color: #f0f0f0;">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK5.jpg" width="400"><br>
            <b style="background-color: #f0f0f0;">Case 1: Steering Angle</b>
        </td>
    </tr>
    <tr>
        <td align="center" style="background-color: #f0f0f0;">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK4.jpg" width="400"><br>
            <b style="background-color: #f0f0f0;">Case 2: Lateral Displacement</b>
        </td>
        <td align="center" style="background-color: #f0f0f0;">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK6.jpg" width="400"><br>
            <b style="background-color: #f0f0f0;">Case 2: Steering Angle</b>
        </td>
    </tr>
</table>
</p>

2. State variations of other states, \( v, \psi, r \). The convex polyhedron with a black boundary represents the control invariant set \( \mathcal{X} \), projected in the 3-D space for the other three states at \( y = 0 \). The other lines show the trajectories starting from the vertices of the convex polyhedron. The top and bottom figures represent the simulation results with and without the control invariant set, respectively.

<table>
    <tr>
        <td align="center">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK1.jpg" width="500"><br>
            <b>With Control Invariant Set</b>
        </td>
        <td align="center">
            <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/LK/Figures/LK2.jpg" width="500"><br>
            <b>Without Control Invariant Set</b>
        </td>
    </tr>
</table>

### **Simulation Results For Adaptive Cruise Problem**

1.Iteration Process and Robust Control Invariant Set. The red regions represent the construction process of the control invariant set using Algorithm \ref{alg:Construct Recursive Feasible Set} (results of the 1st, 6th, ..., 46th iterations). The blue region is the robust control invariant set verified by Theorem \ref{theorem Verification robust control invariant set}, highlighting the relationship between the control invariant set and robust control invariant set and the guiding role of the former in constructing the latter.
<p align="center">
    <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/ACC/Figures/ACC1.jpg" width="600"><br>
    <b>Iteration Process and Robust Control Invariant Set.</b>
</p>

2.Velocity, Traction Force, and Safety Function Curves for Autonomous Vehicles. The red dashed lines indicate key constraints: cruising velocity (25 m/s) and leading vehicle velocity (varied) in the velocity plot, traction force limits in the traction plot, and margins (\(\varepsilon_0 = 5, 1, 0\)) in the safety plot. Blue (with) and black (without) lines compare cases with and without Constraints for Robust Recursive Feasibility (\textbf{CRRF}), while light color (gray or light blue, without robustness) and original color (with robustness) highlight robustness effects. Markers: * for \(\varepsilon_0 = 5\), \(\circ\) for \(\varepsilon_0 = 1\), and unmarked for \(\varepsilon_0 = 0\).
<p align="center">
    <img src="https://raw.githubusercontent.com/aicpslab/DDControlWithCBF/main/ACC/Figures/ACC2.jpg" width="900"><br>
    <b>Velocity, Traction Force, and Safety Function Curves for Autonomous Vehicles.</b>
</p>

---

## **Additional Information**
If you encounter any issues, please check the respective toolbox documentation or contact the authors for assistance.
