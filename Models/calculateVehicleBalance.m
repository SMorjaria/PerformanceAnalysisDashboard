function Balance = calculateVehicleBalance( ...
    Bicycle, Cornering, Response, Constants)
%CALCULATEVEHICLEBALANCE
% Calculate steady-state understeer gradient and vehicle
% balance metrics from the linear bicycle model.
%
% Steering relationship:
%
%   delta = L/R + Kus*ay
%
% where:
%
%   Kus > 0  -> understeer
%   Kus = 0  -> neutral steer
%   Kus < 0  -> oversteer


%% ============================================================
%  MODEL PARAMETERS
%  ============================================================

m = Bicycle.mass;

L = Bicycle.L;
a = Bicycle.a;
b = Bicycle.b;

V = Bicycle.speed;
delta = Bicycle.delta;

Cf = Cornering.CalphaFront;
Cr = Cornering.CalphaRear;

ay = Response.ay;
r  = Response.yawRate;


%% ============================================================
%  UNDERSTEER GRADIENT
%  ============================================================

Kus = (1/L) * ...
    ( ...
    (m*b / Cf) ...
    - ...
    (m*a / Cr) ...
    );


%% ============================================================
%  UNIT CONVERSION
%  ============================================================

Kus_deg_per_g = ...
    Kus * Constants.g * 180/pi;


%% ============================================================
%  VEHICLE BALANCE CLASSIFICATION
%  ============================================================

tolerance = 1e-6;

if Kus > tolerance

    balanceType = 'Understeer';

elseif Kus < -tolerance

    balanceType = 'Oversteer';

else

    balanceType = 'Neutral Steer';

end


%% ============================================================
%  CORNER RADIUS
%  ============================================================

if abs(r) > 1e-12

    radius = V / r;

else

    radius = Inf;

end


%% ============================================================
%  KINEMATIC STEERING REQUIREMENT
%  ============================================================

if isfinite(radius)

    deltaKinematic = L / radius;

else

    deltaKinematic = 0;

end


%% ============================================================
%  UNDERSTEER STEERING CONTRIBUTION
%  ============================================================

deltaUndersteer = Kus * ay;


%% ============================================================
%  RECONSTRUCT STEERING ANGLE
%  ============================================================

deltaPredicted = ...
    deltaKinematic + ...
    deltaUndersteer;

steeringError = ...
    deltaPredicted - delta;


%% ============================================================
%  YAW-RATE GAIN
%  ============================================================

if abs(delta) > 1e-12

    yawRateGain = r / delta;

else

    yawRateGain = NaN;

end


%% ============================================================
%  LATERAL ACCELERATION GAIN
%  ============================================================

if abs(delta) > 1e-12

    lateralAccelerationGain = ...
        ay / delta;

else

    lateralAccelerationGain = NaN;

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

Balance.Kus = Kus;

Balance.Kus_deg_per_g = ...
    Kus_deg_per_g;

Balance.type = balanceType;

Balance.radius = radius;

Balance.deltaKinematic = ...
    deltaKinematic;

Balance.deltaUndersteer = ...
    deltaUndersteer;

Balance.deltaPredicted = ...
    deltaPredicted;

Balance.steeringError = ...
    steeringError;

Balance.yawRateGain = ...
    yawRateGain;

Balance.lateralAccelerationGain = ...
    lateralAccelerationGain;

end