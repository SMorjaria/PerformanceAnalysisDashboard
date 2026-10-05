function Coupled = calculateCoupledLateralResponse( ...
    Vehicle, Setup, Operating, Tyre, Constants)
%CALCULATECOUPLEDLATERALRESPONSE
%
% Iteratively couples the Stage 2 load-transfer model with
% the Stage 3 steady-state bicycle model.
%
% Calculation chain:
%
%   ay
%    ↓
%   lateral load transfer
%    ↓
%   individual tyre vertical loads
%    ↓
%   load-sensitive cornering stiffness
%    ↓
%   steady-state bicycle model
%    ↓
%   calculated ay
%
% The calculation repeats until lateral acceleration converges.


%% ============================================================
%  SOLVER SETTINGS
%  ============================================================

maxIterations = 100;

% Convergence tolerance for lateral acceleration
tolerance = 1e-5;              % [m/s^2]

% Under-relaxation factor
relaxationFactor = 0.5;        % [-]


%% ============================================================
%  INITIAL LATERAL ACCELERATION GUESS
%  ============================================================

% Begin from zero lateral acceleration.
%
% This deliberately avoids relying on the user-entered Stage 2
% lateral acceleration for the coupled solution.

ayCurrent = 0;


%% ============================================================
%  PREALLOCATE CONVERGENCE HISTORY
%  ============================================================

ayHistory = zeros(maxIterations,1);

errorHistory = zeros(maxIterations,1);

converged = false;


%% ============================================================
%  ITERATIVE COUPLED SOLUTION
%  ============================================================

for iteration = 1:maxIterations

    %% --------------------------------------------------------
    %  1. TEMPORARY OPERATING CONDITION
    %  ---------------------------------------------------------

    OperatingIteration = Operating;

    OperatingIteration.ay = ayCurrent;


    %% --------------------------------------------------------
    %  2. DERIVED VEHICLE PARAMETERS
    %  ---------------------------------------------------------

    DerivedIteration = calculateDerivedParameters( ...
        Vehicle, ...
        Setup, ...
        OperatingIteration, ...
        Constants);


    %% --------------------------------------------------------
    %  3. LONGITUDINAL LOAD TRANSFER
    %  ---------------------------------------------------------

    LongitudinalIteration = ...
        calculateLongitudinalLoadTransfer( ...
            Vehicle, ...
            OperatingIteration, ...
            DerivedIteration);


    %% --------------------------------------------------------
    %  4. LATERAL LOAD TRANSFER
    %  ---------------------------------------------------------

    LateralIteration = ...
        calculateLateralLoadTransfer( ...
            Vehicle, ...
            Setup, ...
            OperatingIteration, ...
            DerivedIteration);


    %% --------------------------------------------------------
    %  5. COMBINED FOUR-CORNER TYRE LOADS
    %  ---------------------------------------------------------

    TyreLoadsIteration = ...
        calculateCombinedTyreLoads( ...
            Vehicle, ...
            OperatingIteration, ...
            DerivedIteration, ...
            LongitudinalIteration, ...
            LateralIteration);


    %% --------------------------------------------------------
    %  6. CHECK TYRE LOAD VALIDITY
    %  ---------------------------------------------------------

    if TyreLoadsIteration.wheelLift

        error( ...
            ['Coupled lateral solver encountered zero or ', ...
             'negative tyre vertical load.']);

    end


    %% --------------------------------------------------------
    %  7. LOAD-SENSITIVE CORNERING STIFFNESS
    %  ---------------------------------------------------------

    CorneringIteration = ...
        calculateCorneringStiffness( ...
            TyreLoadsIteration, ...
            Tyre);


    %% --------------------------------------------------------
    %  8. BICYCLE MODEL
    %  ---------------------------------------------------------

    BicycleIteration = ...
        createBicycleModel( ...
            Vehicle, ...
            OperatingIteration);


    %% --------------------------------------------------------
    %  9. STEADY-STATE LATERAL RESPONSE
    %  ---------------------------------------------------------

    ResponseIteration = ...
        calculateSteadyStateLateralResponse( ...
            BicycleIteration, ...
            CorneringIteration);


    %% --------------------------------------------------------
    %  10. CALCULATED LATERAL ACCELERATION
    %  ---------------------------------------------------------

    ayCalculated = ResponseIteration.ay;


    %% --------------------------------------------------------
    %  11. CONVERGENCE ERROR
    %  ---------------------------------------------------------

    convergenceError = ...
        ayCalculated - ayCurrent;


    %% --------------------------------------------------------
    %  12. STORE CONVERGENCE HISTORY
    %  ---------------------------------------------------------

    ayHistory(iteration) = ayCalculated;

    errorHistory(iteration) = convergenceError;


    %% --------------------------------------------------------
    %  13. CHECK FOR CONVERGENCE
    %  ---------------------------------------------------------

    if abs(convergenceError) < tolerance

        converged = true;

        ayCurrent = ayCalculated;

        break

    end


    %% --------------------------------------------------------
    %  14. UNDER-RELAXATION
    %  --------------------------------------------------------

    ayCurrent = ...
        ayCurrent ...
        + relaxationFactor * convergenceError;

