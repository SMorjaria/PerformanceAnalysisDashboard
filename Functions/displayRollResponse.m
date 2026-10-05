function displayRollResponse(Roll)
%DISPLAYROLLRESPONSE
%
% Stage 5.4 - Quasi-Static Roll Response


fprintf('\n');
fprintf('============================================\n');
fprintf('      ROLL RESPONSE - STAGE 5.4\n');
fprintf('============================================\n');


%% OPERATING CONDITION

fprintf('\nOPERATING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Lateral Acceleration    : %+8.4f m/s^2\n', ...
    Roll.lateralAcceleration);

fprintf('Roll Moment             : %+8.2f Nm\n', ...
    Roll.rollMoment);


%% ROLL STIFFNESS

fprintf('\nROLL STIFFNESS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Spring            : %10.1f Nm/rad\n', ...
    Roll.springRollStiffnessFront);

fprintf('Front ARB               : %10.1f Nm/rad\n', ...
    Roll.arbRollStiffnessFront);

fprintf('Front Total             : %10.1f Nm/rad\n', ...
    Roll.rollStiffnessFront);

fprintf('\n');

fprintf('Rear Spring             : %10.1f Nm/rad\n', ...
    Roll.springRollStiffnessRear);

fprintf('Rear ARB                : %10.1f Nm/rad\n', ...
    Roll.arbRollStiffnessRear);

fprintf('Rear Total              : %10.1f Nm/rad\n', ...
    Roll.rollStiffnessRear);

fprintf('\n');

fprintf('Vehicle Total           : %10.1f Nm/rad\n', ...
    Roll.totalRollStiffness);


%% DISTRIBUTION

fprintf('\nROLL STIFFNESS DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                   : %8.2f %%\n', ...
    Roll.frontRollDistribution * 100);

fprintf('Rear                    : %8.2f %%\n', ...
    Roll.rearRollDistribution * 100);


%% BODY RESPONSE

fprintf('\nBODY ROLL RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Roll Angle              : %+8.5f rad\n', ...
    Roll.rollAngle);

fprintf('Roll Angle              : %+8.4f deg\n', ...
    Roll.rollAngleDeg);


%% WHEEL DISPLACEMENT

fprintf('\nROLL-INDUCED WHEEL DISPLACEMENT\n');
fprintf('--------------------------------------------\n');

fprintf('Front +/-               : %8.3f mm\n', ...
    abs(Roll.frontWheelDisplacement));

fprintf('Rear +/-                : %8.3f mm\n', ...
    abs(Roll.rearWheelDisplacement));


%% MOMENT DISTRIBUTION

fprintf('\nROLL MOMENT DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front Roll Moment       : %+8.2f Nm\n', ...
    Roll.frontRollMoment);

fprintf('Rear Roll Moment        : %+8.2f Nm\n', ...
    Roll.rearRollMoment);


%% VALIDATION

fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Reconstructed Moment    : %+8.2f Nm\n', ...
    Roll.reconstructedRollMoment);

fprintf('Roll Moment Error       : %+12.8f Nm\n', ...
    Roll.rollMomentError);

fprintf('Distribution Sum        : %10.6f\n', ...
    Roll.distributionSum);


fprintf('============================================\n');

end