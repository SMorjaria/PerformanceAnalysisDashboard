function Ride = calculateAeroRideHeightResponse( ...
    Vehicle, Setup, Operating, Constants, Suspension, AeroMap)
%CALCULATEAERORIDEHEIGHTRESPONSE
%
% Stage 5.2 - Aerodynamic Suspension Compression
%
% Calculates the first-order suspension compression caused by
% aerodynamic vertical loading and the resulting vehicle ride
% heights.
%
% This is a ONE-WAY calculation:
%
%   Baseline Ride Height
%       -> Aero State
%       -> Aero Load
%       -> Suspension Compression
%       -> Dynamic Ride Height
%
% The modified ride height is NOT fed back into the aerodynamic
% map at this stage. That feedback is introduced later.


%% ============================================================
%  1. BASELINE AERODYNAMIC STATE
%  ============================================================

AeroState = calculateAeroMap( ...
    Vehicle, ...
    Setup, ...
    AeroMap);


%% ============================================================
%  2. APPLY AERO MAP COEFFICIENTS
%  ============================================================

SetupAero = Setup;

SetupAero.CL = AeroState.CL;
SetupAero.CD = AeroState.CD;
SetupAero.aeroBalance = AeroState.frontBalance;


%% ============================================================
%  3. CALCULATE AERODYNAMIC FORCES
%  ============================================================

Aero = calculateAerodynamicForces( ...
    Vehicle, ...
    SetupAero, ...
    Operating, ...
    Constants);


%% ============================================================
%  4. DISTRIBUTE AERODYNAMIC LOAD
%  ============================================================

AeroLoad = calculateAeroLoadDistribution( ...
    Aero, ...
    SetupAero);


frontAeroLoad = ...
    AeroLoad.FL + AeroLoad.FR;

rearAeroLoad = ...
    AeroLoad.RL + AeroLoad.RR;


%% ============================================================
%  5. AXLE SUSPENSION COMPRESSION
%  ============================================================
%
% Aero loads are in N.
% Axle heave stiffness is in N/mm.
%
% Therefore displacement is returned directly in mm.
%

frontCompression = ...
    frontAeroLoad / ...
    Suspension.axleHeaveStiffnessFront;

rearCompression = ...
    rearAeroLoad / ...
    Suspension.axleHeaveStiffnessRear;


%% ============================================================
%  6. DYNAMIC RIDE HEIGHT
%  ============================================================

dynamicFrontRH = ...
    Setup.rideHeightFront - frontCompression;

dynamicRearRH = ...
    Setup.rideHeightRear - rearCompression;


%% ============================================================
%  7. PLATFORM PARAMETERS
%  ============================================================

rideHeightDelta = ...
    dynamicRearRH - dynamicFrontRH;


rakeAngle = atan( ...
    (rideHeightDelta / 1000) / ...
    Vehicle.wheelbase);

rakeAngleDeg = rad2deg(rakeAngle);


%% ============================================================
%  8. PLATFORM MOVEMENT
%  ============================================================

averageCompression = ...
    (frontCompression + rearCompression) / 2;

differentialCompression = ...
    rearCompression - frontCompression;


%% ============================================================
%  9. STORE RESULTS
%  ============================================================

Ride.speed = Operating.speed;
Ride.speedKPH = Operating.speed * 3.6;

Ride.AeroState = AeroState;
Ride.Aero = Aero;
Ride.AeroLoad = AeroLoad;

Ride.frontAeroLoad = frontAeroLoad;
Ride.rearAeroLoad = rearAeroLoad;

Ride.frontCompression = frontCompression;
Ride.rearCompression = rearCompression;

Ride.staticFrontRideHeight = ...
    Setup.rideHeightFront;

Ride.staticRearRideHeight = ...
    Setup.rideHeightRear;

Ride.dynamicFrontRideHeight = ...
    dynamicFrontRH;

Ride.dynamicRearRideHeight = ...
    dynamicRearRH;

Ride.staticRideHeightDelta = ...
    Setup.rideHeightRear - ...
    Setup.rideHeightFront;

Ride.dynamicRideHeightDelta = ...
    rideHeightDelta;

Ride.rakeAngle = rakeAngle;
Ride.rakeAngleDeg = rakeAngleDeg;

Ride.averageCompression = ...
    averageCompression;

Ride.differentialCompression = ...
    differentialCompression;


%% ============================================================
%  10. VALIDATION
%  ============================================================

Ride.frontLoadReconstruction = ...
    frontCompression * ...
    Suspension.axleHeaveStiffnessFront;

Ride.rearLoadReconstruction = ...
    rearCompression * ...
    Suspension.axleHeaveStiffnessRear;

Ride.frontLoadError = ...
    Ride.frontLoadReconstruction - ...
    frontAeroLoad;

Ride.rearLoadError = ...
    Ride.rearLoadReconstruction - ...
    rearAeroLoad;


end