function Performance = evaluateVehiclePerformance( ...
    Vehicle, Setup, Operating, Tyre, Constants, AeroMap)
%EVALUATEVEHICLEPERFORMANCE
%
% Stage 6.1 - Integrated Vehicle Performance Calculation Engine
%
% PURPOSE
% -------
% Provides a single calculation interface connecting the validated
% vehicle-performance models developed during Stages 1-5.
%
% INPUTS
% ------
% Vehicle
% Setup
% Operating
% Tyre
% Constants
% AeroMap
%
% OUTPUT
% ------
% Performance
%
% The returned structure contains:
%
%   Performance.Input
%   Performance.Mechanical
%   Performance.Lateral
%   Performance.Aero
%   Performance.Platform
%   Performance.KPI
%   Performance.Status
%
% IMPORTANT
% ---------
% This function does not introduce new vehicle physics.
% It coordinates the previously validated calculation functions.


%% ============================================================
%  1. INPUT VALIDATION
%  ============================================================

validateVehicle(Vehicle);
validateSetup(Setup);


%% ============================================================
%  2. BASE VEHICLE PARAMETERS
%  ============================================================

Derived = ...
    calculateDerivedParameters( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants);


%% ============================================================
%  3. MECHANICAL LOAD TRANSFER
%  ============================================================

Longitudinal = ...
    calculateLongitudinalLoadTransfer( ...
    Vehicle, ...
    Operating, ...
    Derived);


LateralInitial = ...
    calculateLateralLoadTransfer( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Derived);


TyreLoadsMechanical = ...
    calculateCombinedTyreLoads( ...
    Vehicle, ...
    Operating, ...
    Derived, ...
    Longitudinal, ...
    LateralInitial);


TyrePerformanceMechanical = ...
    calculateTyrePerformance( ...
    TyreLoadsMechanical, ...
    Tyre);


%% ============================================================
%  4. MECHANICAL LATERAL RESPONSE
%  ============================================================
%
% Stage 3.5 coupled lateral model.
%
% This solves:
%
% steering
%   -> lateral acceleration
%   -> lateral load transfer
%   -> tyre vertical load
%   -> cornering stiffness
%   -> vehicle response
%

MechanicalCoupled = ...
    calculateCoupledLateralResponse( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants);


%% ============================================================
%  5. NOMINAL AERODYNAMIC STATE
%  ============================================================

AeroMapState = ...
    calculateAeroMap( ...
    Vehicle, ...
    Setup, ...
    AeroMap);


% Apply the aerodynamic-map state to a temporary setup.
%
% This ensures that aerodynamic force calculations use the
% ride-height-dependent CL, CD and aero balance.

SetupAero = Setup;

SetupAero.CL = ...
    AeroMapState.CL;

SetupAero.CD = ...
    AeroMapState.CD;

SetupAero.aeroBalance = ...
    AeroMapState.frontBalance;


AeroNominal = ...
    calculateAerodynamicForces( ...
    Vehicle, ...
    SetupAero, ...
    Operating, ...
    Constants);


AeroLoadNominal = ...
    calculateAeroLoadDistribution( ...
    AeroNominal, ...
    SetupAero);


%% ============================================================
%  6. AERO-COUPLED LATERAL RESPONSE
%  ============================================================
%
% Stage 4.5:
%
% aerodynamic platform
%   -> tyre vertical load
%   -> cornering stiffness
%   -> lateral response
%

AeroCoupled = ...
    calculateAeroCoupledLateralResponse( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);


%% ============================================================
%  7. SUSPENSION PARAMETERS
%  ============================================================
%
% Wheel rate convention:
%
%   k_wheel = k_spring * MR^2
%

wheelRateFront = ...
    Setup.springFront * ...
    Setup.motionRatioFront^2;

wheelRateRear = ...
    Setup.springRear * ...
    Setup.motionRatioRear^2;


axleHeaveStiffnessFront = ...
    2 * wheelRateFront;

axleHeaveStiffnessRear = ...
    2 * wheelRateRear;


Suspension.wheelRateFront = ...
    wheelRateFront;

Suspension.wheelRateRear = ...
    wheelRateRear;

Suspension.axleHeaveStiffnessFront = ...
    axleHeaveStiffnessFront;

Suspension.axleHeaveStiffnessRear = ...
    axleHeaveStiffnessRear;

Suspension.totalHeaveStiffness = ...
    axleHeaveStiffnessFront + ...
    axleHeaveStiffnessRear;


%% ============================================================
%  8. AERO-SUSPENSION PLATFORM EQUILIBRIUM
%  ============================================================
%
% Stage 5.5:
%
% ride height
%   -> aerodynamic state
%   -> aerodynamic load
%   -> suspension compression
%   -> ride height
%
% solved iteratively until equilibrium.
%

Platform = ...
    calculateAeroSuspensionEquilibrium( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants, ...
    Suspension, ...
    AeroMap);


%% ============================================================
%  9. AERO-MAP VALIDITY
%  ============================================================

insideAeroMap = ...
    Platform.frontRideHeight >= AeroMap.minFrontRH && ...
    Platform.frontRideHeight <= AeroMap.maxFrontRH && ...
    Platform.rearRideHeight >= AeroMap.minRearRH && ...
    Platform.rearRideHeight <= AeroMap.maxRearRH;


