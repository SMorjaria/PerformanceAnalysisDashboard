%% ============================================================
%  VEHICLE PERFORMANCE SETUP & SENSITIVITY TOOL
%
%  Stage 1 - Vehicle & Setup Architecture
%  Stage 2 - Tyre Load Transfer & Performance
%  Stage 3 - Lateral Dynamics & Vehicle Balance
%  ============================================================

clear;
clc;
close all;


%% ============================================================
%  PROJECT INITIALISATION
%  ============================================================

ProjectRoot = fileparts(mfilename('fullpath'));

addpath(fullfile(ProjectRoot,'Functions'));
addpath(fullfile(ProjectRoot,'Models'));
addpath(fullfile(ProjectRoot,'Studies'));
addpath(fullfile(ProjectRoot,'Vehicle'));
addpath(fullfile(ProjectRoot,'GUI'));
rehash;


%% ============================================================
%  1. CREATE CONSTANTS
%  ============================================================

Constants = createConstants();


%% ============================================================
%  2. SELECT VEHICLE / SETUP INPUTS
%  ============================================================

[Vehicle, Setup] = selectInputMode();


%% ============================================================
%  3. SELECT OPERATING CONDITIONS
%  ============================================================

Operating = selectOperatingConditions(Constants);


%% ============================================================
%  4. CREATE TYRE MODEL
%  ============================================================

Tyre = createTyre();


%% ============================================================
%  5. VALIDATE INPUTS
%  ============================================================

validateVehicle(Vehicle);
validateSetup(Setup);


%% ============================================================
%  6. CALCULATE DERIVED VEHICLE PARAMETERS
%  ============================================================

Derived = calculateDerivedParameters( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants);


%% ============================================================
%  STAGE 2.2 - LONGITUDINAL LOAD TRANSFER
%  ============================================================

LoadTransfer = calculateLongitudinalLoadTransfer( ...
    Vehicle, ...
    Operating, ...
    Derived);


%% ============================================================
%  STAGE 2.3 - LATERAL LOAD TRANSFER
%  ============================================================

Lateral = calculateLateralLoadTransfer( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Derived);


%% ============================================================
%  STAGE 2.4 - COMBINED FOUR-CORNER TYRE LOADS
%  ============================================================

TyreLoads = calculateCombinedTyreLoads( ...
    Vehicle, ...
    Operating, ...
    Derived, ...
    LoadTransfer, ...
    Lateral);


%% ============================================================
%  DISPLAY VEHICLE SUMMARY
%  ============================================================

displayVehicleSummary( ...
    Vehicle, ...
    Setup, ...
    Derived);


%% ============================================================
%  VEHICLE VISUALISATION
%  ============================================================

plotVehicleOverview( ...
    Vehicle, ...
    Setup, ...
    Derived);


%% ============================================================
%  DISPLAY LONGITUDINAL LOAD TRANSFER
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('     LONGITUDINAL LOAD TRANSFER\n');
fprintf('============================================\n');

fprintf('Longitudinal Acceleration : %+.2f g\n', ...
    Operating.ax / Constants.g);

fprintf('Load Transfer             : %+.1f N\n', ...
    LoadTransfer.longitudinal);

fprintf('\n');

fprintf('Front Axle Load           : %.1f N\n', ...
    LoadTransfer.frontAxle);

fprintf('Rear Axle Load            : %.1f N\n', ...
    LoadTransfer.rearAxle);

fprintf('\n');

fprintf('FL Tyre Load              : %.1f N\n', ...
    LoadTransfer.FL);

fprintf('FR Tyre Load              : %.1f N\n', ...
    LoadTransfer.FR);

fprintf('RL Tyre Load              : %.1f N\n', ...
    LoadTransfer.RL);

fprintf('RR Tyre Load              : %.1f N\n', ...
    LoadTransfer.RR);

fprintf('\n');

fprintf('Total Vertical Load       : %.1f N\n', ...
    LoadTransfer.total);

fprintf('Load Conservation Error   : %.6f N\n', ...
    LoadTransfer.loadError);


%% ============================================================
%  DISPLAY LATERAL LOAD TRANSFER
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('        LATERAL LOAD TRANSFER\n');
fprintf('============================================\n');

