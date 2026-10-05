function displayCoupledLateralResponse(Coupled)
%DISPLAYCOUPLEDLATERALRESPONSE
% Display Stage 3.5 coupled lateral dynamics results.


fprintf('\n');
fprintf('============================================\n');
fprintf('       COUPLED RESPONSE - STAGE 3.5\n');
fprintf('============================================\n');


%% ============================================================
%  SOLVER
%  ============================================================

fprintf('\nSOLVER STATUS\n');
fprintf('--------------------------------------------\n');

if Coupled.converged

    fprintf('Convergence               : PASS\n');

else

    fprintf('Convergence               : FAIL\n');

end

fprintf('Iterations                : %8d\n', ...
    Coupled.iterations);


%% ============================================================
%  FINAL LATERAL RESPONSE
%  ============================================================

fprintf('\nFINAL VEHICLE RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Lateral Acceleration      : %+8.4f m/s^2\n', ...
    Coupled.Response.ay);

fprintf('Lateral Acceleration      : %+8.4f g\n', ...
    Coupled.Response.ay / 9.81);

fprintf('Yaw Rate                  : %+8.4f rad/s\n', ...
    Coupled.Response.yawRate);

fprintf('CG Sideslip               : %+8.4f deg\n', ...
    rad2deg(Coupled.Response.beta));


%% ============================================================
%  FINAL TYRE LOADS
%  ============================================================

fprintf('\nFINAL TYRE LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('FL                        : %8.1f N\n', ...
    Coupled.TyreLoads.FL);

fprintf('FR                        : %8.1f N\n', ...
    Coupled.TyreLoads.FR);

fprintf('RL                        : %8.1f N\n', ...
    Coupled.TyreLoads.RL);

fprintf('RR                        : %8.1f N\n', ...
    Coupled.TyreLoads.RR);


%% ============================================================
%  FINAL CORNERING STIFFNESS
%  ============================================================

fprintf('\nFINAL CORNERING STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle                : %10.1f N/rad\n', ...
    Coupled.Cornering.CalphaFront);

fprintf('Rear Axle                 : %10.1f N/rad\n', ...
    Coupled.Cornering.CalphaRear);


%% ============================================================
%  FINAL VEHICLE BALANCE
%  ============================================================

fprintf('\nFINAL VEHICLE BALANCE\n');
fprintf('--------------------------------------------\n');

fprintf('Understeer Gradient       : %+9.4f deg/g\n', ...
    Coupled.Balance.Kus_deg_per_g);

fprintf('Balance Classification   : %s\n', ...
    Coupled.Balance.type);


%% ============================================================
%  FINAL VALIDATION
%  ============================================================

fprintf('\nFINAL EQUILIBRIUM VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Force Balance Error       : %+10.6f N\n', ...
    Coupled.Response.forceError);

fprintf('Yaw Moment Error          : %+10.6f Nm\n', ...
    Coupled.Response.yawMomentError);

fprintf('============================================\n');

end