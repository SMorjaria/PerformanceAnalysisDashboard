function FFTResult = calculateVerticalFFT(TimeResponse)
%CALCULATEVERTICALFFT
%
% Stage 5.7E - FFT / Spectral Analysis
%
% Performs frequency-domain analysis of the free-decay
% response generated during Stage 5.7D.
%
% Signals analysed:
%
%   1. Sprung-mass acceleration
%   2. Dynamic tyre-load variation
%
% The FFT begins after the road bump has ended so that the
% resulting spectrum primarily represents the vehicle's
% free dynamic response rather than the imposed road input.


%% ============================================================
%  1. EXTRACT TIME-DOMAIN DATA
%  ============================================================

time = TimeResponse.time;

bodyAcceleration = ...
    TimeResponse.zsAcceleration;

dynamicTyreLoad = ...
    TimeResponse.dynamicTyreLoad;

Fs = TimeResponse.sampleFrequency;

dt = TimeResponse.dt;


%% ============================================================
%  2. DEFINE FREE-DECAY ANALYSIS WINDOW
%  ============================================================
%
% Start immediately after the road disturbance has finished.
%

bumpEnd = ...
    TimeResponse.bumpStart + ...
    TimeResponse.bumpDuration;

analysisStart = bumpEnd;

analysisIndex = ...
    time >= analysisStart;


timeFFT = ...
    time(analysisIndex);

bodyFFTSignal = ...
    bodyAcceleration(analysisIndex);

tyreFFTSignal = ...
    dynamicTyreLoad(analysisIndex);


%% ============================================================
%  3. REMOVE MEAN
%  ============================================================
%
% Removing the mean suppresses the zero-frequency/DC
% component of the spectrum.
%

bodyFFTSignal = ...
    bodyFFTSignal - mean(bodyFFTSignal);

tyreFFTSignal = ...
    tyreFFTSignal - mean(tyreFFTSignal);


%% ============================================================
%  4. APPLY HANN WINDOW
%  ============================================================
%
% The finite analysis interval causes spectral leakage.
% A Hann window reduces leakage from the finite-duration
% free-decay signal.
%
% The window is generated directly so no toolbox function
% is required.
%

N = length(timeFFT);

n = 0:(N-1);

window = ...
    0.5 * ...
    (1 - cos(2*pi*n/(N-1)));


bodyWindowed = ...
    bodyFFTSignal .* window;

tyreWindowed = ...
    tyreFFTSignal .* window;


%% ============================================================
%  5. FFT
%  ============================================================

BodyFFT = ...
    fft(bodyWindowed);

TyreFFT = ...
    fft(tyreWindowed);


%% ============================================================
%  6. SINGLE-SIDED FREQUENCY VECTOR
%  ============================================================

frequency = ...
    (0:N-1) * (Fs/N);

halfIndex = ...
    1:(floor(N/2)+1);

frequencySingle = ...
    frequency(halfIndex);


%% ============================================================
%  7. SINGLE-SIDED AMPLITUDE SPECTRA
%  ============================================================
%
% For this stage we are primarily interested in spectral
% content and peak frequency rather than reconstructing an
% exact steady-state sinusoidal amplitude.
%

bodySpectrum = ...
    abs(BodyFFT(halfIndex));

tyreSpectrum = ...
    abs(TyreFFT(halfIndex));


%% ============================================================
%  8. NORMALISE SPECTRA
%  ============================================================
%
% Normalising each spectrum by its own maximum makes the
% modal frequency content easier to compare.
%

if max(bodySpectrum) > 0

    bodySpectrumNormalised = ...
        bodySpectrum ./ max(bodySpectrum);

else

    bodySpectrumNormalised = ...
        bodySpectrum;

end


if max(tyreSpectrum) > 0

    tyreSpectrumNormalised = ...
        tyreSpectrum ./ max(tyreSpectrum);

else

    tyreSpectrumNormalised = ...
        tyreSpectrum;

end


%% ============================================================
%  9. PEAK SEARCH RANGE
%  ============================================================
%
% Ignore:
%
%   - DC / very-low-frequency content
%   - frequencies above the Stage 5.7B study range
%

minimumSearchFrequency = 0.5;
maximumSearchFrequency = 30.0;

searchIndex = ...
    frequencySingle >= minimumSearchFrequency & ...
    frequencySingle <= maximumSearchFrequency;


searchFrequency = ...
    frequencySingle(searchIndex);

bodySearchSpectrum = ...
    bodySpectrumNormalised(searchIndex);

tyreSearchSpectrum = ...
    tyreSpectrumNormalised(searchIndex);


%% ============================================================
%  10. DOMINANT FREQUENCIES
%  ============================================================

[bodyPeakMagnitude, bodyPeakIndex] = ...
    max(bodySearchSpectrum);

[tyrePeakMagnitude, tyrePeakIndex] = ...
    max(tyreSearchSpectrum);


bodyDominantFrequency = ...
    searchFrequency(bodyPeakIndex);

tyreDominantFrequency = ...
    searchFrequency(tyrePeakIndex);


%% ============================================================
%  11. FREQUENCY RESOLUTION
%  ============================================================

frequencyResolution = ...
    Fs / N;


%% ============================================================
%  12. STORE RESULTS
%  ============================================================

FFTResult.frequency = ...
    frequencySingle;

FFTResult.bodySpectrum = ...
    bodySpectrumNormalised;

FFTResult.tyreSpectrum = ...
    tyreSpectrumNormalised;


FFTResult.bodyDominantFrequency = ...
    bodyDominantFrequency;

FFTResult.tyreDominantFrequency = ...
    tyreDominantFrequency;


FFTResult.bodyPeakMagnitude = ...
    bodyPeakMagnitude;

FFTResult.tyrePeakMagnitude = ...
    tyrePeakMagnitude;


FFTResult.frequencyResolution = ...
    frequencyResolution;

FFTResult.sampleFrequency = ...
    Fs;

FFTResult.analysisStart = ...
    analysisStart;

FFTResult.analysisDuration = ...
    timeFFT(end) - timeFFT(1);

FFTResult.numberSamples = ...
    N;


FFTResult.time = ...
    timeFFT;

FFTResult.bodySignal = ...
    bodyFFTSignal;

FFTResult.tyreSignal = ...
    tyreFFTSignal;

FFTResult.window = ...
    window;


end