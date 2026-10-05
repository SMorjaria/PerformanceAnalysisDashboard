function AeroMap = createAeroMap()
%CREATEAEROMAP
%
% Stage 4.3 - Ride-Height / Rake Aerodynamic Map
%
% Defines a generic surrogate aerodynamic map used to investigate
% vehicle platform sensitivity.
%
% IMPORTANT:
% These parameters are demonstration values and do not represent
% aerodynamic data from a real Formula 1 vehicle.


%% ============================================================
%  NOMINAL AERODYNAMIC OPERATING POINT
%  ============================================================

AeroMap.nominalFrontRH = 30;       % [mm]
AeroMap.nominalRearRH  = 50;       % [mm]


%% ============================================================
%  BASELINE AERODYNAMIC COEFFICIENTS
%  ============================================================

AeroMap.CL0 = 3.50;
AeroMap.CD0 = 1.00;

AeroMap.aeroBalance0 = 0.45;


%% ============================================================
%  LIFT COEFFICIENT MAP PARAMETERS
%  ============================================================
%
% The surrogate CL map contains:
%
%   1. Linear front ride-height sensitivity
%   2. Linear rear ride-height sensitivity
%   3. Quadratic performance loss away from nominal platform
%   4. Front/rear interaction term
%
% This allows the map to contain an operating window rather than
% simply predicting "lower is always better".
%

AeroMap.CL_frontLinear = -0.010;    % [1/mm]
AeroMap.CL_rearLinear  =  0.006;    % [1/mm]

AeroMap.CL_frontQuad = 0.00045;     % [1/mm^2]
AeroMap.CL_rearQuad  = 0.00030;     % [1/mm^2]

AeroMap.CL_cross = 0.00010;         % [1/mm^2]


%% ============================================================
%  DRAG COEFFICIENT MAP PARAMETERS
%  ============================================================

AeroMap.CD_frontLinear = -0.0015;   % [1/mm]
AeroMap.CD_rearLinear  =  0.0010;   % [1/mm]

AeroMap.CD_frontQuad = 0.00005;     % [1/mm^2]
AeroMap.CD_rearQuad  = 0.00004;     % [1/mm^2]


%% ============================================================
%  AERODYNAMIC BALANCE MAP PARAMETERS
%  ============================================================
%
% Balance is stored as a fraction:
%
%       0.45 = 45 % front aero balance
%

AeroMap.balanceFrontSensitivity = -0.0015;  % [1/mm]
AeroMap.balanceRearSensitivity  =  0.0010;  % [1/mm]


%% ============================================================
%  MAP LIMITS
%  ============================================================

AeroMap.minFrontRH = 15;       % [mm]
AeroMap.maxFrontRH = 55;       % [mm]

AeroMap.minRearRH = 30;        % [mm]
AeroMap.maxRearRH = 80;        % [mm]


end