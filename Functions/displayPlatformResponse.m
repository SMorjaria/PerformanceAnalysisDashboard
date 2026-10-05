function displayPlatformResponse(Platform)
%DISPLAYPLATFORMRESPONSE
%
% Stage 5.3 - Heave & Pitch Platform Response


fprintf('\n');
fprintf('============================================\n');
fprintf('   PLATFORM RESPONSE - STAGE 5.3\n');
fprintf('============================================\n');


%% AXLE DISPLACEMENT

fprintf('\nAXLE DISPLACEMENT\n');
fprintf('--------------------------------------------\n');

fprintf('Front Compression       : %8.3f mm\n', ...
    Platform.frontCompression);

fprintf('Rear Compression        : %8.3f mm\n', ...
    Platform.rearCompression);


%% HEAVE / PITCH DECOMPOSITION

fprintf('\nPLATFORM MODES\n');
fprintf('--------------------------------------------\n');

fprintf('Mean Heave              : %8.3f mm\n', ...
    Platform.heave);

fprintf('Rear - Front Difference : %+8.3f mm\n', ...
    Platform.differentialDisplacement);

fprintf('Pitch Angle Change      : %+8.4f deg\n', ...
    Platform.pitchAngleChangeDeg);


%% STATIC PLATFORM

fprintf('\nSTATIC PLATFORM\n');
fprintf('--------------------------------------------\n');

fprintf('Front Ride Height       : %8.3f mm\n', ...
    Platform.staticFrontRideHeight);

fprintf('Rear Ride Height        : %8.3f mm\n', ...
    Platform.staticRearRideHeight);

fprintf('Ride Height Delta       : %8.3f mm\n', ...
    Platform.staticRideHeightDelta);

fprintf('Rake Angle              : %8.4f deg\n', ...
    Platform.staticRakeAngleDeg);


%% DYNAMIC PLATFORM

fprintf('\nDYNAMIC PLATFORM\n');
fprintf('--------------------------------------------\n');

fprintf('Front Ride Height       : %8.3f mm\n', ...
    Platform.dynamicFrontRideHeight);

fprintf('Rear Ride Height        : %8.3f mm\n', ...
    Platform.dynamicRearRideHeight);

fprintf('Ride Height Delta       : %8.3f mm\n', ...
    Platform.dynamicRideHeightDelta);

fprintf('Rake Angle              : %8.4f deg\n', ...
    Platform.dynamicRakeAngleDeg);

fprintf('Exact Rake Change       : %+8.4f deg\n', ...
    Platform.exactRakeChangeDeg);


%% RECONSTRUCTION VALIDATION

fprintf('\nMODE RECONSTRUCTION VALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Reconstructed Front     : %8.3f mm\n', ...
    Platform.reconstructedFrontCompression);

fprintf('Reconstructed Rear      : %8.3f mm\n', ...
    Platform.reconstructedRearCompression);

fprintf('Front Error             : %+12.8f mm\n', ...
    Platform.frontReconstructionError);

fprintf('Rear Error              : %+12.8f mm\n', ...
    Platform.rearReconstructionError);


fprintf('============================================\n');

end