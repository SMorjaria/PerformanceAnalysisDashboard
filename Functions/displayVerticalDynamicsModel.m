function displayVerticalDynamicsModel(Vertical)
%DISPLAYVERTICALDYNAMICSMODEL
%
% Stage 5.7A - Quarter-Car Vertical Dynamics


fprintf('\n');
fprintf('============================================\n');
fprintf(' VERTICAL DYNAMICS MODEL - STAGE 5.7A\n');
fprintf('============================================\n');


%% MASS

fprintf('\nMASS PROPERTIES\n');
fprintf('--------------------------------------------\n');

fprintf('Supported Corner Mass   : %8.2f kg\n', ...
    Vertical.cornerMass);

fprintf('Sprung Mass             : %8.2f kg\n', ...
    Vertical.sprungMass);

fprintf('Unsprung Mass           : %8.2f kg\n', ...
    Vertical.unsprungMass);


%% STIFFNESS

fprintf('\nVERTICAL STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Suspension Wheel Rate   : %8.1f N/mm\n', ...
    Vertical.suspensionStiffness / 1000);

fprintf('Tyre Vertical Stiffness : %8.1f N/mm\n', ...
    Vertical.tyreStiffness / 1000);


%% DAMPING

fprintf('\nDAMPING\n');
fprintf('--------------------------------------------\n');

fprintf('Target Damping Ratio    : %8.3f\n', ...
    Vertical.dampingRatio);

fprintf('Critical Damping        : %8.1f Ns/m\n', ...
    Vertical.criticalDamping);

fprintf('Damper Coefficient      : %8.1f Ns/m\n', ...
    Vertical.dampingCoefficient);


%% SIMPLE FREQUENCY ESTIMATES

fprintf('\nSIMPLE FREQUENCY ESTIMATES\n');
fprintf('--------------------------------------------\n');

fprintf('Body Mode Estimate      : %8.3f Hz\n', ...
    Vertical.bodyNaturalFrequencyEstimate);

fprintf('Wheel-Hop Estimate      : %8.3f Hz\n', ...
    Vertical.wheelHopFrequencyEstimate);


%% COUPLED EIGENVALUE SOLUTION

fprintf('\nCOUPLED UNDAMPED MODES\n');
fprintf('--------------------------------------------\n');

fprintf('Mode 1 - Body Mode      : %8.3f Hz\n', ...
    Vertical.naturalFrequencyBody);

fprintf('Mode 2 - Wheel Hop      : %8.3f Hz\n', ...
    Vertical.naturalFrequencyWheelHop);


%% MODE SHAPES

fprintf('\nMODE SHAPES\n');
fprintf('--------------------------------------------\n');

fprintf('Mode 1 [zs zu]          : [%+8.4f  %+8.4f]\n', ...
    Vertical.modeShapes(1,1), ...
    Vertical.modeShapes(2,1));

fprintf('Mode 2 [zs zu]          : [%+8.4f  %+8.4f]\n', ...
    Vertical.modeShapes(1,2), ...
    Vertical.modeShapes(2,2));


%% VALIDATION

fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Mass Reconstruction     : %8.2f kg\n', ...
    Vertical.totalMassCheck);

fprintf('Mass Error              : %+12.8f kg\n', ...
    Vertical.massError);


fprintf('============================================\n');

end