function Response = calculateSteadyStateLateralResponse( ...
    Bicycle, Cornering)
%CALCULATESTEADYSTATELATERALRESPONSE
% Calculate steady-state lateral response using a linear
% single-track bicycle model.
%
% Inputs:
%   Bicycle  - Vehicle geometry and operating condition
%   Cornering - Front/rear axle cornering stiffness
%
% Outputs include:
%   beta       - CG sideslip angle
%   yawRate    - Vehicle yaw rate
%   alphaFront - Front axle slip angle
%   alphaRear  - Rear axle slip angle
%   FyFront    - Front axle lateral force
%   FyRear     - Rear axle lateral force
%   ay         - Lateral acceleration


%% ============================================================
%  MODEL PARAMETERS
%  ============================================================

m = Bicycle.mass;
Iz = Bicycle.Iz;

a = Bicycle.a;
b = Bicycle.b;

V = Bicycle.speed;
delta = Bicycle.delta;

Cf = Cornering.CalphaFront;
Cr = Cornering.CalphaRear;


%% ============================================================
%  INPUT VALIDATION
%  ============================================================

if V <= 0
    error('Vehicle speed must be greater than zero.');
end

if Cf <= 0 || Cr <= 0
    error('Front and rear cornering stiffness must be positive.');
end


%% ============================================================
%  STEADY-STATE LINEAR SYSTEM
%  ============================================================
%
% Unknown state vector:
%
%       x = [ beta
%             r    ]
%
% From:
%
% m*V*r = FyF + FyR
%
% 0 = a*FyF - b*FyR
%
% with:
%
% FyF = Cf*(delta - beta - a*r/V)
%
% FyR = Cr*(-beta + b*r/V)
%
% Rearranging gives:
%
% A*x = B


A11 = Cf + Cr;

A12 = ...
    m*V + ...
    (Cf*a - Cr*b)/V;

A21 = ...
    a*Cf - b*Cr;

A22 = ...
    (a^2*Cf + b^2*Cr)/V;


A = [ ...
    A11, A12;
    A21, A22];


B = [ ...
    Cf*delta;
    a*Cf*delta];


%% ============================================================
%  SOLVE FOR BETA AND YAW RATE
%  ============================================================

x = A \ B;

beta = x(1);
r = x(2);


%% ============================================================
%  FRONT AND REAR SLIP ANGLES
%  ============================================================

alphaFront = ...
    delta ...
    - beta ...
    - (a*r/V);

alphaRear = ...
    -beta ...
    + (b*r/V);


%% ============================================================
%  LATERAL TYRE FORCES
%  ============================================================

FyFront = Cf * alphaFront;

FyRear = Cr * alphaRear;


%% ============================================================
%  LATERAL ACCELERATION
%  ============================================================

ay = V * r;


%% ============================================================
%  VALIDATION - FORCE EQUILIBRIUM
%  ============================================================

lateralForceDemand = m * ay;

lateralForceAvailable = ...
    FyFront + FyRear;

forceError = ...
    lateralForceAvailable ...
    - lateralForceDemand;


%% ============================================================
%  VALIDATION - YAW MOMENT EQUILIBRIUM
%  ============================================================

yawMoment = ...
    a*FyFront ...
    - b*FyRear;


%% ============================================================
%  STORE RESULTS
%  ============================================================

Response.beta = beta;
Response.yawRate = r;

Response.alphaFront = alphaFront;
Response.alphaRear = alphaRear;

Response.FyFront = FyFront;
Response.FyRear = FyRear;

Response.ay = ay;

Response.lateralForceDemand = lateralForceDemand;
Response.lateralForceAvailable = lateralForceAvailable;

Response.forceError = forceError;
Response.yawMomentError = yawMoment;

end