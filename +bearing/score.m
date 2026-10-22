function [score, anomaly, contribution] = score(F,model)
%SCORE Explainable robust distance, not a failure probability or RUL estimate.
Z = [log(F.RMS),log(F.Kurtosis)];
contribution = ((Z-model.center)./model.scale).^2;
score = sqrt(sum(contribution,2));
anomaly = score > model.threshold;
end
