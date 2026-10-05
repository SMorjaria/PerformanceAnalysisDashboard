function Lateral = calculateLateralLoadTransfer( ...
    Vehicle, Setup, Operating, Derived)
%CALCULATELATERALLOADTRANSFER
% Calculate simplified quasi-static lateral load transfer.
%
% Inputs:
%   Vehicle   - Vehicle definition structure
%   Setup     - Vehicle setup structure
%   Operating - Current operating conditions
%   Derived   - Previously calculated vehicle parameters
%
% Output:
%   Lateral   - Structure containing lateral load-transfer results
%
% Sign convention:
%
%   ay > 0 = left-hand corner
%   ay < 0 = right-hand corner
%
% For ay > 0:
%   Load transfers towards the RIGHT tyres.
%
% For ay < 0:
%   Load transfers towards the LEFT tyres.
%
% NOTE:
%   This is a simplified quasi-static model.
%   Front/rear lateral load transfer distribution is estimated
%   using relative axle roll stiffness.
%
% ============================================================


%% ============================================================
%  WHEEL RATES
%  ============================================================

kWheelFront = ...
    Setup.springFront * Setup.motionRatioFront^2;

kWheelRear = ...
    Setup.springRear * Setup.motionRatioRear^2;


%% ============================================================
%  APPROXIMATE AXLE ROLL STIFFNESS
%  ============================================================
%
% Spring contribution is approximated from wheel rate and track.
%
% ARB stiffness is added as an equivalent axle contribution.
%
% This is currently a relative roll-stiffness model rather than
% a full suspension kinematic roll model.
%

KphiSpringFront = ...
    kWheelFront * Vehicle.trackFront^2 / 2;

KphiSpringRear = ...
    kWheelRear * Vehicle.trackRear^2 / 2;


% Approximate ARB contribution
KphiARBFront = ...
    Setup.arbFront * Vehicle.trackFront^2 / 2;

KphiARBRear = ...
    Setup.arbRear * Vehicle.trackRear^2 / 2;


% Total relative axle roll stiffness

Lateral.KphiFront = ...
    KphiSpringFront + KphiARBFront;

Lateral.KphiRear = ...
    KphiSpringRear + KphiARBRear;


%% ============================================================
%  ROLL STIFFNESS DISTRIBUTION
%  ============================================================

KphiTotal = ...
    Lateral.KphiFront + ...
    Lateral.KphiRear;


Lateral.frontRollStiffnessDistribution = ...
    Lateral.KphiFront / KphiTotal;

Lateral.rearRollStiffnessDistribution = ...
    Lateral.KphiRear / KphiTotal;


%% ============================================================
%  TOTAL LATERAL LOAD TRANSFER
%  ============================================================
%
% Use an effective track width for the total vehicle estimate.
%

effectiveTrack = ...
    (Vehicle.trackFront + Vehicle.trackRear) / 2;


Lateral.totalLoadTransfer = ...
    Vehicle.mass * ...
    Operating.ay * ...
    Vehicle.cgHeight / ...
    effectiveTrack;


%% ============================================================
%  FRONT / REAR DISTRIBUTION
%  ============================================================

Lateral.frontLoadTransfer = ...
    Lateral.totalLoadTransfer * ...
    Lateral.frontRollStiffnessDistribution;


Lateral.rearLoadTransfer = ...
    Lateral.totalLoadTransfer * ...
    Lateral.rearRollStiffnessDistribution;


%% ============================================================
%  STATIC AXLE LOADS
%  ============================================================

frontBasePerTyre = ...
    Derived.frontAxleLoad / 2;

rearBasePerTyre = ...
    Derived.rearAxleLoad / 2;


%% ============================================================
%  INDIVIDUAL TYRE LOADS
%  ============================================================
%
% IMPORTANT:
%
% frontLoadTransfer and rearLoadTransfer represent the
% OUTSIDE-minus-INSIDE load difference contribution.
%
% Therefore each tyre receives +/- DeltaF/2.
%
% ay > 0 = left-hand corner
%
% Vehicle rolls towards the outside of the corner, therefore:
%
%   RIGHT tyres gain load
%   LEFT tyres lose load
%

Lateral.FL = ...
    frontBasePerTyre ...
    - Lateral.frontLoadTransfer / 2;

Lateral.FR = ...
    frontBasePerTyre ...
    + Lateral.frontLoadTransfer / 2;


Lateral.RL = ...
    rearBasePerTyre ...
    - Lateral.rearLoadTransfer / 2;

Lateral.RR = ...
    rearBasePerTyre ...
    + Lateral.rearLoadTransfer / 2;


%% ============================================================
%  TOTAL LOAD
%  ============================================================

Lateral.total = ...
    Lateral.FL + ...
    Lateral.FR + ...
    Lateral.RL + ...
    Lateral.RR;


Lateral.loadError = ...
    Lateral.total - Derived.vehicleWeight;


%% ============================================================
%  VALIDATION
%  ============================================================

if any([ ...
        Lateral.FL ...
        Lateral.FR ...
        Lateral.RL ...
        Lateral.RR] < 0)

    warning([ ...
        'One or more tyre loads are negative. ', ...
        'The requested lateral acceleration exceeds the ', ...
        'valid range of this simplified model.']);

end


end