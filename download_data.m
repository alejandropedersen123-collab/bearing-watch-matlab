function download_data
%DOWNLOAD_DATA Fetch original public records; raw data are not redistributed.
root = fileparts(mfilename('fullpath'));
dest = fullfile(root,'data','raw');
if ~isfolder(dest), mkdir(dest); end
ids = [97 98 99 100 108 121 133];
for id = ids
    target = fullfile(dest,sprintf('%d.mat',id));
    if ~isfile(target)
        url = sprintf('https://engineering.case.edu/sites/default/files/%d.mat',id);
        fprintf('Downloading CWRU record %d...\n',id);
        websave(target,url,weboptions('Timeout',90));
    end
    bearing.read_record(target); % Validate structure before considering it ready.
end
end
