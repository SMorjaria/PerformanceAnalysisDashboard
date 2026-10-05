function Aero = calculateAerodynamicForces( ...
    Vehicle, Setup, Operating, Constants)
%CALCULATEAERODYNAMICFORCES
%
% Stage 4.1 - Baseline Aerodynamic Force Model
%
% Calculates aerodynamic downforce and drag from vehicle
% speed using a simplified coefficient-based aerodynamic model.
%
% Dynamic pressure:
%
%       q = 0.5 * rho * V^2
%
% Downforce:
%
%       Fdown = q * A * CL
%
% Drag:
%
%       Fdrag = q * A * CD
%
% Sign convention:
%
%       CL > 0 represents positive aerodynamic downforce.
%
% This convention is used because aerodynamic downforce will
% later be added directly to tyre vertical loads.


%% ============================================================
%  INPUT PARAMETERS
%  ============================================================

rho = Constants.rho;

V = Operating.speed;

A = Vehicle.referenceArea;

CL = Setup.CL;

CD = Setup.CD;


%% ============================================================
%  INPUT VALIDATION
%  ============================================================

if V < 0

    error( ...
        'Vehicle speed cannot be negative.');

end

if A <= 0

    error( ...
        'Aerodynamic reference area must be greater than zero.');

end

if CL < 0

    error([ ...
        'Stage 4 uses positive CL to represent ', ...
        'aerodynamic downforce.']);

end

if CD < 0

    error( ...
        'Drag coefficient cannot be negative.');

end


%% ============================================================
%  DYNAMIC PRESSURE
%  ============================================================

dynamicPressure = ...
    0.5 * rho * V^2;


%% ============================================================
%  AERODYNAMIC DOWNFORCE
%  ============================================================

downforce = ...
    dynamicPressure * A * CL;


%% ============================================================
%  AERODYNAMIC DRAG
%  ============================================================

drag = ...
    dynamicPressure * A * CD;


%% ============================================================
%  STORE RESULTS
%  ============================================================

Aero.speed = V;

Aero.speedKPH = V * 3.6;

Aero.dynamicPressure = ...
    dynamicPressure;

Aero.referenceArea = A;

Aero.CL = CL;

Aero.CD = CD;

Aero.downforce = ...
    downforce;

Aero.drag = ...
    drag;


%% ============================================================
%  USEFUL PERFORMANCE METRICS
%  ============================================================

Aero.liftToDragRatio = ...
    CL / CD;

Aero.downforceToWeight = ...
    downforce / (Vehicle.mass * Constants.g);

Aero.dragPower = ...
    drag * V;


end