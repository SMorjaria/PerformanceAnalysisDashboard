function displayVehicleBalance( ...
    Balance, Bicycle, Response)
%DISPLAYVEHICLEBALANCE
% Display Stage 3.4 vehicle balance results.


fprintf('\n');
fprintf('============================================\n');
fprintf('       VEHICLE BALANCE - STAGE 3.4\n');
fprintf('============================================\n');


%% ============================================================
%  BALANCE CHARACTERISTIC
%  ============================================================

fprintf('\nBALANCE CHARACTERISTIC\n');
fprintf('--------------------------------------------\n');

fprintf('Understeer Gradient       : %+9.6f rad/(m/s^2)\n', ...
    Balance.Kus);

fprintf('Understeer Gradient       : %+9.4f deg/g\n', ...
    Balance.Kus_deg_per_g);

fprintf('Balance Classification   : %s\n', ...
    Balance.type);


%% ============================================================
%  CORNERING CONDITION
%  ============================================================

fprintf('\nCORNERING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Speed             : %9.2f m/s\n', ...
    Bicycle.speed);

fprintf('Lateral Acceleration      : %+9.3f m/s^2\n', ...
    Response.ay);

fprintf('Corner Radius             : %9.2f m\n', ...
    Balance.radius);


%% ============================================================
%  STEERING REQUIREMENT
%  ============================================================

fprintf('\nSTEERING REQUIREMENT\n');
fprintf('--------------------------------------------\n');

fprintf('Kinematic Steering        : %+9.4f deg\n', ...
    rad2deg(Balance.deltaKinematic));

fprintf('Balance Contribution      : %+9.4f deg\n', ...
    rad2deg(Balance.deltaUndersteer));

fprintf('Predicted Steering        : %+9.4f deg\n', ...
    rad2deg(Balance.deltaPredicted));

fprintf('Actual Steering Input     : %+9.4f deg\n', ...
    rad2deg(Bicycle.delta));

fprintf('Steering Reconstruction Error : %+9.6f deg\n', ...
    rad2deg(Balance.steeringError));


%% ============================================================
%  RESPONSE GAINS
%  ============================================================

fprintf('\nRESPONSE GAINS\n');
fprintf('--------------------------------------------\n');

fprintf('Yaw Rate Gain             : %9.4f (rad/s)/rad\n', ...
    Balance.yawRateGain);

fprintf('Lateral Accel. Gain       : %9.4f (m/s^2)/rad\n', ...
    Balance.lateralAccelerationGain);

fprintf('============================================\n');

end