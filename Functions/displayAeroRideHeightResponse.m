function displayAeroRideHeightResponse(Ride)
%DISPLAYAERORIDEHEIGHTRESPONSE
%
% Stage 5.2 - Aerodynamic Suspension Compression


fprintf('\n');
fprintf('============================================\n');
fprintf('   AERO RIDE RESPONSE - STAGE 5.2\n');
fprintf('============================================\n');


%% OPERATING CONDITION

fprintf('\nOPERATING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Speed           : %8.1f km/h\n', ...
    Ride.speedKPH);

fprintf('Total Downforce         : %8.1f N\n', ...
    Ride.Aero.downforce);


%% AERODYNAMIC AXLE LOAD

fprintf('\nAERODYNAMIC AXLE LOAD\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle              : %8.1f N\n', ...
    Ride.frontAeroLoad);

fprintf('Rear Axle               : %8.1f N\n', ...
    Ride.rearAeroLoad);


%% SUSPENSION COMPRESSION

fprintf('\nSUSPENSION COMPRESSION\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle              : %8.3f mm\n', ...
    Ride.frontCompression);

fprintf('Rear Axle               : %8.3f mm\n', ...
    Ride.rearCompression);

fprintf('Average Compression     : %8.3f mm\n', ...
    Ride.averageCompression);

fprintf('Rear - Front            : %+8.3f mm\n', ...
    Ride.differentialCompression);


%% RIDE HEIGHT

fprintf('\nVEHICLE PLATFORM\n');
fprintf('--------------------------------------------\n');

fprintf('Static Front RH         : %8.3f mm\n', ...
    Ride.staticFrontRideHeight);

fprintf('Dynamic Front RH        : %8.3f mm\n', ...
    Ride.dynamicFrontRideHeight);

fprintf('\n');

fprintf('Static Rear RH          : %8.3f mm\n', ...
    Ride.staticRearRideHeight);

fprintf('Dynamic Rear RH         : %8.3f mm\n', ...
    Ride.dynamicRearRideHeight);


%% RAKE

fprintf('\nRAKE\n');
fprintf('--------------------------------------------\n');

fprintf('Static RH Delta         : %8.3f mm\n', ...
    Ride.staticRideHeightDelta);

fprintf('Dynamic RH Delta        : %8.3f mm\n', ...
    Ride.dynamicRideHeightDelta);

fprintf('Dynamic Rake Angle      : %8.4f deg\n', ...
    Ride.rakeAngleDeg);


%% VALIDATION

fprintf('\nLOAD / DISPLACEMENT VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Front Reconstruction    : %8.3f N\n', ...
    Ride.frontLoadReconstruction);

fprintf('Rear Reconstruction     : %8.3f N\n', ...
    Ride.rearLoadReconstruction);

fprintf('Front Error             : %+12.8f N\n', ...
    Ride.frontLoadError);

fprintf('Rear Error              : %+12.8f N\n', ...
    Ride.rearLoadError);


fprintf('============================================\n');

end