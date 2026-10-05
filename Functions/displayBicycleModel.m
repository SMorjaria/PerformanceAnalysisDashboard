function displayBicycleModel(Bicycle)
%DISPLAYBICYCLEMODEL Display bicycle-model parameters.

fprintf('\n');
fprintf('============================================\n');
fprintf('          BICYCLE MODEL - STAGE 3.1\n');
fprintf('============================================\n');

fprintf('\nVEHICLE GEOMETRY\n');
fprintf('--------------------------------------------\n');

fprintf('Wheelbase, L              : %8.3f m\n', ...
    Bicycle.L);

fprintf('CG to Front Axle, a       : %8.3f m\n', ...
    Bicycle.a);

fprintf('CG to Rear Axle, b        : %8.3f m\n', ...
    Bicycle.b);

fprintf('Geometry Error            : %8.6f m\n', ...
    Bicycle.geometryError);


fprintf('\nVEHICLE PROPERTIES\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Mass              : %8.1f kg\n', ...
    Bicycle.mass);

fprintf('Yaw Inertia               : %8.1f kg m^2\n', ...
    Bicycle.Iz);


fprintf('\nOPERATING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Speed             : %8.2f m/s\n', ...
    Bicycle.speed);

fprintf('Vehicle Speed             : %8.1f km/h\n', ...
    Bicycle.speed * 3.6);

fprintf('Road-Wheel Steering Angle : %8.3f deg\n', ...
    rad2deg(Bicycle.delta));

fprintf('Road-Wheel Steering Angle : %8.5f rad\n', ...
    Bicycle.delta);

fprintf('============================================\n');

end