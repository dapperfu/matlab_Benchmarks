function machine_info()


wmic_info.bios={'Manufacturer'};
wmic_info.cpu={'Name', 'NumberOfEnabledCore', 'NumberOfLogicalProcessors', 'ProcessorId', 'MaxClockSpeed'};
wmic_info.computersystem={'Manufacturer', 'Model'};
wmic_info.memphysical={'MaxCapacity'};

fid = fopen('machine_info.cfg', 'w');
for section = fieldnames(wmic_info)'
    s = section{1};
    fields = strjoin(sort(wmic_info.(s)), ',');
    [~,result] = system(sprintf('wmic %s get %s /value', s, fields));
    result = strip(result);
    
    fprintf(fid, '[%s]\n', s);
    fprintf(fid, '%s\n\n', result);
end
fclose(fid);