function displayTyrePerformance( ...
    TyreLoads, TyrePerformance)
%DISPLAYTYREPERFORMANCE Display tyre load sensitivity results.
%
% ============================================================


fprintf('\n');
fprintf('============================================\n');
fprintf('          TYRE PERFORMANCE\n');
fprintf('============================================\n');


fprintf('\nINDIVIDUAL TYRES\n');
fprintf('--------------------------------------------\n');

fprintf('        Fz [N]      mu [-]      Fy Max [N]\n');

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


fprintf('\nAVAILABLE AXLE GRIP\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle               : %8.1f N\n', ...
    TyrePerformance.frontGrip);

fprintf('Rear Axle                : %8.1f N\n', ...
    TyrePerformance.rearGrip);

fprintf('Total                    : %8.1f N\n', ...
    TyrePerformance.totalGrip);


fprintf('\nGRIP DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                    : %6.2f %%\n', ...
    TyrePerformance.frontGripDistribution * 100);

fprintf('Rear                     : %6.2f %%\n', ...
    TyrePerformance.rearGripDistribution * 100);

fprintf('============================================\n');


end