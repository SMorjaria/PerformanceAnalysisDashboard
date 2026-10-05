function Suspension = calculateSuspensionStiffness(Vehicle, Setup)
%CALCULATESUSPENSIONSTIFFNESS
%
% Stage 5.1 - Suspension Vertical Stiffness Model
%
% Calculates effective wheel and axle stiffness from spring
% stiffness and suspension motion ratio.
%
% Motion-ratio convention:
%
%   MR = spring displacement / wheel displacement
%
% Therefore:
%
%   k_wheel = k_spring * MR^2
%
% NOTE:
% Anti-roll bars are not included in pure symmetric heave
% stiffness at this stage. Their influence is retained for
% roll calculations later in Stage 5.


%% ============================================================
%  1. SPRING STIFFNESS
%  ============================================================

Suspension.springFront = Setup.springFront;     % [N/mm]
Suspension.springRear  = Setup.springRear;      % [N/mm]


%% ============================================================
%  2. MOTION RATIOS
%  ============================================================

Suspension.motionRatioFront = ...
    Setup.motionRatioFront;

Suspension.motionRatioRear = ...
    Setup.motionRatioRear;


%% ============================================================
%  3. EFFECTIVE WHEEL RATES
%  ============================================================

Suspension.wheelRateFront = ...
    Suspension.springFront * ...
    Suspension.motionRatioFront^2;

Suspension.wheelRateRear = ...
    Suspension.springRear * ...
    Suspension.motionRatioRear^2;


%% ============================================================
%  4. AXLE HEAVE STIFFNESS
%  ============================================================
%
% Both wheels move together during pure axle heave.
%
% Therefore:
%
%   K_axle = 2 * k_wheel
%

Suspension.axleHeaveStiffnessFront = ...
    2 * Suspension.wheelRateFront;

Suspension.axleHeaveStiffnessRear = ...
    2 * Suspension.wheelRateRear;


%% ============================================================
%  5. TOTAL VEHICLE HEAVE STIFFNESS
%  ============================================================

Suspension.totalHeaveStiffness = ...
    Suspension.axleHeaveStiffnessFront + ...
    Suspension.axleHeaveStiffnessRear;


%% ============================================================
%  6. EXISTING ROLL STIFFNESS APPROXIMATION
%  ============================================================
%
% Preserve the same first-order roll-stiffness architecture
% already used in Stage 2.
%

Suspension.springRollStiffnessFront = ...
    Suspension.wheelRateFront * ...
    Vehicle.trackFront^2 / 2;

Suspension.springRollStiffnessRear = ...
    Suspension.wheelRateRear * ...
    Vehicle.trackRear^2 / 2;


Suspension.arbRollStiffnessFront = ...
    Setup.arbFront * ...
    Vehicle.trackFront^2 / 2;

Suspension.arbRollStiffnessRear = ...
    Setup.arbRear * ...
    Vehicle.trackRear^2 / 2;


Suspension.totalRollStiffnessFront = ...
    Suspension.springRollStiffnessFront + ...
    Suspension.arbRollStiffnessFront;

Suspension.totalRollStiffnessRear = ...
    Suspension.springRollStiffnessRear + ...
    Suspension.arbRollStiffnessRear;


Suspension.totalRollStiffness = ...
    Suspension.totalRollStiffnessFront + ...
    Suspension.totalRollStiffnessRear;


%% ============================================================
%  7. ROLL STIFFNESS DISTRIBUTION
%  ============================================================

Suspension.frontRollStiffnessDistribution = ...
    Suspension.totalRollStiffnessFront / ...
    Suspension.totalRollStiffness;

Suspension.rearRollStiffnessDistribution = ...
    Suspension.totalRollStiffnessRear / ...
    Suspension.totalRollStiffness;


end