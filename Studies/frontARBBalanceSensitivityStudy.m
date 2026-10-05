function ARBBalanceStudy = frontARBBalanceSensitivityStudy( ...
    Vehicle, Setup, Operating, Tyre, Constants)
%FRONTARBBALANCESENSITIVITYSTUDY
%
% Stage 3.6B - Multi-Speed Front ARB Sensitivity
%
% Investigates how front anti-roll-bar stiffness influences
% vehicle balance at different operating speeds.
%
% Engineering chain:
%
%   Front ARB Stiffness
%           ↓
%   Roll Stiffness Distribution
%           ↓
%   Lateral Load Transfer Distribution
%           ↓
%   Tyre Vertical Loads
%           ↓
%   Axle Cornering Stiffness
%           ↓
%   Understeer Gradient
%
% Rear ARB remains fixed at the baseline value.


%% ============================================================
%  FRONT ARB SWEEP
%  ============================================================

frontARB = 0:5:100;             % [N/mm]

nARB = length(frontARB);


%% ============================================================
%  SPEED CONDITIONS
%  ============================================================

speedKPH = [72 90 108];

nSpeed = length(speedKPH);


%% ============================================================
%  FIXED STEERING CONDITION
%  ============================================================

steerAngle = 1.0;               % [deg]


%% ============================================================
%  PREALLOCATE RESULTS
%  ============================================================

frontRollDistribution = zeros(nARB,nSpeed);

frontTransfer = zeros(nARB,nSpeed);
rearTransfer  = zeros(nARB,nSpeed);

Cf = zeros(nARB,nSpeed);
Cr = zeros(nARB,nSpeed);

ay_g = zeros(nARB,nSpeed);

Kus = zeros(nARB,nSpeed);

valid = false(nARB,nSpeed);


%% ============================================================
%  RUN MULTI-SPEED FRONT ARB SWEEP
%  ============================================================

for j = 1:nSpeed

    %% --------------------------------------------------------
    %  CREATE OPERATING CONDITION FOR CURRENT SPEED
    %  ---------------------------------------------------------

    OperatingStudy = Operating;

    OperatingStudy.speed = ...
        speedKPH(j) / 3.6;

    OperatingStudy.steerAngle = ...
        steerAngle;

    OperatingStudy.ax = 0;

    % Coupled solver determines lateral acceleration
    OperatingStudy.ay = 0;


    %% --------------------------------------------------------
    %  FRONT ARB SWEEP
    %  ---------------------------------------------------------

    for i = 1:nARB

        SetupSweep = Setup;

        SetupSweep.arbFront = ...
            frontARB(i);


        try

            %% ------------------------------------------------
            %  RUN COUPLED VEHICLE MODEL
            %  -------------------------------------------------

            CoupledSweep = ...
                calculateCoupledLateralResponse( ...
                    Vehicle, ...
                    SetupSweep, ...
                    OperatingStudy, ...
                    Tyre, ...
                    Constants);


            %% ------------------------------------------------
            %  ROLL STIFFNESS DISTRIBUTION
            %  -------------------------------------------------

            frontRollDistribution(i,j) = ...
                CoupledSweep.Lateral. ...
                frontRollStiffnessDistribution;


            %% ------------------------------------------------
            %  LATERAL LOAD TRANSFER
            %  -------------------------------------------------

            frontTransfer(i,j) = ...
                CoupledSweep.Lateral. ...
                frontLoadTransfer;

            rearTransfer(i,j) = ...
                CoupledSweep.Lateral. ...
                rearLoadTransfer;


            %% ------------------------------------------------
            %  CORNERING STIFFNESS
            %  -------------------------------------------------

            Cf(i,j) = ...
                CoupledSweep.Cornering. ...
                CalphaFront;

            Cr(i,j) = ...
                CoupledSweep.Cornering. ...
                CalphaRear;


            %% ------------------------------------------------
            %  LATERAL ACCELERATION
            %  -------------------------------------------------

            ay_g(i,j) = ...
                CoupledSweep.Response.ay ...
                / Constants.g;


            %% ------------------------------------------------
            %  UNDERSTEER GRADIENT
            %  -------------------------------------------------

            Kus(i,j) = ...
                CoupledSweep.Balance. ...
                Kus_deg_per_g;


            %% ------------------------------------------------
            %  SOLVER STATUS
            %  -------------------------------------------------

            valid(i,j) = ...
                CoupledSweep.converged;


        catch ME

            frontRollDistribution(i,j) = NaN;

            frontTransfer(i,j) = NaN;
            rearTransfer(i,j) = NaN;

            Cf(i,j) = NaN;
            Cr(i,j) = NaN;

            ay_g(i,j) = NaN;

            Kus(i,j) = NaN;

            valid(i,j) = false;

            warning( ...
                'Stage 3.6B failed at %.0f km/h and %.1f N/mm ARB: %s', ...
                speedKPH(j), ...
                frontARB(i), ...
                ME.message);

        end

    end

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

ARBBalanceStudy.frontARB = ...
    frontARB;

