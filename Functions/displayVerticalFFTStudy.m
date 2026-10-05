function displayVerticalFFTStudy(Study)
%DISPLAYVERTICALFFTSTUDY
%
% Stage 5.7E - FFT / Spectral Analysis


B = Study.BaselineFFT;
S = Study.StifferFFT;


fprintf('\n');
fprintf('============================================\n');
fprintf(' FFT / SPECTRAL ANALYSIS - STAGE 5.7E\n');
fprintf('============================================\n');


%% ============================================================
%  FFT SETTINGS
%  ============================================================

fprintf('\nFFT SETTINGS\n');
fprintf('--------------------------------------------\n');

fprintf('Sample Frequency        : %8.1f Hz\n', ...
    B.sampleFrequency);

fprintf('Analysis Start          : %8.3f s\n', ...
    B.analysisStart);

fprintf('Analysis Duration       : %8.3f s\n', ...
    B.analysisDuration);

fprintf('Number of Samples       : %8d\n', ...
    B.numberSamples);

fprintf('Frequency Resolution    : %8.4f Hz\n', ...
    B.frequencyResolution);


%% ============================================================
%  BODY RESPONSE
%  ============================================================

fprintf('\nBODY RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('                        Baseline     1.15x\n');
fprintf('--------------------------------------------\n');

fprintf('Predicted Mode [Hz]    : %8.3f   %8.3f\n', ...
    Study.baselineBodyMode, ...
    Study.stifferBodyMode);

fprintf('FFT Dominant [Hz]      : %8.3f   %8.3f\n', ...
    B.bodyDominantFrequency, ...
    S.bodyDominantFrequency);

fprintf('Frequency Error [Hz]   : %+8.3f   %+8.3f\n', ...
    Study.baselineBodyError, ...
    Study.stifferBodyError);

fprintf('Frequency Error [%%]    : %+8.2f   %+8.2f\n', ...
    Study.baselineBodyErrorPercent, ...
    Study.stifferBodyErrorPercent);


%% ============================================================
%  TYRE-LOAD RESPONSE
%  ============================================================

fprintf('\nTYRE-LOAD RESPONSE\n');
fprintf('--------------------------------------------\n');

fprintf('Baseline Dominant       : %8.3f Hz\n', ...
    B.tyreDominantFrequency);

fprintf('1.15x Dominant          : %8.3f Hz\n', ...
    S.tyreDominantFrequency);

fprintf('Baseline Wheel-Hop Ref. : %8.3f Hz\n', ...
    Study.baselineWheelHop);

fprintf('1.15x Wheel-Hop Ref.    : %8.3f Hz\n', ...
    Study.stifferWheelHop);


%% ============================================================
%  VALIDATION
%  ============================================================

fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

if abs(Study.baselineBodyError) <= ...
        B.frequencyResolution

    fprintf('Baseline Body Mode      : PASS\n');

else

    fprintf('Baseline Body Mode      : CHECK\n');

end


if abs(Study.stifferBodyError) <= ...
        S.frequencyResolution

    fprintf('1.15x Body Mode         : PASS\n');

else

    fprintf('1.15x Body Mode         : CHECK\n');

end


fprintf('============================================\n');

end