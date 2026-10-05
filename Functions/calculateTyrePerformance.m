function TyrePerformance = calculateTyrePerformance( ...
    TyreLoads, Tyre)
%CALCULATETYREPERFORMANCE
% Calculate simplified tyre performance from vertical tyre load.
%
% The model accounts for tyre load sensitivity using:
%
%   mu = muRef * (Fz/FzRef)^(-k)
%
% where:
%
%   muRef = reference friction coefficient
%   FzRef = reference vertical tyre load
%   k     = tyre load-sensitivity exponent
%
% Maximum lateral force is then:
%
%   FyMax = mu * Fz
%
% This provides a first-order representation of the reduction
% in tyre efficiency as vertical load increases.
%
% ============================================================


%% ============================================================
%  VERTICAL TYRE LOADS
%  ============================================================

Fz = [ ...
    TyreLoads.FL, ...
    TyreLoads.FR, ...
    TyreLoads.RL, ...
    TyreLoads.RR ];


%% ============================================================
%  VALIDATE TYRE LOADS
%  ============================================================

if any(Fz <= 0)

    error([ ...
        'Tyre performance cannot be calculated because ', ...
        'one or more vertical tyre loads are zero or negative.']);

end


%% ============================================================
%  TYRE LOAD RATIO
%  ============================================================
%
% Ratio of current tyre load to reference tyre load.
%
% FzRatio = 1:
%   tyre is operating at reference load.
%
% FzRatio > 1:
%   tyre is more heavily loaded.
%
% FzRatio < 1:
%   tyre is more lightly loaded.
%

FzRatio = Fz ./ Tyre.FzRef;


%% ============================================================
%  EFFECTIVE FRICTION COEFFICIENT
%  ============================================================
%
% Load-sensitive friction model:
%
%   mu = muRef * (Fz/FzRef)^(-k)
%
% Increasing vertical load therefore reduces effective mu.
%

mu = ...
    Tyre.muRef .* ...
    FzRatio.^(-Tyre.loadSensitivity);


%% ============================================================
%  MAXIMUM LATERAL FORCE
%  ============================================================
%
% Maximum available lateral force:
%
%   FyMax = mu * Fz
%

FyMax = mu .* Fz;


%% ============================================================
%  STORE VERTICAL LOAD RATIOS
%  ============================================================

TyrePerformance.FzRatioFL = FzRatio(1);
TyrePerformance.FzRatioFR = FzRatio(2);

TyrePerformance.FzRatioRL = FzRatio(3);
TyrePerformance.FzRatioRR = FzRatio(4);


%% ============================================================
%  STORE EFFECTIVE FRICTION COEFFICIENTS
%  ============================================================

TyrePerformance.muFL = mu(1);
TyrePerformance.muFR = mu(2);

TyrePerformance.muRL = mu(3);
TyrePerformance.muRR = mu(4);


%% ============================================================
%  STORE MAXIMUM TYRE LATERAL FORCES
%  ============================================================

TyrePerformance.FyMaxFL = FyMax(1);
TyrePerformance.FyMaxFR = FyMax(2);

TyrePerformance.FyMaxRL = FyMax(3);
TyrePerformance.FyMaxRR = FyMax(4);


%% ============================================================
%  FRONT AXLE AVAILABLE GRIP
%  ============================================================

TyrePerformance.frontGrip = ...
    TyrePerformance.FyMaxFL + ...
    TyrePerformance.FyMaxFR;


%% ============================================================
%  REAR AXLE AVAILABLE GRIP
%  ============================================================

TyrePerformance.rearGrip = ...
    TyrePerformance.FyMaxRL + ...
    TyrePerformance.FyMaxRR;


%% ============================================================
%  TOTAL AVAILABLE LATERAL GRIP
%  ============================================================

TyrePerformance.totalGrip = ...
    TyrePerformance.frontGrip + ...
    TyrePerformance.rearGrip;


%% ============================================================
%  FRONT / REAR GRIP DISTRIBUTION
%  ============================================================

TyrePerformance.frontGripDistribution = ...
    TyrePerformance.frontGrip / ...
    TyrePerformance.totalGrip;


TyrePerformance.rearGripDistribution = ...
    TyrePerformance.rearGrip / ...
    TyrePerformance.totalGrip;


%% ============================================================
%  LEFT / RIGHT AVAILABLE GRIP
%  ============================================================

TyrePerformance.leftGrip = ...
    TyrePerformance.FyMaxFL + ...
    TyrePerformance.FyMaxRL;


TyrePerformance.rightGrip = ...
    TyrePerformance.FyMaxFR + ...
    TyrePerformance.FyMaxRR;


%% ============================================================
%  STORE TOTALS FOR VALIDATION
%  ============================================================

TyrePerformance.totalVerticalLoad = sum(Fz);

TyrePerformance.totalAvailableLateralForce = ...
    sum(FyMax);


end