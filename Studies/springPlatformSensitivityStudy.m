function Study = springPlatformSensitivityStudy( ...
    Vehicle, Setup, Operating, Constants, AeroMap)
%SPRINGPLATFORMSENSITIVITYSTUDY
%
% Stage 5.6B - Spring Stiffness / Platform Sensitivity
%
% Investigates how overall spring stiffness influences
% high-speed aerodynamic platform control.
%
% Front and rear spring rates are scaled together using a
% common multiplier so that the baseline front/rear spring
% relationship is retained.
%
% The study is performed at 180 km/h, where Stage 5.6A showed
% that the baseline setup leaves the defined aerodynamic-map
% operating envelope.


%% ============================================================
%  1. STUDY SETTINGS
%  ============================================================

springMultiplier = 0.60:0.05:2.00;

nCases = length(springMultiplier);

studySpeedKPH = 180;


OperatingStudy = Operating;

OperatingStudy.speed = ...
    studySpeedKPH / 3.6;


%% ============================================================
%  2. BASELINE SPRING RATES
%  ============================================================

baselineFrontSpring = ...
    Setup.springFront;

baselineRearSpring = ...
    Setup.springRear;


%% ============================================================
%  3. PREALLOCATE
%  ============================================================

frontSpring = nan(1,nCases);
rearSpring = nan(1,nCases);

frontWheelRate = nan(1,nCases);
rearWheelRate = nan(1,nCases);

frontAxleHeaveStiffness = nan(1,nCases);
rearAxleHeaveStiffness = nan(1,nCases);

frontRH = nan(1,nCases);
rearRH = nan(1,nCases);

frontCompression = nan(1,nCases);
rearCompression = nan(1,nCases);

heave = nan(1,nCases);
rake = nan(1,nCases);

CL = nan(1,nCases);
CD = nan(1,nCases);

frontBalance = nan(1,nCases);
downforce = nan(1,nCases);

converged = false(1,nCases);
insideAeroMap = false(1,nCases);


%% ============================================================
%  4. SPRING STIFFNESS SWEEP
%  ============================================================

for i = 1:nCases

    %% --------------------------------------------------------
    % 4.1 Modify spring rates
    % ---------------------------------------------------------

    SetupSweep = Setup;

    SetupSweep.springFront = ...
        baselineFrontSpring * ...
        springMultiplier(i);

    SetupSweep.springRear = ...
        baselineRearSpring * ...
        springMultiplier(i);


    frontSpring(i) = ...
        SetupSweep.springFront;

    rearSpring(i) = ...
        SetupSweep.springRear;


    %% --------------------------------------------------------
    % 4.2 Recalculate suspension parameters
    % ---------------------------------------------------------
    %
    % Motion ratio convention:
    %
    %   MR = spring displacement / wheel displacement
    %
    % Therefore:
    %
    %   k_wheel = k_spring * MR^2
    %

    frontWheelRate(i) = ...
        SetupSweep.springFront * ...
        SetupSweep.motionRatioFront^2;

    rearWheelRate(i) = ...
        SetupSweep.springRear * ...
        SetupSweep.motionRatioRear^2;


    %% --------------------------------------------------------
    % 4.3 Axle heave stiffness
    % --------------------------------------------------------
    %
    % Two wheels act in parallel during symmetric heave.
    %
    % ARBs are NOT included because equal left/right wheel
    % motion does not twist the anti-roll bar in pure heave.
    %

    frontAxleHeaveStiffness(i) = ...
        2 * frontWheelRate(i);

    rearAxleHeaveStiffness(i) = ...
        2 * rearWheelRate(i);


    %% --------------------------------------------------------
    % 4.4 Build temporary suspension structure
    % ---------------------------------------------------------

    SuspensionSweep.wheelRateFront = ...
        frontWheelRate(i);

    SuspensionSweep.wheelRateRear = ...
        rearWheelRate(i);

    SuspensionSweep.axleHeaveStiffnessFront = ...
        frontAxleHeaveStiffness(i);

    SuspensionSweep.axleHeaveStiffnessRear = ...
        rearAxleHeaveStiffness(i);


    %% --------------------------------------------------------
    % 4.5 Solve coupled aero-suspension equilibrium
    % ---------------------------------------------------------

    Equilibrium = calculateAeroSuspensionEquilibrium( ...
        Vehicle, ...
        SetupSweep, ...
        OperatingStudy, ...
        Constants, ...
        SuspensionSweep, ...
        AeroMap);


    %% --------------------------------------------------------
    % 4.6 Store platform response
    % ---------------------------------------------------------

    frontRH(i) = ...
        Equilibrium.frontRideHeight;

    rearRH(i) = ...
        Equilibrium.rearRideHeight;

    frontCompression(i) = ...
        Equilibrium.frontCompression;

    rearCompression(i) = ...
        Equilibrium.rearCompression;

    heave(i) = ...
        Equilibrium.heave;

    rake(i) = ...
        Equilibrium.rakeAngleDeg;


    %% --------------------------------------------------------
    % 4.7 Store aerodynamic response
    % ---------------------------------------------------------

    CL(i) = ...
        Equilibrium.AeroState.CL;

    CD(i) = ...
        Equilibrium.AeroState.CD;

    frontBalance(i) = ...
        Equilibrium.AeroState.frontBalance;

    downforce(i) = ...
        Equilibrium.Aero.downforce;


    %% --------------------------------------------------------
    % 4.8 Solver status
    % ---------------------------------------------------------

    converged(i) = ...
        Equilibrium.converged;


    %% --------------------------------------------------------
    % 4.9 Aero-map validity
    % ---------------------------------------------------------

    insideAeroMap(i) = ...
        frontRH(i) >= AeroMap.minFrontRH && ...
        frontRH(i) <= AeroMap.maxFrontRH && ...
        rearRH(i) >= AeroMap.minRearRH && ...
        rearRH(i) <= AeroMap.maxRearRH;

