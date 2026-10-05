function PlatformSensitivity = aeroPlatformSensitivityStudy( ...
    Vehicle, Setup, AeroMap, Constants)
%AEROPLATFORMSENSITIVITYSTUDY
%
% Stage 4.4 - Aero Balance Migration & Platform Sensitivity
%
% Investigates two fundamental aerodynamic platform modes:
%
%   4.4A - Heave
%   4.4B - Pitch / Rake
%
% HEAVE:
%
%   Front and rear ride heights change by the same amount.
%   The nominal ride-height difference is therefore preserved.
%
% PITCH / RAKE:
%
%   Front and rear ride heights move equal and opposite amounts.
%   Positive pitch displacement increases vehicle rake.
%
% The study evaluates:
%
%   CL
%   CD
%   CL/CD
%   Front aero balance
%   Total downforce
%   Front aero load
%   Rear aero load
%
% IMPORTANT:
% Aero-map coefficients are generic demonstration values and do
% not represent aerodynamic data from a real Formula 1 vehicle.


%% ============================================================
%  REFERENCE OPERATING CONDITION
%  ============================================================

referenceSpeedKPH = 180;

referenceSpeed = ...
    referenceSpeedKPH / 3.6;

dynamicPressure = ...
    0.5 * Constants.rho * referenceSpeed^2;

referenceArea = ...
    Vehicle.referenceArea;


%% ============================================================
%  BASELINE PLATFORM
%  ============================================================

hF0 = Setup.rideHeightFront;
hR0 = Setup.rideHeightRear;


%% ============================================================
%  4.4A - HEAVE SWEEP
%  ============================================================
%
% Negative:
%   Vehicle moves closer to ground.
%
% Positive:
%   Vehicle moves away from ground.
%

heave = -10:1:15;

nHeave = length(heave);


%% ============================================================
%  PREALLOCATE HEAVE RESULTS
%  ============================================================

heaveFrontRH = zeros(nHeave,1);
heaveRearRH = zeros(nHeave,1);

heaveCL = zeros(nHeave,1);
heaveCD = zeros(nHeave,1);
heaveEfficiency = zeros(nHeave,1);

heaveBalance = zeros(nHeave,1);

heaveDownforce = zeros(nHeave,1);

heaveFrontLoad = zeros(nHeave,1);
heaveRearLoad = zeros(nHeave,1);


%% ============================================================
%  RUN HEAVE SWEEP
%  ============================================================

for i = 1:nHeave

    SetupSweep = Setup;

    SetupSweep.rideHeightFront = ...
        hF0 + heave(i);

    SetupSweep.rideHeightRear = ...
        hR0 + heave(i);


    AeroState = ...
        calculateAeroMap( ...
            Vehicle, ...
            SetupSweep, ...
            AeroMap);


    %% --------------------------------------------------------
    %  STORE PLATFORM
    %  ---------------------------------------------------------

    heaveFrontRH(i) = ...
        SetupSweep.rideHeightFront;

    heaveRearRH(i) = ...
        SetupSweep.rideHeightRear;


    %% --------------------------------------------------------
    %  STORE AERO COEFFICIENTS
    %  ---------------------------------------------------------

    heaveCL(i) = ...
        AeroState.CL;

    heaveCD(i) = ...
        AeroState.CD;

    heaveEfficiency(i) = ...
        AeroState.CLtoCD;

    heaveBalance(i) = ...
        AeroState.frontBalance * 100;


    %% --------------------------------------------------------
    %  AERODYNAMIC FORCE
    %  ---------------------------------------------------------

    heaveDownforce(i) = ...
        dynamicPressure * ...
        referenceArea * ...
        AeroState.CL;


    %% --------------------------------------------------------
    %  FRONT / REAR AERO LOAD
    %  ---------------------------------------------------------

    heaveFrontLoad(i) = ...
        heaveDownforce(i) * ...
        AeroState.frontBalance;

    heaveRearLoad(i) = ...
        heaveDownforce(i) * ...
        AeroState.rearBalance;

end


%% ============================================================
%  4.4B - PITCH / RAKE SWEEP
%  ============================================================
%
% Positive pitch displacement:
%
%       Front RH decreases
%       Rear RH increases
%
% therefore increasing rake.
%

pitch = -10:1:10;

nPitch = length(pitch);


%% ============================================================
%  PREALLOCATE PITCH RESULTS
%  ============================================================

pitchFrontRH = zeros(nPitch,1);
pitchRearRH = zeros(nPitch,1);

pitchRake = zeros(nPitch,1);

pitchCL = zeros(nPitch,1);
pitchCD = zeros(nPitch,1);
pitchEfficiency = zeros(nPitch,1);

pitchBalance = zeros(nPitch,1);

pitchDownforce = zeros(nPitch,1);

pitchFrontLoad = zeros(nPitch,1);
pitchRearLoad = zeros(nPitch,1);


