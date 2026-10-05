function ARBSensitivity = frontARBSensitivityStudy( ...
    Vehicle, Setup, Tyre, Constants)
%FRONTARBSENSITIVITYSTUDY
%
% Stage 2.6 - Front Anti-Roll Bar Sensitivity Study
%
% Investigates the influence of front ARB stiffness on:
%
%   - Front roll stiffness distribution
%   - Front and rear lateral load transfer
%   - Individual tyre vertical loads
%   - Front and rear available tyre grip
%   - Total available grip
%   - Front grip distribution
%
% This is a Stage 2 load-transfer / tyre-performance study.
% It does NOT use the Stage 3 bicycle model.


%% ============================================================
%  FRONT ARB SWEEP
%  ============================================================

frontARB = 0:5:100;             % [N/mm]

nPoints = length(frontARB);


%% ============================================================
%  FIXED OPERATING CONDITION
%  ============================================================

OperatingStudy.speed = 50;      % [m/s] = 180 km/h
OperatingStudy.ax = 0;          % [m/s^2]
OperatingStudy.ay = Constants.g; % [m/s^2] = 1.0 g

% Included for compatibility with later Derived calculations
OperatingStudy.steerAngle = 0;  % [deg]


%% ============================================================
%  PREALLOCATE RESULTS
%  ============================================================

frontRollDistribution = zeros(nPoints,1);

frontLoadTransfer = zeros(nPoints,1);
rearLoadTransfer = zeros(nPoints,1);

FL = zeros(nPoints,1);
FR = zeros(nPoints,1);
RL = zeros(nPoints,1);
RR = zeros(nPoints,1);

frontGrip = zeros(nPoints,1);
rearGrip = zeros(nPoints,1);
totalGrip = zeros(nPoints,1);

frontGripDistribution = zeros(nPoints,1);


%% ============================================================
%  RUN FRONT ARB SWEEP
%  ============================================================

for i = 1:nPoints

    %% --------------------------------------------------------
    %  MODIFY FRONT ARB
    %  ---------------------------------------------------------

    SetupSweep = Setup;

    SetupSweep.arbFront = frontARB(i);


    %% --------------------------------------------------------
    %  DERIVED PARAMETERS
    %  ---------------------------------------------------------

    DerivedSweep = calculateDerivedParameters( ...
        Vehicle, ...
        SetupSweep, ...
        OperatingStudy, ...
        Constants);


    %% --------------------------------------------------------
    %  LONGITUDINAL LOAD TRANSFER
    %  ---------------------------------------------------------

    LongitudinalSweep = ...
        calculateLongitudinalLoadTransfer( ...
            Vehicle, ...
            OperatingStudy, ...
            DerivedSweep);


    %% --------------------------------------------------------
    %  LATERAL LOAD TRANSFER
    %  ---------------------------------------------------------

    LateralSweep = ...
        calculateLateralLoadTransfer( ...
            Vehicle, ...
            SetupSweep, ...
            OperatingStudy, ...
            DerivedSweep);


    %% --------------------------------------------------------
    %  COMBINED TYRE LOADS
    %  ---------------------------------------------------------

    TyreLoadsSweep = ...
        calculateCombinedTyreLoads( ...
            Vehicle, ...
            OperatingStudy, ...
            DerivedSweep, ...
            LongitudinalSweep, ...
            LateralSweep);


    %% --------------------------------------------------------
    %  TYRE PERFORMANCE
    %  ---------------------------------------------------------

    TyrePerformanceSweep = ...
        calculateTyrePerformance( ...
            TyreLoadsSweep, ...
            Tyre);


    %% --------------------------------------------------------
    %  STORE ROLL DISTRIBUTION
    %  ---------------------------------------------------------

    frontRollDistribution(i) = ...
        LateralSweep.frontRollStiffnessDistribution;


    %% --------------------------------------------------------
    %  STORE LOAD TRANSFER
    %  ---------------------------------------------------------

    frontLoadTransfer(i) = ...
        LateralSweep.frontLoadTransfer;

    rearLoadTransfer(i) = ...
        LateralSweep.rearLoadTransfer;


    %% --------------------------------------------------------
    %  STORE TYRE LOADS
    %  ---------------------------------------------------------

    FL(i) = TyreLoadsSweep.FL;
    FR(i) = TyreLoadsSweep.FR;
    RL(i) = TyreLoadsSweep.RL;
    RR(i) = TyreLoadsSweep.RR;


   %% --------------------------------------------------------
