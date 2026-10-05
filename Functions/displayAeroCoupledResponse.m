function displayAeroCoupledResponse(AeroCoupled)
%DISPLAYAEROCOUPLEDRESPONSE
%
% Stage 4.5 - Coupled Aerodynamic Vehicle Response
%
% Displays:
%   - Aerodynamic operating state
%   - Mechanical and aerodynamic vertical loading
%   - Combined four-corner tyre loads
%   - Cornering stiffness
%   - Lateral vehicle response
%   - Vehicle balance
%   - Solver and load-conservation validation


%% ============================================================
%  HEADER
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('   AERO-COUPLED RESPONSE - STAGE 4.5\n');
fprintf('============================================\n');


%% ============================================================
%  AERODYNAMIC STATE
%  ============================================================

fprintf('\nAERODYNAMIC STATE\n');
fprintf('--------------------------------------------\n');

fprintf('Speed                  : %8.1f km/h\n', ...
    AeroCoupled.Aero.speedKPH);

fprintf('Lift Coefficient       : %8.3f\n', ...
    AeroCoupled.AeroState.CL);

fprintf('Drag Coefficient       : %8.3f\n', ...
    AeroCoupled.AeroState.CD);

fprintf('Front Aero Balance     : %8.2f %%\n', ...
    AeroCoupled.AeroState.frontBalance * 100);

fprintf('Rear Aero Balance      : %8.2f %%\n', ...
    (1 - AeroCoupled.AeroState.frontBalance) * 100);

fprintf('Total Downforce        : %8.1f N\n', ...
    AeroCoupled.Aero.downforce);


%% ============================================================
%  AERODYNAMIC LOAD DISTRIBUTION
%  ============================================================

fprintf('\nAERODYNAMIC VERTICAL LOADS\n');
fprintf('--------------------------------------------\n');

% Calculate axle totals directly from four-corner aero loads

frontAeroLoad = ...
    AeroCoupled.AeroLoad.FL + ...
    AeroCoupled.AeroLoad.FR;

rearAeroLoad = ...
    AeroCoupled.AeroLoad.RL + ...
    AeroCoupled.AeroLoad.RR;

totalAeroLoad = ...
    frontAeroLoad + rearAeroLoad;


fprintf('Front Axle             : %8.1f N\n', ...
    frontAeroLoad);

fprintf('Rear Axle              : %8.1f N\n', ...
    rearAeroLoad);

fprintf('Total Aero Load        : %8.1f N\n', ...
    totalAeroLoad);


fprintf('\n');

fprintf('Front Left             : %8.1f N\n', ...
    AeroCoupled.AeroLoad.FL);

fprintf('Front Right            : %8.1f N\n', ...
    AeroCoupled.AeroLoad.FR);

fprintf('Rear Left              : %8.1f N\n', ...
    AeroCoupled.AeroLoad.RL);

fprintf('Rear Right             : %8.1f N\n', ...
    AeroCoupled.AeroLoad.RR);

%% ============================================================
%  MECHANICAL VERTICAL LOADS
%  ============================================================

fprintf('\nMECHANICAL VERTICAL LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Left             : %8.1f N\n', ...
    AeroCoupled.MechanicalLoads.FL);

fprintf('Front Right            : %8.1f N\n', ...
    AeroCoupled.MechanicalLoads.FR);

fprintf('Rear Left              : %8.1f N\n', ...
    AeroCoupled.MechanicalLoads.RL);

fprintf('Rear Right             : %8.1f N\n', ...
    AeroCoupled.MechanicalLoads.RR);

fprintf('Mechanical Total       : %8.1f N\n', ...
    AeroCoupled.mechanicalVerticalLoad);


%% ============================================================
%  COMBINED VERTICAL LOADS
%  ============================================================

fprintf('\nCOMBINED VERTICAL LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Left             : %8.1f N\n', ...
    AeroCoupled.TyreLoads.FL);

fprintf('Front Right            : %8.1f N\n', ...
    AeroCoupled.TyreLoads.FR);

fprintf('Rear Left              : %8.1f N\n', ...
    AeroCoupled.TyreLoads.RL);

fprintf('Rear Right             : %8.1f N\n', ...
    AeroCoupled.TyreLoads.RR);

