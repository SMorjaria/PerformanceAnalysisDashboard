
function AeroCoupled = calculateAeroCoupledLateralResponse( ...
    Vehicle, Setup, Operating, Tyre, Constants, AeroMap)
%CALCULATEAEROCOUPLEDLATERALRESPONSE
%
% Stage 4.5 - Aerodynamic Loading and Coupled Vehicle Balance
%
% Calculates the aerodynamic state at the specified platform
% and couples four-corner aero loads to the Stage 3 model.
%
% The solver iterates lateral acceleration because changing
% lateral acceleration changes mechanical lateral load transfer.
%
% ASSUMPTIONS:
%   - Ride heights remain fixed throughout the calculation.
%   - Aerodynamic loads are symmetric left/right.
%   - Aerodynamic drag does not create additional pitch transfer.
%   - The bicycle model remains linear.
%   - No combined-slip or tyre saturation model is included.


%% ============================================================
%  1. AERODYNAMIC PLATFORM STATE
%  ============================================================

AeroState = calculateAeroMap( ...
    Vehicle, Setup, AeroMap);

% Use the map-derived coefficients rather than the fixed
% coefficients originally stored in Setup.

SetupAero = Setup;

SetupAero.CL = AeroState.CL;
SetupAero.CD = AeroState.CD;
SetupAero.aeroBalance = AeroState.frontBalance;


%% ============================================================
%  2. AERODYNAMIC FORCES AND DISTRIBUTION
%  ============================================================

Aero = calculateAerodynamicForces( ...
    Vehicle, SetupAero, Operating, Constants);

AeroLoad = calculateAeroLoadDistribution( ...
    Aero, SetupAero);


%% ============================================================
%  3. SOLVER PARAMETERS
%  ============================================================

maxIterations = 100;

tolerance = 1e-5;

relaxationFactor = 0.5;

ayCurrent = 0;

ayHistory = nan(maxIterations,1);
errorHistory = nan(maxIterations,1);

converged = false;

iterations = 0;


%% ============================================================
%  4. COUPLED ITERATION
%  ============================================================

for k = 1:maxIterations

    OperatingIteration = Operating;

    OperatingIteration.ay = ayCurrent;


    % --------------------------------------------------------
    % Mechanical loading
    % ---------------------------------------------------------

    DerivedIteration = calculateDerivedParameters( ...
        Vehicle, Setup, OperatingIteration, Constants);

    LongitudinalIteration = ...
        calculateLongitudinalLoadTransfer( ...
            Vehicle, OperatingIteration, DerivedIteration);

    LateralIteration = calculateLateralLoadTransfer( ...
        Vehicle, Setup, OperatingIteration, DerivedIteration);

    MechanicalLoads = calculateCombinedTyreLoads( ...
        Vehicle, ...
        OperatingIteration, ...
        DerivedIteration, ...
        LongitudinalIteration, ...
        LateralIteration);


    % --------------------------------------------------------
    % Add aerodynamic vertical loading
    % ---------------------------------------------------------

    CombinedLoads = MechanicalLoads;

    CombinedLoads.FL = MechanicalLoads.FL + AeroLoad.FL;
    CombinedLoads.FR = MechanicalLoads.FR + AeroLoad.FR;

    CombinedLoads.RL = MechanicalLoads.RL + AeroLoad.RL;
    CombinedLoads.RR = MechanicalLoads.RR + AeroLoad.RR;


    % --------------------------------------------------------
    % Check tyre contact
    % ---------------------------------------------------------

    Fz = [ ...
        CombinedLoads.FL, ...
        CombinedLoads.FR, ...
        CombinedLoads.RL, ...
        CombinedLoads.RR];

    if any(~isfinite(Fz)) || any(Fz <= 0)

        error([ ...
            'Stage 4.5: non-positive or invalid tyre ', ...
            'vertical load at iteration %d.'], k);

    end


    % --------------------------------------------------------
    % Cornering stiffness and bicycle response
    % ---------------------------------------------------------

    CorneringIteration = calculateCorneringStiffness( ...
        CombinedLoads, Tyre);

    BicycleIteration = createBicycleModel( ...
        Vehicle, OperatingIteration);

    ResponseIteration = ...
        calculateSteadyStateLateralResponse( ...
            BicycleIteration, CorneringIteration);

    ayCalculated = ResponseIteration.ay;


    % --------------------------------------------------------
    % Convergence
    % ---------------------------------------------------------

    errorCurrent = ayCalculated - ayCurrent;

    iterations = k;

    ayHistory(k) = ayCalculated;
    errorHistory(k) = errorCurrent;

    if ~isfinite(ayCalculated)

        error('Stage 4.5: solver produced invalid acceleration.');

    end

    if abs(errorCurrent) < tolerance

        converged = true;

        ayCurrent = ayCalculated;

        break;

    end


    % Relaxation to improve convergence

    ayCurrent = ayCurrent + ...
        relaxationFactor * errorCurrent;

