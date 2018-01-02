function times = bench_lu()
N = 10;
stream = RandStream('mt19937ar');
reset(stream,0);

times = zeros(1, N);

n=1e4;
for i = 1:N
    A = randn(stream,n,n);
    tic
    B = lu(A);
    times(i) = toc;
end
