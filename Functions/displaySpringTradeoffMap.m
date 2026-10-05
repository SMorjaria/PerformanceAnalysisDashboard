function displaySpringTradeoffMap(Study)
%DISPLAYSPRINGTRADEOFFMAP
%
% Stage 6.4 - Front / Rear Spring Trade-Off Summary


R = ...
    Study.Results;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' FRONT / REAR SPRING TRADE-OFF MAP - STAGE 6.4\n');
fprintf('============================================================\n');


%% ============================================================
% STUDY DEFINITION
% ============================================================

fprintf('\nSTUDY DEFINITION\n');
fprintf('------------------------------------------------------------\n');

fprintf('Vehicle Speed           : %10.1f km/h\n', ...
    Study.Operating.speed * 3.6);

fprintf('Front Spring Range      : %6.1f to %6.1f N/mm\n', ...
    min(Study.frontSpringValues), ...
    max(Study.frontSpringValues));

fprintf('Rear Spring Range       : %6.1f to %6.1f N/mm\n', ...
    min(Study.rearSpringValues), ...
    max(Study.rearSpringValues));

fprintf('Front Sweep Points      : %10d\n', ...
    length(Study.frontSpringValues));

fprintf('Rear Sweep Points       : %10d\n', ...
    length(Study.rearSpringValues));

fprintf('Total Configurations    : %10d\n', ...
    Study.numberCases);


%% ============================================================
% MODEL VALIDITY
% ============================================================

fprintf('\nMODEL VALIDITY\n');
fprintf('------------------------------------------------------------\n');

fprintf('Fully Valid Cases       : %10d / %d\n', ...
    Study.numberValid, ...
    Study.numberCases);

fprintf('Valid Fraction          : %10.1f %%\n', ...
    100 * Study.validFraction);

fprintf('Front Minimum RH        : %10.2f mm\n', ...
    Study.frontMinimumRH);

fprintf('Rear Minimum RH         : %10.2f mm\n', ...
    Study.rearMinimumRH);


%% ============================================================
% COMPLETE CALCULATED RANGE
% ============================================================

fprintf('\nCALCULATED PERFORMANCE RANGE\n');
fprintf('------------------------------------------------------------\n');

fprintf('Downforce               : %8.1f to %8.1f N\n', ...
    min(R.downforce(:),[],'omitnan'), ...
    max(R.downforce(:),[],'omitnan'));

fprintf('Front Ride Height       : %8.3f to %8.3f mm\n', ...
    min(R.frontRideHeight(:),[],'omitnan'), ...
    max(R.frontRideHeight(:),[],'omitnan'));

fprintf('Rear Ride Height        : %8.3f to %8.3f mm\n', ...
    min(R.rearRideHeight(:),[],'omitnan'), ...
    max(R.rearRideHeight(:),[],'omitnan'));

fprintf('Understeer Gradient     : %8.5f to %8.5f deg/g\n', ...
    min(R.understeerGradient(:),[],'omitnan'), ...
    max(R.understeerGradient(:),[],'omitnan'));


%% ============================================================
% MAXIMUM VALID DOWNFORCE
% ============================================================

fprintf('\nMAXIMUM DOWNFORCE WITHIN VALID REGION\n');
fprintf('------------------------------------------------------------\n');


if isnan(Study.maximumValidDownforce)

    fprintf('No fully valid configuration found.\n');

else

    fprintf('Front Spring            : %10.1f N/mm\n', ...
        Study.maxDownforceFrontSpring);

    fprintf('Rear Spring             : %10.1f N/mm\n', ...
        Study.maxDownforceRearSpring);

    fprintf('Downforce               : %10.1f N\n', ...
        Study.maximumValidDownforce);

    fprintf('Front Ride Height       : %10.3f mm\n', ...
        Study.maxDownforceFrontRH);

    fprintf('Rear Ride Height        : %10.3f mm\n', ...
        Study.maxDownforceRearRH);

    fprintf('Understeer Gradient     : %10.5f deg/g\n', ...
        Study.maxDownforceUndersteerGradient);

end


fprintf('\nIMPORTANT\n');
fprintf('------------------------------------------------------------\n');
fprintf('Maximum valid downforce is a grid-search result only.\n');
fprintf('It is NOT a complete vehicle setup optimisation.\n');


fprintf('============================================================\n');

end