function x = read_record(file)
%READ_RECORD Load one CWRU drive-end numeric acceleration channel explicitly.
S = load(file);
% CWRU 99.mat also contains stale X098 channels. Select the requested ID,
% never the first matching field (which would leak training data into calibration).
[~,recordID] = fileparts(file);
id = str2double(recordID);
assert(isfinite(id),'bearing:RecordID','Expected a numeric CWRU filename.');
channel = sprintf('X%03d_DE_time',id);
assert(isfield(S,channel),'bearing:Channel','Missing requested channel %s.',channel);
x = S.(channel);
assert(isnumeric(x) && isvector(x) && isreal(x),'bearing:Data','Invalid acceleration data.');
x = double(x(:));
assert(all(isfinite(x)),'bearing:Data','Nonfinite acceleration data.');
end
