function times = bench2()






%BENCH  MATLAB Benchmark
%   Heavily modified
%
%   BENCH times six different MATLAB tasks and compares the execution
%   speed with the speed of several other computers.  The six tasks are:
%
%    LU       LAPACK.                            Floating point, regular memory access.
%    FFT      Fast Fourier Transform.            Floating point, irregular memory access.
%    ODE      Ordinary diff. eqn.                Data structures and functions.
%    Sparse   Solve sparse system.               Sparse linear algebra.

%
%   A final bar chart shows speed, which is inversely proportional to
%   time.  Here, longer bars are faster machines, shorter bars are slower.
%
%   BENCH runs each of the six tasks once.
%   BENCH(N) runs each of the six tasks N times.
%   BENCH(0) just displays the results from other machines.
%   T = BENCH(N) returns an N-by-6 array with the execution times.
%
%   The comparison data for other computers is stored in a text file:
%     fullfile(matlabroot, 'toolbox','matlab','general','bench.dat')
%   Updated versions of this file are available from <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1836&objectType=file#','-browser')">MATLAB Central</a>
%   Note the link above opens your system web browser as defined by WEB.
%
%   Fluctuations of five or 10 percent in the measured times of repeated
%   runs on a single machine are not uncommon.  Your own mileage may vary.
%
%   This benchmark is intended to compare performance of one particular
%   version of MATLAB on different machines.  It does not offer direct
%   comparisons between different versions of MATLAB.  The tasks and
%   problem sizes change from version to version.

%   Copyright 1984-2015 The MathWorks, Inc.
%   Copyright 2017 Jed Frey

% Use a private stream to avoid resetting the global stream
stream = RandStream('mt19937ar');
bench_lu(stream);
bench_fft(stream);
bench_ode;
bench_sparse;
bench_2d('Off');
bench_3d(false);    

% Compare with other machines.  Get latest data file, bench.dat, from
% MATLAB Central at the URL given in the help at the beginning of bench.m

if exist('bench.dat','file') ~= 2
    warning(message('MATLAB:bench:noDataFileFound'))
    return
end
fp = fopen('bench.dat', 'rt');

% Skip over headings in first six lines.
for k = 1:6
    fgetl(fp);
end

% Read the comparison data

specs = {};
T = [];
details = {};
g = fgetl(fp);
m = 0;
desclength = 61;
while length(g) > 1
    m = m+1;
    specs{m} = g(1:desclength); %#ok<AGROW>
    T(m,:) = sscanf(g((desclength+1):end),'%f')'; %#ok<AGROW>
    details{m} = fgetl(fp); %#ok<AGROW>
    g = fgetl(fp);
end

% Close the data file
fclose(fp);

% Determine the best 10 runs (if user asked for at least 10 runs)
if count > 10
    warning(message('MATLAB:bench:display10BestTrials', count));
    totaltimes = 100./sum(times, 2);
    [~, timeOrder] = sort(totaltimes, 'descend'); 
    selected = timeOrder(1:10);
else
    selected = 1:count;
end

meanValues = mean(T, 1);

% Add the current machine and sort
T = [T; times(selected, :)];
this = [zeros(m,1); ones(length(selected),1)];
if count==1
    % if a single BENCH run
    specs(m+1) = {getString(message('MATLAB:bench:ThisMachine', repmat(' ', 1, desclength-12)))};
    details{m+1} = getString(message('MATLAB:bench:YourMachine', version));
else
    for k = m+1:size(T, 1)
        ind = k-m; % this varies 1:length(selected)
        sel = num2str(selected(ind));
        specs(k) = {getString(message('MATLAB:bench:ThisMachineRunN', sel, repmat(' ', 1, desclength-18-length(sel))))}; %#ok<AGROW>
        details{k} = getString(message('MATLAB:bench:YourMachineRunN', version, sel));         %#ok<AGROW>
    end
end
scores = mean(bsxfun(@rdivide, T, meanValues), 2);
m = size(T, 1);

% Normalize by the sum of meanValues to bring the results in line with
% earlier implementation 
speeds = (100/sum(meanValues))./(scores);
[speeds,k] = sort(speeds);
specs = specs(k);
details = details(k);
T = T(k,:);
this = this(k);

% Horizontal bar chart. Highlight this machine with another color.

clf(fig1)

% Stretch the figure's width slightly to account for longer machine
% descriptions
units1 = get(fig1, 'Units');
set(fig1, 'Units', 'normalized');
pos1 = get(fig1, 'Position');
set(fig1, 'Position', pos1 + [-0.1 -0.1 0.2 0.1]);
set(fig1, 'Units', units1);

hax2 = axes('position',[.4 .1 .5 .8],'parent',fig1);
barh(hax2,speeds.*(1-this),'y')
hold(hax2,'on')
barh(hax2,speeds.*this,'m')
set(hax2,'xlim',[0 max(speeds)+.1],'xtick',0:10:max(speeds))
title(hax2,getString(message('MATLAB:bench:RelativeSpeed')))
axis(hax2,[0 max(speeds)+.1 0 m+1])
set(hax2,'ytick',1:m)
set(hax2,'yticklabel',specs,'fontsize',9)

% Display report in second figure
fig2 = figure('pos',get(fig1,'pos')+[50 -150 50 0], 'menubar','none', ...
    'numbertitle','off','name',getString(message('MATLAB:bench:MATLABBenchmarkTimes')));

% Defining layout constants - change to adjust 'look and feel'
% The names of the tests
TestNames = {getString(message('MATLAB:bench:LU')), ...
    getString(message('MATLAB:bench:FFT')), ...
    getString(message('MATLAB:bench:ODE')), ...
    getString(message('MATLAB:bench:Sparse')), ...
    getString(message('MATLAB:bench:twoD')), ...
    getString(message('MATLAB:bench:threeD'))};

