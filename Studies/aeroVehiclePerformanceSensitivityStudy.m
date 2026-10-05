function AeroSensitivity = aeroVehiclePerformanceSensitivityStudy( ...
    Vehicle, Setup, Operating, Tyre, Constants, AeroMap)
%AEROVEHICLEPERFORMANCESENSITIVITYSTUDY
%
% Stage 4.6 - Aerodynamic Vehicle Performance Sensitivity
%
% Compares:
%
%   Stage 3.5 - Mechanical-only coupled lateral model
%   Stage 4.5 - Aero-coupled lateral model
%
% across a vehicle-speed sweep.
%
% Outputs investigated:
%   - Aerodynamic downforce
%   - Front and rear cornering stiffness
%   - Lateral acceleration
%   - Understeer gradient
%
% The same steering input is used for both models so that the
% aerodynamic influence can be isolated.


%% ============================================================
%  1. STUDY DEFINITION
%  ============================================================

speedKPH = 30:5:180;

nSpeed = length(speedKPH);

steerAngle = 1.0;        % [deg]

ax = 0;                  % [m/s^2]
initialAy = 0;           % [m/s^2]


%% ============================================================
%  2. PREALLOCATE RESULTS
%  ============================================================

% Aerodynamics

downforce = nan(nSpeed,1);
frontAeroLoad = nan(nSpeed,1);
rearAeroLoad = nan(nSpeed,1);


% Mechanical-only model

ayMechanical = nan(nSpeed,1);
yawMechanical = nan(nSpeed,1);

CfMechanical = nan(nSpeed,1);
CrMechanical = nan(nSpeed,1);

KusMechanical = nan(nSpeed,1);


% Aero-coupled model

ayAero = nan(nSpeed,1);
yawAero = nan(nSpeed,1);

CfAero = nan(nSpeed,1);
CrAero = nan(nSpeed,1);

KusAero = nan(nSpeed,1);


% Solver status

mechanicalConverged = false(nSpeed,1);
aeroConverged = false(nSpeed,1);


%% ============================================================
%  3. SPEED SWEEP
%  ============================================================

for i = 1:nSpeed

    % --------------------------------------------------------
    % Operating condition
    % --------------------------------------------------------

    OperatingSweep = Operating;

    OperatingSweep.speed = speedKPH(i) / 3.6;

    OperatingSweep.ax = ax;

    OperatingSweep.ay = initialAy;

    OperatingSweep.steerAngle = steerAngle;


    % ========================================================
    % STAGE 3.5 - MECHANICAL MODEL
    % ========================================================

    Mechanical = calculateCoupledLateralResponse( ...
        Vehicle, ...
        Setup, ...
        OperatingSweep, ...
        Tyre, ...
        Constants);


    mechanicalConverged(i) = Mechanical.converged;

    if Mechanical.converged

        ayMechanical(i) = Mechanical.Response.ay;

        yawMechanical(i) = ...
            Mechanical.Response.yawRate;

        CfMechanical(i) = ...
            Mechanical.Cornering.CalphaFront;

        CrMechanical(i) = ...
            Mechanical.Cornering.CalphaRear;

        KusMechanical(i) = ...
            Mechanical.Balance.Kus_deg_per_g;

    end


    % ========================================================
    % STAGE 4.5 - AERO-COUPLED MODEL
    % ========================================================

    Aero = calculateAeroCoupledLateralResponse( ...
        Vehicle, ...
        Setup, ...
        OperatingSweep, ...
        Tyre, ...
        Constants, ...
        AeroMap);


    aeroConverged(i) = Aero.converged;

    if Aero.converged

        ayAero(i) = Aero.Response.ay;

        yawAero(i) = ...
            Aero.Response.yawRate;

        CfAero(i) = ...
            Aero.Cornering.CalphaFront;

        CrAero(i) = ...
            Aero.Cornering.CalphaRear;

        KusAero(i) = ...
            Aero.Balance.Kus_deg_per_g;


        % ----------------------------------------------------
        % Aerodynamic loading
        % ----------------------------------------------------

        downforce(i) = ...
            Aero.Aero.downforce;

        frontAeroLoad(i) = ...
            Aero.AeroLoad.FL + ...
            Aero.AeroLoad.FR;

        rearAeroLoad(i) = ...
            Aero.AeroLoad.RL + ...
            Aero.AeroLoad.RR;

    end

end


%% ============================================================
%  4. DERIVED COMPARISON PARAMETERS
%  ============================================================

ayMechanical_g = ayMechanical / Constants.g;
ayAero_g = ayAero / Constants.g;


deltaAy_g = ...
    ayAero_g - ayMechanical_g;


deltaCf = ...
    CfAero - CfMechanical;

deltaCr = ...
    CrAero - CrMechanical;


deltaKus = ...
    KusAero - KusMechanical;


%% ============================================================
%  5. STORE RESULTS
%  ============================================================

AeroSensitivity.speedKPH = speedKPH(:);

AeroSensitivity.steerAngle = steerAngle;


% Aerodynamics

AeroSensitivity.downforce = downforce;

AeroSensitivity.frontAeroLoad = frontAeroLoad;

AeroSensitivity.rearAeroLoad = rearAeroLoad;


% Mechanical model

AeroSensitivity.mechanical.ay = ayMechanical;

AeroSensitivity.mechanical.ay_g = ayMechanical_g;