fprintf('Lateral Acceleration       : %+.2f g\n', ...
    Operating.ay / Constants.g);

fprintf('\n');

fprintf('Front Roll Distribution    : %.1f %%\n', ...
    Lateral.frontRollStiffnessDistribution * 100);

fprintf('Rear Roll Distribution     : %.1f %%\n', ...
    Lateral.rearRollStiffnessDistribution * 100);

fprintf('\n');

fprintf('Total Lateral Transfer     : %+.1f N\n', ...
    Lateral.totalLoadTransfer);

fprintf('Front Transfer             : %+.1f N\n', ...
    Lateral.frontLoadTransfer);

fprintf('Rear Transfer              : %+.1f N\n', ...
    Lateral.rearLoadTransfer);

fprintf('\n');

fprintf('FL Tyre Load               : %.1f N\n', ...
    Lateral.FL);

fprintf('FR Tyre Load               : %.1f N\n', ...
    Lateral.FR);

fprintf('RL Tyre Load               : %.1f N\n', ...
    Lateral.RL);

fprintf('RR Tyre Load               : %.1f N\n', ...
    Lateral.RR);

fprintf('\n');

fprintf('Total Vertical Load        : %.1f N\n', ...
    Lateral.total);

fprintf('Load Conservation Error    : %.6f N\n', ...
    Lateral.loadError);


%% ============================================================
%  DISPLAY COMBINED TYRE LOADS
%  ============================================================

displayTyreLoads( ...
    TyreLoads, ...
    Operating, ...
    Constants);


%% ============================================================
%  STAGE 2.5 - TYRE PERFORMANCE
%  ============================================================

TyrePerformance = calculateTyrePerformance( ...
    TyreLoads, ...
    Tyre);


%% ============================================================
%  DISPLAY TYRE PERFORMANCE
%  ============================================================

displayTyrePerformance( ...
    TyreLoads, ...
    TyrePerformance);


%% ============================================================
%  STAGE 2.6 - FRONT ARB SENSITIVITY STUDY
%  ============================================================

ARBSensitivity = frontARBSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Tyre, ...
    Constants);


%% ============================================================
%  STAGE 3.1 - BICYCLE MODEL ARCHITECTURE
%  ============================================================

Bicycle = createBicycleModel( ...
    Vehicle, ...
    Operating);

displayBicycleModel(Bicycle);


%% ============================================================
%  STAGE 3.2 - CORNERING STIFFNESS
%  ============================================================

Cornering = calculateCorneringStiffness( ...
    TyreLoads, ...
    Tyre);

displayCorneringStiffness( ...
    TyreLoads, ...
    Cornering);


%% ============================================================
%  STAGE 3.3 - STEADY-STATE LATERAL RESPONSE
%  ============================================================

Response = calculateSteadyStateLateralResponse( ...
    Bicycle, ...
    Cornering);

displayLateralResponse( ...
    Response, ...
    Bicycle);


%% ============================================================
%  STAGE 3.4 - VEHICLE BALANCE
%  ============================================================

Balance = calculateVehicleBalance( ...
    Bicycle, ...
    Cornering, ...
    Response, ...
    Constants);

displayVehicleBalance( ...
    Balance, ...
    Bicycle, ...
    Response);


%% ============================================================
%  STAGE 3.5 - COUPLED LATERAL RESPONSE
%  ============================================================

Coupled = calculateCoupledLateralResponse( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants);

displayCoupledLateralResponse(Coupled);


%% ============================================================
%  STAGE 3.5 - CONVERGENCE VISUALISATION
%  ============================================================

plotCoupledConvergence(Coupled);

%% ============================================================
%  STAGE 3.6A - SPEED SENSITIVITY
%  ============================================================

SpeedStudy = speedSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants);


%% ============================================================
%  STAGE 3.6B - FRONT ARB / BALANCE SENSITIVITY
%  ============================================================

ARBBalanceStudy = frontARBBalanceSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants);

%% ============================================================
%  STAGE 4.1 - BASELINE AERODYNAMIC FORCE MODEL
%  ============================================================

Aero = calculateAerodynamicForces( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants);

displayAerodynamicForces(Aero);

