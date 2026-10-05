function Study = setupSensitivityStudy( ...
    Vehicle, Setup, Operating, Tyre, Constants, AeroMap, ...
    parameterName, parameterValues)
%SETUPSENSITIVITYSTUDY
%
% Stage 6.3 - Generic Setup Sensitivity Analysis
%
% PURPOSE
% -------
% Sweeps a selected setup parameter through a user-defined range and
% evaluates each configuration using the validated Stage 6.1 integrated
% performance calculation engine.
%
% EXAMPLE
% -------
%
% Study = setupSensitivityStudy( ...
%     Vehicle, Setup, Operating, Tyre, Constants, AeroMap, ...
%     'springFront', 100:5:200);
%
% SUPPORTED PARAMETERS
% --------------------
% springFront
% springRear
% arbFront
% arbRear
% rideHeightFront
% rideHeightRear
% camberFront
% camberRear
% toeFront
% toeRear
%
% IMPORTANT
% ---------
% No new vehicle physics are introduced here. Each point simply modifies
% one setup parameter and calls evaluateVehiclePerformance().


%% ============================================================
%  1. INPUT CHECKS
%  ============================================================

if ~isfield(Setup, parameterName)

    error( ...
        'setupSensitivityStudy:InvalidParameter', ...
        'Setup parameter "%s" does not exist.', ...
        parameterName);

end


if isempty(parameterValues)

    error( ...
        'setupSensitivityStudy:EmptyRange', ...
        'The parameter sweep cannot be empty.');

end


parameterValues = parameterValues(:)';

nPoints = length(parameterValues);


%% ============================================================
%  2. PREALLOCATE RESULTS
%  ============================================================

Results.parameterValue = ...
    parameterValues;


Results.lateralAccelerationG = ...
    nan(1,nPoints);

Results.yawRateDeg = ...
    nan(1,nPoints);

Results.understeerGradient = ...
    nan(1,nPoints);


Results.CL = ...
    nan(1,nPoints);

Results.CD = ...
    nan(1,nPoints);

Results.aeroEfficiency = ...
    nan(1,nPoints);

Results.downforce = ...
    nan(1,nPoints);

Results.aeroBalanceFrontPercent = ...
    nan(1,nPoints);


Results.frontRideHeight = ...
    nan(1,nPoints);

Results.rearRideHeight = ...
    nan(1,nPoints);

Results.frontCompression = ...
    nan(1,nPoints);

Results.rearCompression = ...
    nan(1,nPoints);

Results.heave = ...
    nan(1,nPoints);

Results.rakeAngleDeg = ...
    nan(1,nPoints);


Results.frontWheelRate = ...
    nan(1,nPoints);

Results.rearWheelRate = ...
    nan(1,nPoints);


Results.frontCorneringStiffness = ...
    nan(1,nPoints);

Results.rearCorneringStiffness = ...
    nan(1,nPoints);


Results.aeroMapValid = ...
    false(1,nPoints);

Results.platformConverged = ...
    false(1,nPoints);

Results.lateralSolverConverged = ...
    false(1,nPoints);

Results.allValid = ...
    false(1,nPoints);


%% ============================================================
%  3. PARAMETER SWEEP
%  ============================================================

for i = 1:nPoints

    CurrentSetup = Setup;

    CurrentSetup.(parameterName) = ...
        parameterValues(i);


    try

        Performance = ...
            evaluateVehiclePerformance( ...
            Vehicle, ...
            CurrentSetup, ...
            Operating, ...
            Tyre, ...
            Constants, ...
            AeroMap);


        KPI = ...
            Performance.KPI;

        Status = ...
            Performance.Status;


        %% Lateral

        Results.lateralAccelerationG(i) = ...
            KPI.lateralAccelerationG;

        Results.yawRateDeg(i) = ...
            KPI.yawRateDeg;

        Results.understeerGradient(i) = ...
            KPI.understeerGradient;


        %% Aerodynamics

        Results.CL(i) = ...
            KPI.CL;

        Results.CD(i) = ...
            KPI.CD;

        Results.aeroEfficiency(i) = ...
            KPI.aeroEfficiency;

        Results.downforce(i) = ...
            KPI.downforce;

        Results.aeroBalanceFrontPercent(i) = ...
            KPI.aeroBalanceFrontPercent;


        %% Platform

        Results.frontRideHeight(i) = ...
            KPI.frontRideHeight;

        Results.rearRideHeight(i) = ...
            KPI.rearRideHeight;

        Results.frontCompression(i) = ...
            KPI.frontCompression;

        Results.rearCompression(i) = ...
            KPI.rearCompression;

        Results.heave(i) = ...
            KPI.heave;

        Results.rakeAngleDeg(i) = ...
            KPI.rakeAngleDeg;


        %% Suspension

        Results.frontWheelRate(i) = ...
            KPI.frontWheelRate;

        Results.rearWheelRate(i) = ...
            KPI.rearWheelRate;


        %% Tyre / lateral

        Results.frontCorneringStiffness(i) = ...
            KPI.frontCorneringStiffness;

        Results.rearCorneringStiffness(i) = ...
            KPI.rearCorneringStiffness;


        %% Status

        Results.aeroMapValid(i) = ...
            Status.aeroMapValid;

        Results.platformConverged(i) = ...
            Status.platformConverged;

        Results.lateralSolverConverged(i) = ...
            Status.lateralSolverConverged;

        Results.allValid(i) = ...
            Status.allValid;


    catch ME

        warning( ...
            'Sensitivity point %d failed: %s', ...
            i, ...
            ME.message);

    end

end


%% ============================================================
%  4. BASELINE LOCATION
%  ============================================================

baselineValue = ...
    Setup.(parameterName);


[~, baselineIndex] = ...
    min(abs(parameterValues - baselineValue));


%% ============================================================
%  5. VALID POINTS
%  ============================================================

validIndices = ...
    find(Results.allValid);

invalidIndices = ...
    find(~Results.allValid);


%% ============================================================
%  6. AERO-MAP BOUNDARY INFORMATION
%  ============================================================

aeroValidIndices = ...
    find(Results.aeroMapValid);

aeroInvalidIndices = ...
    find(~Results.aeroMapValid);


if isempty(aeroValidIndices)

    minimumValidParameter = NaN;
    maximumValidParameter = NaN;

else

    minimumValidParameter = ...
        min(parameterValues(aeroValidIndices));

    maximumValidParameter = ...
        max(parameterValues(aeroValidIndices));

end


%% ============================================================
%  7. STORE STUDY
%  ============================================================

Study.parameterName = ...
    parameterName;

Study.parameterValues = ...
    parameterValues;

Study.baselineValue = ...
    baselineValue;

Study.baselineIndex = ...
    baselineIndex;

Study.numberPoints = ...
    nPoints;

Study.Results = ...
    Results;


Study.validIndices = ...
    validIndices;

Study.invalidIndices = ...
    invalidIndices;

Study.aeroValidIndices = ...
    aeroValidIndices;

Study.aeroInvalidIndices = ...
    aeroInvalidIndices;


Study.minimumValidParameter = ...
    minimumValidParameter;

Study.maximumValidParameter = ...
    maximumValidParameter;


Study.Operating = ...
    Operating;


end