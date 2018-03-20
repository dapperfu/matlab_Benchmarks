cwd = fileparts(mfilename('fullpath'));

addpath(fullfile(cwd, 'benchmarks'));
bench_lu;
rtwdemo_bench;
simulink_fixedstep_simulation;
simulink_paramgeter_init;