fprintf('\n');

fprintf('Front Axle             : %8.1f N\n', ...
    AeroCoupled.TyreLoads.frontAxle);

fprintf('Rear Axle              : %8.1f N\n', ...
    AeroCoupled.TyreLoads.rearAxle);

fprintf('Total Vertical Load    : %8.1f N\n', ...
    AeroCoupled.TyreLoads.totalVerticalLoad);


%% ============================================================
%  CORNERING STIFFNESS
%  ============================================================

fprintf('\nAERO-LOADED CORNERING STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle             : %8.1f N/rad\n', ...
    AeroCoupled.Cornering.CalphaFront);

fprintf('Rear Axle              : %8.1f N/rad\n', ...
    AeroCoupled.Cornering.CalphaRear);

fprintf('Total                  : %8.1f N/rad\n', ...
    AeroCoupled.Cornering.CalphaFront + ...
    AeroCoupled.Cornering.CalphaRear);


%% ============================================================
%  LATERAL RESPONSE
%  ============================================================

fprintf('\nLATERAL RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Lateral Acceleration   : %+8.4f m/s^2\n', ...
    AeroCoupled.Response.ay);

fprintf('Lateral Acceleration   : %+8.4f g\n', ...
    AeroCoupled.Response.ay / 9.81);

fprintf('Yaw Rate               : %+8.4f rad/s\n', ...
    AeroCoupled.Response.yawRate);

fprintf('Yaw Rate               : %+8.3f deg/s\n', ...
    rad2deg(AeroCoupled.Response.yawRate));

fprintf('CG Sideslip            : %+8.4f deg\n', ...
    rad2deg(AeroCoupled.Response.beta));

fprintf('Front Slip Angle       : %+8.4f deg\n', ...
    rad2deg(AeroCoupled.Response.alphaFront));

fprintf('Rear Slip Angle        : %+8.4f deg\n', ...
    rad2deg(AeroCoupled.Response.alphaRear));


%% ============================================================
%  VEHICLE BALANCE
%  ============================================================

fprintf('\nVEHICLE BALANCE\n');
fprintf('--------------------------------------------\n');

fprintf('Understeer Gradient    : %+8.4f deg/g\n', ...
    AeroCoupled.Balance.Kus_deg_per_g);

fprintf('Balance Classification : %s\n', ...
    AeroCoupled.Balance.type);

fprintf('Corner Radius          : %8.2f m\n', ...
    AeroCoupled.Balance.radius);


%% ============================================================
%  EQUILIBRIUM VALIDATION
%  ============================================================

fprintf('\nEQUILIBRIUM VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Force Balance Error    : %+12.6f N\n', ...
    AeroCoupled.Response.forceError);

fprintf('Yaw Moment Error       : %+12.6f Nm\n', ...
    AeroCoupled.Response.yawMomentError);


%% ============================================================
%  SOLVER VALIDATION
%  ============================================================

fprintf('\nSOLVER VALIDATION\n');
fprintf('--------------------------------------------\n');

if AeroCoupled.converged
    fprintf('Convergence             : PASS\n');
else
    fprintf('Convergence             : FAIL\n');
end

fprintf('Iterations              : %8d\n', ...
    AeroCoupled.iterations);

fprintf('Final Coupling Error    : %12.8f m/s^2\n', ...
    AeroCoupled.finalCouplingError);


%% ============================================================
%  LOAD CONSERVATION
%  ============================================================

fprintf('\nLOAD CONSERVATION\n');
fprintf('--------------------------------------------\n');

fprintf('Mechanical Load        : %8.1f N\n', ...
    AeroCoupled.mechanicalVerticalLoad);

fprintf('Aerodynamic Load       : %8.1f N\n', ...
    AeroCoupled.AeroLoad.totalDownforce);

fprintf('Expected Total Load    : %8.1f N\n', ...
    AeroCoupled.expectedVerticalLoad);

fprintf('Calculated Total Load  : %8.1f N\n', ...
    AeroCoupled.TyreLoads.totalVerticalLoad);

fprintf('Load Conservation Error: %12.8f N\n', ...
    AeroCoupled.loadConservationError);


fprintf('============================================\n');

end