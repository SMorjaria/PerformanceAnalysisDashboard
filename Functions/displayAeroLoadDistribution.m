function displayAeroLoadDistribution(AeroLoad)
%DISPLAYAEROLOADDISTRIBUTION
%
% Stage 4.2
% Displays front/rear and four-corner aerodynamic load
% distribution.


fprintf('\n');
fprintf('============================================\n');
fprintf('    AERO LOAD DISTRIBUTION - STAGE 4.2\n');
fprintf('============================================\n');


%% ============================================================
%  AERODYNAMIC BALANCE
%  ============================================================

fprintf('\n');

fprintf('AERODYNAMIC BALANCE\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Front Aero Balance       : %8.1f %%\n', ...
    AeroLoad.frontBalance * 100);

fprintf( ...
    'Rear Aero Balance        : %8.1f %%\n', ...
    AeroLoad.rearBalance * 100);


%% ============================================================
%  AXLE AERODYNAMIC LOADS
%  ============================================================

fprintf('\n');

fprintf('AXLE AERODYNAMIC LOADS\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Front Axle Aero Load     : %8.1f N\n', ...
    AeroLoad.frontLoad);

fprintf( ...
    'Rear Axle Aero Load      : %8.1f N\n', ...
    AeroLoad.rearLoad);

fprintf( ...
    'Total Aero Load          : %8.1f N\n', ...
    AeroLoad.totalDownforce);


%% ============================================================
%  FOUR-CORNER AERODYNAMIC LOADS
%  ============================================================

fprintf('\n');

fprintf('FOUR-CORNER AERODYNAMIC LOADS\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Front Left               : %8.1f N\n', ...
    AeroLoad.FL);

fprintf( ...
    'Front Right              : %8.1f N\n', ...
    AeroLoad.FR);

fprintf( ...
    'Rear Left                : %8.1f N\n', ...
    AeroLoad.RL);

fprintf( ...
    'Rear Right               : %8.1f N\n', ...
    AeroLoad.RR);


%% ============================================================
%  VALIDATION
%  ============================================================

fprintf('\n');

fprintf('VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Distributed Aero Load    : %8.1f N\n', ...
    AeroLoad.totalDistributedLoad);

fprintf( ...
    'Load Conservation Error  : %12.6f N\n', ...
    AeroLoad.loadConservationError);

fprintf('============================================\n');


end