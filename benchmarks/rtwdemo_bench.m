%% Simulink RTW Building Benchmark
% An actual benchmark of what I spend 80% of the time staring at the screen
% waiting to complete.
% Runs slbuild on all of rtwdemos_*slx models.

% Remember where we are.
here = fileparts(mfilename('fullpath'));

% List all of the demos.
rtwdemo_wc = fullfile(matlabroot, 'toolbox', 'rtw', 'rtwdemos', 'rtwdemo_*.slx');
demos = dir(rtwdemo_wc);

% Open the results file.
result_file = fullfile(getenv('WORKSPACE'), sprintf('%s.%s', mfilename, 'csv'));
fid = fopen(result_file, 'w');

% For each of the demos
for demo = demos'
    % Close all other models.
    bdclose('all');
    % Create and move to temp directory
    rtwdemodir;
    % Get just the model name.
    [~, mdl] = fileparts(demo.name);
    try
        % Open the model.
        % Not timed, only testing RTW Generation.
        open_system(mdl);
        % Start the stopwatch.
        tic;
        % Build with default settings.
        slbuild(mdl);
        % Stop the stopwatch
        t = toc;
    catch    
        % Some of the demos need additional hardware.
    end
    % Close the model.
    bdclose(mdl);
    % Clean the rtw demo.
    rtwdemoclean;
    % Log the results.
    fprintf('%s, %.2f', mdl, t);
end
%%
% Close the results file.
fclose(fid);
cd(here);