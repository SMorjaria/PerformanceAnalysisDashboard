function Vehicle = createVehicle()
%CREATEVEHICLE Define the baseline vehicle parameters.
%
%   Vehicle = createVehicle()
%
%   Outputs:
%       Vehicle - Structure containing fundamental vehicle
%                 parameters.
%
%   NOTE:
%   The values used here represent a generic high-performance
%   single-seater and do not represent a specific vehicle.
%
% ============================================================


%% VEHICLE MASS

Vehicle.mass = 800;                     % [kg]


%% VEHICLE DIMENSIONS

Vehicle.wheelbase  = 3.60;              % [m]

Vehicle.trackFront = 1.60;              % [m]
Vehicle.trackRear  = 1.55;              % [m]


%% CENTRE OF GRAVITY

Vehicle.cgHeight = 0.30;                % [m]

Vehicle.frontWeightDistribution = 0.45; % [-]


%% INERTIA

Vehicle.yawInertia = 1100;              % [kg m^2]

%% ============================================================
%  AERODYNAMIC REFERENCE GEOMETRY
%  ============================================================

Vehicle.referenceArea = 1.50;     % [m^2]
end