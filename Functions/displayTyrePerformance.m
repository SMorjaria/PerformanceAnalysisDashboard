function displayTyrePerformance(TyreLoads, TyrePerformance)
%DISPLAYTYREPERFORMANCE Display tyre performance results.
%
% Inputs:
%   TyreLoads       - Final vertical loads at each tyre
%   TyrePerformance - Calculated tyre grip characteristics
%
% ============================================================


fprintf('\n');
fprintf('============================================\n');
fprintf('           TYRE PERFORMANCE\n');
fprintf('============================================\n');


%% ============================================================
%  INDIVIDUAL TYRE PERFORMANCE
%  ============================================================

fprintf('\nINDIVIDUAL TYRES\n');
fprintf('--------------------------------------------\n');

fprintf('       Fz [N]       mu [-]      Fy Max [N]\n');
fprintf('--------------------------------------------\n');

fprintf('FL   %8.1f      %6.3f      %8.1f\n', ...
    TyreLoads.FL, ...
    TyrePerformance.muFL, ...
    TyrePerformance.FyMaxFL);

fprintf('FR   %8.1f      %6.3f      %8.1f\n', ...
    TyreLoads.FR, ...
    TyrePerformance.muFR, ...
    TyrePerformance.FyMaxFR);

fprintf('RL   %8.1f      %6.3f      %8.1f\n', ...
    TyreLoads.RL, ...
    TyrePerformance.muRL, ...
    TyrePerformance.FyMaxRL);

fprintf('RR   %8.1f      %6.3f      %8.1f\n', ...
    TyreLoads.RR, ...
    TyrePerformance.muRR, ...
    TyrePerformance.FyMaxRR);


%% ============================================================
%  AXLE GRIP
%  ============================================================

fprintf('\nAVAILABLE AXLE GRIP\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle               : %8.1f N\n', ...
    TyrePerformance.frontGrip);

fprintf('Rear Axle                : %8.1f N\n', ...
    TyrePerformance.rearGrip);

fprintf('Total Available Grip     : %8.1f N\n', ...
    TyrePerformance.totalGrip);


%% ============================================================
%  GRIP DISTRIBUTION
%  ============================================================

fprintf('\nGRIP DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                    : %6.2f %%\n', ...
    TyrePerformance.frontGripDistribution * 100);

fprintf('Rear                     : %6.2f %%\n', ...
    TyrePerformance.rearGripDistribution * 100);


%% ============================================================
%  LEFT / RIGHT GRIP
%  ============================================================

fprintf('\nLEFT / RIGHT GRIP\n');
fprintf('--------------------------------------------\n');

fprintf('Left Side                : %8.1f N\n', ...
    TyrePerformance.leftGrip);

fprintf('Right Side               : %8.1f N\n', ...
    TyrePerformance.rightGrip);


fprintf('============================================\n');


end