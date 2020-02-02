%% Setup
% Clear Screen.
clc;
% Close all models.
bdclose('all');
% Close all files.
fclose('all');

% Get current directory.
cwd = fileparts(mfilename('fullpath'));
% Add the benchmarks directory.
addpath(fullfile(cwd, 'benchmarks'));

% Generate Test UUID & results directory.
test_uuid = char(java.util.UUID.randomUUID);
results_dir = fullfile(cwd, 'results', test_uuid);
mkdir(results_dir);
assert(exist(results_dir, 'dir')==7);
setenv('RESULTS_DIR', results_dir);

% List benchmarks directory.
benchmarks = dir('benchmarks');
% Loop through all of the benchmarks.
for idx = 1:length(benchmarks)
    benchmark = benchmarks(idx);
    % Directories are not benchmarks.
    if benchmark.isdir
        continue;
    end
    % Get just the benchmark name.
    [~, bnch, ~] = fileparts(benchmark.name);
    % Run it.
    try
        fprintf('Running: %s\n', bnch)
        feval(bnch);
    catch
        fprintf('Failed: %s\n', bnch)
    end
end
% Come back here.
cd(cwd);
% Open the results directory.
[s, w] = system(['start ', results_dir]);
%%
if ~exist('UserBenchMark.exe', 'file')
    fprintf(1, 'Downloading UserBenchMark.exe\n');
    websave('UserBenchMark.exe', 'http://www.userbenchmark.com/resources/download/UserBenchMark.exe');
end

fid = fopen(fullfile(results_dir, 'UserBenchMark.txt'), 'w');
fprintf(fid, 'Copy and paste the results from UserBenchMark here');
fclose(fid);

dos(sprintf('start %s', fullfile(results_dir, 'UserBenchMark.txt')));
dos('start UserBenchMark.exe');