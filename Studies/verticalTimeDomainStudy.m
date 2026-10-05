function Study = verticalTimeDomainStudy(VerticalTradeoff)
%VERTICALTIMEDOMAINSTUDY
%
% Stage 5.7D - Time-Domain Road Excitation
%
% Applies the same finite road disturbance to:
%
%   1. Baseline suspension configuration
%   2. Platform-controlled 1.15x spring configuration
%
% This allows the dynamic consequences of the aerodynamic
% platform-control setup to be assessed using actual
% time-domain quantities.


%% ============================================================
%  1. EXTRACT VERTICAL MODELS
%  ============================================================

VerticalBaseline = ...
    VerticalTradeoff.VerticalBaseline;

VerticalStiffer = ...
    VerticalTradeoff.VerticalStiffer;


%% ============================================================
%  2. RUN BASELINE RESPONSE
%  ============================================================

Baseline = ...
    calculateVerticalTimeResponse( ...
    VerticalBaseline);


%% ============================================================
%  3. RUN STIFFER RESPONSE
%  ============================================================

Stiffer = ...
    calculateVerticalTimeResponse( ...
    VerticalStiffer);


%% ============================================================
%  4. VALIDATE COMMON TIME VECTOR
%  ============================================================

timeVectorError = ...
    max(abs( ...
    Baseline.time - ...
    Stiffer.time));

if timeVectorError > 1e-12

    error(['Baseline and stiffer time vectors ' ...
           'do not match.']);

end


roadInputError = ...
    max(abs( ...
    Baseline.road - ...
    Stiffer.road));

if roadInputError > 1e-12

    error(['Baseline and stiffer simulations do not ' ...
           'contain the same road input.']);

end


%% ============================================================
%  5. CALCULATE CHANGES
%  ============================================================

bodyAccelerationChangePercent = ...
    100 * ...
    (Stiffer.peakBodyAcceleration - ...
     Baseline.peakBodyAcceleration) / ...
    Baseline.peakBodyAcceleration;


suspensionTravelChangePercent = ...
    100 * ...
    (Stiffer.peakSuspensionTravel - ...
     Baseline.peakSuspensionTravel) / ...
    Baseline.peakSuspensionTravel;


tyreLoadChangePercent = ...
    100 * ...
    (Stiffer.peakDynamicTyreLoad - ...
     Baseline.peakDynamicTyreLoad) / ...
    Baseline.peakDynamicTyreLoad;


rmsBodyAccelerationChangePercent = ...
    100 * ...
    (Stiffer.rmsBodyAcceleration - ...
     Baseline.rmsBodyAcceleration) / ...
    Baseline.rmsBodyAcceleration;


rmsTyreLoadChangePercent = ...
    100 * ...
    (Stiffer.rmsDynamicTyreLoad - ...
     Baseline.rmsDynamicTyreLoad) / ...
    Baseline.rmsDynamicTyreLoad;


%% ============================================================
%  6. STORE STUDY
%  ============================================================

Study.Baseline = Baseline;
Study.Stiffer = Stiffer;


Study.bodyAccelerationChangePercent = ...
    bodyAccelerationChangePercent;

Study.suspensionTravelChangePercent = ...
    suspensionTravelChangePercent;

Study.tyreLoadChangePercent = ...
    tyreLoadChangePercent;

Study.rmsBodyAccelerationChangePercent = ...
    rmsBodyAccelerationChangePercent;

Study.rmsTyreLoadChangePercent = ...
    rmsTyreLoadChangePercent;


Study.timeVectorError = ...
    timeVectorError;

Study.roadInputError = ...
    roadInputError;


end