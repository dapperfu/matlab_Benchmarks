%% Simulink Parameter Creation Benchmark
% At times I have found certain models have a disproportonate amount of
% init/run time tied up in Simulink parameter creation.
%
% Depending on where previous employees put the 'init' script call back
% this could be called once per day or once per trying to do anything in
% the model.
%

% Environment Variables:
%   SIMULINK_PARAMETER: Parameter type to create. Can be set to
%   YourCorp.Parameter
%       default: Simulink.Parameter

%% Input processing
simulink_parameter = getenv('SIMULINK_PARAMETER');
if isempty(simulink_parameter)
    simulink_parameter = 'Simulink.Parameter';
end

% Number of times to run the projects.
NN = 10;
% Number of parameters to create.
N = 1e4;

% Results file
result_file = fullfile(getenv('RESULTS_DIR'), sprintf('%s.%s', mfilename, 'csv'));
fid = fopen(result_file, 'w');
fprintf(fid, '%s, N=%.2f\n', simulink_parameter, N);
for n = 1:NN
    tic
    parameters=cell(1,N);
    for i=1:N
        parameters{i} = feval(simulink_parameter);
        parameters{i}.Value = i;
    end
    time = toc;
    fprintf(fid, '%d, %.2f\n', n, time);
end
fclose(fid);