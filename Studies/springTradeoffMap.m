function Study = springTradeoffMap( ...
    Vehicle, Setup, Operating, Tyre, Constants, AeroMap, ...
    frontSpringValues, rearSpringValues)
%SPRINGTRADEOFFMAP
%
% Stage 6.4 - Front / Rear Spring Trade-Off Map
%
% PURPOSE
% -------
% Evaluates combinations of front and rear spring stiffness using the
% validated integrated vehicle-performance model.
%
% The study identifies how front/rear spring combinations influence:
%
%   - aerodynamic platform
%   - front and rear ride height
%   - aero-map validity
%   - downforce
%   - aerodynamic efficiency
%   - understeer gradient
%   - lateral acceleration
%
% No new vehicle physics are introduced in this function.
%
% Each grid point modifies:
%
%       Setup.springFront
%       Setup.springRear
%
% and evaluates the resulting configuration using
% evaluateVehiclePerformance().
%
% INPUTS
% ------
% frontSpringValues : front spring sweep [N/mm]
% rearSpringValues  : rear spring sweep [N/mm]


%% ============================================================
%  1. INPUT PREPARATION
%  ============================================================

frontSpringValues = ...
    frontSpringValues(:)';

rearSpringValues = ...
    rearSpringValues(:)';


nFront = ...
    length(frontSpringValues);

nRear = ...
    length(rearSpringValues);


if isempty(frontSpringValues) || isempty(rearSpringValues)

    error( ...
        'springTradeoffMap:EmptyRange', ...
        'Front and rear spring ranges must not be empty.');

end


%% ============================================================
%  2. CREATE GRID
%  ============================================================

[FrontSpringGrid, RearSpringGrid] = ...
    meshgrid( ...
    frontSpringValues, ...
    rearSpringValues);


gridSize = ...
    size(FrontSpringGrid);


%% ============================================================
%  3. PREALLOCATE RESULTS
%  ============================================================

Results.frontRideHeight = ...
    nan(gridSize);

Results.rearRideHeight = ...
    nan(gridSize);

Results.frontCompression = ...
    nan(gridSize);

Results.rearCompression = ...
    nan(gridSize);

Results.heave = ...
    nan(gridSize);

Results.rakeAngleDeg = ...
    nan(gridSize);


Results.CL = ...
    nan(gridSize);

Results.CD = ...
    nan(gridSize);

Results.aeroEfficiency = ...
    nan(gridSize);

Results.downforce = ...
    nan(gridSize);

Results.aeroBalanceFrontPercent = ...
    nan(gridSize);


Results.lateralAccelerationG = ...
    nan(gridSize);

Results.yawRateDeg = ...
    nan(gridSize);

Results.understeerGradient = ...
    nan(gridSize);


Results.frontWheelRate = ...
    nan(gridSize);

Results.rearWheelRate = ...
    nan(gridSize);


Results.aeroMapValid = ...
    false(gridSize);

Results.platformConverged = ...
    false(gridSize);

Results.lateralSolverConverged = ...
    false(gridSize);

Results.allValid = ...
    false(gridSize);


%% ============================================================
%  4. RUN 2D SETUP SWEEP
%  ============================================================

for iRear = 1:nRear

    for iFront = 1:nFront

        CurrentSetup = ...
            Setup;


        CurrentSetup.springFront = ...
            FrontSpringGrid(iRear,iFront);

        CurrentSetup.springRear = ...
            RearSpringGrid(iRear,iFront);


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


            %% Platform

            Results.frontRideHeight(iRear,iFront) = ...
                KPI.frontRideHeight;

            Results.rearRideHeight(iRear,iFront) = ...
                KPI.rearRideHeight;

            Results.frontCompression(iRear,iFront) = ...
                KPI.frontCompression;

            Results.rearCompression(iRear,iFront) = ...
                KPI.rearCompression;

            Results.heave(iRear,iFront) = ...
                KPI.heave;

            Results.rakeAngleDeg(iRear,iFront) = ...
                KPI.rakeAngleDeg;


            %% Aerodynamics

            Results.CL(iRear,iFront) = ...
                KPI.CL;

            Results.CD(iRear,iFront) = ...
                KPI.CD;

            Results.aeroEfficiency(iRear,iFront) = ...
                KPI.aeroEfficiency;

            Results.downforce(iRear,iFront) = ...
                KPI.downforce;

            Results.aeroBalanceFrontPercent(iRear,iFront) = ...
                KPI.aeroBalanceFrontPercent;


            %% Lateral performance

            Results.lateralAccelerationG(iRear,iFront) = ...
                KPI.lateralAccelerationG;

            Results.yawRateDeg(iRear,iFront) = ...
                KPI.yawRateDeg;

            Results.understeerGradient(iRear,iFront) = ...
                KPI.understeerGradient;


            %% Suspension

            Results.frontWheelRate(iRear,iFront) = ...
                KPI.frontWheelRate;

            Results.rearWheelRate(iRear,iFront) = ...
                KPI.rearWheelRate;


            %% Status

            Results.aeroMapValid(iRear,iFront) = ...
                Status.aeroMapValid;

            Results.platformConverged(iRear,iFront) = ...
                Status.platformConverged;

            Results.lateralSolverConverged(iRear,iFront) = ...
                Status.lateralSolverConverged;

            Results.allValid(iRear,iFront) = ...
                Status.allValid;


        catch ME

            warning( ...
                ['Spring-map point failed: ' ...
                 'Front = %.1f N/mm, Rear = %.1f N/mm. %s'], ...
                CurrentSetup.springFront, ...
                CurrentSetup.springRear, ...
                ME.message);

        end

    end

