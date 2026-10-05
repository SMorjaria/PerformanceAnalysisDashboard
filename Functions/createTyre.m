function Tyre = createTyre()
%CREATETYRE Define simplified tyre-model parameters.

%% ============================================================
%  STAGE 2 - TYRE LOAD SENSITIVITY
%  ============================================================

Tyre.FzRef = 2000;              % [N]
Tyre.muRef = 1.80;              % [-]
Tyre.loadSensitivity = 0.10;    % [-]


%% ============================================================
%  STAGE 3 - CORNERING STIFFNESS
%  ============================================================

% Reference cornering stiffness for ONE tyre
Tyre.CalphaRef = 50000;         % [N/rad]

% Cornering stiffness load-sensitivity exponent
Tyre.CalphaLoadExponent = 0.90; % [-]

end