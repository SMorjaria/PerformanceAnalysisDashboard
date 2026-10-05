function validateVehicle(Vehicle)
%VALIDATEVEHICLE Check vehicle parameters for invalid values.
%
%   validateVehicle(Vehicle)
%
%   The function stops execution using ERROR if an invalid
%   vehicle parameter is detected.
%
% ============================================================


%% MASS

if Vehicle.mass <= 0

    error('Vehicle mass must be greater than zero.');

end


%% WHEELBASE

if Vehicle.wheelbase <= 0

    error('Vehicle wheelbase must be greater than zero.');

end


%% TRACK WIDTH

if Vehicle.trackFront <= 0 || Vehicle.trackRear <= 0

    error('Vehicle track widths must be greater than zero.');

end


%% CG HEIGHT

if Vehicle.cgHeight <= 0

    error('CG height must be greater than zero.');

end


%% WEIGHT DISTRIBUTION

if Vehicle.frontWeightDistribution <= 0 || ...
        Vehicle.frontWeightDistribution >= 1

    error(['Front weight distribution must be expressed ', ...
        'as a fraction between 0 and 1.']);

end


%% YAW INERTIA

if Vehicle.yawInertia <= 0

    error('Yaw moment of inertia must be greater than zero.');

end


end