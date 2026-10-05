function displaySuspensionStiffness(Suspension)
%DISPLAYSUSPENSIONSTIFFNESS
%
% Stage 5.1 - Suspension Vertical Stiffness Model


fprintf('\n');
fprintf('============================================\n');
fprintf('   SUSPENSION STIFFNESS - STAGE 5.1\n');
fprintf('============================================\n');


%% SPRING DATA

fprintf('\nSPRING PARAMETERS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Spring            : %8.1f N/mm\n', ...
    Suspension.springFront);

fprintf('Rear Spring             : %8.1f N/mm\n', ...
    Suspension.springRear);

fprintf('Front Motion Ratio      : %8.3f\n', ...
    Suspension.motionRatioFront);

fprintf('Rear Motion Ratio       : %8.3f\n', ...
    Suspension.motionRatioRear);


%% WHEEL RATES

fprintf('\nEFFECTIVE WHEEL RATES\n');
fprintf('--------------------------------------------\n');

fprintf('Front Wheel Rate        : %8.1f N/mm\n', ...
    Suspension.wheelRateFront);

fprintf('Rear Wheel Rate         : %8.1f N/mm\n', ...
    Suspension.wheelRateRear);


%% AXLE HEAVE STIFFNESS

fprintf('\nAXLE HEAVE STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle              : %8.1f N/mm\n', ...
    Suspension.axleHeaveStiffnessFront);

fprintf('Rear Axle               : %8.1f N/mm\n', ...
    Suspension.axleHeaveStiffnessRear);

fprintf('Total Vehicle           : %8.1f N/mm\n', ...
    Suspension.totalHeaveStiffness);


%% ROLL STIFFNESS DISTRIBUTION

fprintf('\nROLL STIFFNESS DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                    : %8.2f %%\n', ...
    Suspension.frontRollStiffnessDistribution * 100);

fprintf('Rear                     : %8.2f %%\n', ...
    Suspension.rearRollStiffnessDistribution * 100);


fprintf('============================================\n');

end