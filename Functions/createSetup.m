function Setup = createSetup()
%CREATESETUP Define the baseline vehicle setup.
%
%   Setup = createSetup()
%
%   Outputs:
%       Setup - Structure containing adjustable vehicle
%               setup parameters.
%
% ============================================================


%% SPRINGS

Setup.springFront = 150;             % [N/mm]
Setup.springRear  = 130;             % [N/mm]


%% ANTI-ROLL BARS

Setup.arbFront = 40;                 % [N/mm]
Setup.arbRear  = 35;                 % [N/mm]


%% RIDE HEIGHT

Setup.rideHeightFront = 30;          % [mm]
Setup.rideHeightRear  = 50;          % [mm]


%% CAMBER

Setup.camberFront = -3.0;            % [deg]
Setup.camberRear  = -2.0;            % [deg]


%% TOE

% Sign convention:
%
% Positive = Toe Out
% Negative = Toe In

Setup.toeFront =  0.10;              % [deg]
Setup.toeRear  = -0.10;              % [deg]


%% BRAKE SYSTEM

Setup.brakeBias = 0.58;              % Front fraction [-]


%% AERODYNAMIC SETUP

Setup.frontWing = 5;                 % Wing setting [index]

Setup.CL = 3.50;                     % Downforce coefficient [-]
Setup.CD = 1.00;                     % Drag coefficient [-]

Setup.aeroBalance = 0.45;            % Front aero fraction [-]


%% MOTION RATIOS

% Convention:
%
%       Spring displacement
% MR = -----------------------
%        Wheel displacement

Setup.motionRatioFront = 0.90;       % [-]
Setup.motionRatioRear  = 0.85;       % [-]


end