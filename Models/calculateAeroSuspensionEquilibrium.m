function Equilibrium = calculateAeroSuspensionEquilibrium( ...
    Vehicle, Setup, Operating, Constants, Suspension, AeroMap)
%CALCULATEAEROSUSPENSIONEQUILIBRIUM
%
% Stage 5.5 - Coupled Aero-Suspension Platform Equilibrium
%
% Iteratively solves the coupled relationship:
%
%   Ride Height
%       -> Aero Map
%       -> Aerodynamic Load
%       -> Suspension Compression
%       -> Ride Height
%
% until the front and rear platform positions converge.
%
% IMPORTANT:
% Setup ride heights are treated as the zero-aero reference
% condition. Vehicle static weight is therefore not applied
% again when calculating suspension compression.


%% ============================================================
%  1. SOLVER SETTINGS
%  ============================================================

maxIterations = 100;

tolerance = 1e-5;          % [mm]

relaxationFactor = 0.50;


%% ============================================================
%  2. INITIAL PLATFORM
%  ============================================================

frontRH = Setup.rideHeightFront;
rearRH  = Setup.rideHeightRear;


%% ============================================================
%  3. HISTORY ARRAYS
%  ============================================================

frontRHHistory = nan(maxIterations,1);
rearRHHistory  = nan(maxIterations,1);

frontCompressionHistory = nan(maxIterations,1);
rearCompressionHistory  = nan(maxIterations,1);

downforceHistory = nan(maxIterations,1);
CLHistory = nan(maxIterations,1);
CDHistory = nan(maxIterations,1);
balanceHistory = nan(maxIterations,1);

errorHistory = nan(maxIterations,1);


converged = false;


%% ============================================================
%  4. ITERATIVE EQUILIBRIUM SOLVER
%  ============================================================

for iteration = 1:maxIterations

    %% --------------------------------------------------------
    % 4.1 Current platform
    % ---------------------------------------------------------

    SetupIteration = Setup;

    SetupIteration.rideHeightFront = frontRH;
    SetupIteration.rideHeightRear  = rearRH;


    %% --------------------------------------------------------
    % 4.2 Aerodynamic map
    % ---------------------------------------------------------

    AeroState = calculateAeroMap( ...
        Vehicle, ...
        SetupIteration, ...
        AeroMap);


    %% --------------------------------------------------------
    % 4.3 Apply aerodynamic coefficients
    % ---------------------------------------------------------

    SetupAero = SetupIteration;

    SetupAero.CL = AeroState.CL;
    SetupAero.CD = AeroState.CD;
    SetupAero.aeroBalance = ...
        AeroState.frontBalance;


    %% --------------------------------------------------------
    % 4.4 Aerodynamic forces
    % ---------------------------------------------------------

    Aero = calculateAerodynamicForces( ...
        Vehicle, ...
        SetupAero, ...
        Operating, ...
        Constants);


    AeroLoad = calculateAeroLoadDistribution( ...
        Aero, ...
        SetupAero);


    frontAeroLoad = ...
        AeroLoad.FL + AeroLoad.FR;

    rearAeroLoad = ...
        AeroLoad.RL + AeroLoad.RR;


    %% --------------------------------------------------------
    % 4.5 Suspension compression
    % ---------------------------------------------------------

    frontCompression = ...
        frontAeroLoad / ...
        Suspension.axleHeaveStiffnessFront;

    rearCompression = ...
        rearAeroLoad / ...
        Suspension.axleHeaveStiffnessRear;


    %% --------------------------------------------------------
    % 4.6 Target equilibrium ride heights
    % ---------------------------------------------------------

    targetFrontRH = ...
        Setup.rideHeightFront - ...
        frontCompression;

    targetRearRH = ...
        Setup.rideHeightRear - ...
        rearCompression;


    %% --------------------------------------------------------
    % 4.7 Convergence error
    % ---------------------------------------------------------

    frontError = targetFrontRH - frontRH;
    rearError  = targetRearRH - rearRH;

    equilibriumError = max( ...
        abs([frontError, rearError]));


    %% --------------------------------------------------------
    % 4.8 Store iteration history
    % ---------------------------------------------------------

    frontRHHistory(iteration) = frontRH;
    rearRHHistory(iteration) = rearRH;

    frontCompressionHistory(iteration) = ...
        frontCompression;

    rearCompressionHistory(iteration) = ...
        rearCompression;

    downforceHistory(iteration) = ...
        Aero.downforce;

    CLHistory(iteration) = ...
        AeroState.CL;

    CDHistory(iteration) = ...
        AeroState.CD;

    balanceHistory(iteration) = ...
        AeroState.frontBalance;

    errorHistory(iteration) = ...
        equilibriumError;


    %% --------------------------------------------------------
    % 4.9 Check convergence
    % ---------------------------------------------------------

    if equilibriumError < tolerance

        frontRH = targetFrontRH;
        rearRH = targetRearRH;

        converged = true;

        break

    end


    %% --------------------------------------------------------
    % 4.10 Relaxed update
    % ---------------------------------------------------------

    frontRH = ...
        frontRH + ...
        relaxationFactor * frontError;

    rearRH = ...
        rearRH + ...
        relaxationFactor * rearError;

end


%% ============================================================
%  5. FINAL CONSISTENT STATE
%  ============================================================
%
% Recalculate all quantities using the final converged
% platform so that the stored output is internally consistent.
%