end


%% ============================================================
%  5. AERO-MAP MARGINS
%  ============================================================

% Current surrogate aero-map limits.
%
% These correspond to the validated Stage 4 aero-map range.
% They can later be read directly from AeroMap once the GUI
% architecture is finalised.

frontMinimumRH = ...
    15;

rearMinimumRH = ...
    30;


Results.frontAeroMargin = ...
    Results.frontRideHeight - frontMinimumRH;

Results.rearAeroMargin = ...
    Results.rearRideHeight - rearMinimumRH;


% Governing margin:
%
% Positive = both minimum ride-height requirements satisfied.
% Negative = at least one axle is below its minimum.

Results.minimumAeroMargin = ...
    min( ...
    Results.frontAeroMargin, ...
    Results.rearAeroMargin);


%% ============================================================
%  6. VALID CONFIGURATIONS
%  ============================================================

validMask = ...
    Results.allValid;


numberValid = ...
    nnz(validMask);

numberCases = ...
    numel(validMask);


%% ============================================================
%  7. MAXIMUM DOWNFORCE WITHIN VALID REGION
%  ============================================================

validDownforce = ...
    Results.downforce;

validDownforce(~validMask) = ...
    NaN;


if any(validMask(:))

    maximumValidDownforce = ...
        max(validDownforce(:),[],'omitnan');


    [rowMax, columnMax] = ...
        find( ...
        validDownforce == maximumValidDownforce, ...
        1, ...
        'first');


    maxDownforceFrontSpring = ...
        FrontSpringGrid(rowMax,columnMax);

    maxDownforceRearSpring = ...
        RearSpringGrid(rowMax,columnMax);


    maxDownforceFrontRH = ...
        Results.frontRideHeight(rowMax,columnMax);

    maxDownforceRearRH = ...
        Results.rearRideHeight(rowMax,columnMax);


    maxDownforceUndersteerGradient = ...
        Results.understeerGradient(rowMax,columnMax);


else

    maximumValidDownforce = NaN;

    maxDownforceFrontSpring = NaN;
    maxDownforceRearSpring = NaN;

    maxDownforceFrontRH = NaN;
    maxDownforceRearRH = NaN;

    maxDownforceUndersteerGradient = NaN;

end


%% ============================================================
%  8. BASELINE GRID LOCATION
%  ============================================================

[~, baselineFrontIndex] = ...
    min(abs(frontSpringValues - Setup.springFront));

[~, baselineRearIndex] = ...
    min(abs(rearSpringValues - Setup.springRear));


%% ============================================================
%  9. STORE STUDY
%  ============================================================

Study.frontSpringValues = ...
    frontSpringValues;

Study.rearSpringValues = ...
    rearSpringValues;


Study.FrontSpringGrid = ...
    FrontSpringGrid;

Study.RearSpringGrid = ...
    RearSpringGrid;


Study.Results = ...
    Results;


Study.numberCases = ...
    numberCases;

Study.numberValid = ...
    numberValid;

Study.validFraction = ...
    numberValid / numberCases;


Study.baselineFrontSpring = ...
    Setup.springFront;

Study.baselineRearSpring = ...
    Setup.springRear;

Study.baselineFrontIndex = ...
    baselineFrontIndex;

Study.baselineRearIndex = ...
    baselineRearIndex;


Study.maximumValidDownforce = ...
    maximumValidDownforce;

Study.maxDownforceFrontSpring = ...
    maxDownforceFrontSpring;

Study.maxDownforceRearSpring = ...
    maxDownforceRearSpring;

Study.maxDownforceFrontRH = ...
    maxDownforceFrontRH;

Study.maxDownforceRearRH = ...
    maxDownforceRearRH;

Study.maxDownforceUndersteerGradient = ...
    maxDownforceUndersteerGradient;


Study.frontMinimumRH = ...
    frontMinimumRH;

Study.rearMinimumRH = ...
    rearMinimumRH;


Study.Operating = ...
    Operating;


end