end


%% ============================================================
%  5. FIND MINIMUM VALID SPRING MULTIPLIER
%  ============================================================

firstValidIndex = find( ...
    insideAeroMap & converged, ...
    1, ...
    'first');


%% ============================================================
%  6. STORE RESULTS
%  ============================================================

Study.speedKPH = ...
    studySpeedKPH;

Study.springMultiplier = ...
    springMultiplier;

Study.frontSpring = ...
    frontSpring;

Study.rearSpring = ...
    rearSpring;

Study.frontWheelRate = ...
    frontWheelRate;

Study.rearWheelRate = ...
    rearWheelRate;

Study.frontAxleHeaveStiffness = ...
    frontAxleHeaveStiffness;

Study.rearAxleHeaveStiffness = ...
    rearAxleHeaveStiffness;

Study.frontRideHeight = ...
    frontRH;

Study.rearRideHeight = ...
    rearRH;

Study.frontCompression = ...
    frontCompression;

Study.rearCompression = ...
    rearCompression;

Study.heave = ...
    heave;

Study.rakeAngleDeg = ...
    rake;

Study.CL = ...
    CL;

Study.CD = ...
    CD;

Study.frontBalance = ...
    frontBalance;

Study.downforce = ...
    downforce;

Study.converged = ...
    converged;

Study.insideAeroMap = ...
    insideAeroMap;

Study.firstValidIndex = ...
    firstValidIndex;


%% ============================================================
%  7. COMMAND-WINDOW SUMMARY
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' SPRING / PLATFORM SENSITIVITY - STAGE 5.6B\n');
fprintf('============================================\n');

fprintf('Study Speed             : %.0f km/h\n', ...
    studySpeedKPH);

fprintf('Spring Multiplier Range : %.2f to %.2f\n', ...
    min(springMultiplier), ...
    max(springMultiplier));

fprintf('Converged Cases         : %d / %d\n', ...
    sum(converged), ...
    nCases);

fprintf('Inside Aero Map         : %d / %d\n', ...
    sum(insideAeroMap), ...
    nCases);


%% Minimum spring stiffness required

if isempty(firstValidIndex)

    fprintf('\n');
    fprintf('Platform Validity       : FAIL\n');
    fprintf('No tested spring setup keeps the vehicle\n');
    fprintf('inside the aero map at %.0f km/h.\n', ...
        studySpeedKPH);

else

    fprintf('\n');
    fprintf('FIRST VALID CONFIGURATION\n');
    fprintf('--------------------------------------------\n');

    fprintf('Spring Multiplier       : %.2f\n', ...
        springMultiplier(firstValidIndex));

    fprintf('Front Spring            : %.1f N/mm\n', ...
        frontSpring(firstValidIndex));

    fprintf('Rear Spring             : %.1f N/mm\n', ...
        rearSpring(firstValidIndex));

    fprintf('Front Ride Height       : %.2f mm\n', ...
        frontRH(firstValidIndex));

    fprintf('Rear Ride Height        : %.2f mm\n', ...
        rearRH(firstValidIndex));

    fprintf('Rake Angle              : %.4f deg\n', ...
        rake(firstValidIndex));

    fprintf('Lift Coefficient        : %.4f\n', ...
        CL(firstValidIndex));

    fprintf('Downforce               : %.1f N\n', ...
        downforce(firstValidIndex));

