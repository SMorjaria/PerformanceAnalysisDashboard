function SpeedStudy = speedSensitivityStudy( ...
    Vehicle, Setup, Operating, Tyre, Constants)
%SPEEDSENSITIVITYSTUDY
%
% Stage 3.6A - Speed Sensitivity Study
%
% Investigates how vehicle speed affects the coupled
% steady-state lateral response at a fixed steering angle.
%
% Engineering chain:
%
%   Vehicle Speed
%       ↓
%   Coupled Lateral Response
%       ↓
%   Lateral Acceleration
%       ↓
%   Load Transfer
%       ↓
%   Cornering Stiffness
%       ↓
%   Yaw Response / Vehicle Balance


%% ============================================================
%  SPEED SWEEP
%  ============================================================

speedKPH = 30:5:120;

nPoints = length(speedKPH);


%% ============================================================
%  FIXED OPERATING CONDITIONS
%  ============================================================

% Use the steering angle selected by the user in Main.
steerAngle = Operating.steerAngle;


%% ============================================================
%  PREALLOCATE RESULTS
%  ============================================================

ay = zeros(nPoints,1);
ay_g = zeros(nPoints,1);

yawRate = zeros(nPoints,1);
beta = zeros(nPoints,1);

Kus = zeros(nPoints,1);

Cf = zeros(nPoints,1);
Cr = zeros(nPoints,1);

frontTransfer = zeros(nPoints,1);
rearTransfer = zeros(nPoints,1);

iterations = zeros(nPoints,1);

valid = false(nPoints,1);


%% ============================================================
%  RUN SPEED SWEEP
%  ============================================================

for i = 1:nPoints

    %% --------------------------------------------------------
    %  OPERATING CONDITION
    %  ---------------------------------------------------------

    OperatingSweep = Operating;

    OperatingSweep.speed = ...
        speedKPH(i) / 3.6;

    OperatingSweep.steerAngle = ...
        steerAngle;

    % Stage 3.5 determines the internally consistent ay
    OperatingSweep.ay = 0;


    try

        %% ----------------------------------------------------
        %  RUN COUPLED LATERAL SOLVER
        %  -----------------------------------------------------

        CoupledSweep = ...
            calculateCoupledLateralResponse( ...
                Vehicle, ...
                Setup, ...
                OperatingSweep, ...
                Tyre, ...
                Constants);


        %% ----------------------------------------------------
        %  VEHICLE RESPONSE
        %  -----------------------------------------------------

        ay(i) = ...
            CoupledSweep.Response.ay;

        ay_g(i) = ...
            CoupledSweep.Response.ay / Constants.g;

        yawRate(i) = ...
            CoupledSweep.Response.yawRate;

        beta(i) = ...
            rad2deg(CoupledSweep.Response.beta);


        %% ----------------------------------------------------
        %  VEHICLE BALANCE
        %  -----------------------------------------------------

        Kus(i) = ...
            CoupledSweep.Balance.Kus_deg_per_g;


        %% ----------------------------------------------------
        %  CORNERING STIFFNESS
        %  -----------------------------------------------------

        Cf(i) = ...
            CoupledSweep.Cornering.CalphaFront;

        Cr(i) = ...
            CoupledSweep.Cornering.CalphaRear;


        %% ----------------------------------------------------
        %  LOAD TRANSFER
        %  -----------------------------------------------------

        frontTransfer(i) = ...
            CoupledSweep.Lateral.frontLoadTransfer;

        rearTransfer(i) = ...
            CoupledSweep.Lateral.rearLoadTransfer;


        %% ----------------------------------------------------
        %  SOLVER INFORMATION
        %  -----------------------------------------------------

        iterations(i) = ...
            CoupledSweep.iterations;

        valid(i) = ...
            CoupledSweep.converged;


    catch ME

        ay(i) = NaN;
        ay_g(i) = NaN;

        yawRate(i) = NaN;
        beta(i) = NaN;

        Kus(i) = NaN;

        Cf(i) = NaN;
        Cr(i) = NaN;

        frontTransfer(i) = NaN;
        rearTransfer(i) = NaN;

        iterations(i) = NaN;

        valid(i) = false;

        warning( ...
            'Stage 3.6A failed at %.0f km/h: %s', ...
            speedKPH(i), ...
            ME.message);

    end

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

SpeedStudy.speedKPH = speedKPH;