%% ============================================================
%  10. LOAD CONSERVATION
%  ============================================================

expectedVerticalLoad = ...
    Vehicle.mass * Constants.g + ...
    AeroCoupled.Aero.downforce;


actualVerticalLoad = ...
    AeroCoupled.TyreLoads.FL + ...
    AeroCoupled.TyreLoads.FR + ...
    AeroCoupled.TyreLoads.RL + ...
    AeroCoupled.TyreLoads.RR;


verticalLoadError = ...
    actualVerticalLoad - ...
    expectedVerticalLoad;


%% ============================================================
%  11. PERFORMANCE KPI STRUCTURE
%  ============================================================
%
% These are physical engineering quantities rather than an
% arbitrary weighted performance score.
%

KPI.speedKPH = ...
    Operating.speed * 3.6;


%% Lateral performance

KPI.lateralAcceleration = ...
    AeroCoupled.ay;

KPI.lateralAccelerationG = ...
    AeroCoupled.ay / Constants.g;

KPI.yawRate = ...
    AeroCoupled.Response.yawRate;

KPI.yawRateDeg = ...
    rad2deg(AeroCoupled.Response.yawRate);

KPI.cgSideslipDeg = ...
    rad2deg(AeroCoupled.Response.beta);

KPI.understeerGradient = ...
    AeroCoupled.Balance.Kus_deg_per_g;

KPI.balanceType = ...
    AeroCoupled.Balance.type;


%% Aerodynamic performance

KPI.CL = ...
    Platform.AeroState.CL;

KPI.CD = ...
    Platform.AeroState.CD;

KPI.aeroEfficiency = ...
    Platform.AeroState.CL / ...
    Platform.AeroState.CD;

KPI.downforce = ...
    Platform.Aero.downforce;

KPI.downforceToWeight = ...
    Platform.Aero.downforce / ...
    (Vehicle.mass * Constants.g);

KPI.aeroBalanceFront = ...
    Platform.AeroState.frontBalance;

KPI.aeroBalanceFrontPercent = ...
    100 * Platform.AeroState.frontBalance;


%% Platform performance

KPI.frontRideHeight = ...
    Platform.frontRideHeight;

KPI.rearRideHeight = ...
    Platform.rearRideHeight;

KPI.frontCompression = ...
    Platform.frontCompression;

KPI.rearCompression = ...
    Platform.rearCompression;

KPI.heave = ...
    Platform.heave;

KPI.rakeAngleDeg = ...
    Platform.rakeAngleDeg;


%% Suspension parameters

KPI.frontWheelRate = ...
    wheelRateFront;

KPI.rearWheelRate = ...
    wheelRateRear;

KPI.totalHeaveStiffness = ...
    Suspension.totalHeaveStiffness;


%% Tyre / cornering performance

KPI.frontCorneringStiffness = ...
    AeroCoupled.Cornering.CalphaFront;

KPI.rearCorneringStiffness = ...
    AeroCoupled.Cornering.CalphaRear;


%% ============================================================
%  12. STATUS FLAGS
%  ============================================================

Status.aeroMapValid = ...
    insideAeroMap;

Status.platformConverged = ...
    Platform.converged;

Status.lateralSolverConverged = ...
    AeroCoupled.converged;


loadTolerance = 1e-6;

Status.verticalLoadValid = ...
    abs(verticalLoadError) <= loadTolerance;


Status.allValid = ...
    Status.aeroMapValid && ...
    Status.platformConverged && ...
    Status.lateralSolverConverged && ...
    Status.verticalLoadValid;


%% ============================================================
%  13. STORE INPUTS
%  ============================================================

Performance.Input.Vehicle = ...
    Vehicle;

Performance.Input.Setup = ...
    Setup;

Performance.Input.Operating = ...
    Operating;


%% ============================================================
%  14. STORE MECHANICAL MODEL
%  ============================================================

Performance.Mechanical.Derived = ...
    Derived;

Performance.Mechanical.Longitudinal = ...
    Longitudinal;

Performance.Mechanical.LateralInitial = ...
    LateralInitial;

Performance.Mechanical.TyreLoads = ...
    TyreLoadsMechanical;

Performance.Mechanical.TyrePerformance = ...
    TyrePerformanceMechanical;

Performance.Mechanical.Coupled = ...
    MechanicalCoupled;


%% ============================================================
%  15. STORE AERODYNAMIC MODEL
%  ============================================================

Performance.Aero.MapState = ...
    AeroMapState;

Performance.Aero.Nominal = ...
    AeroNominal;

Performance.Aero.NominalLoad = ...
    AeroLoadNominal;

Performance.Aero.Coupled = ...
    AeroCoupled;


%% ============================================================
%  16. STORE SUSPENSION / PLATFORM MODEL
%  ============================================================

Performance.Suspension = ...
    Suspension;

Performance.Platform = ...
    Platform;


%% ============================================================
%  17. STORE KPI / STATUS
%  ============================================================

Performance.KPI = ...
    KPI;

Performance.Status = ...
    Status;


%% ============================================================
%  18. STORE VALIDATION INFORMATION
%  ============================================================

Performance.Validation.expectedVerticalLoad = ...
    expectedVerticalLoad;

Performance.Validation.actualVerticalLoad = ...
    actualVerticalLoad;

Performance.Validation.verticalLoadError = ...
    verticalLoadError;


end