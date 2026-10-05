function displaySetupSensitivity(Study)
%DISPLAYSETUPSENSITIVITY
%
% Stage 6.3 - Setup Sensitivity Summary


R = Study.Results;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' SETUP SENSITIVITY ANALYSIS - STAGE 6.3\n');
fprintf('============================================================\n');


fprintf('\nSWEEP DEFINITION\n');
fprintf('------------------------------------------------------------\n');

fprintf('Parameter                : %s\n', ...
    Study.parameterName);

fprintf('Minimum Value            : %.3f\n', ...
    min(Study.parameterValues));

fprintf('Maximum Value            : %.3f\n', ...
    max(Study.parameterValues));

fprintf('Number of Points         : %d\n', ...
    Study.numberPoints);

fprintf('Baseline Value           : %.3f\n', ...
    Study.baselineValue);


fprintf('\nMODEL VALIDITY\n');
fprintf('------------------------------------------------------------\n');

fprintf('Fully Valid Cases        : %d / %d\n', ...
    length(Study.validIndices), ...
    Study.numberPoints);

fprintf('Aero-Map Valid Cases     : %d / %d\n', ...
    length(Study.aeroValidIndices), ...
    Study.numberPoints);


if ~isempty(Study.aeroValidIndices)

    fprintf('Valid Parameter Range    : %.3f to %.3f\n', ...
        Study.minimumValidParameter, ...
        Study.maximumValidParameter);

else

    fprintf('Valid Parameter Range    : NONE\n');

end


fprintf('\nPERFORMANCE RANGE\n');
fprintf('------------------------------------------------------------\n');

fprintf('Downforce                : %.1f to %.1f N\n', ...
    min(R.downforce,[],'omitnan'), ...
    max(R.downforce,[],'omitnan'));

fprintf('Front Ride Height        : %.3f to %.3f mm\n', ...
    min(R.frontRideHeight,[],'omitnan'), ...
    max(R.frontRideHeight,[],'omitnan'));

fprintf('Rear Ride Height         : %.3f to %.3f mm\n', ...
    min(R.rearRideHeight,[],'omitnan'), ...
    max(R.rearRideHeight,[],'omitnan'));

fprintf('Mean Heave               : %.3f to %.3f mm\n', ...
    min(R.heave,[],'omitnan'), ...
    max(R.heave,[],'omitnan'));

fprintf('Understeer Gradient      : %.5f to %.5f deg/g\n', ...
    min(R.understeerGradient,[],'omitnan'), ...
    max(R.understeerGradient,[],'omitnan'));

fprintf('Lateral Acceleration     : %.4f to %.4f g\n', ...
    min(R.lateralAccelerationG,[],'omitnan'), ...
    max(R.lateralAccelerationG,[],'omitnan'));


fprintf('============================================================\n');

end