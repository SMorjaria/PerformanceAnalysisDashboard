function AeroPlatformStudy = aeroPlatformMapStudy( ...
    Vehicle, Setup, AeroMap)
%AEROPLATFORMMAPSTUDY
%
% Stage 4.3 - Aerodynamic Platform Map Study
%
% Sweeps front and rear ride height and evaluates:
%
%   CL
%   CD
%   CL/CD
%   Front aerodynamic balance
%
% The results are presented as 2D contour maps.


%% ============================================================
%  RIDE-HEIGHT SWEEP
%  ============================================================

frontRH = ...
    AeroMap.minFrontRH:2:AeroMap.maxFrontRH;

rearRH = ...
    AeroMap.minRearRH:2:AeroMap.maxRearRH;


[FrontRHGrid,RearRHGrid] = ...
    meshgrid(frontRH,rearRH);


%% ============================================================
%  PREALLOCATE RESULTS
%  ============================================================

CL = zeros(size(FrontRHGrid));

CD = zeros(size(FrontRHGrid));

CLtoCD = zeros(size(FrontRHGrid));

frontBalance = zeros(size(FrontRHGrid));

rake = zeros(size(FrontRHGrid));


%% ============================================================
%  RUN PLATFORM SWEEP
%  ============================================================

for row = 1:size(FrontRHGrid,1)

    for col = 1:size(FrontRHGrid,2)

        SetupSweep = Setup;

        SetupSweep.rideHeightFront = ...
            FrontRHGrid(row,col);

        SetupSweep.rideHeightRear = ...
            RearRHGrid(row,col);


        AeroStateSweep = ...
            calculateAeroMap( ...
                Vehicle, ...
                SetupSweep, ...
                AeroMap);


        CL(row,col) = ...
            AeroStateSweep.CL;

        CD(row,col) = ...
            AeroStateSweep.CD;

        CLtoCD(row,col) = ...
            AeroStateSweep.CLtoCD;

        frontBalance(row,col) = ...
            AeroStateSweep.frontBalance * 100;

        rake(row,col) = ...
            AeroStateSweep.rakeAngleDeg;

    end

end


%% ============================================================
%  STORE RESULTS
%  ============================================================

AeroPlatformStudy.frontRH = frontRH;
AeroPlatformStudy.rearRH = rearRH;

AeroPlatformStudy.FrontRHGrid = ...
    FrontRHGrid;

AeroPlatformStudy.RearRHGrid = ...
    RearRHGrid;

AeroPlatformStudy.CL = CL;
AeroPlatformStudy.CD = CD;

AeroPlatformStudy.CLtoCD = ...
    CLtoCD;

AeroPlatformStudy.frontBalance = ...
    frontBalance;

AeroPlatformStudy.rake = rake;


%% ============================================================
%  STAGE 4.3 - FIGURE 1
%
%  LIFT COEFFICIENT MAP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.3 - Figure 1 - ', ...
     'Ride Height vs Lift Coefficient'], ...
    'NumberTitle','off');

contourf( ...
    FrontRHGrid, ...
    RearRHGrid, ...
    CL, ...
    20);

colorbar;

hold on;

plot( ...
    Setup.rideHeightFront, ...
    Setup.rideHeightRear, ...
    'ko', ...
    'MarkerFaceColor','w', ...
    'MarkerSize',8, ...
    'LineWidth',1.5);

xlabel('Front Ride Height [mm]');
ylabel('Rear Ride Height [mm]');

title( ...
    ['Stage 4.3 - Aero Platform Map: ', ...
     'Lift Coefficient']);

grid on;
box on;


%% ============================================================
%  STAGE 4.3 - FIGURE 2
%
%  DRAG COEFFICIENT MAP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.3 - Figure 2 - ', ...
     'Ride Height vs Drag Coefficient'], ...
    'NumberTitle','off');

contourf( ...
    FrontRHGrid, ...
    RearRHGrid, ...
    CD, ...
    20);

colorbar;

hold on;

plot( ...
    Setup.rideHeightFront, ...
    Setup.rideHeightRear, ...
    'ko', ...
    'MarkerFaceColor','w', ...
    'MarkerSize',8, ...
    'LineWidth',1.5);

xlabel('Front Ride Height [mm]');
ylabel('Rear Ride Height [mm]');

title( ...
    ['Stage 4.3 - Aero Platform Map: ', ...
     'Drag Coefficient']);

grid on;
box on;


%% ============================================================
%  STAGE 4.3 - FIGURE 3
%
%  AERODYNAMIC EFFICIENCY MAP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.3 - Figure 3 - ', ...
     'Ride Height vs Aero Efficiency'], ...
    'NumberTitle','off');

contourf( ...
    FrontRHGrid, ...
    RearRHGrid, ...
    CLtoCD, ...
    20);

colorbar;

hold on;

plot( ...
    Setup.rideHeightFront, ...
    Setup.rideHeightRear, ...
    'ko', ...
    'MarkerFaceColor','w', ...
    'MarkerSize',8, ...
    'LineWidth',1.5);

xlabel('Front Ride Height [mm]');
ylabel('Rear Ride Height [mm]');

title( ...
    ['Stage 4.3 - Aero Platform Map: ', ...
     'C_L / C_D']);

grid on;
box on;


%% ============================================================
%  STAGE 4.3 - FIGURE 4
%
%  FRONT AERODYNAMIC BALANCE MAP
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 4.3 - Figure 4 - ', ...
     'Ride Height vs Aero Balance'], ...
    'NumberTitle','off');

contourf( ...
    FrontRHGrid, ...
    RearRHGrid, ...
    frontBalance, ...
    20);

colorbar;

hold on;

plot( ...
    Setup.rideHeightFront, ...
    Setup.rideHeightRear, ...
    'ko', ...
    'MarkerFaceColor','w', ...
    'MarkerSize',8, ...
    'LineWidth',1.5);

xlabel('Front Ride Height [mm]');
ylabel('Rear Ride Height [mm]');

title( ...
    ['Stage 4.3 - Aero Platform Map: ', ...
     'Front Aero Balance [%]']);

grid on;
box on;


end