function  simulink_fixedstep_simulation()
%% Fixed Step Simulation Benchmark
% Benchmarks ODE1-5 & ODE8 simulations at two different sample rates.
% 
% Environment Variables:
%   SIMULATION_MODEL: Model to run
%       default: sldemo_bounce_two_integrators
%

%% Input processing
simulation_model = getenv('SIMULATION_MODEL');
if isempty(simulation_model)
    simulation_model = 'sldemo_bounce_two_integrators';
end

%% Setup
% Results file
result_file = fullfile(getenv('RESULTS_DIR'), sprintf('%s.%s', mfilename, 'csv'));
fid = fopen(result_file, 'w');

% close all models.
bdclose('all');
% open simulation model in simulink.
open_system(simulation_model);

% Get the current configuration set.
configObj = getActiveConfigSet(simulation_model);
% Set the Solver to Fixed-Step.
configObj.set_param('SolverType', 'Fixed-step');
% Print the simulation model used to the top of the results file.
fprintf(fid, 'simulation_model,%s\n', simulation_model);

% Sample rates
for dT = [1e-5, 1e-6]
    % ODE Solvers
    for ode = [1:5, 8]
        % Set the Solver and Fixed step values for the model.
        configObj.set_param('Solver', sprintf('ode%d', ode));
        configObj.set_param('FixedStep', sprintf('%f', dT));
        % Start stopwatch.
        tic
        % Simulate the model.
        sim(simulation_model);
        % Stop stopwatch
        total = toc;
        % Log results.
        fprintf(fid, 'ode%d,%e,%2f\n', ode, dT, total);
    end
end

fclose(fid);
bdclose(simulation_model);
