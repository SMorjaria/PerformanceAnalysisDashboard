function FrequencyResponse = calculateVerticalFrequencyResponse(Vertical)
%CALCULATEVERTICALFREQUENCYRESPONSE
%
% Stage 5.7B - Quarter-Car Frequency Response
%
% Calculates the steady-state harmonic response of the
% 2-DOF quarter-car model to road displacement excitation.
%
% Outputs:
%
%   |Zs / Zr|               Sprung-mass transmissibility
%   |Zu / Zr|               Unsprung-mass transmissibility
%   |Suspension Travel/Zr|  Relative suspension motion
%   |Dynamic Tyre Load/Zr|  Tyre-load sensitivity
%
% NOTE:
% A unit road displacement amplitude is used because the
% system is linear and the results are expressed as transfer
% functions.


%% ============================================================
%  1. FREQUENCY RANGE
%  ============================================================

frequency = logspace( ...
    log10(0.5), ...
    log10(30), ...
    500);

omega = 2*pi*frequency;

nFrequency = length(frequency);


%% ============================================================
%  2. SYSTEM MATRICES
%  ============================================================

M = Vertical.M;
C = Vertical.C;
K = Vertical.K;

kt = Vertical.tyreStiffness;


%% ============================================================
%  3. ROAD INPUT
%  ============================================================
%
% Unit road displacement:
%
%   Zr = 1
%
% Road excitation enters the unsprung-mass equation through
% the tyre stiffness:
%
%   Fr = [0 ; kt*Zr]
%

Zr = 1;

roadForce = [ ...
    0;
    kt * Zr];


%% ============================================================
%  4. PREALLOCATE
%  ============================================================

Zs = complex(zeros(1,nFrequency));
Zu = complex(zeros(1,nFrequency));

suspensionTravel = ...
    complex(zeros(1,nFrequency));

tyreDeflection = ...
    complex(zeros(1,nFrequency));

dynamicTyreLoad = ...
    complex(zeros(1,nFrequency));


%% ============================================================
%  5. FREQUENCY SWEEP
%  ============================================================

for i = 1:nFrequency

    w = omega(i);


    %% Dynamic stiffness matrix

    dynamicStiffness = ...
        -w^2 * M + ...
        1i*w * C + ...
        K;


    %% Solve harmonic response
    %
    % [Zs ; Zu]

    response = ...
        dynamicStiffness \ roadForce;


    Zs(i) = response(1);

    Zu(i) = response(2);


    %% Suspension relative displacement

    suspensionTravel(i) = ...
        Zs(i) - Zu(i);


    %% Dynamic tyre deflection
    %
    % Positive magnitude represents relative deformation
    % between the road and unsprung mass.
    %

    tyreDeflection(i) = ...
        Zr - Zu(i);


    %% Dynamic tyre load

    dynamicTyreLoad(i) = ...
        kt * tyreDeflection(i);

end


%% ============================================================
%  6. TRANSFER-FUNCTION MAGNITUDES
%  ============================================================

bodyTransmissibility = ...
    abs(Zs / Zr);

wheelTransmissibility = ...
    abs(Zu / Zr);

suspensionTravelRatio = ...
    abs(suspensionTravel / Zr);

tyreLoadSensitivity = ...
    abs(dynamicTyreLoad / Zr);


%% ============================================================
%  7. PHASE
%  ============================================================

bodyPhase = ...
    rad2deg(angle(Zs));

wheelPhase = ...
    rad2deg(angle(Zu));


%% ============================================================
%  8. IDENTIFY RESPONSE PEAKS
%  ============================================================
%
% These are response peaks of the damped, road-excited system.
% They are not expected to be numerically identical to the
% undamped eigenfrequencies from Stage 5.7A.
%

[bodyPeakMagnitude, bodyPeakIndex] = ...
    max(bodyTransmissibility);

[wheelPeakMagnitude, wheelPeakIndex] = ...
    max(wheelTransmissibility);

[tyreLoadPeak, tyreLoadPeakIndex] = ...
    max(tyreLoadSensitivity);


bodyPeakFrequency = ...
    frequency(bodyPeakIndex);

wheelPeakFrequency = ...
    frequency(wheelPeakIndex);

tyreLoadPeakFrequency = ...
    frequency(tyreLoadPeakIndex);


%% ============================================================
%  9. STORE OUTPUT
%  ============================================================

FrequencyResponse.frequency = ...
    frequency;

FrequencyResponse.omega = ...
    omega;


FrequencyResponse.Zs = ...
    Zs;

FrequencyResponse.Zu = ...
    Zu;


FrequencyResponse.bodyTransmissibility = ...
    bodyTransmissibility;

FrequencyResponse.wheelTransmissibility = ...
    wheelTransmissibility;

FrequencyResponse.suspensionTravelRatio = ...
    suspensionTravelRatio;

FrequencyResponse.tyreLoadSensitivity = ...
    tyreLoadSensitivity;


FrequencyResponse.bodyPhase = ...
    bodyPhase;

FrequencyResponse.wheelPhase = ...
    wheelPhase;


FrequencyResponse.bodyPeakMagnitude = ...
    bodyPeakMagnitude;

FrequencyResponse.bodyPeakFrequency = ...
    bodyPeakFrequency;


FrequencyResponse.wheelPeakMagnitude = ...
    wheelPeakMagnitude;

FrequencyResponse.wheelPeakFrequency = ...
    wheelPeakFrequency;


FrequencyResponse.tyreLoadPeak = ...
    tyreLoadPeak;

FrequencyResponse.tyreLoadPeakFrequency = ...
    tyreLoadPeakFrequency;


FrequencyResponse.bodyNaturalFrequency = ...
    Vertical.naturalFrequencyBody;

FrequencyResponse.wheelHopNaturalFrequency = ...
    Vertical.naturalFrequencyWheelHop;


end