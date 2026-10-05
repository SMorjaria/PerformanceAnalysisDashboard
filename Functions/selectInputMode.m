function [Vehicle, Setup] = selectInputMode()
%SELECTINPUTMODE Select baseline or custom vehicle configuration.
%
%   [Vehicle, Setup] = selectInputMode()
%
%   Allows the user to choose between:
%
%       1 - Baseline vehicle/setup
%       2 - Custom vehicle/setup
%
% ============================================================


%% ============================================================
%  LOAD BASELINE
%  ============================================================

Vehicle = createVehicle();
Setup   = createSetup();


%% ============================================================
%  DISPLAY MODE SELECTION
%  ============================================================

fprintf('\n');
fprintf('============================================\n');
fprintf('        VEHICLE PERFORMANCE TOOL\n');
fprintf('============================================\n');

fprintf('\nSELECT INPUT MODE\n');
fprintf('--------------------------------------------\n');

fprintf('1 - Baseline Vehicle & Setup\n');
fprintf('2 - Custom Vehicle & Setup\n\n');


mode = input('Select mode [1/2]: ');


%% ============================================================
%  BASELINE MODE
%  ============================================================

if mode == 1

    fprintf('\n');
    fprintf('Baseline configuration selected.\n');


%% ============================================================
%  CUSTOM MODE
%  ============================================================

elseif mode == 2

    fprintf('\n');
    fprintf('CUSTOM VEHICLE CONFIGURATION\n');
    fprintf('--------------------------------------------\n');

    fprintf('Press ENTER to retain the baseline value.\n\n');


    %% --------------------------------------------------------
    % VEHICLE PARAMETERS
    % ---------------------------------------------------------

    Vehicle.mass = getUserValue( ...
        'Vehicle Mass [kg]', ...
        Vehicle.mass);

    Vehicle.wheelbase = getUserValue( ...
        'Wheelbase [m]', ...
        Vehicle.wheelbase);

    Vehicle.trackFront = getUserValue( ...
        'Front Track [m]', ...
        Vehicle.trackFront);

    Vehicle.trackRear = getUserValue( ...
        'Rear Track [m]', ...
        Vehicle.trackRear);

    Vehicle.cgHeight = getUserValue( ...
        'CG Height [m]', ...
        Vehicle.cgHeight);


    %% --------------------------------------------------------
    % FRONT WEIGHT DISTRIBUTION
    % ---------------------------------------------------------

    frontWD_percent = getUserValue( ...
        'Front Weight Distribution [%]', ...
        Vehicle.frontWeightDistribution * 100);

    Vehicle.frontWeightDistribution = ...
        frontWD_percent / 100;


    Vehicle.yawInertia = getUserValue( ...
        'Yaw Inertia [kg m^2]', ...
        Vehicle.yawInertia);


    %% --------------------------------------------------------
    % SUSPENSION SETUP
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('SUSPENSION SETUP\n');
    fprintf('--------------------------------------------\n');

    Setup.springFront = getUserValue( ...
        'Front Spring [N/mm]', ...
        Setup.springFront);

    Setup.springRear = getUserValue( ...
        'Rear Spring [N/mm]', ...
        Setup.springRear);

    Setup.arbFront = getUserValue( ...
        'Front ARB [N/mm]', ...
        Setup.arbFront);

    Setup.arbRear = getUserValue( ...
        'Rear ARB [N/mm]', ...
        Setup.arbRear);

    Setup.motionRatioFront = getUserValue( ...
        'Front Motion Ratio [-]', ...
        Setup.motionRatioFront);

    Setup.motionRatioRear = getUserValue( ...
        'Rear Motion Ratio [-]', ...
        Setup.motionRatioRear);


    %% --------------------------------------------------------
    % PLATFORM
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('PLATFORM\n');
    fprintf('--------------------------------------------\n');

    Setup.rideHeightFront = getUserValue( ...
        'Front Ride Height [mm]', ...
        Setup.rideHeightFront);

    Setup.rideHeightRear = getUserValue( ...
        'Rear Ride Height [mm]', ...
        Setup.rideHeightRear);


    %% --------------------------------------------------------
    % ALIGNMENT
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('ALIGNMENT\n');
    fprintf('--------------------------------------------\n');

    Setup.camberFront = getUserValue( ...
        'Front Camber [deg]', ...
        Setup.camberFront);

    Setup.camberRear = getUserValue( ...
        'Rear Camber [deg]', ...
        Setup.camberRear);

    Setup.toeFront = getUserValue( ...
        'Front Toe [deg]', ...
        Setup.toeFront);

    Setup.toeRear = getUserValue( ...
        'Rear Toe [deg]', ...
        Setup.toeRear);


    %% --------------------------------------------------------
    % BRAKES
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('BRAKES\n');
    fprintf('--------------------------------------------\n');

    brakeBias_percent = getUserValue( ...
        'Front Brake Bias [%]', ...
        Setup.brakeBias * 100);

    Setup.brakeBias = ...
        brakeBias_percent / 100;


    %% --------------------------------------------------------
    % AERODYNAMICS
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('AERODYNAMICS\n');
    fprintf('--------------------------------------------\n');

    Setup.frontWing = getUserValue( ...
        'Front Wing Setting [-]', ...
        Setup.frontWing);

    Setup.CL = getUserValue( ...
        'CL [-]', ...
        Setup.CL);

    Setup.CD = getUserValue( ...
        'CD [-]', ...
        Setup.CD);


    aeroBalance_percent = getUserValue( ...
        'Front Aero Balance [%]', ...
        Setup.aeroBalance * 100);

    Setup.aeroBalance = ...
        aeroBalance_percent / 100;


    fprintf('\nCustom configuration loaded.\n');


%% ============================================================
%  INVALID SELECTION
%  ============================================================

else

    error('Invalid input mode. Select either 1 or 2.');

end


end


%% ============================================================
%  LOCAL FUNCTION - USER INPUT
%  ============================================================

function value = getUserValue(promptText,defaultValue)
%GETUSERVALUE Request a numerical value from the user.
%
% Pressing ENTER retains the supplied default value.

    userInput = input( ...
        sprintf('%s [%.3f]: ', ...
        promptText,defaultValue), ...
        's');

    if isempty(userInput)

        value = defaultValue;

    else

        value = str2double(userInput);

        if isnan(value)

            error( ...
                'Invalid numerical input entered for %s.', ...
                promptText);

        end

    end

end