end


%% ============================================================
%  5. FINAL CONSISTENT STATE
%  ============================================================

% Recalculate all outputs using the final acceleration.
% This avoids returning intermediate iteration values.

OperatingFinal = Operating;

OperatingFinal.ay = ayCurrent;

DerivedFinal = calculateDerivedParameters( ...
    Vehicle, Setup, OperatingFinal, Constants);

LongitudinalFinal = calculateLongitudinalLoadTransfer( ...
    Vehicle, OperatingFinal, DerivedFinal);

LateralFinal = calculateLateralLoadTransfer( ...
    Vehicle, Setup, OperatingFinal, DerivedFinal);

MechanicalFinal = calculateCombinedTyreLoads( ...
    Vehicle, ...
    OperatingFinal, ...
    DerivedFinal, ...
    LongitudinalFinal, ...
    LateralFinal);


%% ============================================================
%  6. FINAL COMBINED TYRE LOADS
%  ============================================================

CombinedFinal = MechanicalFinal;

CombinedFinal.FL = MechanicalFinal.FL + AeroLoad.FL;
CombinedFinal.FR = MechanicalFinal.FR + AeroLoad.FR;

CombinedFinal.RL = MechanicalFinal.RL + AeroLoad.RL;
CombinedFinal.RR = MechanicalFinal.RR + AeroLoad.RR;


% Update aggregate load fields used by downstream models.

CombinedFinal.frontAxle = ...
    CombinedFinal.FL + CombinedFinal.FR;

CombinedFinal.rearAxle = ...
    CombinedFinal.RL + CombinedFinal.RR;

CombinedFinal.leftSide = ...
    CombinedFinal.FL + CombinedFinal.RL;

CombinedFinal.rightSide = ...
    CombinedFinal.FR + CombinedFinal.RR;

CombinedFinal.totalVerticalLoad = ...
    sum([ ...
        CombinedFinal.FL, ...
        CombinedFinal.FR, ...
        CombinedFinal.RL, ...
        CombinedFinal.RR]);


%% ============================================================
%  7. FINAL VEHICLE RESPONSE
%  ============================================================

CorneringFinal = calculateCorneringStiffness( ...
    CombinedFinal, Tyre);

BicycleFinal = createBicycleModel( ...
    Vehicle, OperatingFinal);

ResponseFinal = calculateSteadyStateLateralResponse( ...
    BicycleFinal, CorneringFinal);

BalanceFinal = calculateVehicleBalance( ...
    BicycleFinal, ...
    CorneringFinal, ...
    ResponseFinal, ...
    Constants);


%% ============================================================
%  8. VALIDATION
%  ============================================================

mechanicalTotal = sum([ ...
    MechanicalFinal.FL, ...
    MechanicalFinal.FR, ...
    MechanicalFinal.RL, ...
    MechanicalFinal.RR]);

expectedTotal = mechanicalTotal + AeroLoad.totalDownforce;

loadConservationError = ...
    CombinedFinal.totalVerticalLoad - expectedTotal;

finalCouplingError = ...
    ResponseFinal.ay - OperatingFinal.ay;


%% ============================================================
%  9. STORE RESULTS
%  ============================================================

AeroCoupled.converged = converged;

AeroCoupled.iterations = iterations;

AeroCoupled.tolerance = tolerance;

AeroCoupled.relaxationFactor = relaxationFactor;

AeroCoupled.finalCouplingError = finalCouplingError;

AeroCoupled.Operating = OperatingFinal;

AeroCoupled.ay = ResponseFinal.ay;

AeroCoupled.AeroState = AeroState;
AeroCoupled.Aero = Aero;
AeroCoupled.AeroLoad = AeroLoad;

AeroCoupled.Derived = DerivedFinal;
AeroCoupled.Longitudinal = LongitudinalFinal;
AeroCoupled.Lateral = LateralFinal;

AeroCoupled.MechanicalLoads = MechanicalFinal;
AeroCoupled.TyreLoads = CombinedFinal;

AeroCoupled.Cornering = CorneringFinal;
AeroCoupled.Bicycle = BicycleFinal;

AeroCoupled.Response = ResponseFinal;
AeroCoupled.Balance = BalanceFinal;

AeroCoupled.mechanicalVerticalLoad = mechanicalTotal;

AeroCoupled.expectedVerticalLoad = expectedTotal;

AeroCoupled.loadConservationError = ...
    loadConservationError;

AeroCoupled.ayHistory = ayHistory(1:iterations);

AeroCoupled.errorHistory = errorHistory(1:iterations);

if ~converged

    warning( ...
        'Stage 4.5: solver did not converge within %d iterations.', ...
        maxIterations);

end

end
