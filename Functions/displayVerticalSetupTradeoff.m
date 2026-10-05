function displayVerticalSetupTradeoff(Study)
%DISPLAYVERTICALSETUPTRADEOFF
%
% Stage 5.7C - Vertical Dynamics Setup Trade-Off


B = Study.VerticalBaseline;
S = Study.VerticalStiffer;

FB = Study.FrequencyBaseline;
FS = Study.FrequencyStiffer;


fprintf('\n');
fprintf('============================================\n');
fprintf(' VERTICAL SETUP TRADE-OFF - STAGE 5.7C\n');
fprintf('============================================\n');


%% ============================================================
%  SETUP COMPARISON
%  ============================================================

fprintf('\nSETUP COMPARISON\n');
fprintf('--------------------------------------------\n');

fprintf('Baseline Multiplier     : %8.2f\n', ...
    Study.baselineMultiplier);

fprintf('Stiffer Multiplier      : %8.2f\n', ...
    Study.stifferMultiplier);


fprintf('\n');

fprintf('Baseline Front Spring   : %8.1f N/mm\n', ...
    Study.SetupBaseline.springFront);

fprintf('Stiffer Front Spring    : %8.1f N/mm\n', ...
    Study.SetupStiffer.springFront);

fprintf('Baseline Rear Spring    : %8.1f N/mm\n', ...
    Study.SetupBaseline.springRear);

fprintf('Stiffer Rear Spring     : %8.1f N/mm\n', ...
    Study.SetupStiffer.springRear);


%% ============================================================
%  WHEEL RATE
%  ============================================================

fprintf('\nFRONT WHEEL RATE\n');
fprintf('--------------------------------------------\n');

fprintf('Baseline                : %8.2f N/mm\n', ...
    B.suspensionStiffness / 1000);

fprintf('Stiffer                 : %8.2f N/mm\n', ...
    S.suspensionStiffness / 1000);


%% ============================================================
%  DAMPING
%  ============================================================

fprintf('\nDAMPING\n');
fprintf('--------------------------------------------\n');

fprintf('Target Damping Ratio    : %8.3f\n', ...
    B.dampingRatio);

fprintf('Baseline Damping        : %8.1f Ns/m\n', ...
    B.dampingCoefficient);

fprintf('Stiffer Damping         : %8.1f Ns/m\n', ...
    S.dampingCoefficient);


%% ============================================================
%  NATURAL FREQUENCIES
%  ============================================================

fprintf('\nNATURAL FREQUENCY COMPARISON\n');
fprintf('--------------------------------------------\n');

fprintf('Baseline Body Mode      : %8.3f Hz\n', ...
    B.naturalFrequencyBody);

fprintf('Stiffer Body Mode       : %8.3f Hz\n', ...
    S.naturalFrequencyBody);

fprintf('Body Mode Change        : %+8.2f %%\n', ...
    Study.bodyFrequencyChangePercent);


fprintf('\n');

fprintf('Baseline Wheel Hop      : %8.3f Hz\n', ...
    B.naturalFrequencyWheelHop);

fprintf('Stiffer Wheel Hop       : %8.3f Hz\n', ...
    S.naturalFrequencyWheelHop);

fprintf('Wheel-Hop Change        : %+8.2f %%\n', ...
    Study.wheelHopFrequencyChangePercent);


%% ============================================================
%  FORCED RESPONSE
%  ============================================================

fprintf('\nROAD-EXCITED RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Baseline Body Maximum   : %8.3f\n', ...
    FB.bodyPeakMagnitude);

fprintf('Stiffer Body Maximum    : %8.3f\n', ...
    FS.bodyPeakMagnitude);

fprintf('Body Maximum Change     : %+8.2f %%\n', ...
    Study.bodyPeakChangePercent);


fprintf('\n');

fprintf('Baseline Tyre Load Max  : %8.1f N/m\n', ...
    FB.tyreLoadPeak);

fprintf('Stiffer Tyre Load Max   : %8.1f N/m\n', ...
    FS.tyreLoadPeak);

fprintf('Tyre Load Max Change    : %+8.2f %%\n', ...
    Study.tyreLoadPeakChangePercent);


%% ============================================================
%  VALIDATION
%  ============================================================

fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Frequency Vector Error  : %.3e Hz\n', ...
    Study.frequencyVectorError);


fprintf('============================================\n');

end