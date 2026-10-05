function TimeResponse = calculateVerticalTimeResponse(Vertical)
%CALCULATEVERTICALTIMERESPONSE
%
% Stage 5.7D - Time-Domain Road Excitation
%
% Simulates the response of the validated 2-DOF quarter-car
% model to a finite half-sine road bump.
%
% Outputs:
%   - Road displacement
%   - Sprung-mass displacement
%   - Unsprung-mass displacement
%   - Suspension travel
%   - Sprung-mass acceleration
%   - Dynamic tyre-load variation
%
% The road disturbance is a generic demonstration input and
% does not represent measured circuit data.


%% ============================================================
%  1. SIMULATION PARAMETERS
%  ============================================================

dt = 0.001;             % [s]
tEnd = 3.0;             % [s]

time = 0:dt:tEnd;

nTime = length(time);

sampleFrequency = 1 / dt;


%% ============================================================
%  2. ROAD DISTURBANCE
%  ============================================================
%
% Generic half-sine bump:
%
% Height   = 10 mm
% Duration = 0.10 s
%
% The bump begins at t = 0.50 s.
%

bumpHeight = 10 / 1000;     % [m]
bumpDuration = 0.10;        % [s]
bumpStart = 0.50;           % [s]

road = zeros(1,nTime);

insideBump = ...
    time >= bumpStart & ...
    time <= (bumpStart + bumpDuration);

tau = time(insideBump) - bumpStart;

road(insideBump) = ...
    0.5 * bumpHeight .* ...
    (1 - cos(2*pi*tau/bumpDuration));


%% ============================================================
%  3. VEHICLE PARAMETERS
%  ============================================================

ms = Vertical.sprungMass;
mu = Vertical.unsprungMass;

ks = Vertical.suspensionStiffness;
kt = Vertical.tyreStiffness;

cs = Vertical.dampingCoefficient;


%% ============================================================
%  4. STATE-SPACE MODEL
%  ============================================================
%
% State vector:
%
% x = [zs
%      zu
%      zs_dot
%      zu_dot]
%
% where:
%
% zs = sprung-mass displacement
% zu = unsprung-mass displacement
%

A = [ ...
     0,        0,        1,        0;
     0,        0,        0,        1;
    -ks/ms,    ks/ms,    -cs/ms,    cs/ms;
     ks/mu, -(ks+kt)/mu,  cs/mu,   -cs/mu];


B = [ ...
    0;
    0;
    0;
    kt/mu];


%% ============================================================
%  5. NUMERICAL INTEGRATION
%  ============================================================
%
% Fixed-step fourth-order Runge-Kutta integration is used.
%
% This avoids requiring Simulink or Control System Toolbox and
% gives us direct control over the simulation time history.
%

state = zeros(4,nTime);


for i = 1:nTime-1

    x = state(:,i);

    zr1 = road(i);
    zr2 = 0.5 * (road(i) + road(i+1));
    zr4 = road(i+1);


    %% RK4

    k1 = A*x + B*zr1;

    k2 = A*(x + 0.5*dt*k1) + B*zr2;

    k3 = A*(x + 0.5*dt*k2) + B*zr2;

    k4 = A*(x + dt*k3) + B*zr4;


    state(:,i+1) = ...
        x + ...
        (dt/6) * ...
        (k1 + 2*k2 + 2*k3 + k4);

end


%% ============================================================
%  6. EXTRACT STATES
%  ============================================================

zs = state(1,:);
zu = state(2,:);

zsDot = state(3,:);
zuDot = state(4,:);


%% ============================================================
%  7. SUSPENSION TRAVEL
%  ============================================================

suspensionTravel = ...
    zs - zu;


%% ============================================================
%  8. TYRE DEFLECTION
%  ============================================================

tyreDeflection = ...
    road - zu;


%% ============================================================
%  9. DYNAMIC TYRE LOAD
%  ============================================================
%
% Dynamic tyre force relative to the static equilibrium:
%
% Delta Fz = kt * (zr - zu)
%

dynamicTyreLoad = ...
    kt * tyreDeflection;


%% ============================================================
%  10. SPRUNG-MASS ACCELERATION
%  ============================================================
%
% From:
%
% ms*z_s_ddot =
%   -ks(zs-zu) - cs(zs_dot-zu_dot)
%

zsAcceleration = ...
    ( ...
    -ks .* (zs - zu) ...
    -cs .* (zsDot - zuDot) ...
    ) ./ ms;


%% ============================================================
%  11. UNSPRUNG-MASS ACCELERATION
%  ============================================================

zuAcceleration = ...
    ( ...
     ks .* (zs - zu) ...
    +cs .* (zsDot - zuDot) ...
    +kt .* (road - zu) ...
    ) ./ mu;


%% ============================================================
%  12. RESPONSE METRICS
%  ============================================================

peakBodyDisplacement = ...
    max(abs(zs));

peakWheelDisplacement = ...
    max(abs(zu));

peakSuspensionTravel = ...
    max(abs(suspensionTravel));

peakBodyAcceleration = ...
    max(abs(zsAcceleration));

peakDynamicTyreLoad = ...
    max(abs(dynamicTyreLoad));


%% RMS VALUES

rmsBodyAcceleration = ...
    sqrt(mean(zsAcceleration.^2));

rmsDynamicTyreLoad = ...
    sqrt(mean(dynamicTyreLoad.^2));


%% ============================================================
%  13. STORE OUTPUT
%  ============================================================

TimeResponse.time = time;
TimeResponse.dt = dt;
TimeResponse.sampleFrequency = sampleFrequency;


TimeResponse.road = road;

TimeResponse.bumpHeight = bumpHeight;
TimeResponse.bumpDuration = bumpDuration;
TimeResponse.bumpStart = bumpStart;


TimeResponse.zs = zs;
TimeResponse.zu = zu;

TimeResponse.zsDot = zsDot;
TimeResponse.zuDot = zuDot;

TimeResponse.zsAcceleration = zsAcceleration;
TimeResponse.zuAcceleration = zuAcceleration;

TimeResponse.suspensionTravel = suspensionTravel;

TimeResponse.tyreDeflection = tyreDeflection;
TimeResponse.dynamicTyreLoad = dynamicTyreLoad;


TimeResponse.peakBodyDisplacement = ...
    peakBodyDisplacement;

TimeResponse.peakWheelDisplacement = ...
    peakWheelDisplacement;

TimeResponse.peakSuspensionTravel = ...
    peakSuspensionTravel;

TimeResponse.peakBodyAcceleration = ...
    peakBodyAcceleration;

TimeResponse.peakDynamicTyreLoad = ...
    peakDynamicTyreLoad;


TimeResponse.rmsBodyAcceleration = ...
    rmsBodyAcceleration;

TimeResponse.rmsDynamicTyreLoad = ...
    rmsDynamicTyreLoad;


end