testDatatips = {getString(message('MATLAB:bench:LUOfMatrix', problemsize(1), problemsize(1))),...
    getString(message('MATLAB:bench:FFTOfVector', problemsize(2))),...
    getString(message('MATLAB:bench:SolutionFromTo', problemsize(3))),...
    getString(message('MATLAB:bench:SolvingSparseLinearSystem', problemsize(4), problemsize(4))),...    
    getString(message('MATLAB:bench:BernsteinPolynomialGraph')),...
    getString(message('MATLAB:bench:AnimatedLshapedMembrane'))};
% Number of test columns
NumTests = size(TestNames, 2);
NumRows = m+1;      % Total number of rows - header (1) + number of results (m)
TopMargin = 0.05; % Margin between top of figure and title row
BotMargin = 0.20; % Margin between last test row and bottom of figure
LftMargin = 0.03; % Margin between left side of figure and Computer Name
RgtMargin = 0.03; % Margin between last test column and right side of figure
CNWidth = 0.40;  % Width of Computer Name column
MidMargin = 0.03; % Margin between Computer Name column and first test column
HBetween = 0.005; % Distance between two rows of tests
WBetween = 0.015; % Distance between two columns of tests
% Width of each test column
TestWidth = (1-LftMargin-CNWidth-MidMargin-RgtMargin-(NumTests-1)*WBetween)/NumTests;
% Height of each test row
RowHeight = (1-TopMargin-(NumRows-1)*HBetween-BotMargin)/NumRows;
% Beginning of first test column
BeginTestCol = LftMargin+CNWidth+MidMargin;
% Retrieve the background color for the figure
bc = get(fig2,'Color');
YourMachineColor = [0 0 1];

% Create headers

% Computer Name column header
uicontrol(fig2,'Style', 'text', 'Units', 'normalized', ...
    'Position', [LftMargin 1-TopMargin-RowHeight CNWidth RowHeight],...
    'String',  getString(message('MATLAB:bench:LabelComputerType')), 'BackgroundColor', bc, 'Tag', 'Computer_Name','FontWeight','bold');

% Test name column header
for k=1:NumTests
    uicontrol(fig2,'Style', 'text', 'Units', 'normalized', ...
        'Position', [BeginTestCol+(k-1)*(WBetween+TestWidth) 1-TopMargin-RowHeight TestWidth RowHeight],...
        'String', TestNames{k}, 'BackgroundColor', bc, 'Tag', TestNames{k}, 'FontWeight', 'bold', ...
        'TooltipString', testDatatips{k});
end
% For each computer
for k=1:NumRows-1
    VertPos = 1-TopMargin-k*(RowHeight+HBetween)-RowHeight;
    if this(NumRows - k)
        thecolor = YourMachineColor;
    else
        thecolor = [0 0 0];
    end
    % Computer Name row header
    uicontrol(fig2,'Style', 'text', 'Units', 'normalized', ...
        'Position', [LftMargin VertPos CNWidth RowHeight],...
        'String', specs{NumRows-k}, 'BackgroundColor', bc, 'Tag', specs{NumRows-k},...
        'TooltipString', details{NumRows-k}, 'HorizontalAlignment', 'left', ...
        'ForegroundColor', thecolor);
    % Test results for that computer
    for n=1:NumTests
        uicontrol(fig2,'Style', 'text', 'Units', 'normalized', ...
            'Position', [BeginTestCol+(n-1)*(WBetween+TestWidth) VertPos TestWidth RowHeight],...
            'String', sprintf('%.4f',T(NumRows-k, n)), 'BackgroundColor', bc, ...
            'Tag', sprintf('Test_%d_%d',NumRows-k,n), 'ForegroundColor', thecolor);
    end
end

% Warning text
uicontrol(fig2, 'Style', 'text', 'Units', 'normalized', ...
    'Position', [0.01 0.01 0.98 BotMargin-0.02], 'BackgroundColor', bc, 'Tag', 'Disclaimer', ...
    'String', getString(message('MATLAB:bench:sprintf_PlaceTheCursorNearAComputerNameForSystemAndVersionDetai')) );

set([fig1 fig2], 'NextPlot', 'new');
end
% ----------------------------------------------- %
function dydt = vanderpol(~,y)
%VANDERPOL  Evaluate the van der Pol ODEs for mu = 1
dydt = [y(2); (1-y(1)^2)*y(2)-y(1)];
end

function [t, n] = bench_lu(stream, n)
reset(stream,0);
A = randn(stream,n,n);
tic
B = lu(A); 
t = toc;
end
% ----------------------------------------------- %
function [t, n] = bench_fft(stream)
% FFT, n = 2^23.
n = 2^23;
reset(stream,1);
x = randn(stream,1,n);
tic;
y = fft(x);
t = toc;
end


% ----------------------------------------------- %
function [t, n] = bench_ode
% ODE. van der Pol equation, mu = 1
F = @vanderpol;
y0 = [2; 0]; 
tspan = [0 eps];
[s,y] = ode45(F,tspan,y0);  %#ok Used  to preallocate s and  y   
tspan = [0 450];
n = tspan(end);
tic
[s,y] = ode45(F,tspan,y0); %#ok Results not used -- strictly for timing
t = toc;
end
% ----------------------------------------------- %
function [t, n] = bench_sparse
% Sparse linear equations
n = 300;
A = delsq(numgrid('L',n));
n = size(A, 1);
b = sum(A)';
tic
x = A\b; %#ok Result not used -- strictly for timing
t = toc;
end

end
