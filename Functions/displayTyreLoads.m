function displayTyreLoads(TyreLoads, Operating, Constants)
%DISPLAYTYRELOADS Display final four-corner tyre loads.
%
% ============================================================


fprintf('\n');
fprintf('============================================\n');
fprintf('          DYNAMIC TYRE LOADS\n');
fprintf('============================================\n');

fprintf('\nOPERATING CONDITION\n');
fprintf('--------------------------------------------\n');

fprintf('Longitudinal Acceleration : %+.2f g\n', ...
    Operating.ax / Constants.g);

fprintf('Lateral Acceleration      : %+.2f g\n', ...
    Operating.ay / Constants.g);


fprintf('\nTYRE LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Left                : %8.1f N\n', ...
    TyreLoads.FL);

fprintf('Front Right               : %8.1f N\n', ...
    TyreLoads.FR);

fprintf('Rear Left                 : %8.1f N\n', ...
    TyreLoads.RL);

fprintf('Rear Right                : %8.1f N\n', ...
    TyreLoads.RR);


fprintf('\nAXLE LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('Front Axle                : %8.1f N\n', ...
    TyreLoads.frontAxle);

fprintf('Rear Axle                 : %8.1f N\n', ...
    TyreLoads.rearAxle);


fprintf('\nSIDE LOADS\n');
fprintf('--------------------------------------------\n');

fprintf('Left Side                 : %8.1f N\n', ...
    TyreLoads.leftSide);

fprintf('Right Side                : %8.1f N\n', ...
    TyreLoads.rightSide);


fprintf('\nLOAD DISTRIBUTION\n');
fprintf('--------------------------------------------\n');

fprintf('Front                     : %6.2f %%\n', ...
    TyreLoads.frontDistribution * 100);

fprintf('Rear                      : %6.2f %%\n', ...
    TyreLoads.rearDistribution * 100);

fprintf('Left                      : %6.2f %%\n', ...
    TyreLoads.leftDistribution * 100);

fprintf('Right                     : %6.2f %%\n', ...
    TyreLoads.rightDistribution * 100);


fprintf('\nVALIDATION\n');
fprintf('--------------------------------------------\n');

fprintf('Total Vertical Load       : %8.1f N\n', ...
    TyreLoads.total);

fprintf('Load Conservation Error   : %.6f N\n', ...
    TyreLoads.loadError);


if TyreLoads.wheelLift

    fprintf('Wheel Lift                : WARNING\n');

else

    fprintf('Wheel Lift                : None\n');

end


fprintf('============================================\n');

end