%% ============================================================
%  RUN PITCH / RAKE SWEEP
%  ============================================================

for i = 1:nPitch

    SetupSweep = Setup;


    %% --------------------------------------------------------
    %  APPLY PITCH MODE
    %  ---------------------------------------------------------

    SetupSweep.rideHeightFront = ...
        hF0 - pitch(i);

    SetupSweep.rideHeightRear = ...
        hR0 + pitch(i);


    %% --------------------------------------------------------
    %  CALCULATE AERO STATE
    %  ---------------------------------------------------------

    AeroState = ...
        calculateAeroMap( ...
            Vehicle, ...
            SetupSweep, ...
            AeroMap);


    %% --------------------------------------------------------
    %  STORE PLATFORM
    %  ---------------------------------------------------------

    pitchFrontRH(i) = ...
        SetupSweep.rideHeightFront;

    pitchRearRH(i) = ...
        SetupSweep.rideHeightRear;

    pitchRake(i) = ...
        AeroState.rakeAngleDeg;


    %% --------------------------------------------------------
    %  STORE AERO COEFFICIENTS
    %  ---------------------------------------------------------

    pitchCL(i) = ...
        AeroState.CL;

    pitchCD(i) = ...
        AeroState.CD;

    pitchEfficiency(i) = ...
        AeroState.CLtoCD;

    pitchBalance(i) = ...
        AeroState.frontBalance * 100;


    %% --------------------------------------------------------
    %  AERODYNAMIC FORCE
    %  ---------------------------------------------------------

    pitchDownforce(i) = ...
        dynamicPressure * ...
        referenceArea * ...
        AeroState.CL;


    %% --------------------------------------------------------
    %  FRONT / REAR AERO LOAD
    %  ---------------------------------------------------------

    pitchFrontLoad(i) = ...
        pitchDownforce(i) * ...
        AeroState.frontBalance;

    pitchRearLoad(i) = ...
        pitchDownforce(i) * ...
        AeroState.rearBalance;

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

PlatformSensitivity.referenceSpeedKPH = ...
    referenceSpeedKPH;

PlatformSensitivity.dynamicPressure = ...
    dynamicPressure;


%% HEAVE

PlatformSensitivity.heave.displacement = ...
    heave;

PlatformSensitivity.heave.frontRH = ...
    heaveFrontRH;

PlatformSensitivity.heave.rearRH = ...
    heaveRearRH;

PlatformSensitivity.heave.CL = ...
    heaveCL;

PlatformSensitivity.heave.CD = ...
    heaveCD;

PlatformSensitivity.heave.efficiency = ...
    heaveEfficiency;

PlatformSensitivity.heave.frontBalance = ...
    heaveBalance;

PlatformSensitivity.heave.downforce = ...
    heaveDownforce;

PlatformSensitivity.heave.frontLoad = ...
    heaveFrontLoad;

PlatformSensitivity.heave.rearLoad = ...
    heaveRearLoad;


%% PITCH

PlatformSensitivity.pitch.displacement = ...
    pitch;

PlatformSensitivity.pitch.frontRH = ...
    pitchFrontRH;

PlatformSensitivity.pitch.rearRH = ...
    pitchRearRH;

PlatformSensitivity.pitch.rake = ...
    pitchRake;

PlatformSensitivity.pitch.CL = ...
    pitchCL;

PlatformSensitivity.pitch.CD = ...
    pitchCD;

PlatformSensitivity.pitch.efficiency = ...
    pitchEfficiency;

PlatformSensitivity.pitch.frontBalance = ...
    pitchBalance;

PlatformSensitivity.pitch.downforce = ...
    pitchDownforce;

PlatformSensitivity.pitch.frontLoad = ...
    pitchFrontLoad;

PlatformSensitivity.pitch.rearLoad = ...
    pitchRearLoad;


%% ============================================================
%  STAGE 4.4A - FIGURE 1
%
%  HEAVE VS LIFT COEFFICIENT
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4A - Figure 1 - ', ...
     'Heave vs Lift Coefficient'], ...
    'NumberTitle','off');

plot( ...
    heave, ...
    heaveCL, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

hold on;

xline( ...
    0, ...
    '--', ...
    'Baseline', ...
    'HandleVisibility','off');

grid on;
box on;

xlabel('Heave Displacement [mm]');
ylabel('Lift Coefficient, C_L');

title( ...
    ['Stage 4.4A - Platform Sensitivity: ', ...
     'Heave vs Lift Coefficient']);


%% ============================================================
%  STAGE 4.4A - FIGURE 2
%
%  HEAVE VS AERO BALANCE
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4A - Figure 2 - ', ...
     'Heave vs Aero Balance'], ...
    'NumberTitle','off');

