function TyreLoads = calculateCombinedTyreLoads( ...
    Vehicle, Operating, Derived, LoadTransfer, Lateral)
%CALCULATECOMBINEDTYRELOADS
% Calculate final four-corner vertical tyre loads by combining
% static loading, longitudinal load transfer and lateral load
% transfer.
%
% Inputs:
%   Vehicle       - Vehicle definition structure
%   Operating     - Current operating conditions
%   Derived       - Static / derived vehicle parameters
%   LoadTransfer  - Longitudinal load-transfer results
%   Lateral       - Lateral load-transfer results
%
% Output:
%   TyreLoads     - Final dynamic vertical tyre loads
%
% Sign conventions:
%
%   ax > 0 = acceleration
%   ax < 0 = braking
%
%   ay > 0 = left-hand corner
%   ay < 0 = right-hand corner
%
% ============================================================


%% ============================================================
%  STATIC TYRE LOADS
%  ============================================================

FzFL_static = Derived.FL;
FzFR_static = Derived.FR;

FzRL_static = Derived.RL;
FzRR_static = Derived.RR;


%% ============================================================
%  LONGITUDINAL LOAD TRANSFER
%  ============================================================

deltaFx = LoadTransfer.longitudinal;

% Positive deltaFx:
%   acceleration -> load moves rearwards
%
% Negative deltaFx:
%   braking -> load moves forwards


%% ============================================================
%  LATERAL LOAD TRANSFER
%  ============================================================

deltaFyFront = Lateral.frontLoadTransfer;
deltaFyRear  = Lateral.rearLoadTransfer;

% Positive lateral transfer corresponds to ay > 0:
%
%   left-hand corner
%   right-hand tyres are outside
%
% Therefore:
%
%   FL loses load
%   FR gains load
%   RL loses load
%   RR gains load


%% ============================================================
%  COMBINED FOUR-CORNER TYRE LOADS
%  ============================================================

TyreLoads.FL = ...
    FzFL_static ...
    - deltaFx/2 ...
    - deltaFyFront/2;


TyreLoads.FR = ...
    FzFR_static ...
    - deltaFx/2 ...
    + deltaFyFront/2;


TyreLoads.RL = ...
    FzRL_static ...
    + deltaFx/2 ...
    - deltaFyRear/2;


TyreLoads.RR = ...
    FzRR_static ...
    + deltaFx/2 ...
    + deltaFyRear/2;


%% ============================================================
%  DYNAMIC AXLE LOADS
%  ============================================================

TyreLoads.frontAxle = ...
    TyreLoads.FL + TyreLoads.FR;

TyreLoads.rearAxle = ...
    TyreLoads.RL + TyreLoads.RR;


%% ============================================================
%  LEFT / RIGHT VEHICLE LOADS
%  ============================================================

TyreLoads.leftSide = ...
    TyreLoads.FL + TyreLoads.RL;

TyreLoads.rightSide = ...
    TyreLoads.FR + TyreLoads.RR;


%% ============================================================
%  TOTAL VERTICAL LOAD
%  ============================================================

TyreLoads.total = ...
    TyreLoads.FL + ...
    TyreLoads.FR + ...
    TyreLoads.RL + ...
    TyreLoads.RR;


%% ============================================================
%  LOAD CONSERVATION
%  ============================================================

TyreLoads.loadError = ...
    TyreLoads.total - Derived.vehicleWeight;


%% ============================================================
%  TYRE LIFT CHECK
%  ============================================================

TyreLoads.wheelLift = false;

TyreLoads.FL_Lift = TyreLoads.FL <= 0;
TyreLoads.FR_Lift = TyreLoads.FR <= 0;
TyreLoads.RL_Lift = TyreLoads.RL <= 0;
TyreLoads.RR_Lift = TyreLoads.RR <= 0;


if TyreLoads.FL_Lift || ...
   TyreLoads.FR_Lift || ...
   TyreLoads.RL_Lift || ...
   TyreLoads.RR_Lift

    TyreLoads.wheelLift = true;

    warning([ ...
        'One or more tyre loads are zero or negative. ', ...
        'Wheel lift predicted or operating condition ', ...
        'is outside the valid range of this model.']);

end


%% ============================================================
%  LOAD DISTRIBUTIONS
%  ============================================================

TyreLoads.frontDistribution = ...
    TyreLoads.frontAxle / TyreLoads.total;

TyreLoads.rearDistribution = ...
    TyreLoads.rearAxle / TyreLoads.total;

TyreLoads.leftDistribution = ...
    TyreLoads.leftSide / TyreLoads.total;

TyreLoads.rightDistribution = ...
    TyreLoads.rightSide / TyreLoads.total;


%% ============================================================
%  OPERATING CONDITION STORAGE
%  ============================================================

TyreLoads.ax = Operating.ax;
TyreLoads.ay = Operating.ay;


end