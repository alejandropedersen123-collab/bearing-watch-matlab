function result = analyze_csv(file,modelFile)
%ANALYZE_CSV Screen an acceleration CSV using a previously calibrated model.
% CSV must contain a finite numeric column named acceleration. Use the same
% units, sensor gain, placement, and operating envelope as the calibration.
arguments
    file (1,:) char
    modelFile (1,:) char = fullfile(fileparts(mfilename('fullpath')),'results','detector.mat')
end
T=readtable(file);
assert(ismember('acceleration',T.Properties.VariableNames),'bearing:CSV','Missing acceleration column.');
assert(isnumeric(T.acceleration),'bearing:CSV','Acceleration must be numeric.');
S=load(modelFile,'model');
result=bearing.features(double(T.acceleration(:)));
[result.Score,result.Anomaly,C]=bearing.score(result,S.model);
result.RMSContribution=C(:,1); result.KurtosisContribution=C(:,2);
result.Alarm=bearing.alarm(result.Anomaly);
end
