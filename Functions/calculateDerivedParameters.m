function Derived = calculateDerivedParameters( ...
    Vehicle, Setup, Operating, Constants)
%CALCULATEDERIVEDPARAMETERS Calculate vehicle and setup quantities.
%
%   Derived = calculateDerivedParameters( ...
%       Vehicle, Setup, Constants)
%
%   Inputs:
%       Vehicle   - Fundamental vehicle parameters
%       Setup     - Adjustable setup parameters
%       Constants - Physical constants
%
%   Outputs:
%       Derived   - Calculated vehicle quantities
%
% ============================================================


%% ============================================================
%  VEHICLE WEIGHT
%  ============================================================

Derived.vehicleWeight = ...
    Vehicle.mass * Constants.g;


%% ============================================================
%  LONGITUDINAL CG POSITION
%  ============================================================

Derived.cgToRear = ...
    Vehicle.frontWeightDistribution * ...
    Vehicle.wheelbase;

Derived.cgToFront = ...
    Vehicle.wheelbase - Derived.cgToRear;
%% ============================================================
%  VEHICLE COORDINATE SYSTEM
%  ============================================================
%
%  Origin:
%       Front axle centre at ground level
%
%  Axes:
%       +X = Front to Rear
%       +Y = Centreline to Vehicle Left
%       +Z = Ground Upwards
%
%  CG coordinates are therefore expressed relative to the
%  front axle centre.
%  ============================================================

Derived.cgX = Derived.cgToFront;

% Baseline vehicle assumed laterally symmetric
Derived.cgY = 0;

Derived.cgZ = Vehicle.cgHeight;

% CG position vector
Derived.cgPosition = [ ...
    Derived.cgX;
    Derived.cgY;
    Derived.cgZ ];

%% ============================================================
%  STATIC AXLE LOADS
%  ============================================================

Derived.frontAxleLoad = ...
    Derived.vehicleWeight * ...
    Vehicle.frontWeightDistribution;

Derived.rearAxleLoad = ...
    Derived.vehicleWeight * ...
    (1 - Vehicle.frontWeightDistribution);


%% ============================================================
%  STATIC CORNER LOADS
%  ============================================================

% Baseline assumption:
% Symmetric left/right static loading.

Derived.FL = ...
    Derived.frontAxleLoad / 2;

Derived.FR = ...
    Derived.frontAxleLoad / 2;

Derived.RL = ...
    Derived.rearAxleLoad / 2;

Derived.RR = ...
    Derived.rearAxleLoad / 2;


%% ============================================================
%  EFFECTIVE SPRING WHEEL RATES
%  ============================================================

% Wheel rate relationship:
%
% k_wheel = k_spring * MR^2

Derived.springWheelRateFront = ...
    Setup.springFront * ...
    Setup.motionRatioFront^2;

Derived.springWheelRateRear = ...
    Setup.springRear * ...
    Setup.motionRatioRear^2;


%% ============================================================
%  RIDE HEIGHT DIFFERENCE
%  ============================================================

Derived.rideHeightDelta = ...
    Setup.rideHeightRear - ...
    Setup.rideHeightFront;


%% ============================================================
%  RAKE ANGLE
%  ============================================================

% Convert ride-height difference from mm to metres.

rideHeightDelta_m = ...
    Derived.rideHeightDelta / 1000;

Derived.rakeAngle = ...
    atan(rideHeightDelta_m / ...
    Vehicle.wheelbase);

% Convert from radians to degrees.

Derived.rakeAngleDeg = ...
    rad2deg(Derived.rakeAngle);

%% ============================================================
%  OPERATING CONDITIONS
%  ============================================================

Derived.speedKPH = Operating.speed * 3.6;

Derived.ax_g = Operating.ax / Constants.g;

Derived.ay_g = Operating.ay / Constants.g;
end