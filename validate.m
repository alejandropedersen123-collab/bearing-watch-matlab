function validate(realData)
%VALIDATE One-command local/CI verification. Real-data download is opt-in.
arguments
    realData (1,1) logical = false
end
root=fileparts(mfilename('fullpath')); addpath(root);
results=runtests(fullfile(root,'tests'));
assert(numel(results)>=7,'No complete test suite discovered.');assertSuccess(results);
out=fullfile(root,'results');if ~isfolder(out),mkdir(out);end
writetable(table(string({results.Name})',[results.Passed]',[results.Failed]',[results.Duration]', ...
    'VariableNames',{'Test','Passed','Failed','DurationSeconds'}),fullfile(out,'unit-tests.csv'));
run_demo;
if realData, download_data;run_benchmark;end
end
