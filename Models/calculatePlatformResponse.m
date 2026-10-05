function Platform = calculatePlatformResponse( ...
    Vehicle, Setup, Ride)
%CALCULATEPLATFORMRESPONSE
%
% Stage 5.3 - Heave & Pitch Platform Decomposition
%
% Decomposes front and rear suspension displacement into
% first-order vehicle heave and pitch behaviour.
%
% Sign convention:
%
%   Positive compression = vehicle moves downward
%
%   Positive pitch change = increasing rake
%   Negative pitch change = decreasing rake
%
% This is a quasi-static platform decomposition rather than
% a transient sprung-mass dynamics model.


%% ============================================================
%  1. AXLE DISPLACEMENTS
%  ============================================================

zFront = Ride.frontCompression;     % [mm]
zRear  = Ride.rearCompression;      % [mm]


%% ============================================================
%  2. HEAVE DISPLACEMENT
%  ============================================================
%
% First-order mean axle displacement.
%

heave = (zFront + zRear) / 2;


%% ============================================================
%  3. DIFFERENTIAL AXLE DISPLACEMENT
%  ============================================================

differentialDisplacement = ...
    zRear - zFront;


%% ============================================================
%  4. PITCH ANGLE CHANGE
%  ============================================================
%
% Rear compression greater than front compression reduces
% rear ride height relative to the front and therefore reduces
% rake.
%
% Positive pitch change is defined as increasing rake.
%

pitchAngleChange = atan( ...
    ((zFront - zRear) / 1000) / ...
    Vehicle.wheelbase);

pitchAngleChangeDeg = ...
    rad2deg(pitchAngleChange);


%% ============================================================
%  5. STATIC PLATFORM
%  ============================================================

staticRideHeightDelta = ...
    Setup.rideHeightRear - ...
    Setup.rideHeightFront;


staticRakeAngle = atan( ...
    (staticRideHeightDelta / 1000) / ...
    Vehicle.wheelbase);

staticRakeAngleDeg = ...
    rad2deg(staticRakeAngle);


%% ============================================================
%  6. DYNAMIC PLATFORM
%  ============================================================

dynamicFrontRideHeight = ...
    Setup.rideHeightFront - zFront;

dynamicRearRideHeight = ...
    Setup.rideHeightRear - zRear;


dynamicRideHeightDelta = ...
    dynamicRearRideHeight - ...
    dynamicFrontRideHeight;


dynamicRakeAngle = atan( ...
    (dynamicRideHeightDelta / 1000) / ...
    Vehicle.wheelbase);

dynamicRakeAngleDeg = ...
    rad2deg(dynamicRakeAngle);


%% ============================================================
%  7. EXACT RAKE CHANGE
%  ============================================================
%
% Difference between the actual static and dynamic platform
% angles.
%

exactRakeChange = ...
    dynamicRakeAngle - staticRakeAngle;

exactRakeChangeDeg = ...
    rad2deg(exactRakeChange);


%% ============================================================
%  8. STORE RESULTS
%  ============================================================

Platform.frontCompression = zFront;
Platform.rearCompression = zRear;

Platform.heave = heave;

Platform.differentialDisplacement = ...
    differentialDisplacement;

Platform.pitchAngleChange = ...
    pitchAngleChange;

Platform.pitchAngleChangeDeg = ...
    pitchAngleChangeDeg;

Platform.staticFrontRideHeight = ...
    Setup.rideHeightFront;

Platform.staticRearRideHeight = ...
    Setup.rideHeightRear;

Platform.dynamicFrontRideHeight = ...
    dynamicFrontRideHeight;

Platform.dynamicRearRideHeight = ...
    dynamicRearRideHeight;

Platform.staticRideHeightDelta = ...
    staticRideHeightDelta;

Platform.dynamicRideHeightDelta = ...
    dynamicRideHeightDelta;

Platform.staticRakeAngle = ...
    staticRakeAngle;

Platform.staticRakeAngleDeg = ...
    staticRakeAngleDeg;

Platform.dynamicRakeAngle = ...
    dynamicRakeAngle;

Platform.dynamicRakeAngleDeg = ...
    dynamicRakeAngleDeg;

Platform.exactRakeChange = ...
    exactRakeChange;

Platform.exactRakeChangeDeg = ...
    exactRakeChangeDeg;


%% ============================================================
%  9. RECONSTRUCTION
%  ============================================================
%
% Using:
%
%   heave = (zF + zR)/2
%   differential = zR - zF
%
% Therefore:
%
%   zF = heave - differential/2
%   zR = heave + differential/2
%

Platform.reconstructedFrontCompression = ...
    heave - differentialDisplacement / 2;

Platform.reconstructedRearCompression = ...
    heave + differentialDisplacement / 2;


Platform.frontReconstructionError = ...
    Platform.reconstructedFrontCompression - ...
    zFront;

Platform.rearReconstructionError = ...
    Platform.reconstructedRearCompression - ...
    zRear;


end