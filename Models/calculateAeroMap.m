function AeroState = calculateAeroMap( ...
    Vehicle, Setup, AeroMap)
%CALCULATEAEROMAP
%
% Stage 4.3 - Ride-Height / Rake Aerodynamic Map
%
% Calculates aerodynamic coefficients as functions of front
% and rear ride height using a generic surrogate aero map.
%
% Outputs:
%
%   CL
%   CD
%   Front aerodynamic balance
%   Ride-height delta
%   Rake angle


%% ============================================================
%  CURRENT PLATFORM
%  ============================================================

hF = Setup.rideHeightFront;
hR = Setup.rideHeightRear;


%% ============================================================
%  RIDE-HEIGHT DEVIATION FROM NOMINAL PLATFORM
%  ============================================================

dHF = ...
    hF - AeroMap.nominalFrontRH;

dHR = ...
    hR - AeroMap.nominalRearRH;


%% ============================================================
%  PLATFORM GEOMETRY
%  ============================================================

rideHeightDelta = ...
    hR - hF;


% Convert mm to m for rake calculation

rideHeightDelta_m = ...
    rideHeightDelta / 1000;


rakeAngle = ...
    atan( ...
        rideHeightDelta_m / ...
        Vehicle.wheelbase);


rakeAngleDeg = ...
    rad2deg(rakeAngle);


%% ============================================================
%  LIFT COEFFICIENT
%  ============================================================
%
% Generic surrogate:
%
% CL =
% CL0
% + linear front effect
% + linear rear effect
% - quadratic front loss
% - quadratic rear loss
% + front/rear interaction
%

CL = ...
    AeroMap.CL0 ...
    + AeroMap.CL_frontLinear * dHF ...
    + AeroMap.CL_rearLinear  * dHR ...
    - AeroMap.CL_frontQuad * dHF^2 ...
    - AeroMap.CL_rearQuad  * dHR^2 ...
    + AeroMap.CL_cross * dHF * dHR;


%% ============================================================
%  DRAG COEFFICIENT
%  ============================================================

CD = ...
    AeroMap.CD0 ...
    + AeroMap.CD_frontLinear * dHF ...
    + AeroMap.CD_rearLinear  * dHR ...
    + AeroMap.CD_frontQuad * dHF^2 ...
    + AeroMap.CD_rearQuad  * dHR^2;


%% ============================================================
%  FRONT AERODYNAMIC BALANCE
%  ============================================================

frontBalance = ...
    AeroMap.aeroBalance0 ...
    + AeroMap.balanceFrontSensitivity * dHF ...
    + AeroMap.balanceRearSensitivity  * dHR;


%% ============================================================
%  BASIC PHYSICAL LIMITS
%  ============================================================

frontBalance = ...
    max(0,min(1,frontBalance));


if CL <= 0

    warning( ...
        'Calculated CL is zero or negative.');

end


if CD <= 0

    warning( ...
        'Calculated CD is zero or negative.');

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

AeroState.frontRideHeight = hF;
AeroState.rearRideHeight = hR;

AeroState.frontRideHeightDeviation = dHF;
AeroState.rearRideHeightDeviation = dHR;

AeroState.rideHeightDelta = ...
    rideHeightDelta;

AeroState.rakeAngle = ...
    rakeAngle;

AeroState.rakeAngleDeg = ...
    rakeAngleDeg;

AeroState.CL = CL;
AeroState.CD = CD;

AeroState.frontBalance = ...
    frontBalance;

AeroState.rearBalance = ...
    1 - frontBalance;

AeroState.CLtoCD = ...
    CL / CD;


end