end


%% ============================================================
%  CHECK SOLVER STATUS
%  ============================================================

if ~converged

    warning( ...
        ['Coupled lateral solver did not converge within ', ...
         '%d iterations.'], ...
         maxIterations);

end


%% ============================================================
%  TRIM CONVERGENCE HISTORY
%  ============================================================

ayHistory = ayHistory(1:iteration);

errorHistory = errorHistory(1:iteration);


%% ============================================================
%  FINAL CONSISTENT OPERATING CONDITION
%  ============================================================

OperatingFinal = Operating;

OperatingFinal.ay = ayCurrent;


%% ============================================================
%  FINAL DERIVED PARAMETERS
%  ============================================================

DerivedFinal = calculateDerivedParameters( ...
    Vehicle, ...
    Setup, ...
    OperatingFinal, ...
    Constants);


%% ============================================================
%  FINAL LONGITUDINAL LOAD TRANSFER
%  ============================================================

LongitudinalFinal = ...
    calculateLongitudinalLoadTransfer( ...
        Vehicle, ...
        OperatingFinal, ...
        DerivedFinal);


%% ============================================================
%  FINAL LATERAL LOAD TRANSFER
%  ============================================================

LateralFinal = ...
    calculateLateralLoadTransfer( ...
        Vehicle, ...
        Setup, ...
        OperatingFinal, ...
        DerivedFinal);


%% ============================================================
%  FINAL COMBINED TYRE LOADS
%  ============================================================

TyreLoadsFinal = ...
    calculateCombinedTyreLoads( ...
        Vehicle, ...
        OperatingFinal, ...
        DerivedFinal, ...
        LongitudinalFinal, ...
        LateralFinal);


%% ============================================================
%  FINAL TYRE LOAD VALIDATION
%  ============================================================

if TyreLoadsFinal.wheelLift

    error( ...
        ['Final coupled solution contains zero or ', ...
         'negative tyre vertical load.']);

end


%% ============================================================
%  FINAL CORNERING STIFFNESS
%  ============================================================

CorneringFinal = ...
    calculateCorneringStiffness( ...
        TyreLoadsFinal, ...
        Tyre);


%% ============================================================
%  FINAL BICYCLE MODEL
%  ============================================================

BicycleFinal = ...
    createBicycleModel( ...
        Vehicle, ...
        OperatingFinal);


%% ============================================================
%  FINAL STEADY-STATE RESPONSE
%  ============================================================

ResponseFinal = ...
    calculateSteadyStateLateralResponse( ...
        BicycleFinal, ...
        CorneringFinal);


%% ============================================================
%  FINAL VEHICLE BALANCE
%  ============================================================

BalanceFinal = ...
    calculateVehicleBalance( ...
        BicycleFinal, ...
        CorneringFinal, ...
        ResponseFinal, ...
        Constants);


%% ============================================================
%  FINAL COUPLING ERROR
%  ============================================================

finalCouplingError = ...
    ResponseFinal.ay - OperatingFinal.ay;


%% ============================================================
%  STORE SOLVER INFORMATION
%  ============================================================

Coupled.converged = converged;

Coupled.iterations = iteration;

Coupled.tolerance = tolerance;

Coupled.relaxationFactor = relaxationFactor;

Coupled.finalCouplingError = finalCouplingError;


%% ============================================================
%  STORE FINAL OPERATING CONDITION
%  ============================================================

Coupled.Operating = OperatingFinal;

Coupled.ay = ResponseFinal.ay;


%% ============================================================
%  STORE FINAL MODEL RESULTS
%  ============================================================

Coupled.Derived = DerivedFinal;

Coupled.Longitudinal = LongitudinalFinal;

Coupled.Lateral = LateralFinal;

Coupled.TyreLoads = TyreLoadsFinal;

Coupled.Cornering = CorneringFinal;

Coupled.Bicycle = BicycleFinal;

Coupled.Response = ResponseFinal;

Coupled.Balance = BalanceFinal;


%% ============================================================
%  STORE CONVERGENCE HISTORY
%  ============================================================

Coupled.ayHistory = ayHistory;

Coupled.errorHistory = errorHistory;

end