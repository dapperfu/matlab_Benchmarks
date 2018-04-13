function mult()

% Number of times to loop through multiplying.
N=1e2;
% Size of the array to multiply.
n=1e4;

stream = RandStream('mt19937ar');
% Generate a random array and scale it to 32.
x = rand(stream, n, n)*2^32;

% Build a list of data types to test.
data_types = {'single', 'double'};
% Build int#, uint# data types where # is 8, 16, 32 and 64 bits.
for l = [8, 16, 32, 64]
    for s = {'int' 'uint'}
        data_types = [data_types, sprintf('%s%d', s{1}, l)]; %#ok<AGROW>
    end
end
% Get the results file.
result_file = fullfile(getenv('RESULTS_DIR'), sprintf('%s.%s', mfilename, 'csv'));

fid = fopen(result_file, 'w');
for idx = 1:length(data_types)
    data_type = data_types{idx};
    X = feval(data_type, x);
    tic
    for i=1:N
        X.*2;
    end
    t=toc;
    fprintf(fid,'%s,%.2f\n', data_type, t);
end
fclose(fid);