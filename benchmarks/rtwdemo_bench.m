here = fileparts(mfilename('fullpath'));

rtwdemo_wc = fullfile(matlabroot, 'toolbox', 'rtw', 'rtwdemos', 'rtwdemo_*.slx');
demos = dir(rtwdemo_wc);

results = [];

for demo = demos'
    
    tmp.mdl = mdl;

    bdclose('all');
    rtwdemodir;
    [~, mdl] = fileparts(demo.name);
    try
               
        open_system(mdl);
        tic;
        slbuild(mdl);
        t = toc;
        tmp.time = t;
    catch    
        tmp.time = -1;
    end
    bdclose(mdl);
    rtwdemoclean;
    
    results = [results; tmp];
end
%%
save('rtw_results', 'results');
cd(here);
