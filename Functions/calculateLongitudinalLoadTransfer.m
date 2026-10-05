function LoadTransfer = calculateLongitudinalLoadTransfer( ...
    Vehicle, Operating, Derived)
%CALCULATELONGITUDINALLOADTRANSFER
% Calculate quasi-static longitudinal load transfer.
%
% Inputs:
%   Vehicle   - Vehicle definition structure
%   Operating - Current operating conditions
%   Derived   - Previously calculated vehicle parameters
%
% Output:
%   LoadTransfer - Structure containing dynamic axle and tyre loads
%
% Sign convention:
%
%   ax > 0  = acceleration
%   ax < 0  = braking
%
% During braking:
%   Front axle load increases
%   Rear axle load decreases
%
% During acceleration:
%   Front axle load decreases
%   Rear axle load increases
%
% ============================================================


%% ============================================================
%  LONGITUDINAL LOAD TRANSFER
%  ============================================================

LoadTransfer.longitudinal = ...
    Vehicle.mass * ...
    Operating.ax * ...
    Vehicle.cgHeight / ...
    Vehicle.wheelbase;


%% ============================================================
%  DYNAMIC AXLE LOADS
%  ============================================================
%
% Positive ax transfers load rearwards.
% Negative ax transfers load forwards.
%

LoadTransfer.frontAxle = ...
    Derived.frontAxleLoad - LoadTransfer.longitudinal;

LoadTransfer.rearAxle = ...
    Derived.rearAxleLoad + LoadTransfer.longitudinal;


%% ============================================================
%  INDIVIDUAL TYRE LOADS
%  ============================================================
%
% Longitudinal acceleration alone does not create left/right
% load transfer, so each axle load is divided equally.
%

LoadTransfer.FL = LoadTransfer.frontAxle / 2;
LoadTransfer.FR = LoadTransfer.frontAxle / 2;

LoadTransfer.RL = LoadTransfer.rearAxle / 2;
LoadTransfer.RR = LoadTransfer.rearAxle / 2;


%% ============================================================
%  LOAD CONSERVATION CHECK
%  ============================================================

LoadTransfer.total = ...
    LoadTransfer.FL + ...
    LoadTransfer.FR + ...
    LoadTransfer.RL + ...
    LoadTransfer.RR;

LoadTransfer.loadError = ...
    LoadTransfer.total - Derived.vehicleWeight;


%% ============================================================
%  BASIC PHYSICAL VALIDATION
%  ============================================================

if any([ ...
        LoadTransfer.FL, ...
        LoadTransfer.FR, ...
        LoadTransfer.RL, ...
        LoadTransfer.RR] < 0)

    warning(['One or more calculated tyre loads are negative. ', ...
             'The requested operating condition exceeds the ', ...
             'valid range of this quasi-static model.']);

end


end