AeroSensitivity.mechanical.yawRate = yawMechanical;

AeroSensitivity.mechanical.Cf = CfMechanical;

AeroSensitivity.mechanical.Cr = CrMechanical;

AeroSensitivity.mechanical.Kus = KusMechanical;


% Aero model

AeroSensitivity.aero.ay = ayAero;

AeroSensitivity.aero.ay_g = ayAero_g;

AeroSensitivity.aero.yawRate = yawAero;

AeroSensitivity.aero.Cf = CfAero;

AeroSensitivity.aero.Cr = CrAero;

AeroSensitivity.aero.Kus = KusAero;


% Differences

AeroSensitivity.deltaAy_g = deltaAy_g;

AeroSensitivity.deltaCf = deltaCf;

AeroSensitivity.deltaCr = deltaCr;

AeroSensitivity.deltaKus = deltaKus;


% Convergence

AeroSensitivity.mechanicalConverged = ...
    mechanicalConverged;

AeroSensitivity.aeroConverged = ...
    aeroConverged;


%% ============================================================
%  6. COMMAND WINDOW SUMMARY
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf(' AERO PERFORMANCE SENSITIVITY - STAGE 4.6\n');
fprintf('============================================\n');

fprintf('Speed Range             : %.0f to %.0f km/h\n', ...
    min(speedKPH), max(speedKPH));

fprintf('Steering Angle          : %.2f deg\n', ...
    steerAngle);

fprintf('\n');

fprintf('Mechanical Convergence  : %d / %d\n', ...
    sum(mechanicalConverged), nSpeed);

fprintf('Aero Convergence        : %d / %d\n', ...
    sum(aeroConverged), nSpeed);

fprintf('\n');

fprintf('Downforce Range         : %.1f to %.1f N\n', ...
    min(downforce), max(downforce));

fprintf('Front C_alpha Increase  : %.1f to %.1f kN/rad\n', ...
    min(deltaCf)/1000, max(deltaCf)/1000);

fprintf('Rear C_alpha Increase   : %.1f to %.1f kN/rad\n', ...
    min(deltaCr)/1000, max(deltaCr)/1000);

fprintf('============================================\n');


%% ============================================================
%  7. FIGURE 1 - AERODYNAMIC DOWNFORCE
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 1 - Speed vs Aerodynamic Downforce');

plot(speedKPH, downforce, ...
    'LineWidth', 1.8);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Aerodynamic Downforce [N]');

title('Aerodynamic Downforce vs Vehicle Speed');


%% ============================================================
%  8. FIGURE 2 - AXLE AERODYNAMIC LOAD
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 2 - Speed vs Axle Aerodynamic Load');

plot(speedKPH, frontAeroLoad, ...
    'LineWidth', 1.8);

hold on;

plot(speedKPH, rearAeroLoad, ...
    'LineWidth', 1.8);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Aerodynamic Vertical Load [N]');

title('Axle Aerodynamic Loading vs Vehicle Speed');

legend( ...
    'Front Axle', ...
    'Rear Axle', ...
    'Location','northwest');


%% ============================================================
%  9. FIGURE 3 - FRONT CORNERING STIFFNESS
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 3 - Speed vs Front Cornering Stiffness');

plot(speedKPH, CfMechanical/1000, ...
    'LineWidth', 1.8);

hold on;

plot(speedKPH, CfAero/1000, ...
    'LineWidth', 1.8);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Front Axle C_\alpha [kN/rad]');

title('Front Cornering Stiffness vs Vehicle Speed');

legend( ...
    'Mechanical Only', ...
    'Aero Coupled', ...
    'Location','northwest');


%% ============================================================
%  10. FIGURE 4 - REAR CORNERING STIFFNESS
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 4 - Speed vs Rear Cornering Stiffness');

plot(speedKPH, CrMechanical/1000, ...
    'LineWidth', 1.8);

hold on;

plot(speedKPH, CrAero/1000, ...
    'LineWidth', 1.8);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Rear Axle C_\alpha [kN/rad]');

title('Rear Cornering Stiffness vs Vehicle Speed');

legend( ...
    'Mechanical Only', ...
    'Aero Coupled', ...
    'Location','northwest');


%% ============================================================
%  11. FIGURE 5 - LATERAL ACCELERATION
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 5 - Speed vs Lateral Acceleration');

plot(speedKPH, ayMechanical_g, ...
    'LineWidth', 1.8);

hold on;

plot(speedKPH, ayAero_g, ...
    'LineWidth', 1.8);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Lateral Acceleration [g]');

title('Lateral Response vs Vehicle Speed');

legend( ...
    'Mechanical Only', ...
    'Aero Coupled', ...
    'Location','northwest');


%% ============================================================
%  12. FIGURE 6 - UNDERSTEER GRADIENT
%  ============================================================

figure( ...
    'Name', ...
    'Stage 4.6 - Figure 6 - Speed vs Understeer Gradient');

plot(speedKPH, KusMechanical, ...
    'LineWidth', 1.8);

hold on;

plot(speedKPH, KusAero, ...
    'LineWidth', 1.8);

yline(0, '--');

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Understeer Gradient [deg/g]');

title('Vehicle Balance vs Vehicle Speed');

legend( ...
    'Mechanical Only', ...
    'Aero Coupled', ...
    'Neutral Steer', ...
    'Location','best');


end