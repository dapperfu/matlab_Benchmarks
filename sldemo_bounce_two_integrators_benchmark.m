mdl = 'sldemo_bounce_two_integrators';
bdclose('all');

tic
open_system('sldemo_bounce_two_integrators');
fprintf('Open: %.2f\n', toc);

tic
sim(mdl);
fprintf('Default Simulation Time: %.2f\n', toc);

configObj = getActiveConfigSet(mdl);
configObj.set_param('SolverType', 'Fixed-step');
for dT = 1e-5
    for ode = [1:5, 8]
        configObj.set_param('Solver', sprintf('ode%d', ode));
        configObj.set_param('FixedStep', sprintf('%f', dT));
        tic
        sim(mdl);
        fprintf('Fixed-Step Ode%d dT=%e: %.2f\n', ode, dT, toc);
    end
end
