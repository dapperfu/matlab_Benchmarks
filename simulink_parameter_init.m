NN = 10;
N = 1e4;

times = zeros(1, NN);
for n = 1:NN
    tic
    parameters=cell(1,N);
    for i=1:N
        parameters{i} = Simulink.Parameter;
        parameters{i}.Value = i;
    end
    times(n) = toc;
end
%%
fprintf('Mean: %.2fs\nStdev: %.2f\n',mean(times),std(times));
