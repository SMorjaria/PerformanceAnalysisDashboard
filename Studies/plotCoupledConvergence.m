function plotCoupledConvergence(Coupled)
%PLOTCOUPLEDCONVERGENCE
%
% Stage 3.5
%
% Visualises convergence of the coupled lateral dynamics solver.
%
% Figure 1:
%   Lateral acceleration convergence
%
% Figure 2:
%   Solver convergence error


%% ============================================================
%  ITERATION VECTOR
%  ============================================================

iterations = 1:Coupled.iterations;


%% ============================================================
%  STAGE 3.5 - FIGURE 1
%
%  LATERAL ACCELERATION CONVERGENCE
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.5 - Figure 1 - ', ...
     'Lateral Acceleration Convergence'], ...
    'NumberTitle','off');

plot( ...
    iterations, ...
    Coupled.ayHistory, ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Iteration');

ylabel( ...
    'Calculated Lateral Acceleration [m/s^2]');

title( ...
    ['Stage 3.5 - Coupled Lateral Acceleration ', ...
     'Convergence']);

xlim([1 Coupled.iterations]);


%% ============================================================
%  STAGE 3.5 - FIGURE 2
%
%  SOLVER CONVERGENCE ERROR
%  ============================================================

figure( ...
    'Name', ...
    ['Stage 3.5 - Figure 2 - ', ...
     'Solver Convergence Error'], ...
    'NumberTitle','off');

semilogy( ...
    iterations, ...
    abs(Coupled.errorHistory), ...
    '-o', ...
    'LineWidth',1.6, ...
    'MarkerSize',5);

grid on;
box on;

xlabel('Iteration');

ylabel( ...
    '|a_{y,calculated} - a_{y,current}| [m/s^2]');

title( ...
    'Stage 3.5 - Coupled Solver Convergence Error');

xlim([1 Coupled.iterations]);

end