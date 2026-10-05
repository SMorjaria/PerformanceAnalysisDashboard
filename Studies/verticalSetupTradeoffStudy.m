function Study = verticalSetupTradeoffStudy( ...
    Vehicle, Setup, Suspension)
%VERTICALSETUPTRADEOFFSTUDY
%
% Stage 5.7C - Vertical Dynamics Setup Trade-Off
%
% Compares:
%
%   Baseline setup:
%       Spring multiplier = 1.00
%
%   Platform-controlled setup:
%       Spring multiplier = 1.15
%
% The 1.15 configuration was identified in Stage 5.6B as
% the minimum tested stiffness satisfying the aerodynamic
% platform constraint at 180 km/h.
%
% The study compares:
%
%   - Wheel stiffness
%   - Natural frequencies
%   - Body transmissibility
%   - Suspension travel
%   - Dynamic tyre-load sensitivity
%
% IMPORTANT:
% The same target damping ratio is retained between setups.
% Therefore the damping coefficient changes with stiffness.


%% ============================================================
%  1. SETUP DEFINITIONS
%  ============================================================

baselineMultiplier = 1.00;
stifferMultiplier  = 1.15;


%% ============================================================
%  2. BASELINE SETUP
%  ============================================================

SetupBaseline = Setup;

SetupBaseline.springFront = ...
    Setup.springFront * baselineMultiplier;

SetupBaseline.springRear = ...
    Setup.springRear * baselineMultiplier;


%% Baseline wheel rates

SuspensionBaseline = Suspension;

SuspensionBaseline.wheelRateFront = ...
    SetupBaseline.springFront * ...
    SetupBaseline.motionRatioFront^2;

SuspensionBaseline.wheelRateRear = ...
    SetupBaseline.springRear * ...
    SetupBaseline.motionRatioRear^2;


%% Baseline axle heave stiffness

SuspensionBaseline.axleHeaveStiffnessFront = ...
    2 * SuspensionBaseline.wheelRateFront;

SuspensionBaseline.axleHeaveStiffnessRear = ...
    2 * SuspensionBaseline.wheelRateRear;


%% Baseline vertical model

VerticalBaseline = ...
    createVerticalDynamicsModel( ...
    Vehicle, ...
    SetupBaseline, ...
    SuspensionBaseline);


%% Baseline frequency response

FrequencyBaseline = ...
    calculateVerticalFrequencyResponse( ...
    VerticalBaseline);


%% ============================================================
%  3. STIFFER PLATFORM-CONTROLLED SETUP
%  ============================================================

SetupStiffer = Setup;

SetupStiffer.springFront = ...
    Setup.springFront * stifferMultiplier;

SetupStiffer.springRear = ...
    Setup.springRear * stifferMultiplier;


%% Stiffer wheel rates

SuspensionStiffer = Suspension;

SuspensionStiffer.wheelRateFront = ...
    SetupStiffer.springFront * ...
    SetupStiffer.motionRatioFront^2;

SuspensionStiffer.wheelRateRear = ...
    SetupStiffer.springRear * ...
    SetupStiffer.motionRatioRear^2;


%% Stiffer axle heave stiffness

SuspensionStiffer.axleHeaveStiffnessFront = ...
    2 * SuspensionStiffer.wheelRateFront;

SuspensionStiffer.axleHeaveStiffnessRear = ...
    2 * SuspensionStiffer.wheelRateRear;


%% Stiffer vertical model

VerticalStiffer = ...
    createVerticalDynamicsModel( ...
    Vehicle, ...
    SetupStiffer, ...
    SuspensionStiffer);


%% Stiffer frequency response

FrequencyStiffer = ...
    calculateVerticalFrequencyResponse( ...
    VerticalStiffer);


%% ============================================================
%  4. VALIDATE COMMON FREQUENCY VECTOR
%  ============================================================

frequencyError = max(abs( ...
    FrequencyBaseline.frequency - ...
    FrequencyStiffer.frequency));

if frequencyError > 1e-12

    error(['Baseline and stiffer frequency vectors ' ...
           'do not match.']);

end


%% ============================================================
%  5. NATURAL-FREQUENCY CHANGES
%  ============================================================

bodyFrequencyChange = ...
    VerticalStiffer.naturalFrequencyBody - ...
    VerticalBaseline.naturalFrequencyBody;

bodyFrequencyChangePercent = ...
    100 * bodyFrequencyChange / ...
    VerticalBaseline.naturalFrequencyBody;


wheelHopFrequencyChange = ...
    VerticalStiffer.naturalFrequencyWheelHop - ...
    VerticalBaseline.naturalFrequencyWheelHop;

wheelHopFrequencyChangePercent = ...
    100 * wheelHopFrequencyChange / ...
    VerticalBaseline.naturalFrequencyWheelHop;


%% ============================================================
%  6. MAXIMUM RESPONSE CHANGES
%  ============================================================

bodyPeakChangePercent = ...
    100 * ...
    (FrequencyStiffer.bodyPeakMagnitude - ...
     FrequencyBaseline.bodyPeakMagnitude) / ...
    FrequencyBaseline.bodyPeakMagnitude;


tyreLoadPeakChangePercent = ...
    100 * ...
    (FrequencyStiffer.tyreLoadPeak - ...
     FrequencyBaseline.tyreLoadPeak) / ...
    FrequencyBaseline.tyreLoadPeak;


%% ============================================================
%  7. STORE STUDY RESULTS
%  ============================================================

Study.baselineMultiplier = ...
    baselineMultiplier;

Study.stifferMultiplier = ...
    stifferMultiplier;


Study.SetupBaseline = ...
    SetupBaseline;

Study.SetupStiffer = ...
    SetupStiffer;


Study.SuspensionBaseline = ...
    SuspensionBaseline;

Study.SuspensionStiffer = ...
    SuspensionStiffer;


Study.VerticalBaseline = ...
    VerticalBaseline;

Study.VerticalStiffer = ...
    VerticalStiffer;


Study.FrequencyBaseline = ...
    FrequencyBaseline;

Study.FrequencyStiffer = ...
    FrequencyStiffer;


Study.bodyFrequencyChange = ...
    bodyFrequencyChange;

Study.bodyFrequencyChangePercent = ...
    bodyFrequencyChangePercent;


Study.wheelHopFrequencyChange = ...
    wheelHopFrequencyChange;

Study.wheelHopFrequencyChangePercent = ...
    wheelHopFrequencyChangePercent;


Study.bodyPeakChangePercent = ...
    bodyPeakChangePercent;

Study.tyreLoadPeakChangePercent = ...
    tyreLoadPeakChangePercent;


Study.frequencyVectorError = ...
    frequencyError;


end