function displayAeroMapState(AeroState)
%DISPLAYAEROMAPSTATE
%
% Stage 4.3
% Displays the aerodynamic state predicted by the
% ride-height / rake surrogate aero map.


fprintf('\n');
fprintf('============================================\n');
fprintf('       AERO PLATFORM MAP - STAGE 4.3\n');
fprintf('============================================\n');


%% ============================================================
%  PLATFORM
%  ============================================================

fprintf('\n');

fprintf('VEHICLE PLATFORM\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Front Ride Height        : %8.1f mm\n', ...
    AeroState.frontRideHeight);

fprintf( ...
    'Rear Ride Height         : %8.1f mm\n', ...
    AeroState.rearRideHeight);

fprintf( ...
    'Ride Height Delta        : %8.1f mm\n', ...
    AeroState.rideHeightDelta);

fprintf( ...
    'Rake Angle               : %8.3f deg\n', ...
    AeroState.rakeAngleDeg);


%% ============================================================
%  AERODYNAMIC STATE
%  ============================================================

fprintf('\n');

fprintf('AERODYNAMIC STATE\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Lift Coefficient         : %8.3f\n', ...
    AeroState.CL);

fprintf( ...
    'Drag Coefficient         : %8.3f\n', ...
    AeroState.CD);

fprintf( ...
    'CL / CD                  : %8.3f\n', ...
    AeroState.CLtoCD);

fprintf( ...
    'Front Aero Balance       : %8.2f %%\n', ...
    AeroState.frontBalance * 100);

fprintf( ...
    'Rear Aero Balance        : %8.2f %%\n', ...
    AeroState.rearBalance * 100);

fprintf('============================================\n');


end