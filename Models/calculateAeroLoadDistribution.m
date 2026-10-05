function AeroLoad = calculateAeroLoadDistribution( ...
    Aero, Setup)
%CALCULATEAEROLOADDISTRIBUTION
%
% Stage 4.2 - Front / Rear Aerodynamic Load Distribution
%
% Distributes the total aerodynamic downforce calculated in
% Stage 4.1 between the front and rear axles using the defined
% front aerodynamic balance.
%
% Front aerodynamic load:
%
%       F_aero,F = AeroBalance * F_down
%
% Rear aerodynamic load:
%
%       F_aero,R = (1 - AeroBalance) * F_down
%
% The axle aerodynamic loads are then divided equally between
% the left and right tyres.
%
% Sign convention:
%
%       Aerodynamic downforce is stored as a positive vertical
%       load acting onto the vehicle.


%% ============================================================
%  INPUT PARAMETERS
%  ============================================================

totalDownforce = Aero.downforce;

frontAeroBalance = Setup.aeroBalance;


%% ============================================================
%  INPUT VALIDATION
%  ============================================================

if totalDownforce < 0

    error([ ...
        'Aerodynamic downforce must be positive using the ', ...
        'Stage 4 sign convention.']);

end


if frontAeroBalance < 0 || frontAeroBalance > 1

    error([ ...
        'Front aerodynamic balance must be between ', ...
        '0 and 1.']);

end


%% ============================================================
%  FRONT / REAR AERODYNAMIC LOAD
%  ============================================================

frontLoad = ...
    frontAeroBalance * totalDownforce;

rearLoad = ...
    (1 - frontAeroBalance) * totalDownforce;


%% ============================================================
%  FOUR-CORNER AERODYNAMIC LOAD
%  ============================================================
%
% Stage 4.2 assumes symmetric left/right aerodynamic loading.
%

FL = frontLoad / 2;
FR = frontLoad / 2;

RL = rearLoad / 2;
RR = rearLoad / 2;


%% ============================================================
%  LOAD CONSERVATION
%  ============================================================

totalDistributedLoad = ...
    FL + FR + RL + RR;

loadConservationError = ...
    totalDistributedLoad - totalDownforce;


%% ============================================================
%  STORE RESULTS
%  ============================================================

AeroLoad.totalDownforce = ...
    totalDownforce;

AeroLoad.frontBalance = ...
    frontAeroBalance;

AeroLoad.rearBalance = ...
    1 - frontAeroBalance;


% Axle loads

AeroLoad.frontLoad = ...
    frontLoad;

AeroLoad.rearLoad = ...
    rearLoad;


% Individual wheel loads

AeroLoad.FL = FL;
AeroLoad.FR = FR;

AeroLoad.RL = RL;
AeroLoad.RR = RR;


% Validation

AeroLoad.totalDistributedLoad = ...
    totalDistributedLoad;

AeroLoad.loadConservationError = ...
    loadConservationError;


end