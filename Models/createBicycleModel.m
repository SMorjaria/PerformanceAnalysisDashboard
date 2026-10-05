function Bicycle = createBicycleModel(Vehicle, Operating)
%CREATEBICYCLEMODEL
% Create the geometric and operating parameters required
% for the single-track (bicycle) lateral dynamics model.


%% ============================================================
%  VEHICLE GEOMETRY
%  ============================================================

Bicycle.L = Vehicle.wheelbase;

% Distance from CG to front axle
Bicycle.a = ...
    Vehicle.wheelbase * ...
    (1 - Vehicle.frontWeightDistribution);

% Distance from CG to rear axle
Bicycle.b = ...
    Vehicle.wheelbase * ...
    Vehicle.frontWeightDistribution;


%% ============================================================
%  VEHICLE PROPERTIES
%  ============================================================

Bicycle.mass = Vehicle.mass;

Bicycle.Iz = Vehicle.yawInertia;


%% ============================================================
%  OPERATING CONDITION
%  ============================================================

Bicycle.speed = Operating.speed;

% Convert road-wheel steering angle to radians
Bicycle.delta = deg2rad(Operating.steerAngle);


%% ============================================================
%  GEOMETRY VALIDATION
%  ============================================================

Bicycle.geometryError = ...
    (Bicycle.a + Bicycle.b) - Bicycle.L;

if abs(Bicycle.geometryError) > 1e-9

    warning( ...
        'Bicycle-model geometry does not satisfy a + b = L.');

end


%% ============================================================
%  OPERATING CONDITION VALIDATION
%  ============================================================

if Bicycle.speed <= 0

    warning( ...
        ['Bicycle model requires positive vehicle speed ', ...
        'for slip-angle calculations.']);

end

end