ARBBalanceStudy.speedKPH = ...
    speedKPH;

ARBBalanceStudy.steerAngle = ...
    steerAngle;

ARBBalanceStudy.frontRollDistribution = ...
    frontRollDistribution;

ARBBalanceStudy.frontTransfer = ...
    frontTransfer;

ARBBalanceStudy.rearTransfer = ...
    rearTransfer;

ARBBalanceStudy.Cf = ...
    Cf;

ARBBalanceStudy.Cr = ...
    Cr;

ARBBalanceStudy.ay_g = ...
    ay_g;

ARBBalanceStudy.Kus = ...
    Kus;

ARBBalanceStudy.valid = ...
    valid;


%% ============================================================
%  STAGE 3.6B - FIGURE 1
%
%  FRONT ARB VS FRONT ROLL STIFFNESS DISTRIBUTION
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6B - Figure 1 - ', ...
     'Front ARB vs Roll Distribution'], ...
    'NumberTitle','off');

hold on;


for j = 1:nSpeed

    plot( ...
        frontARB, ...
        frontRollDistribution(:,j) * 100, ...
        '-o', ...
        'LineWidth',1.6, ...
        'MarkerSize',5, ...
        'DisplayName', ...
        sprintf('%.0f km/h',speedKPH(j)));

end


grid on;
box on;

xlabel( ...
    'Front ARB Stiffness [N/mm]');

ylabel( ...
    'Front Roll Stiffness Distribution [%]');

title( ...
    ['Stage 3.6B - Front ARB Sensitivity: ', ...
     'Roll Stiffness Distribution']);

legend( ...
    'Location','best');


%% ============================================================
%  STAGE 3.6B - FIGURE 2
%
%  FRONT ARB VS FRONT AXLE CORNERING STIFFNESS
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6B - Figure 2 - ', ...
     'Front ARB vs Front Cornering Stiffness'], ...
    'NumberTitle','off');

hold on;


for j = 1:nSpeed

    plot( ...
        frontARB, ...
        Cf(:,j) / 1000, ...
        '-o', ...
        'LineWidth',1.6, ...
        'MarkerSize',5, ...
        'DisplayName', ...
        sprintf('%.0f km/h',speedKPH(j)));

end


grid on;
box on;

xlabel( ...
    'Front ARB Stiffness [N/mm]');

ylabel( ...
    'Front Axle Cornering Stiffness [kN/rad]');

title( ...
    ['Stage 3.6B - Front ARB Sensitivity: ', ...
     'Front Cornering Stiffness']);

legend( ...
    'Location','best');


%% ============================================================
%  STAGE 3.6B - FIGURE 3
%
%  FRONT ARB VS UNDERSTEER GRADIENT
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.6B - Figure 3 - ', ...
     'Front ARB vs Understeer Gradient'], ...
    'NumberTitle','off');

hold on;


for j = 1:nSpeed

    plot( ...
        frontARB, ...
        Kus(:,j), ...
        '-o', ...
        'LineWidth',1.6, ...
        'MarkerSize',5, ...
        'DisplayName', ...
        sprintf('%.0f km/h',speedKPH(j)));

end


grid on;
box on;

xlabel( ...
    'Front ARB Stiffness [N/mm]');

ylabel( ...
    'Understeer Gradient [deg/g]');

title( ...
    ['Stage 3.6B - Front ARB Sensitivity: ', ...
     'Vehicle Balance']);

legend( ...
    'Location','best');

% Focus y-axis on the sensitivity range
ylim([-0.047 -0.044]);
%% ============================================================
%  DISPLAY STUDY SUMMARY
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('   FRONT ARB SENSITIVITY - STAGE 3.6B\n');
fprintf('============================================\n');

fprintf('Front ARB Range      : %.0f to %.0f N/mm\n', ...
    min(frontARB), ...
    max(frontARB));

fprintf('Steering Angle       : %.2f deg\n', ...
    steerAngle);

fprintf('Speed Conditions     : ');

fprintf('%.0f ',speedKPH);

fprintf('km/h\n');

fprintf('\n');


for j = 1:nSpeed

    fprintf('--------------------------------------------\n');
    fprintf('Speed: %.0f km/h\n',speedKPH(j));
    fprintf('--------------------------------------------\n');

    fprintf( ...
        'Lateral Acceleration Range : %.3f to %.3f g\n', ...
        min(ay_g(:,j),[],'omitnan'), ...
        max(ay_g(:,j),[],'omitnan'));

    fprintf( ...
        'Front C_alpha Range        : %.2f to %.2f kN/rad\n', ...
        min(Cf(:,j),[],'omitnan') / 1000, ...
        max(Cf(:,j),[],'omitnan') / 1000);

    fprintf( ...
        'Understeer Gradient Range  : %.5f to %.5f deg/g\n', ...
        min(Kus(:,j),[],'omitnan'), ...
        max(Kus(:,j),[],'omitnan'));

    fprintf('\n');

end


fprintf('============================================\n');

end