function F = features(x, windowSamples)
%FEATURES Non-overlapping, DC-rejected vibration features. Base MATLAB only.
% Units follow the input acceleration. No sample-rate assumption is required.
arguments
    x (:,1) double {mustBeFinite}
    windowSamples (1,1) double {mustBeInteger,mustBePositive} = 4096
end
assert(windowSamples >= 16,'bearing:Window','Use at least 16 samples.');
assert(numel(x) >= windowSamples,'bearing:ShortRecord','Record is too short.');
n = floor(numel(x)/windowSamples);
X = reshape(x(1:n*windowSamples),windowSamples,n);
X = X - mean(X,1);
r = sqrt(mean(X.^2,1));
assert(all(r > 1e-12),'bearing:FlatSignal','Flat or disconnected sensor detected.');
crest = max(abs(X),[],1)./r;
kurt = mean(X.^4,1)./(r.^4); % Pearson kurtosis, not excess kurtosis
F = table((1:n)',r',crest',kurt', ...
    'VariableNames',{'Window','RMS','CrestFactor','Kurtosis'});
end
