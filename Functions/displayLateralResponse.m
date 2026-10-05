function displayLateralResponse(Response, Bicycle)
%DISPLAYLATERALRESPONSE
% Display Stage 3.3 steady-state bicycle-model response.


fprintf('\n');
fprintf('============================================\n');
fprintf('     STEADY-STATE RESPONSE - STAGE 3.3\n');
fprintf('============================================\n');


%% ============================================================
%  INPUT CONDITION
%  ============================================================

fprintf('\nINPUT CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Speed             : %8.2f m/s\n', ...
    Bicycle.speed);

fprintf('Vehicle Speed             : %8.1f km/h\n', ...
    Bicycle.speed * 3.6);

fprintf('Road-Wheel Steering Angle : %8.3f deg\n', ...
    rad2deg(Bicycle.delta));


%% ============================================================
%  VEHICLE RESPONSE
%  ============================================================

fprintf('\nVEHICLE RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('CG Sideslip Angle         : %+8.4f deg\n', ...
    rad2deg(Response.beta));

fprintf('Yaw Rate                  : %+8.4f rad/s\n', ...
    Response.yawRate);

fprintf('Yaw Rate                  : %+8.2f deg/s\n', ...
    rad2deg(Response.yawRate));

fprintf('Lateral Acceleration      : %+8.3f m/s^2\n', ...
    Response.ay);

fprintf('Lateral Acceleration      : %+8.3f g\n', ...
    Response.ay / 9.81);


%% ============================================================
%  SLIP ANGLES
%  ============================================================

fprintf('\nSLIP ANGLES\n');
fprintf('--------------------------------------------\n');

fprintf('Front Slip Angle          : %+8.4f deg\n', ...
    rad2deg(Response.alphaFront));

fprintf('Rear Slip Angle           : %+8.4f deg\n', ...
    rad2deg(Response.alphaRear));


%% ============================================================
%  LATERAL FORCES
%  ============================================================

fprintf('\nLATERAL FORCES\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle                : %+8.1f N\n', ...
    Response.FyFront);

fprintf('Rear Axle                 : %+8.1f N\n', ...
    Response.FyRear);

fprintf('Total                     : %+8.1f N\n', ...
    Response.FyFront + Response.FyRear);


%% ============================================================
%  MODEL VALIDATION
%  ============================================================

fprintf('\nEQUILIBRIUM VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Required Lateral Force    : %+10.3f N\n', ...
    Response.lateralForceDemand);

fprintf('Calculated Lateral Force  : %+10.3f N\n', ...
    Response.lateralForceAvailable);

fprintf('Force Balance Error       : %+10.6f N\n', ...
    Response.forceError);

fprintf('Yaw Moment Error          : %+10.6f Nm\n', ...
    Response.yawMomentError);

fprintf('============================================\n');

end