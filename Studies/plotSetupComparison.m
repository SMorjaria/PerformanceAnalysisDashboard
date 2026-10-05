function plotSetupComparison(Comparison)
%PLOTSETUPCOMPARISON
%
% Stage 6.2 - Baseline vs Proposed Setup Comparison


B = Comparison.BaselinePerformance.KPI;
P = Comparison.ProposedPerformance.KPI;


%% ============================================================
% FIGURE 1 - AERODYNAMIC PLATFORM
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.2 - Figure 1 - Aerodynamic Platform Comparison');


values = [ ...
    B.frontRideHeight, P.frontRideHeight;
    B.rearRideHeight,  P.rearRideHeight];


bar(values);

grid on;

ylabel('Dynamic Ride Height [mm]');

xticks([1 2]);

xticklabels({ ...
    'Front', ...
    'Rear'});

title( ...
    'Stage 6.2 - Figure 1 - Dynamic Ride Height Comparison');

legend( ...
    'Baseline', ...
    'Proposed', ...
    'Location','best');


%% ============================================================
% FIGURE 2 - AERODYNAMIC PERFORMANCE
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.2 - Figure 2 - Aerodynamic Performance');


yyaxis left

bar( ...
    [1 2], ...
    [B.downforce P.downforce]);

ylabel('Downforce [N]');


yyaxis right

plot( ...
    [1 2], ...
    [B.aeroEfficiency P.aeroEfficiency], ...
    'o-', ...
    'LineWidth',1.6, ...
    'MarkerSize',7);

ylabel('C_L / C_D [-]');


grid on;

xticks([1 2]);

xticklabels({ ...
    'Baseline', ...
    'Proposed'});

xlim([0.5 2.5]);

title( ...
    'Stage 6.2 - Figure 2 - Aerodynamic Performance Comparison');


%% ============================================================
% FIGURE 3 - VEHICLE BALANCE
% ============================================================

figure( ...
    'Name', ...
    'Stage 6.2 - Figure 3 - Vehicle Balance');


bar( ...
    [1 2], ...
    [ ...
    B.understeerGradient, ...
    P.understeerGradient]);


hold on;

yline( ...
    0, ...
    ':', ...
    'Neutral Steer');


grid on;

xticks([1 2]);

xticklabels({ ...
    'Baseline', ...
    'Proposed'});

ylabel('Understeer Gradient [deg/g]');

title( ...
    'Stage 6.2 - Figure 3 - Vehicle Balance Comparison');


end