SetupFinal = Setup;

SetupFinal.rideHeightFront = frontRH;
SetupFinal.rideHeightRear  = rearRH;


AeroStateFinal = calculateAeroMap( ...
    Vehicle, ...
    SetupFinal, ...
    AeroMap);


SetupAeroFinal = SetupFinal;

SetupAeroFinal.CL = ...
    AeroStateFinal.CL;

SetupAeroFinal.CD = ...
    AeroStateFinal.CD;

SetupAeroFinal.aeroBalance = ...
    AeroStateFinal.frontBalance;


AeroFinal = calculateAerodynamicForces( ...
    Vehicle, ...
    SetupAeroFinal, ...
    Operating, ...
    Constants);


AeroLoadFinal = calculateAeroLoadDistribution( ...
    AeroFinal, ...
    SetupAeroFinal);


frontAeroLoadFinal = ...
    AeroLoadFinal.FL + AeroLoadFinal.FR;

rearAeroLoadFinal = ...
    AeroLoadFinal.RL + AeroLoadFinal.RR;


frontCompressionFinal = ...
    frontAeroLoadFinal / ...
    Suspension.axleHeaveStiffnessFront;

rearCompressionFinal = ...
    rearAeroLoadFinal / ...
    Suspension.axleHeaveStiffnessRear;


targetFrontRHFinal = ...
    Setup.rideHeightFront - ...
    frontCompressionFinal;

targetRearRHFinal = ...
    Setup.rideHeightRear - ...
    rearCompressionFinal;


%% ============================================================
%  6. FINAL PLATFORM PARAMETERS
%  ============================================================

rideHeightDelta = ...
    rearRH - frontRH;


rakeAngle = atan( ...
    (rideHeightDelta / 1000) / ...
    Vehicle.wheelbase);

rakeAngleDeg = rad2deg(rakeAngle);


heave = ...
    (frontCompressionFinal + ...
     rearCompressionFinal) / 2;


differentialCompression = ...
    rearCompressionFinal - ...
    frontCompressionFinal;


%% ============================================================
%  7. FINAL EQUILIBRIUM ERROR
%  ============================================================

frontFinalError = ...
    targetFrontRHFinal - frontRH;

rearFinalError = ...
    targetRearRHFinal - rearRH;

finalEquilibriumError = max( ...
    abs([frontFinalError, rearFinalError]));


%% ============================================================
%  8. TRIM HISTORY ARRAYS
%  ============================================================

frontRHHistory = ...
    frontRHHistory(1:iteration);

rearRHHistory = ...
    rearRHHistory(1:iteration);

frontCompressionHistory = ...
    frontCompressionHistory(1:iteration);

rearCompressionHistory = ...
    rearCompressionHistory(1:iteration);

downforceHistory = ...
    downforceHistory(1:iteration);

CLHistory = ...
    CLHistory(1:iteration);

CDHistory = ...
    CDHistory(1:iteration);

balanceHistory = ...
    balanceHistory(1:iteration);

errorHistory = ...
    errorHistory(1:iteration);


%% ============================================================
%  9. STORE OUTPUT
%  ============================================================

Equilibrium.converged = converged;

Equilibrium.iterations = iteration;

Equilibrium.tolerance = tolerance;

Equilibrium.relaxationFactor = ...
    relaxationFactor;


Equilibrium.speed = Operating.speed;

Equilibrium.speedKPH = ...
    Operating.speed * 3.6;


Equilibrium.staticFrontRideHeight = ...
    Setup.rideHeightFront;

Equilibrium.staticRearRideHeight = ...
    Setup.rideHeightRear;


Equilibrium.frontRideHeight = frontRH;

Equilibrium.rearRideHeight = rearRH;


Equilibrium.frontCompression = ...
    frontCompressionFinal;

Equilibrium.rearCompression = ...
    rearCompressionFinal;


Equilibrium.heave = heave;

Equilibrium.differentialCompression = ...
    differentialCompression;


Equilibrium.rideHeightDelta = ...
    rideHeightDelta;

Equilibrium.rakeAngle = ...
    rakeAngle;

Equilibrium.rakeAngleDeg = ...
    rakeAngleDeg;


Equilibrium.AeroState = ...
    AeroStateFinal;

Equilibrium.Aero = ...
    AeroFinal;

Equilibrium.AeroLoad = ...
    AeroLoadFinal;


Equilibrium.frontAeroLoad = ...
    frontAeroLoadFinal;

Equilibrium.rearAeroLoad = ...
    rearAeroLoadFinal;


Equilibrium.finalFrontError = ...
    frontFinalError;

Equilibrium.finalRearError = ...
    rearFinalError;

Equilibrium.finalEquilibriumError = ...
    finalEquilibriumError;


Equilibrium.frontRHHistory = ...
    frontRHHistory;

Equilibrium.rearRHHistory = ...
    rearRHHistory;

Equilibrium.frontCompressionHistory = ...
    frontCompressionHistory;

Equilibrium.rearCompressionHistory = ...
    rearCompressionHistory;

Equilibrium.downforceHistory = ...
    downforceHistory;

Equilibrium.CLHistory = ...
    CLHistory;

Equilibrium.CDHistory = ...
    CDHistory;

Equilibrium.balanceHistory = ...
    balanceHistory;

Equilibrium.errorHistory = ...
    errorHistory;


end