%% ============================================================
%  STAGE 4.2 - AERODYNAMIC LOAD DISTRIBUTION
%  ============================================================

AeroLoad = calculateAeroLoadDistribution( ...
    Aero, ...
    Setup);

displayAeroLoadDistribution(AeroLoad);

%% ============================================================
%  STAGE 4.3 - RIDE-HEIGHT / RAKE AERO MAP
%  ============================================================

AeroMap = createAeroMap();

AeroState = calculateAeroMap( ...
    Vehicle, ...
    Setup, ...
    AeroMap);

displayAeroMapState(AeroState);

%% ============================================================
%  STAGE 4.3 - AERO PLATFORM MAP STUDY
%  ============================================================

AeroPlatformStudy = aeroPlatformMapStudy( ...
    Vehicle, ...
    Setup, ...
    AeroMap);


%% ============================================================
%  STAGE 4.4 - AERO PLATFORM SENSITIVITY
%  ============================================================

PlatformSensitivity = aeroPlatformSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    AeroMap, ...
    Constants);



%% ============================================================
%  STAGE 4.5 - AERO-COUPLED VEHICLE BALANCE
%  ============================================================

AeroCoupled = calculateAeroCoupledLateralResponse( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);

displayAeroCoupledResponse(AeroCoupled);


%% ============================================================
%  STAGE 4.6 - AERODYNAMIC PERFORMANCE SENSITIVITY
%  ============================================================

AeroSensitivity = aeroVehiclePerformanceSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);

%% ============================================================
%  STAGE 5.1 - SUSPENSION VERTICAL STIFFNESS
%  ============================================================

Suspension = calculateSuspensionStiffness( ...
    Vehicle, ...
    Setup);

displaySuspensionStiffness(Suspension);


%% ============================================================
%  STAGE 5.2 - AERODYNAMIC RIDE-HEIGHT RESPONSE
%  ============================================================

Ride = calculateAeroRideHeightResponse( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants, ...
    Suspension, ...
    AeroMap);

displayAeroRideHeightResponse(Ride);

%% ============================================================
%  STAGE 5.3 - HEAVE & PITCH PLATFORM RESPONSE
%  ============================================================

Platform = calculatePlatformResponse( ...
    Vehicle, ...
    Setup, ...
    Ride);

displayPlatformResponse(Platform);

%% ============================================================
%  STAGE 5.4 - QUASI-STATIC ROLL RESPONSE
%  ============================================================

Roll = calculateRollResponse( ...
    Vehicle, ...
    Setup, ...
    Suspension, ...
    Coupled.ay);

displayRollResponse(Roll);

%% ============================================================
%  STAGE 5.5 - COUPLED AERO-SUSPENSION EQUILIBRIUM
%  ============================================================

AeroSuspension = calculateAeroSuspensionEquilibrium( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants, ...
    Suspension, ...
    AeroMap);

displayAeroSuspensionEquilibrium(AeroSuspension);

plotAeroSuspensionEquilibrium(AeroSuspension);


%% ============================================================
%  STAGE 5.6A - SPEED / PLATFORM SENSITIVITY
%  ============================================================

PlatformSpeedStudy = aeroSuspensionSpeedSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants, ...
    Suspension, ...
    AeroMap);


%% ============================================================
%  STAGE 5.6B - SPRING STIFFNESS / PLATFORM SENSITIVITY
%  ============================================================

SpringPlatformStudy = springPlatformSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Constants, ...
    AeroMap);

%% ============================================================
%  STAGE 5.7A - QUARTER-CAR VERTICAL DYNAMICS
%  ============================================================

Vertical = createVerticalDynamicsModel( ...
    Vehicle, ...
    Setup, ...
    Suspension);

displayVerticalDynamicsModel(Vertical);

%% ============================================================
%  STAGE 5.7B - VERTICAL FREQUENCY RESPONSE
%  ============================================================

VerticalFrequency = ...
    calculateVerticalFrequencyResponse(Vertical);

displayVerticalFrequencyResponse(VerticalFrequency);

plotVerticalFrequencyResponse(VerticalFrequency);
%% ============================================================
%  STAGE 5.7C - VERTICAL DYNAMICS SETUP TRADE-OFF
%  ============================================================

