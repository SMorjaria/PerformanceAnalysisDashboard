# Vehicle Performance — Setup & Sensitivity Analysis

A MATLAB-based vehicle performance tool developed to investigate how mechanical setup changes influence the behaviour of a high-performance single-seater.

The project combines simplified vehicle dynamics, tyre, aerodynamic and suspension models into a single analysis framework. Rather than assessing each subsystem independently, the tool follows how a setup change propagates through the vehicle — from tyre loading and lateral balance to aerodynamic platform behaviour and vertical dynamics.

The final model is integrated into an interactive MATLAB dashboard for setup comparison, sensitivity studies and engineering interpretation.

---

## Project Objectives

The project was developed around one central engineering question:

> **How do mechanical setup changes propagate through the vehicle to influence overall performance?**

The model was therefore structured to connect:

**Vehicle Setup → Tyre Loading → Lateral Dynamics → Aerodynamics → Suspension Platform → Performance**

This allows setup changes to be evaluated against multiple vehicle-level performance indicators rather than a single isolated metric.

---

## Model Architecture

The tool is divided into a series of interconnected models and studies:

### 1. Vehicle & Setup Definition

Defines the baseline vehicle architecture and configurable setup parameters, including:

- Vehicle mass and geometry
- Centre of gravity position
- Front and rear spring rates
- Anti-roll bar stiffness
- Motion ratios
- Ride heights
- Camber and toe
- Aerodynamic coefficients and balance
- Vehicle operating conditions

---

### 2. Tyres & Load Transfer

Longitudinal and lateral load-transfer models are used to calculate the vertical load acting at each tyre.

A load-sensitive tyre model then determines how changes in vertical load influence:

- Available friction
- Cornering stiffness
- Front/rear lateral characteristics

This provides the link between vehicle state and the lateral dynamics model.

---

### 3. Lateral Dynamics & Vehicle Balance

A steady-state single-track vehicle model evaluates:

- Lateral acceleration
- Yaw rate
- Vehicle sideslip
- Front and rear slip angles
- Understeer gradient
- Vehicle balance

Speed-sensitivity studies are used to investigate how the lateral response evolves across the operating range.

---

### 4. Aerodynamic Platform

Aerodynamic performance is modelled as a function of vehicle speed and ride height.

Increasing speed increases aerodynamic load, which compresses the suspension and changes the vehicle platform. Because aerodynamic performance is itself dependent on ride height, an iterative equilibrium is used to couple the two systems:

**Speed → Downforce → Suspension Compression → Ride Height → Aero Map → Equilibrium**

The resulting model calculates quantities including:

- Front and rear dynamic ride height
- Suspension compression
- Rake
- Downforce
- Drag
- Lift coefficient
- Aerodynamic efficiency
- Aerodynamic balance

---

### 5. Suspension & Vertical Dynamics

The suspension model evaluates both aerodynamic platform control and the mechanical consequences of changing spring stiffness.

A simplified vertical dynamics model is used to investigate:

- Suspension travel
- Sprung-mass displacement
- Sprung-mass acceleration
- Dynamic tyre-load variation
- Body natural frequency
- Wheel-hop frequency

A bump-response study demonstrates an important setup trade-off: increasing spring stiffness improves platform control but can increase body acceleration and tyre-load variation.

---

### 6. Setup Sensitivity

Two levels of setup sensitivity analysis are implemented.

#### One-Dimensional Sensitivity

Individual setup parameters can be swept while the remaining setup is held constant.

This allows the influence of a single parameter to be assessed against vehicle KPIs and aerodynamic-platform constraints.

#### Two-Dimensional Design Space

Front and rear spring rates are varied simultaneously to create a setup trade-off map.

This makes it possible to identify regions of the tested design space that satisfy the defined aerodynamic-platform constraints while comparing their resulting performance.

> The highest-performing valid point within the tested grid is treated only as the maximum valid result evaluated — not as a globally optimised vehicle setup.

---

## Integrated Performance Dashboard

The individual models are combined into an interactive MATLAB dashboard.

The dashboard allows the user to modify:

- Front spring rate
- Rear spring rate
- Front ARB stiffness
- Rear ARB stiffness
- Front ride height
- Rear ride height
- Vehicle speed
- Steering angle

The complete vehicle model is then recalculated and reports performance, platform and validity information.

Key outputs include:

- Downforce
- Aerodynamic efficiency
- Aerodynamic balance
- Lateral acceleration
- Understeer gradient
- Vehicle balance classification
- Front and rear dynamic ride height
- Suspension compression
- Rake
- Aero-map margins
- Model validity checks

---

## Example Engineering Trade-Off

One of the integrated studies investigates the vehicle at **180 km/h**.

The baseline spring configuration of:

- Front: **150 N/mm**
- Rear: **130 N/mm**

results in a rear ride height of approximately **27.75 mm**, placing the vehicle outside the defined 30 mm minimum rear aero-map ride height.

Increasing spring stiffness to:

- Front: **172.5 N/mm**
- Rear: **149.5 N/mm**

reduces aerodynamic compression and increases rear ride height to approximately **30.39 mm**, bringing the platform back inside the defined aerodynamic-map range.

The revised configuration also increases calculated downforce from approximately **7582 N to 7686 N**, while the predicted lateral balance remains effectively unchanged.

However, vertical-dynamics analysis shows the associated mechanical penalty: increased stiffness reduces suspension travel while increasing body acceleration and dynamic tyre-load variation.

This demonstrates the central purpose of the tool — evaluating a setup change against the behaviour of the **complete vehicle**, rather than judging it from a single performance metric.

---

## Repository Structure

```text
Vehicle_Performance_Tool/
│
├── Functions/
│   └── Supporting calculations and plotting functions
│
├── GUI/
│   └── Interactive vehicle performance dashboard
│
├── Models/
│   └── Vehicle dynamics, aerodynamic and suspension models
│
├── Studies/
│   └── Sensitivity and trade-off studies
│
├── Vehicle/
│   └── Vehicle and setup definitions
│
└── Main.m
    └── Main project execution script
