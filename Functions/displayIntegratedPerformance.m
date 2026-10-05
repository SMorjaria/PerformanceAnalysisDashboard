function displayIntegratedPerformance(Performance)
%DISPLAYINTEGRATEDPERFORMANCE
%
% Stage 6.1 - Integrated Vehicle Performance Summary


KPI = Performance.KPI;
Status = Performance.Status;


fprintf('\n');
fprintf('============================================================\n');
fprintf(' INTEGRATED VEHICLE PERFORMANCE - STAGE 6.1\n');
fprintf('============================================================\n');


%% ============================================================
%  OPERATING CONDITION
%  ============================================================

fprintf('\nOPERATING CONDITION\n');
fprintf('------------------------------------------------------------\n');

fprintf('Vehicle Speed           : %10.1f km/h\n', ...
    KPI.speedKPH);


%% ============================================================
%  LATERAL PERFORMANCE
%  ============================================================

fprintf('\nLATERAL PERFORMANCE\n');
fprintf('------------------------------------------------------------\n');

fprintf('Lateral Acceleration    : %+10.4f g\n', ...
    KPI.lateralAccelerationG);

fprintf('Yaw Rate                : %+10.3f deg/s\n', ...
    KPI.yawRateDeg);

fprintf('CG Sideslip             : %+10.4f deg\n', ...
    KPI.cgSideslipDeg);

fprintf('Understeer Gradient     : %+10.4f deg/g\n', ...
    KPI.understeerGradient);

fprintf('Vehicle Balance         : %s\n', ...
    KPI.balanceType);


%% ============================================================
%  AERODYNAMIC PERFORMANCE
%  ============================================================

fprintf('\nAERODYNAMIC PERFORMANCE\n');
fprintf('------------------------------------------------------------\n');

fprintf('Lift Coefficient        : %10.4f\n', ...
    KPI.CL);

fprintf('Drag Coefficient        : %10.4f\n', ...
    KPI.CD);

fprintf('Aero Efficiency CL/CD   : %10.4f\n', ...
    KPI.aeroEfficiency);

fprintf('Downforce               : %10.1f N\n', ...
    KPI.downforce);

fprintf('Downforce / Weight      : %10.3f\n', ...
    KPI.downforceToWeight);

fprintf('Front Aero Balance      : %10.2f %%\n', ...
    KPI.aeroBalanceFrontPercent);


%% ============================================================
%  PLATFORM
%  ============================================================

fprintf('\nAERODYNAMIC PLATFORM\n');
fprintf('------------------------------------------------------------\n');

fprintf('Front Ride Height       : %10.3f mm\n', ...
    KPI.frontRideHeight);

fprintf('Rear Ride Height        : %10.3f mm\n', ...
    KPI.rearRideHeight);

fprintf('Front Compression       : %10.3f mm\n', ...
    KPI.frontCompression);

fprintf('Rear Compression        : %10.3f mm\n', ...
    KPI.rearCompression);

fprintf('Mean Heave              : %10.3f mm\n', ...
    KPI.heave);

fprintf('Rake Angle              : %10.4f deg\n', ...
    KPI.rakeAngleDeg);


%% ============================================================
%  SUSPENSION
%  ============================================================

fprintf('\nSUSPENSION\n');
fprintf('------------------------------------------------------------\n');

fprintf('Front Wheel Rate        : %10.2f N/mm\n', ...
    KPI.frontWheelRate);

fprintf('Rear Wheel Rate         : %10.2f N/mm\n', ...
    KPI.rearWheelRate);

fprintf('Total Heave Stiffness   : %10.2f N/mm\n', ...
    KPI.totalHeaveStiffness);


%% ============================================================
%  TYRE / LATERAL CAPABILITY
%  ============================================================

fprintf('\nTYRE / LATERAL MODEL\n');
fprintf('------------------------------------------------------------\n');

fprintf('Front Cornering Stiff.  : %10.1f N/rad\n', ...
    KPI.frontCorneringStiffness);

fprintf('Rear Cornering Stiff.   : %10.1f N/rad\n', ...
    KPI.rearCorneringStiffness);


%% ============================================================
%  MODEL STATUS
%  ============================================================

fprintf('\nMODEL STATUS\n');
fprintf('------------------------------------------------------------\n');

fprintf('Aero Map Valid          : %s\n', ...
    passFail(Status.aeroMapValid));

fprintf('Platform Solver         : %s\n', ...
    passFail(Status.platformConverged));

fprintf('Lateral Solver          : %s\n', ...
    passFail(Status.lateralSolverConverged));

fprintf('Vertical Load Check     : %s\n', ...
    passFail(Status.verticalLoadValid));

fprintf('Overall Model Status    : %s\n', ...
    passFail(Status.allValid));


%% ============================================================
%  VALIDATION
%  ============================================================

fprintf('\nVALIDATION\n');
fprintf('------------------------------------------------------------\n');

fprintf('Expected Vertical Load  : %10.3f N\n', ...
    Performance.Validation.expectedVerticalLoad);

fprintf('Calculated Vertical Load: %10.3f N\n', ...
    Performance.Validation.actualVerticalLoad);

fprintf('Vertical Load Error     : %+.3e N\n', ...
    Performance.Validation.verticalLoadError);


fprintf('============================================================\n');


end


%% ============================================================
%  LOCAL FUNCTION
%  ============================================================

function text = passFail(condition)

if condition
    text = 'PASS';
else
    text = 'CHECK';
end

end