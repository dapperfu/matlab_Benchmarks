function bench_lu()
%% Matlab lu Benchmark
% lu factorization benchmark. 
% 'bench.m' uses a 2400x2400 matrix.
% This uses 10,000 x 10,000

N = 10;
stream = RandStream('mt19937ar');
reset(stream,0);
n=1e4;
% Open the results file.
result_file = fullfile(getenv('RESULTS_DIR'), sprintf('%s.%s', mfilename, 'csv'));
fid = fopen(result_file, 'w');
for i = 1:N
    A = randn(stream,n,n);
    tic
    lu(A);
    t = toc;
    fprintf(fid, '%d, %.2f\n', i, t);
end
fclose(fid);