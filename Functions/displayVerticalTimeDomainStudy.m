function displayVerticalTimeDomainStudy(Study)
%DISPLAYVERTICALTIMEDOMAINSTUDY
%
% Stage 5.7D - Time-Domain Road Excitation


B = Study.Baseline;
S = Study.Stiffer;


fprintf('\n');
fprintf('============================================\n');
fprintf(' TIME-DOMAIN ROAD RESPONSE - STAGE 5.7D\n');
fprintf('============================================\n');


%% ============================================================
%  ROAD INPUT
%  ============================================================

fprintf('\nROAD DISTURBANCE\n');
fprintf('--------------------------------------------\n');

fprintf('Bump Height             : %8.2f mm\n', ...
    B.bumpHeight * 1000);

fprintf('Bump Duration           : %8.3f s\n', ...
    B.bumpDuration);

fprintf('Bump Start              : %8.3f s\n', ...
    B.bumpStart);

fprintf('Sample Frequency        : %8.1f Hz\n', ...
    B.sampleFrequency);


%% ============================================================
%  PEAK RESPONSE
%  ============================================================

fprintf('\nPEAK RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('                        Baseline     1.15x\n');
fprintf('--------------------------------------------\n');

fprintf('Body Disp. [mm]       : %8.3f   %8.3f\n', ...
    B.peakBodyDisplacement * 1000, ...
    S.peakBodyDisplacement * 1000);

fprintf('Wheel Disp. [mm]      : %8.3f   %8.3f\n', ...
    B.peakWheelDisplacement * 1000, ...
    S.peakWheelDisplacement * 1000);

fprintf('Susp. Travel [mm]     : %8.3f   %8.3f\n', ...
    B.peakSuspensionTravel * 1000, ...
    S.peakSuspensionTravel * 1000);

fprintf('Body Accel. [m/s^2]   : %8.3f   %8.3f\n', ...
    B.peakBodyAcceleration, ...
    S.peakBodyAcceleration);

fprintf('Tyre Load [N]         : %8.1f   %8.1f\n', ...
    B.peakDynamicTyreLoad, ...
    S.peakDynamicTyreLoad);


%% ============================================================
%  RMS RESPONSE
%  ============================================================

fprintf('\nRMS RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Body Accel. [m/s^2]   : %8.3f   %8.3f\n', ...
    B.rmsBodyAcceleration, ...
    S.rmsBodyAcceleration);

fprintf('Tyre Load [N]         : %8.1f   %8.1f\n', ...
    B.rmsDynamicTyreLoad, ...
    S.rmsDynamicTyreLoad);


%% ============================================================
%  SETUP EFFECT
%  ============================================================

fprintf('\n1.15x SETUP EFFECT\n');
fprintf('--------------------------------------------\n');

fprintf('Peak Body Accel. Change : %+8.2f %%\n', ...
    Study.bodyAccelerationChangePercent);

fprintf('Peak Susp. Travel Change: %+8.2f %%\n', ...
    Study.suspensionTravelChangePercent);

fprintf('Peak Tyre Load Change   : %+8.2f %%\n', ...
    Study.tyreLoadChangePercent);

fprintf('RMS Body Accel. Change  : %+8.2f %%\n', ...
    Study.rmsBodyAccelerationChangePercent);

fprintf('RMS Tyre Load Change    : %+8.2f %%\n', ...
    Study.rmsTyreLoadChangePercent);


%% ============================================================
%  VALIDATION
%  ============================================================

fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Time Vector Error       : %.3e s\n', ...
    Study.timeVectorError);

fprintf('Road Input Error        : %.3e m\n', ...
    Study.roadInputError);


fprintf('============================================\n');

end