%  STORE AVAILABLE GRIP
%  ---------------------------------------------------------

frontGrip(i) = ...
    TyrePerformanceSweep.frontGrip;

rearGrip(i) = ...
    TyrePerformanceSweep.rearGrip;

totalGrip(i) = ...
    TyrePerformanceSweep.totalGrip;

frontGripDistribution(i) = ...
    TyrePerformanceSweep.frontGripDistribution;

%% ============================================================
%  STORE RESULTS
%  ============================================================

ARBSensitivity.frontARB = frontARB;

ARBSensitivity.frontRollDistribution = ...
    frontRollDistribution;

ARBSensitivity.frontLoadTransfer = ...
    frontLoadTransfer;

ARBSensitivity.rearLoadTransfer = ...
    rearLoadTransfer;

ARBSensitivity.FL = FL;
ARBSensitivity.FR = FR;
ARBSensitivity.RL = RL;
ARBSensitivity.RR = RR;

ARBSensitivity.frontGrip = frontGrip;
ARBSensitivity.rearGrip = rearGrip;
ARBSensitivity.totalGrip = totalGrip;

ARBSensitivity.frontGripDistribution = ...
    frontGripDistribution;


%% ============================================================
%  STAGE 2.6 - FIGURE 1
%
%  FRONT ARB VS ROLL STIFFNESS DISTRIBUTION
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 1 - ', ...
     'Front ARB vs Roll Distribution'], ...
    'NumberTitle','off');

plot( ...
    frontARB, ...
    frontRollDistribution * 100, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');

ylabel( ...
    'Front Roll Stiffness Distribution [%]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Roll Stiffness Distribution']);


%% ============================================================
%  STAGE 2.6 - FIGURE 2
%
%  FRONT ARB VS LATERAL LOAD TRANSFER
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 2 - ', ...
     'Front ARB vs Load Transfer'], ...
    'NumberTitle','off');

plot( ...
    frontARB, ...
    frontLoadTransfer, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Front Axle');

hold on;

plot( ...
    frontARB, ...
    rearLoadTransfer, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Rear Axle');

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');
ylabel('Lateral Load Transfer [N]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Lateral Load Transfer']);

legend('Location','best');


%% ============================================================
%  STAGE 2.6 - FIGURE 3
%
%  FRONT ARB VS FOUR-CORNER TYRE LOADS
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 3 - ', ...
     'Front ARB vs Tyre Loads'], ...
    'NumberTitle','off');

plot(frontARB,FL,'-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','FL');

hold on;

plot(frontARB,FR,'-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','FR');

plot(frontARB,RL,'-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','RL');

plot(frontARB,RR,'-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','RR');

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');
ylabel('Vertical Tyre Load [N]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Four-Corner Tyre Loads']);

legend('Location','best');


%% ============================================================
%  STAGE 2.6 - FIGURE 4
%
%  FRONT ARB VS AXLE GRIP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 4 - ', ...
     'Front ARB vs Axle Grip'], ...
    'NumberTitle','off');

plot( ...
    frontARB, ...
    frontGrip, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Front Axle');

hold on;

plot( ...
    frontARB, ...
    rearGrip, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Rear Axle');

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');
ylabel('Available Lateral Grip [N]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Axle Grip']);

legend('Location','best');


%% ============================================================
%  STAGE 2.6 - FIGURE 5
%
%  FRONT ARB VS TOTAL AVAILABLE GRIP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 5 - ', ...
     'Front ARB vs Total Grip'], ...
    'NumberTitle','off');

plot( ...
    frontARB, ...
    totalGrip, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');
ylabel('Total Available Lateral Grip [N]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Total Available Grip']);


%% ============================================================
%  STAGE 2.6 - FIGURE 6
%
%  FRONT ARB VS FRONT GRIP DISTRIBUTION
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 2.6 - Figure 6 - ', ...
     'Front ARB vs Grip Distribution'], ...
    'NumberTitle','off');

plot( ...
    frontARB, ...
    frontGripDistribution * 100, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Front ARB Stiffness [N/mm]');
ylabel('Front Grip Distribution [%]');

title( ...
    ['Stage 2.6 - Front ARB Sensitivity: ', ...
     'Front Grip Distribution']);

end