SpeedStudy.steerAngle = steerAngle;

SpeedStudy.ay = ay;
SpeedStudy.ay_g = ay_g;

SpeedStudy.yawRate = yawRate;
SpeedStudy.beta = beta;

SpeedStudy.Kus = Kus;

SpeedStudy.Cf = Cf;
SpeedStudy.Cr = Cr;

SpeedStudy.frontTransfer = frontTransfer;
SpeedStudy.rearTransfer = rearTransfer;

SpeedStudy.iterations = iterations;

SpeedStudy.valid = valid;


%% ============================================================
%  STAGE 3.6A - FIGURE 1
%
%  SPEED VS LATERAL ACCELERATION
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6A - Figure 1 - ', ...
     'Speed vs Lateral Acceleration'], ...
    'NumberTitle','off');

plot( ...
    speedKPH, ...
    ay_g, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Lateral Acceleration [g]');

title( ...
    ['Stage 3.6A - Speed Sensitivity: ', ...
     'Lateral Acceleration']);


%% ============================================================
%  STAGE 3.6A - FIGURE 2
%
%  SPEED VS YAW RATE
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6A - Figure 2 - ', ...
     'Speed vs Yaw Rate'], ...
    'NumberTitle','off');

plot( ...
    speedKPH, ...
    rad2deg(yawRate), ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Yaw Rate [deg/s]');

title( ...
    ['Stage 3.6A - Speed Sensitivity: ', ...
     'Yaw Rate']);


%% ============================================================
%  STAGE 3.6A - FIGURE 3
%
%  SPEED VS CG SIDESLIP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6A - Figure 3 - ', ...
     'Speed vs CG Sideslip'], ...
    'NumberTitle','off');

plot( ...
    speedKPH, ...
    beta, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('CG Sideslip Angle [deg]');

title( ...
    ['Stage 3.6A - Speed Sensitivity: ', ...
     'CG Sideslip']);


%% ============================================================
%  STAGE 3.6A - FIGURE 4
%
%  SPEED VS UNDERSTEER GRADIENT
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6A - Figure 4 - ', ...
     'Speed vs Understeer Gradient'], ...
    'NumberTitle','off');

plot( ...
    speedKPH, ...
    Kus, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Understeer Gradient [deg/g]');

title( ...
    ['Stage 3.6A - Speed Sensitivity: ', ...
     'Vehicle Balance']);


%% ============================================================
%  STAGE 3.6A - FIGURE 5
%
%  SPEED VS CORNERING STIFFNESS
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6A - Figure 5 - ', ...
     'Speed vs Cornering Stiffness'], ...
    'NumberTitle','off');

plot( ...
    speedKPH, ...
    Cf / 1000, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Front Axle');

hold on;

plot( ...
    speedKPH, ...
    Cr / 1000, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5, ...
    'DisplayName','Rear Axle');

grid on;
box on;

xlabel('Vehicle Speed [km/h]');
ylabel('Axle Cornering Stiffness [kN/rad]');

title( ...
    ['Stage 3.6A - Speed Sensitivity: ', ...
     'Cornering Stiffness']);

legend('Location','best');


%% ============================================================
%  DISPLAY STUDY SUMMARY
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('      SPEED SENSITIVITY - STAGE 3.6A\n');
fprintf('============================================\n');

fprintf( ...
    'Speed Range             : %.0f to %.0f km/h\n', ...
    min(speedKPH), ...
    max(speedKPH));

fprintf( ...
    'Steering Angle          : %.2f deg\n', ...
    steerAngle);

fprintf('\n');

fprintf( ...
    'Lateral Accel. Range    : %.3f to %.3f g\n', ...
    min(ay_g,[],'omitnan'), ...
    max(ay_g,[],'omitnan'));

fprintf( ...
    'Yaw Rate Range          : %.2f to %.2f deg/s\n', ...
    min(rad2deg(yawRate),[],'omitnan'), ...
    max(rad2deg(yawRate),[],'omitnan'));

fprintf( ...
    'Understeer Gradient     : %.5f to %.5f deg/g\n', ...
    min(Kus,[],'omitnan'), ...
    max(Kus,[],'omitnan'));

fprintf('\n');

fprintf( ...
    'Converged Cases         : %d / %d\n', ...
    sum(valid), ...
    nPoints);

fprintf('============================================\n');

end