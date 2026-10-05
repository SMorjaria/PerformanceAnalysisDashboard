function Cornering = calculateCorneringStiffness( ...
    TyreLoads, Tyre)
%CALCULATECORNERINGSTIFFNESS
% Calculate load-sensitive tyre and axle cornering stiffness.
%
% Individual tyre cornering stiffness is calculated using:
%
%   C_alpha = C_alpha_ref * (Fz / Fz_ref)^n
%
% where:
%
%   C_alpha_ref = reference tyre cornering stiffness
%   Fz_ref      = reference vertical load
%   n           = load-sensitivity exponent


%% ============================================================
%  VERTICAL TYRE LOADS
%  ============================================================

FzFL = TyreLoads.FL;
FzFR = TyreLoads.FR;

FzRL = TyreLoads.RL;
FzRR = TyreLoads.RR;


%% ============================================================
%  INPUT VALIDATION
%  ============================================================

if any([FzFL FzFR FzRL FzRR] <= 0)

    error( ...
        ['Cornering stiffness cannot be calculated because ', ...
         'one or more tyre vertical loads are zero or negative.']);

end


%% ============================================================
%  LOAD RATIOS
%  ============================================================

loadRatioFL = FzFL / Tyre.FzRef;
loadRatioFR = FzFR / Tyre.FzRef;

loadRatioRL = FzRL / Tyre.FzRef;
loadRatioRR = FzRR / Tyre.FzRef;


%% ============================================================
%  INDIVIDUAL TYRE CORNERING STIFFNESS
%  ============================================================

Cornering.CalphaFL = ...
    Tyre.CalphaRef * ...
    loadRatioFL^Tyre.CalphaLoadExponent;

Cornering.CalphaFR = ...
    Tyre.CalphaRef * ...
    loadRatioFR^Tyre.CalphaLoadExponent;

Cornering.CalphaRL = ...
    Tyre.CalphaRef * ...
    loadRatioRL^Tyre.CalphaLoadExponent;

Cornering.CalphaRR = ...
    Tyre.CalphaRef * ...
    loadRatioRR^Tyre.CalphaLoadExponent;


%% ============================================================
%  AXLE CORNERING STIFFNESS
%  ============================================================

Cornering.CalphaFront = ...
    Cornering.CalphaFL + ...
    Cornering.CalphaFR;

Cornering.CalphaRear = ...
    Cornering.CalphaRL + ...
    Cornering.CalphaRR;


%% ============================================================
%  TOTAL CORNERING STIFFNESS
%  ============================================================

Cornering.CalphaTotal = ...
    Cornering.CalphaFront + ...
    Cornering.CalphaRear;


%% ============================================================
%  CORNERING STIFFNESS DISTRIBUTION
%  ============================================================

Cornering.frontDistribution = ...
    Cornering.CalphaFront / ...
    Cornering.CalphaTotal;

Cornering.rearDistribution = ...
    Cornering.CalphaRear / ...
    Cornering.CalphaTotal;

end