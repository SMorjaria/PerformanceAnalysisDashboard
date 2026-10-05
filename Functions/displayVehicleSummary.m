function displayVehicleSummary(Vehicle, Setup, Derived)
%DISPLAYVEHICLESUMMARY Display baseline vehicle and setup information.
%
%   displayVehicleSummary(Vehicle, Setup, Derived)
%
% ============================================================


fprintf('\n');
fprintf('============================================\n');
fprintf('   VEHICLE PERFORMANCE DEVELOPMENT TOOL\n');
fprintf('============================================\n\n');


%% VEHICLE

fprintf('BASELINE VEHICLE\n');
fprintf('--------------------------------------------\n');

fprintf('Mass:                  %.1f kg\n', ...
    Vehicle.mass);

fprintf('Wheelbase:             %.3f m\n', ...
    Vehicle.wheelbase);

fprintf('Front Track:           %.3f m\n', ...
    Vehicle.trackFront);

fprintf('Rear Track:            %.3f m\n', ...
    Vehicle.trackRear);

fprintf('CG Height:             %.3f m\n', ...
    Vehicle.cgHeight);

fprintf('Front Weight Dist.:    %.1f %%\n', ...
    Vehicle.frontWeightDistribution * 100);

fprintf('Yaw Inertia:           %.1f kg m^2\n', ...
    Vehicle.yawInertia);


%% DERIVED VEHICLE PARAMETERS

fprintf('\n');

fprintf('DERIVED VEHICLE PARAMETERS\n');
fprintf('--------------------------------------------\n');

fprintf('CG from Front Axle:    %.3f m\n', ...
    Derived.cgToFront);

fprintf('CG from Rear Axle:     %.3f m\n', ...
    Derived.cgToRear);

fprintf('Front Axle Load:       %.1f N\n', ...
    Derived.frontAxleLoad);

fprintf('Rear Axle Load:        %.1f N\n', ...
    Derived.rearAxleLoad);


%% CORNER LOADS

fprintf('\n');

fprintf('STATIC CORNER LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('FL: %.1f N     FR: %.1f N\n', ...
    Derived.FL, Derived.FR);

fprintf('RL: %.1f N     RR: %.1f N\n', ...
    Derived.RL, Derived.RR);


%% SETUP

fprintf('\n');

fprintf('VEHICLE SETUP\n');
fprintf('--------------------------------------------\n');

fprintf('Front Spring:          %.1f N/mm\n', ...
    Setup.springFront);

fprintf('Rear Spring:           %.1f N/mm\n', ...
    Setup.springRear);

fprintf('Front ARB:             %.1f N/mm\n', ...
    Setup.arbFront);

fprintf('Rear ARB:              %.1f N/mm\n', ...
    Setup.arbRear);


%% MOTION RATIOS / WHEEL RATES

fprintf('\n');

fprintf('Front Motion Ratio:    %.3f\n', ...
    Setup.motionRatioFront);

fprintf('Rear Motion Ratio:     %.3f\n', ...
    Setup.motionRatioRear);

fprintf('Front Wheel Rate:      %.1f N/mm\n', ...
    Derived.springWheelRateFront);

fprintf('Rear Wheel Rate:       %.1f N/mm\n', ...
    Derived.springWheelRateRear);


%% RIDE HEIGHT

fprintf('\n');

fprintf('Front Ride Height:     %.1f mm\n', ...
    Setup.rideHeightFront);

fprintf('Rear Ride Height:      %.1f mm\n', ...
    Setup.rideHeightRear);

fprintf('Ride Height Delta:     %.1f mm\n', ...
    Derived.rideHeightDelta);

fprintf('Rake Angle:            %.3f deg\n', ...
    Derived.rakeAngleDeg);


%% ALIGNMENT

fprintf('\n');

fprintf('Front Camber:          %.2f deg\n', ...
    Setup.camberFront);

fprintf('Rear Camber:           %.2f deg\n', ...
    Setup.camberRear);

fprintf('Front Toe:             %.2f deg\n', ...
    Setup.toeFront);

fprintf('Rear Toe:              %.2f deg\n', ...
    Setup.toeRear);


%% BRAKES

fprintf('\n');

fprintf('Brake Bias:            %.1f %% Front\n', ...
    Setup.brakeBias * 100);


%% AERODYNAMICS

fprintf('\n');

fprintf('Front Wing Setting:    %.0f\n', ...
    Setup.frontWing);

fprintf('CL:                    %.3f\n', ...
    Setup.CL);

fprintf('CD:                    %.3f\n', ...
    Setup.CD);

fprintf('Aero Balance:          %.1f %% Front\n', ...
    Setup.aeroBalance * 100);


fprintf('\n');
fprintf('============================================\n');


end