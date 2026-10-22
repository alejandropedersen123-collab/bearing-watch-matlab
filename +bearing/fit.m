function model = fit(training, calibration)
%FIT Healthy-only detector; calibration must come from independent records.
Z = [log(training.RMS),log(training.Kurtosis)];
model.center = median(Z,1);
model.scale = max(1.4826*median(abs(Z-model.center),1),[0.08 0.08]);
model.featureNames = ["log RMS","log Pearson kurtosis"];
model.version = '1.0.0';
model.threshold = inf;
[s,~] = bearing.score(calibration,model);
% Conservative, fixed policy. Never tuned on test labels or defect records.
model.threshold = max(3,1.1*max(s));
model.calibrationPolicy = 'max(3, 1.1 * maximum healthy calibration score)';
end
