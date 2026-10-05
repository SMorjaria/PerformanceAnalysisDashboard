function Operating = selectOperatingConditions(Constants)
%SELECTOPERATINGCONDITIONS Request vehicle operating conditions.

fprintf('\n');
fprintf('============================================\n');
fprintf('       OPERATING CONDITION INPUT\n');
fprintf('============================================\n');

%% Speed

speedKPH = input( ...
    'Vehicle Speed [km/h] (Enter for 180): ');

if isempty(speedKPH)
    speedKPH = 180;
end

Operating.speed = speedKPH / 3.6;


%% Longitudinal Acceleration

ax_g = input( ...
    'Longitudinal Acceleration [g] (Enter for 0): ');

if isempty(ax_g)
    ax_g = 0;
end

Operating.ax = ax_g * Constants.g;


%% Lateral Acceleration

ay_g = input( ...
    'Lateral Acceleration [g] (Enter for 0): ');

if isempty(ay_g)
    ay_g = 0;
end

Operating.ay = ay_g * Constants.g;


%% Steering Angle

steerAngle = input( ...
    'Front Road-Wheel Steering Angle [deg] (Enter for 2): ');

if isempty(steerAngle)
    steerAngle = 2;
end

Operating.steerAngle = steerAngle;


fprintf('============================================\n');

end