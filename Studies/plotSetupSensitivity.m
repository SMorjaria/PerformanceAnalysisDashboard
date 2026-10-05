function plotSetupSensitivity(Study)
%PLOTSETUPSENSITIVITY
%
% Stage 6.3 - Generic Setup Sensitivity Visualisation


x = Study.parameterValues;
R = Study.Results;

baselineX = Study.baselineValue;


%% ============================================================
% FIGURE 1 - AERODYNAMIC PERFORMANCE
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.3 - Figure 1 - Setup Sensitivity - Aerodynamic Performance');


plot( ...
    x, ...
    R.downforce, ...
    'LineWidth',1.6);

hold on;

xline( ...
    baselineX, ...
    '--', ...
    'Baseline');

grid on;

xlabel( ...
    formatParameterName(Study.parameterName));

ylabel('Downforce [N]');

title( ...
    'Stage 6.3 - Figure 1 - Downforce Sensitivity');


%% ============================================================
% FIGURE 2 - AERODYNAMIC PLATFORM
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.3 - Figure 2 - Setup Sensitivity - Platform');


plot( ...
    x, ...
    R.frontRideHeight, ...
    'LineWidth',1.6);

hold on;

plot( ...
    x, ...
    R.rearRideHeight, ...
    'LineWidth',1.6);

xline( ...
    baselineX, ...
    '--', ...
    'Baseline');

grid on;

xlabel( ...
    formatParameterName(Study.parameterName));

ylabel('Dynamic Ride Height [mm]');

title( ...
    'Stage 6.3 - Figure 2 - Platform Sensitivity');

legend( ...
    'Front Ride Height', ...
    'Rear Ride Height', ...
    'Location','best');


%% ============================================================
% FIGURE 3 - VEHICLE BALANCE
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.3 - Figure 3 - Setup Sensitivity - Vehicle Balance');


plot( ...
    x, ...
    R.understeerGradient, ...
    'LineWidth',1.6);

hold on;

yline( ...
    0, ...
    ':', ...
    'Neutral Steer');

xline( ...
    baselineX, ...
    '--', ...
    'Baseline');

grid on;

xlabel( ...
    formatParameterName(Study.parameterName));

ylabel('Understeer Gradient [deg/g]');

title( ...
    'Stage 6.3 - Figure 3 - Vehicle Balance Sensitivity');


%% ============================================================
% FIGURE 4 - AERO-MAP MARGIN
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.3 - Figure 4 - Setup Sensitivity - Aero Map Margin');


% Current valid aero-map minimum ride heights
frontMinimumRH = 15;
rearMinimumRH  = 30;


frontMargin = ...
    R.frontRideHeight - frontMinimumRH;

rearMargin = ...
    R.rearRideHeight - rearMinimumRH;


plot( ...
    x, ...
    frontMargin, ...
    'LineWidth',1.6);

hold on;

plot( ...
    x, ...
    rearMargin, ...
    'LineWidth',1.6);


yline( ...
    0, ...
    ':', ...
    'Validity Boundary');


xline( ...
    baselineX, ...
    '--', ...
    'Baseline');


grid on;


xlabel( ...
    formatParameterName(Study.parameterName));


ylabel('Aero-Map Margin [mm]');


title( ...
    'Stage 6.3 - Figure 4 - Aero-Map Margin');


legend( ...
    'Front Ride-Height Margin', ...
    'Rear Ride-Height Margin', ...
    'Location','best');


end


%% ============================================================
% LOCAL FUNCTION - PARAMETER LABEL
% ============================================================

function label = formatParameterName(parameterName)

switch parameterName

    case 'springFront'
        label = 'Front Spring Rate [N/mm]';

    case 'springRear'
        label = 'Rear Spring Rate [N/mm]';

    case 'arbFront'
        label = 'Front ARB Stiffness [N/mm]';

    case 'arbRear'
        label = 'Rear ARB Stiffness [N/mm]';

    case 'rideHeightFront'
        label = 'Front Ride Height [mm]';

    case 'rideHeightRear'
        label = 'Rear Ride Height [mm]';

    case 'camberFront'
        label = 'Front Camber [deg]';

    case 'camberRear'
        label = 'Rear Camber [deg]';

    case 'toeFront'
        label = 'Front Toe [deg]';

    case 'toeRear'
        label = 'Rear Toe [deg]';

    otherwise
        label = parameterName;

end

end