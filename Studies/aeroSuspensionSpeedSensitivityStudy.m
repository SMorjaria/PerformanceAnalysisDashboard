function Study = aeroSuspensionSpeedSensitivityStudy( ...
    Vehicle, Setup, Operating, Constants, Suspension, AeroMap)
%AEROSUSPENSIONSPEEDSENSITIVITYSTUDY
%
% Stage 5.6A - Speed / Aero-Platform Sensitivity
%
% Sweeps vehicle speed and solves the coupled Stage 5.5
% aero-suspension equilibrium at every operating point.


%% ============================================================
%  1. SPEED RANGE
%  ============================================================

speedKPH = 30:5:180;

nSpeed = length(speedKPH);


%% ============================================================
%  2. PREALLOCATE
%  ============================================================

frontRH = nan(1,nSpeed);
rearRH = nan(1,nSpeed);

frontCompression = nan(1,nSpeed);
rearCompression = nan(1,nSpeed);

heave = nan(1,nSpeed);
rake = nan(1,nSpeed);

CL = nan(1,nSpeed);
CD = nan(1,nSpeed);
frontBalance = nan(1,nSpeed);

downforce = nan(1,nSpeed);

iterations = nan(1,nSpeed);
converged = false(1,nSpeed);

insideAeroMap = false(1,nSpeed);


%% ============================================================
%  3. SPEED SWEEP
%  ============================================================

for i = 1:nSpeed

    OperatingSweep = Operating;

    OperatingSweep.speed = ...
        speedKPH(i) / 3.6;


    Equilibrium = calculateAeroSuspensionEquilibrium( ...
        Vehicle, ...
        Setup, ...
        OperatingSweep, ...
        Constants, ...
        Suspension, ...
        AeroMap);


    %% Platform

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


    %% Aerodynamics

    CL(i) = ...
        Equilibrium.AeroState.CL;

    CD(i) = ...
        Equilibrium.AeroState.CD;

    frontBalance(i) = ...
        Equilibrium.AeroState.frontBalance;

    downforce(i) = ...
        Equilibrium.Aero.downforce;


    %% Solver

    iterations(i) = ...
        Equilibrium.iterations;

    converged(i) = ...
        Equilibrium.converged;


    %% Aero-map validity
    %
    % This is deliberately checked rather than silently
    % extrapolating outside the Stage 4 map.

    insideAeroMap(i) = ...
        frontRH(i) >= AeroMap.minFrontRH && ...
        frontRH(i) <= AeroMap.maxFrontRH && ...
        rearRH(i) >= AeroMap.minRearRH && ...
        rearRH(i) <= AeroMap.maxRearRH;

end


%% ============================================================
%  4. STORE RESULTS
%  ============================================================

Study.speedKPH = speedKPH;

Study.frontRideHeight = frontRH;
Study.rearRideHeight = rearRH;

Study.frontCompression = frontCompression;
Study.rearCompression = rearCompression;

Study.heave = heave;
Study.rakeAngleDeg = rake;

Study.CL = CL;
Study.CD = CD;
Study.frontBalance = frontBalance;

Study.downforce = downforce;

Study.iterations = iterations;
Study.converged = converged;

Study.insideAeroMap = insideAeroMap;


%% ============================================================
%  5. DISPLAY SUMMARY
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' SPEED / PLATFORM SENSITIVITY - STAGE 5.6A\n');
fprintf('============================================\n');

fprintf('Speed Range             : %.0f to %.0f km/h\n', ...
    min(speedKPH), max(speedKPH));

fprintf('Converged Cases         : %d / %d\n', ...
    sum(converged), nSpeed);

fprintf('Inside Aero Map         : %d / %d\n', ...
    sum(insideAeroMap), nSpeed);


%% Aero-map validity limit

firstInvalidIndex = find(~insideAeroMap, 1, 'first');

if isempty(firstInvalidIndex)

    fprintf('Aero Map Validity       : PASS - Full Speed Range\n');

else

    fprintf('First Invalid Speed     : %.0f km/h\n', ...
        speedKPH(firstInvalidIndex));

    fprintf('Front RH @ Limit        : %.2f mm\n', ...
        frontRH(firstInvalidIndex));

    fprintf('Rear RH @ Limit         : %.2f mm\n', ...
        rearRH(firstInvalidIndex));

end


fprintf('\n');

fprintf('Front RH Range          : %.2f to %.2f mm\n', ...
    min(frontRH), max(frontRH));

fprintf('Rear RH Range           : %.2f to %.2f mm\n', ...
    min(rearRH), max(rearRH));

fprintf('Rake Range              : %.4f to %.4f deg\n', ...
    min(rake), max(rake));

fprintf('Downforce Range         : %.1f to %.1f N\n', ...
    min(downforce), max(downforce));

fprintf('============================================\n');


%% ============================================================
%  6. FIGURE 1 - RIDE HEIGHT
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6A - Figure 1 - Speed vs Ride Height');

plot(speedKPH, frontRH, ...
    '-o', 'LineWidth',1.5);

hold on;

plot(speedKPH, rearRH, ...
    '-s', 'LineWidth',1.5);

grid on;

xlabel('Vehicle Speed [km/h]');
ylabel('Ride Height [mm]');

title( ...
    'Stage 5.6A - Figure 1 - Speed vs Ride Height');

legend( ...
    'Front Ride Height', ...
    'Rear Ride Height', ...
    'Location','best');


%% ============================================================
%  7. FIGURE 2 - SUSPENSION COMPRESSION
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6A - Figure 2 - Speed vs Suspension Compression');

plot(speedKPH, frontCompression, ...
    '-o', 'LineWidth',1.5);

hold on;

plot(speedKPH, rearCompression, ...
    '-s', 'LineWidth',1.5);

grid on;

xlabel('Vehicle Speed [km/h]');
ylabel('Suspension Compression [mm]');

title( ...
    'Stage 5.6A - Figure 2 - Speed vs Suspension Compression');

legend( ...
    'Front Compression', ...
    'Rear Compression', ...
    'Location','best');


%% ============================================================
%  8. FIGURE 3 - RAKE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6A - Figure 3 - Speed vs Rake');

plot(speedKPH, rake, ...
    '-o', 'LineWidth',1.5);

grid on;

xlabel('Vehicle Speed [km/h]');
ylabel('Rake Angle [deg]');

title( ...
    'Stage 5.6A - Figure 3 - Speed vs Rake Angle');


%% ============================================================
%  9. FIGURE 4 - AERODYNAMIC PERFORMANCE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6A - Figure 4 - Speed vs Aero Coefficient');

plot(speedKPH, CL, ...
    '-o', 'LineWidth',1.5);

hold on;

plot(speedKPH, CD, ...
    '-s', 'LineWidth',1.5);

grid on;

xlabel('Vehicle Speed [km/h]');
ylabel('Aerodynamic Coefficient [-]');

title( ...
    'Stage 5.6A - Figure 4 - Platform Influence on Aerodynamics');

legend( ...
    'C_L', ...
    'C_D', ...
    'Location','best');


%% ============================================================
%  10. FIGURE 5 - AERO BALANCE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 5.6A - Figure 5 - Speed vs Aero Balance');

plot(speedKPH, ...
    frontBalance * 100, ...
    '-o', ...
    'LineWidth',1.5);

grid on;

xlabel('Vehicle Speed [km/h]');
ylabel('Front Aero Balance [%]');

title( ...
    'Stage 5.6A - Figure 5 - Aero Balance Migration');


end