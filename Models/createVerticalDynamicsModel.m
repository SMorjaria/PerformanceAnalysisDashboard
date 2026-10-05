function Vertical = createVerticalDynamicsModel( ...
    Vehicle, Setup, Suspension)
%CREATEVERTICALDYNAMICSMODEL
%
% Stage 5.7A - Quarter-Car Vertical Dynamics
%
% Creates a front quarter-car 2-DOF vertical dynamics model.
%
% Architecture:
%
%       Sprung Mass
%           |
%       ks     cs
%           |
%       Unsprung Mass
%           |
%           kt
%           |
%          Road
%
% IMPORTANT:
% The dynamic parameters introduced here are generic
% demonstration values and are NOT real Formula 1 data.


%% ============================================================
%  1. CORNER MASS
%  ============================================================
%
% Front axle supported mass:
%
%   mFront = m * frontWeightDistribution
%
% Quarter-car supported mass:
%
%   mCorner = mFront / 2
%

Vertical.cornerMass = ...
    Vehicle.mass * ...
    Vehicle.frontWeightDistribution / 2;


%% ============================================================
%  2. UNSPRUNG MASS
%  ============================================================
%
% Generic assumed front-corner unsprung mass.
%

Vertical.unsprungMass = 25;       % [kg]


%% ============================================================
%  3. SPRUNG MASS
%  ============================================================

Vertical.sprungMass = ...
    Vertical.cornerMass - ...
    Vertical.unsprungMass;


%% ============================================================
%  4. SUSPENSION WHEEL RATE
%  ============================================================
%
% Existing Stage 5 wheel rate is stored in N/mm.
% Convert to N/m for dynamic equations.
%

Vertical.suspensionStiffness = ...
    Suspension.wheelRateFront * 1000;       % [N/m]


%% ============================================================
%  5. TYRE VERTICAL STIFFNESS
%  ============================================================
%
% Generic demonstration value.
%

Vertical.tyreStiffness = ...
    250 * 1000;                             % [N/m]


%% ============================================================
%  6. SUSPENSION DAMPING
%  ============================================================
%
% Use a target damping ratio to define a first-order
% suspension damping coefficient.
%
% Approximate sprung-mass critical damping:
%
%   cCritical = 2*sqrt(ks*ms)
%
% and:
%
%   cs = zeta*cCritical
%

Vertical.dampingRatio = 0.60;


Vertical.criticalDamping = ...
    2 * sqrt( ...
    Vertical.suspensionStiffness * ...
    Vertical.sprungMass);


Vertical.dampingCoefficient = ...
    Vertical.dampingRatio * ...
    Vertical.criticalDamping;


%% ============================================================
%  7. SIMPLE NATURAL-FREQUENCY ESTIMATES
%  ============================================================
%
% These are useful engineering estimates before solving the
% complete coupled eigenvalue problem.
%

Vertical.bodyNaturalFrequencyEstimate = ...
    (1 / (2*pi)) * ...
    sqrt( ...
    Vertical.suspensionStiffness / ...
    Vertical.sprungMass);


Vertical.wheelHopFrequencyEstimate = ...
    (1 / (2*pi)) * ...
    sqrt( ...
    (Vertical.suspensionStiffness + ...
     Vertical.tyreStiffness) / ...
    Vertical.unsprungMass);


%% ============================================================
%  8. MASS MATRIX
%  ============================================================

Vertical.M = [ ...
    Vertical.sprungMass, 0;
    0, Vertical.unsprungMass];


%% ============================================================
%  9. DAMPING MATRIX
%  ============================================================

c = Vertical.dampingCoefficient;

Vertical.C = [ ...
     c, -c;
    -c,  c];


%% ============================================================
%  10. STIFFNESS MATRIX
%  ============================================================

ks = Vertical.suspensionStiffness;
kt = Vertical.tyreStiffness;

Vertical.K = [ ...
     ks,      -ks;
    -ks, ks + kt];


%% ============================================================
%  11. UNDAMPED COUPLED NATURAL FREQUENCIES
%  ============================================================
%
% Solve:
%
%   det(K - omega^2 M) = 0
%
% Equivalent MATLAB eigenproblem:
%
%   K*phi = lambda*M*phi
%
% where:
%
%   lambda = omega_n^2
%

[eigenvectors, eigenvalues] = ...
    eig(Vertical.K, Vertical.M);


omegaSquared = ...
    real(diag(eigenvalues));


omegaNatural = ...
    sqrt(omegaSquared);


frequencyNatural = ...
    omegaNatural / (2*pi);


[frequencyNatural, sortIndex] = ...
    sort(frequencyNatural);


omegaNatural = ...
    omegaNatural(sortIndex);

eigenvectors = ...
    eigenvectors(:,sortIndex);


Vertical.naturalFrequency = ...
    frequencyNatural;

Vertical.naturalFrequencyBody = ...
    frequencyNatural(1);

Vertical.naturalFrequencyWheelHop = ...
    frequencyNatural(2);

Vertical.naturalOmega = ...
    omegaNatural;

Vertical.modeShapes = ...
    eigenvectors;


%% ============================================================
%  12. VALIDATION
%  ============================================================

Vertical.totalMassCheck = ...
    Vertical.sprungMass + ...
    Vertical.unsprungMass;

Vertical.massError = ...
    Vertical.totalMassCheck - ...
    Vertical.cornerMass;


end