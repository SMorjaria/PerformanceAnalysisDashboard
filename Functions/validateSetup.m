function validateSetup(Setup)
%VALIDATESETUP Check vehicle setup parameters.
%
%   validateSetup(Setup)
%
% ============================================================


%% SPRING RATES

if Setup.springFront <= 0 || Setup.springRear <= 0

    error('Spring rates must be greater than zero.');

end


%% ANTI-ROLL BAR RATES

if Setup.arbFront < 0 || Setup.arbRear < 0

    error('Anti-roll bar rates cannot be negative.');

end


%% RIDE HEIGHT

if Setup.rideHeightFront <= 0 || Setup.rideHeightRear <= 0

    error('Ride heights must be greater than zero.');

end


%% BRAKE BIAS

if Setup.brakeBias <= 0 || Setup.brakeBias >= 1

    error('Brake bias must be between 0 and 1.');

end


%% AERO BALANCE

if Setup.aeroBalance <= 0 || Setup.aeroBalance >= 1

    error('Aerodynamic balance must be between 0 and 1.');

end


%% MOTION RATIOS

if Setup.motionRatioFront <= 0 || ...
        Setup.motionRatioRear <= 0

    error('Motion ratios must be greater than zero.');

end


%% AERODYNAMIC COEFFICIENTS

if Setup.CL < 0

    error(['CL cannot be negative using the current ', ...
        'downforce convention.']);

end


if Setup.CD < 0

    error('CD cannot be negative.');

end


end