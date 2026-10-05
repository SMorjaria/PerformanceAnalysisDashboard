function Study = verticalFFTStudy(VerticalTimeStudy, VerticalTradeoff)
%VERTICALFFTSTUDY
%
% Stage 5.7E - FFT / Spectral Analysis
%
% Compares the spectral content of:
%
%   1. Baseline suspension
%   2. Platform-controlled 1.15x suspension
%
% Dominant FFT frequencies are compared with the coupled
% natural frequencies predicted independently in Stage 5.7A/C.


%% ============================================================
%  1. CALCULATE FFT RESULTS
%  ============================================================

BaselineFFT = ...
    calculateVerticalFFT( ...
    VerticalTimeStudy.Baseline);

StifferFFT = ...
    calculateVerticalFFT( ...
    VerticalTimeStudy.Stiffer);


%% ============================================================
%  2. REFERENCE NATURAL FREQUENCIES
%  ============================================================
%
% These values come directly from the validated Stage 5.7A
% vertical dynamics model.
%

baselineBodyMode = ...
    VerticalTradeoff.VerticalBaseline.naturalFrequencyBody;

baselineWheelHop = ...
    VerticalTradeoff.VerticalBaseline.naturalFrequencyWheelHop;


stifferBodyMode = ...
    VerticalTradeoff.VerticalStiffer.naturalFrequencyBody;

stifferWheelHop = ...
    VerticalTradeoff.VerticalStiffer.naturalFrequencyWheelHop;


%% ============================================================
%  3. BODY-MODE FFT ERROR
%  ============================================================
%
% Compare the dominant sprung-mass FFT frequency with the
% independently predicted body natural frequency.
%

baselineBodyError = ...
    BaselineFFT.bodyDominantFrequency - ...
    baselineBodyMode;

stifferBodyError = ...
    StifferFFT.bodyDominantFrequency - ...
    stifferBodyMode;


baselineBodyErrorPercent = ...
    100 * baselineBodyError / ...
    baselineBodyMode;

stifferBodyErrorPercent = ...
    100 * stifferBodyError / ...
    stifferBodyMode;


%% ============================================================
%  4. FFT FREQUENCY SHIFT
%  ============================================================
%
% Quantifies whether the stiffer setup shifts the dominant
% measured body-response frequency upward.
%

bodyFFTShift = ...
    StifferFFT.bodyDominantFrequency - ...
    BaselineFFT.bodyDominantFrequency;

bodyFFTShiftPercent = ...
    100 * bodyFFTShift / ...
    BaselineFFT.bodyDominantFrequency;


tyreFFTShift = ...
    StifferFFT.tyreDominantFrequency - ...
    BaselineFFT.tyreDominantFrequency;

tyreFFTShiftPercent = ...
    100 * tyreFFTShift / ...
    BaselineFFT.tyreDominantFrequency;


%% ============================================================
%  5. VALIDATE COMMON FREQUENCY VECTOR
%  ============================================================

frequencyVectorError = ...
    max(abs( ...
    BaselineFFT.frequency - ...
    StifferFFT.frequency));

if frequencyVectorError > 1e-12

    error(['Baseline and stiffer FFT frequency vectors ' ...
           'do not match.']);

end


%% ============================================================
%  6. STORE STUDY
%  ============================================================

Study.BaselineFFT = ...
    BaselineFFT;

Study.StifferFFT = ...
    StifferFFT;


%% Natural-frequency references

Study.baselineBodyMode = ...
    baselineBodyMode;

Study.baselineWheelHop = ...
    baselineWheelHop;

Study.stifferBodyMode = ...
    stifferBodyMode;

Study.stifferWheelHop = ...
    stifferWheelHop;


%% FFT versus eigenvalue errors

Study.baselineBodyError = ...
    baselineBodyError;

Study.stifferBodyError = ...
    stifferBodyError;

Study.baselineBodyErrorPercent = ...
    baselineBodyErrorPercent;

Study.stifferBodyErrorPercent = ...
    stifferBodyErrorPercent;


%% Setup-induced FFT shifts

Study.bodyFFTShift = ...
    bodyFFTShift;

Study.bodyFFTShiftPercent = ...
    bodyFFTShiftPercent;

Study.tyreFFTShift = ...
    tyreFFTShift;

Study.tyreFFTShiftPercent = ...
    tyreFFTShiftPercent;


%% Validation

Study.frequencyVectorError = ...
    frequencyVectorError;


end