end


%% Baseline case

[~, baselineIndex] = ...
    min(abs(springMultiplier - 1.0));

fprintf('\n');
fprintf('BASELINE CONFIGURATION\n');
fprintf('--------------------------------------------\n');

fprintf('Spring Multiplier       : %.2f\n', ...
    springMultiplier(baselineIndex));

fprintf('Front Spring            : %.1f N/mm\n', ...
    frontSpring(baselineIndex));

fprintf('Rear Spring             : %.1f N/mm\n', ...
    rearSpring(baselineIndex));

fprintf('Front Ride Height       : %.2f mm\n', ...
    frontRH(baselineIndex));

fprintf('Rear Ride Height        : %.2f mm\n', ...
    rearRH(baselineIndex));

fprintf('Rake Angle              : %.4f deg\n', ...
    rake(baselineIndex));

fprintf('Lift Coefficient        : %.4f\n', ...
    CL(baselineIndex));

fprintf('Downforce               : %.1f N\n', ...
    downforce(baselineIndex));

fprintf('============================================\n');


%% ============================================================
%  8. FIGURE 1 - RIDE HEIGHT
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6B - Figure 1 - Spring Stiffness vs Ride Height');

plot( ...
    springMultiplier, ...
    frontRH, ...
    '-o', ...
    'LineWidth',1.5);

hold on;

plot( ...
    springMultiplier, ...
    rearRH, ...
    '-s', ...
    'LineWidth',1.5);

yline( ...
    AeroMap.minFrontRH, ...
    '--', ...
    'Front Aero Map Minimum');

yline( ...
    AeroMap.minRearRH, ...
    '--', ...
    'Rear Aero Map Minimum');

grid on;

xlabel('Spring Stiffness Multiplier [-]');
ylabel('Ride Height [mm]');

title( ...
    'Stage 5.6B - Figure 1 - Spring Stiffness vs Ride Height');

legend( ...
    'Front Ride Height', ...
    'Rear Ride Height', ...
    'Location','best');


%% ============================================================
%  9. FIGURE 2 - SUSPENSION COMPRESSION
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6B - Figure 2 - Spring Stiffness vs Compression');

plot( ...
    springMultiplier, ...
    frontCompression, ...
    '-o', ...
    'LineWidth',1.5);

hold on;

plot( ...
    springMultiplier, ...
    rearCompression, ...
    '-s', ...
    'LineWidth',1.5);

grid on;

xlabel('Spring Stiffness Multiplier [-]');
ylabel('Suspension Compression [mm]');

title( ...
    'Stage 5.6B - Figure 2 - Spring Stiffness vs Suspension Compression');

legend( ...
    'Front Compression', ...
    'Rear Compression', ...
    'Location','best');


%% ============================================================
%  10. FIGURE 3 - RAKE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6B - Figure 3 - Spring Stiffness vs Rake');

plot( ...
    springMultiplier, ...
    rake, ...
    '-o', ...
    'LineWidth',1.5);

grid on;

xlabel('Spring Stiffness Multiplier [-]');
ylabel('Rake Angle [deg]');

title( ...
    'Stage 5.6B - Figure 3 - Spring Stiffness vs Rake');


%% ============================================================
%  11. FIGURE 4 - AERODYNAMIC PERFORMANCE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6B - Figure 4 - Spring Stiffness vs Aero Performance');

plot( ...
    springMultiplier, ...
    CL, ...
    '-o', ...
    'LineWidth',1.5);

hold on;

plot( ...
    springMultiplier, ...
    CD, ...
    '-s', ...
    'LineWidth',1.5);

grid on;

xlabel('Spring Stiffness Multiplier [-]');
ylabel('Aerodynamic Coefficient [-]');

title( ...
    'Stage 5.6B - Figure 4 - Spring Stiffness vs Aerodynamic Performance');

legend( ...
    'C_L', ...
    'C_D', ...
    'Location','best');


%% ============================================================
%  12. FIGURE 5 - DOWNFORCE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6B - Figure 5 - Spring Stiffness vs Downforce');

plot( ...
    springMultiplier, ...
    downforce, ...
    '-o', ...
    'LineWidth',1.5);

grid on;

xlabel('Spring Stiffness Multiplier [-]');
ylabel('Downforce [N]');

title( ...
    'Stage 5.6B - Figure 5 - Spring Stiffness vs Downforce');


end