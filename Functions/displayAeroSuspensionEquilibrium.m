function displayAeroSuspensionEquilibrium(Equilibrium)
%DISPLAYAEROSUSPENSIONEQUILIBRIUM
%
% Stage 5.5 - Coupled Aero-Suspension Equilibrium


fprintf('\n');
fprintf('============================================\n');
fprintf(' AERO-SUSPENSION EQUILIBRIUM - STAGE 5.5\n');
fprintf('============================================\n');


%% SOLVER

fprintf('\nSOLVER STATUS\n');
fprintf('--------------------------------------------\n');

if Equilibrium.converged
    fprintf('Convergence             : PASS\n');
else
    fprintf('Convergence             : FAIL\n');
end

fprintf('Iterations              : %8d\n', ...
    Equilibrium.iterations);

fprintf('Final Error             : %12.8f mm\n', ...
    Equilibrium.finalEquilibriumError);


%% AERODYNAMIC STATE

fprintf('\nEQUILIBRIUM AERODYNAMIC STATE\n');
fprintf('--------------------------------------------\n');

fprintf('Vehicle Speed           : %8.1f km/h\n', ...
    Equilibrium.speedKPH);

fprintf('Lift Coefficient        : %8.4f\n', ...
    Equilibrium.AeroState.CL);

fprintf('Drag Coefficient        : %8.4f\n', ...
    Equilibrium.AeroState.CD);

fprintf('Front Aero Balance      : %8.3f %%\n', ...
    Equilibrium.AeroState.frontBalance * 100);

fprintf('Total Downforce         : %8.1f N\n', ...
    Equilibrium.Aero.downforce);


%% AERODYNAMIC LOAD

fprintf('\nAERODYNAMIC AXLE LOAD\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle              : %8.1f N\n', ...
    Equilibrium.frontAeroLoad);

fprintf('Rear Axle               : %8.1f N\n', ...
    Equilibrium.rearAeroLoad);


%% SUSPENSION RESPONSE

fprintf('\nSUSPENSION COMPRESSION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                   : %8.3f mm\n', ...
    Equilibrium.frontCompression);

fprintf('Rear                    : %8.3f mm\n', ...
    Equilibrium.rearCompression);

fprintf('Mean Heave              : %8.3f mm\n', ...
    Equilibrium.heave);

fprintf('Rear - Front            : %+8.3f mm\n', ...
    Equilibrium.differentialCompression);


%% PLATFORM

fprintf('\nEQUILIBRIUM PLATFORM\n');
fprintf('--------------------------------------------\n');

fprintf('Reference Front RH      : %8.3f mm\n', ...
    Equilibrium.staticFrontRideHeight);

fprintf('Equilibrium Front RH    : %8.3f mm\n', ...
    Equilibrium.frontRideHeight);

fprintf('\n');

fprintf('Reference Rear RH       : %8.3f mm\n', ...
    Equilibrium.staticRearRideHeight);

fprintf('Equilibrium Rear RH     : %8.3f mm\n', ...
    Equilibrium.rearRideHeight);

fprintf('\n');

fprintf('Ride Height Delta       : %8.3f mm\n', ...
    Equilibrium.rideHeightDelta);

fprintf('Rake Angle              : %8.4f deg\n', ...
    Equilibrium.rakeAngleDeg);


%% VALIDATION

fprintf('\nEQUILIBRIUM VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Front RH Error          : %+12.8f mm\n', ...
    Equilibrium.finalFrontError);

fprintf('Rear RH Error           : %+12.8f mm\n', ...
    Equilibrium.finalRearError);


fprintf('============================================\n');

end