plot( ...
    heave, ...
    heaveBalance, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

hold on;

xline( ...
    0, ...
    '--', ...
    'Baseline', ...
    'HandleVisibility','off');

grid on;
box on;

xlabel('Heave Displacement [mm]');
ylabel('Front Aero Balance [%]');

title( ...
    ['Stage 4.4A - Platform Sensitivity: ', ...
     'Heave vs Aero Balance']);


%% ============================================================
%  STAGE 4.4A - FIGURE 3
%
%  HEAVE VS DOWNFORCE
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4A - Figure 3 - ', ...
     'Heave vs Downforce'], ...
    'NumberTitle','off');

plot( ...
    heave, ...
    heaveDownforce, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

hold on;

xline( ...
    0, ...
    '--', ...
    'Baseline', ...
    'HandleVisibility','off');

grid on;
box on;

xlabel('Heave Displacement [mm]');
ylabel('Total Downforce [N]');

title( ...
    sprintf( ...
    'Stage 4.4A - Heave Sensitivity at %.0f km/h', ...
    referenceSpeedKPH));


%% ============================================================
%  STAGE 4.4B - FIGURE 1
%
%  RAKE VS LIFT COEFFICIENT
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4B - Figure 1 - ', ...
     'Rake vs Lift Coefficient'], ...
    'NumberTitle','off');

plot( ...
    pitchRake, ...
    pitchCL, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Rake Angle [deg]');
ylabel('Lift Coefficient, C_L');

title( ...
    ['Stage 4.4B - Platform Sensitivity: ', ...
     'Rake vs Lift Coefficient']);


%% ============================================================
%  STAGE 4.4B - FIGURE 2
%
%  RAKE VS FRONT AERO BALANCE
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4B - Figure 2 - ', ...
     'Rake vs Aero Balance'], ...
    'NumberTitle','off');

plot( ...
    pitchRake, ...
    pitchBalance, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Rake Angle [deg]');
ylabel('Front Aero Balance [%]');

title( ...
    ['Stage 4.4B - Platform Sensitivity: ', ...
     'Aero Balance Migration']);


%% ============================================================
%  STAGE 4.4B - FIGURE 3
%
%  RAKE VS FRONT / REAR AERO LOAD
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.4B - Figure 3 - ', ...
     'Rake vs Axle Aero Load'], ...
    'NumberTitle','off');

plot( ...
    pitchRake, ...
    pitchFrontLoad, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Front Axle');

hold on;

plot( ...
    pitchRake, ...
    pitchRearLoad, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Rear Axle');

grid on;
box on;

xlabel('Rake Angle [deg]');
ylabel('Aerodynamic Axle Load [N]');

title( ...
    sprintf( ...
    ['Stage 4.4B - Aero Load Migration ', ...
     'at %.0f km/h'], ...
    referenceSpeedKPH));

legend('Location','best');


%% ============================================================
%  COMMAND WINDOW SUMMARY
%  ============================================================

baselineIndexHeave = ...
    find(heave == 0,1);

baselineIndexPitch = ...
    find(pitch == 0,1);


fprintf('\n');
fprintf('============================================\n');
fprintf('    AERO PLATFORM SENSITIVITY - STAGE 4.4\n');
fprintf('============================================\n');

fprintf('\n');

fprintf('REFERENCE CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Reference Speed          : %8.1f km/h\n', ...
    referenceSpeedKPH);

fprintf( ...
    'Baseline Front RH        : %8.1f mm\n', ...
    hF0);

fprintf( ...
    'Baseline Rear RH         : %8.1f mm\n', ...
    hR0);


fprintf('\n');

fprintf('BASELINE AERODYNAMIC STATE\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Lift Coefficient         : %8.3f\n', ...
    heaveCL(baselineIndexHeave));

fprintf( ...
    'Drag Coefficient         : %8.3f\n', ...
    heaveCD(baselineIndexHeave));

fprintf( ...
    'Front Aero Balance       : %8.2f %%\n', ...
    heaveBalance(baselineIndexHeave));

fprintf( ...
    'Downforce @ 180 km/h     : %8.1f N\n', ...
    heaveDownforce(baselineIndexHeave));


fprintf('\n');

fprintf('HEAVE SENSITIVITY\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'CL Range                 : %.3f to %.3f\n', ...
    min(heaveCL), ...
    max(heaveCL));

fprintf( ...
    'Front Balance Range      : %.2f to %.2f %%\n', ...
    min(heaveBalance), ...
    max(heaveBalance));


fprintf('\n');

fprintf('PITCH / RAKE SENSITIVITY\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Rake Range               : %.3f to %.3f deg\n', ...
    min(pitchRake), ...
    max(pitchRake));

fprintf( ...
    'CL Range                 : %.3f to %.3f\n', ...
    min(pitchCL), ...
    max(pitchCL));

fprintf( ...
    'Front Balance Range      : %.2f to %.2f %%\n', ...
    min(pitchBalance), ...
    max(pitchBalance));

fprintf('============================================\n');


end