VerticalTradeoff = ...
    verticalSetupTradeoffStudy( ...
    Vehicle, ...
    Setup, ...
    Suspension);

displayVerticalSetupTradeoff(VerticalTradeoff);

plotVerticalSetupTradeoff(VerticalTradeoff);

%% ============================================================
%  STAGE 5.7D - TIME-DOMAIN ROAD EXCITATION
%  ============================================================

VerticalTimeStudy = ...
    verticalTimeDomainStudy( ...
    VerticalTradeoff);

displayVerticalTimeDomainStudy( ...
    VerticalTimeStudy);

plotVerticalTimeDomainStudy( ...
    VerticalTimeStudy);

%% ============================================================
%  STAGE 5.7E - FFT / SPECTRAL ANALYSIS
%  ============================================================

VerticalFFTStudy = ...
    verticalFFTStudy( ...
    VerticalTimeStudy, ...
    VerticalTradeoff);

displayVerticalFFTStudy( ...
    VerticalFFTStudy);

plotVerticalFFTStudy( ...
    VerticalFFTStudy);

%% ============================================================
%  STAGE 6.1 - INTEGRATED PERFORMANCE CALCULATION ENGINE
%  ============================================================

Performance = ...
    evaluateVehiclePerformance( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);


displayIntegratedPerformance( ...
    Performance);


%% ============================================================
%  STAGE 6.2 - BASELINE vs PROPOSED SETUP
%  ============================================================

BaselineSetup = Setup;


%% ------------------------------------------------------------
%  PROPOSED SETUP
%  ------------------------------------------------------------
%
% Validation case:
%
% 1.15x front and rear spring stiffness.
%
% This is the configuration identified during Stage 5.6B as
% the minimum tested stiffness satisfying the aero-platform
% constraint at 180 km/h.
%
% All other setup parameters remain unchanged.
%

ProposedSetup = Setup;

ProposedSetup.springFront = ...
    Setup.springFront * 1.15;

ProposedSetup.springRear = ...
    Setup.springRear * 1.15;


%% ------------------------------------------------------------
%  RUN COMPARISON
%  ------------------------------------------------------------

SetupComparison = ...
    compareVehicleSetups( ...
    Vehicle, ...
    BaselineSetup, ...
    ProposedSetup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);


displaySetupComparison( ...
    SetupComparison);


plotSetupComparison( ...
    SetupComparison);

%% ============================================================
%  STAGE 6.3 - AUTOMATED SETUP SENSITIVITY
%  ============================================================

SensitivityOperating = Operating;

SensitivityOperating.speed = ...
    180 / 3.6;


%% ------------------------------------------------------------
% FRONT SPRING SENSITIVITY
% ------------------------------------------------------------

parameterName = ...
    'springFront';

parameterValues = ...
    90:5:240;


SetupSensitivity = ...
    setupSensitivityStudy( ...
    Vehicle, ...
    Setup, ...
    SensitivityOperating, ...
    Tyre, ...
    Constants, ...
    AeroMap, ...
    parameterName, ...
    parameterValues);


displaySetupSensitivity( ...
    SetupSensitivity);


plotSetupSensitivity( ...
    SetupSensitivity);

%% ============================================================
%  STAGE 6.4 - FRONT / REAR SPRING TRADE-OFF MAP
%  ============================================================

TradeoffOperating = ...
    Operating;

TradeoffOperating.speed = ...
    180 / 3.6;


frontSpringValues = ...
    100:5:220;

rearSpringValues = ...
    90:5:200;


SpringTradeoff = ...
    springTradeoffMap( ...
    Vehicle, ...
    Setup, ...
    TradeoffOperating, ...
    Tyre, ...
    Constants, ...
    AeroMap, ...
    frontSpringValues, ...
    rearSpringValues);


displaySpringTradeoffMap( ...
    SpringTradeoff);


plotSpringTradeoffMap( ...
    SpringTradeoff);

%% ============================================================
% STAGE 6.5 - INTERACTIVE VEHICLE PERFORMANCE DASHBOARD
% ============================================================

VehiclePerfromanceDashboard( ...
    Vehicle, ...
    Setup, ...
    Operating, ...
    Tyre, ...
    Constants, ...
    AeroMap);
