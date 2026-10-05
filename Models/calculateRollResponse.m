function Roll = calculateRollResponse( ...
    Vehicle, Setup, Suspension, lateralAcceleration)
%CALCULATEROLLRESPONSE
%
% Stage 5.4 - Quasi-Static Roll Response
%
% Calculates first-order vehicle roll response from lateral
% acceleration using the existing spring and anti-roll-bar
% stiffness architecture.
%
% Sign convention:
%
%   ay > 0  = left-hand corner
%
%   Positive roll angle represents body roll towards the
%   outside of the left-hand corner.
%
% The model is quasi-static and does not yet include:
%   - roll-centre geometry
%   - geometric load transfer
%   - tyre vertical stiffness
%   - damper effects
%   - transient roll dynamics
%
% These limitations should be retained when interpreting the
% absolute roll-angle magnitude.


%% ============================================================
%  1. INPUT CONDITION
%  ============================================================

Roll.lateralAcceleration = lateralAcceleration;


%% ============================================================
%  2. ROLL MOMENT
%  ============================================================
%
% First-order inertial roll moment:
%
%   M_phi = m * ay * h_CG
%

Roll.rollMoment = ...
    Vehicle.mass * ...
    lateralAcceleration * ...
    Vehicle.cgHeight;


%% ============================================================
%  3. CONVERT STIFFNESS TO SI UNITS
%  ============================================================
%
% Suspension rates are stored in N/mm.
%
% Convert to N/m before calculating Nm/rad roll stiffness.
%

wheelRateFrontSI = ...
    Suspension.wheelRateFront * 1000;

wheelRateRearSI = ...
    Suspension.wheelRateRear * 1000;

arbRateFrontSI = ...
    Setup.arbFront * 1000;

arbRateRearSI = ...
    Setup.arbRear * 1000;


%% ============================================================
%  4. SPRING ROLL STIFFNESS
%  ============================================================
%
% For equal and opposite wheel displacement:
%
%   K_phi = k_wheel * t^2 / 2
%

Roll.springRollStiffnessFront = ...
    wheelRateFrontSI * ...
    Vehicle.trackFront^2 / 2;

Roll.springRollStiffnessRear = ...
    wheelRateRearSI * ...
    Vehicle.trackRear^2 / 2;


%% ============================================================
%  5. ANTI-ROLL-BAR ROLL STIFFNESS
%  ============================================================

Roll.arbRollStiffnessFront = ...
    arbRateFrontSI * ...
    Vehicle.trackFront^2 / 2;

Roll.arbRollStiffnessRear = ...
    arbRateRearSI * ...
    Vehicle.trackRear^2 / 2;


%% ============================================================
%  6. TOTAL AXLE ROLL STIFFNESS
%  ============================================================

Roll.rollStiffnessFront = ...
    Roll.springRollStiffnessFront + ...
    Roll.arbRollStiffnessFront;

Roll.rollStiffnessRear = ...
    Roll.springRollStiffnessRear + ...
    Roll.arbRollStiffnessRear;

Roll.totalRollStiffness = ...
    Roll.rollStiffnessFront + ...
    Roll.rollStiffnessRear;


%% ============================================================
%  7. ROLL STIFFNESS DISTRIBUTION
%  ============================================================

Roll.frontRollDistribution = ...
    Roll.rollStiffnessFront / ...
    Roll.totalRollStiffness;

Roll.rearRollDistribution = ...
    Roll.rollStiffnessRear / ...
    Roll.totalRollStiffness;


%% ============================================================
%  8. VEHICLE ROLL ANGLE
%  ============================================================
%
%   phi = M_phi / K_phi
%

Roll.rollAngle = ...
    Roll.rollMoment / ...
    Roll.totalRollStiffness;

Roll.rollAngleDeg = ...
    rad2deg(Roll.rollAngle);


%% ============================================================
%  9. AXLE ROLL MOMENTS
%  ============================================================

Roll.frontRollMoment = ...
    Roll.rollStiffnessFront * ...
    Roll.rollAngle;

Roll.rearRollMoment = ...
    Roll.rollStiffnessRear * ...
    Roll.rollAngle;


%% ============================================================
%  10. LEFT / RIGHT WHEEL DISPLACEMENT
%  ============================================================
%
% Small-angle approximation:
%
%   Delta z = phi * track / 2
%
% Values are converted from metres to millimetres.
%

Roll.frontWheelDisplacement = ...
    Roll.rollAngle * ...
    Vehicle.trackFront / 2 * 1000;

Roll.rearWheelDisplacement = ...
    Roll.rollAngle * ...
    Vehicle.trackRear / 2 * 1000;


%% ============================================================
%  11. VALIDATION
%  ============================================================

Roll.reconstructedRollMoment = ...
    Roll.frontRollMoment + ...
    Roll.rearRollMoment;

Roll.rollMomentError = ...
    Roll.reconstructedRollMoment - ...
    Roll.rollMoment;

Roll.distributionSum = ...
    Roll.frontRollDistribution + ...
    Roll.rearRollDistribution;


end