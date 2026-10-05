function displayAerodynamicForces(Aero)
%DISPLAYAERODYNAMICFORCES
%
% Stage 4.1
% Displays baseline aerodynamic performance.


fprintf('\n');
fprintf('============================================\n');
fprintf('       AERODYNAMIC FORCES - STAGE 4.1\n');
fprintf('============================================\n');

fprintf('\n');

fprintf('OPERATING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Vehicle Speed             : %8.1f km/h\n', ...
    Aero.speedKPH);

fprintf( ...
    'Dynamic Pressure          : %8.1f Pa\n', ...
    Aero.dynamicPressure);


fprintf('\n');

fprintf('AERODYNAMIC PARAMETERS\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Reference Area            : %8.3f m^2\n', ...
    Aero.referenceArea);

fprintf( ...
    'Lift Coefficient          : %8.3f\n', ...
    Aero.CL);

fprintf( ...
    'Drag Coefficient          : %8.3f\n', ...
    Aero.CD);

fprintf( ...
    'CL / CD                   : %8.3f\n', ...
    Aero.liftToDragRatio);


fprintf('\n');

fprintf('AERODYNAMIC FORCES\n');
fprintf('--------------------------------------------\n');

fprintf( ...
    'Total Downforce           : %8.1f N\n', ...
    Aero.downforce);

fprintf( ...
    'Total Drag                : %8.1f N\n', ...
    Aero.drag);

fprintf( ...
    'Downforce / Vehicle Weight: %8.3f\n', ...
    Aero.downforceToWeight);

fprintf( ...
    'Drag Power                : %8.1f kW\n', ...
    Aero.dragPower / 1000);

fprintf('============================================\n');

end