function Operating = createOperatingConditions()
%CREATEOPERATINGCONDITIONS Define vehicle operating conditions.
%
%   Operating = createOperatingConditions()
%
%   Defines the dynamic state used by the vehicle performance
%   calculations.
%
%   Coordinate convention:
%
%       +X = Front to Rear
%       +Y = Centreline to Vehicle Left
%       +Z = Ground Upwards
%
%   Acceleration convention used by the performance model:
%
%       ax > 0 : Acceleration
%       ax < 0 : Braking
%
%       ay > 0 : Left-hand corner
%       ay < 0 : Right-hand corner
%
% ============================================================


%% ============================================================
%  VEHICLE SPEED
%  ============================================================

Operating.speed = 50;               % [m/s]


%% ============================================================
%  LONGITUDINAL ACCELERATION
%  ============================================================

Operating.ax = 0;                   % [m/s^2]


%% ============================================================
%  LATERAL ACCELERATION
%  ============================================================

Operating.ay = 0;                   % [m/s^2]

%% ============================================================
%  FRONT WHEEL STEERING ANGLE
%  ============================================================

% Front road-wheel steering angle
Operating.steerAngle = 2.0;     % [deg]

end