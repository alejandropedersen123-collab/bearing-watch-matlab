function summary = run_benchmark
%RUN_BENCHMARK Record-disjoint healthy training, calibration and 3 hp test.
root = fileparts(mfilename('fullpath')); addpath(root);
out = fullfile(root,'results'); if ~isfolder(out), mkdir(out); end
ids = [97 98 99 100 108 121 133];
roles = ["train","train","calibration","test","test","test","test"];
labels = ["healthy","healthy","healthy","healthy","inner_race","ball","outer_race"];
loads = [0 1 2 3 3 3 3];
allFeatures = table;
for j = 1:numel(ids)
    file = fullfile(root,'data','raw',sprintf('%d.mat',ids(j)));
    assert(isfile(file),'bearing:MissingData','Run download_data first. Missing %s',file);
    F = bearing.features(bearing.read_record(file));
    F.Record = repmat(ids(j),height(F),1);
    F.Role = repmat(roles(j),height(F),1);
    F.Label = repmat(labels(j),height(F),1);
    F.LoadHP = repmat(loads(j),height(F),1);
    allFeatures = [allFeatures;F]; %#ok<AGROW>
end
train = allFeatures(allFeatures.Role=="train",:);
cal = allFeatures(allFeatures.Role=="calibration",:);
test = allFeatures(allFeatures.Role=="test",:);
assert(isempty(intersect(unique(train.Record),unique(test.Record))));
assert(isempty(intersect(unique(cal.Record),unique(test.Record))));
model = bearing.fit(train,cal);
[test.Score,test.Anomaly,C] = bearing.score(test,model);
test.RMSContribution = C(:,1); test.KurtosisContribution = C(:,2);
test.Alarm = false(height(test),1);
for id = unique(test.Record)'
    idx = test.Record==id; test.Alarm(idx) = bearing.alarm(test.Anomaly(idx));
end
truth = test.Label~="healthy";
tp = sum(truth & test.Anomaly); fn = sum(truth & ~test.Anomaly);
fp = sum(~truth & test.Anomaly); tn = sum(~truth & ~test.Anomaly);
summary = struct('testWindows',height(test),'testRecords',numel(unique(test.Record)), ...
    'trainRecords',[97 98],'calibrationRecords',99,'testRecordIDs',[100 108 121 133], ...
    'threshold',model.threshold,'truePositive',tp,'falseNegative',fn, ...
    'falsePositive',fp,'trueNegative',tn,'sensitivity',tp/(tp+fn), ...
    'falseAlarmRate',fp/(fp+tn),'balancedAccuracy',0.5*(tp/(tp+fn)+tn/(tn+fp)), ...
    'matlabVersion',version,'windowSamples',4096, ...
    'scope','CWRU seeded defects, single test rig, 3 hp held-out records. Windows are correlated; not independent machines.');
writetable(allFeatures,fullfile(out,'features.csv'));
writetable(test,fullfile(out,'test_predictions.csv'));
% Diagnostic baseline and acquisition-gain stress: no refitting on test data.
calRms=abs((log(cal.RMS)-model.center(1))/model.scale(1));
rmsThreshold=max(3,1.1*max(calRms));
rmsFlag=abs((log(test.RMS)-model.center(1))/model.scale(1))>rmsThreshold;
summary.rmsOnlyBalancedAccuracy=.5*(mean(rmsFlag(truth))+mean(~rmsFlag(~truth)));
gains=[.5 1 2]; stress=table;
for gain=gains
    shifted=test; shifted.RMS=shifted.RMS*gain;
    [~,flag]=bearing.score(shifted,model);
    stress=[stress;table(gain,mean(flag(truth)),mean(flag(~truth)), ...
        .5*(mean(flag(truth))+mean(~flag(~truth))), ...
        'VariableNames',{'AcquisitionGain','Sensitivity','FalseAlarmRate','BalancedAccuracy'})]; %#ok<AGROW>
end
writetable(stress,fullfile(out,'gain_stress.csv'));
save(fullfile(out,'detector.mat'),'model');
fid=fopen(fullfile(out,'summary.json'),'w'); cleanup=onCleanup(@()fclose(fid));
fprintf(fid,'%s',jsonencode(summary,'PrettyPrint',true)); clear cleanup;
fig=figure('Visible','off','Color','w','Position',[50 50 1200 720]);
tiledlayout(2,2,'TileSpacing','compact');
nexttile; hold on; colors=lines(4); names=unique(test.Label,'stable');
for j=1:numel(names)
    f=test(test.Label==names(j),:);
    scatter(f.RMS,f.Kurtosis,18,colors(j,:),'filled','DisplayName',strrep(names(j),'_',' '));
end
set(gca,'XScale','log','YScale','log'); grid on; xlabel('Acceleration RMS (input units)'); ylabel('Pearson kurtosis');
legend('Location','best'); title('Unseen 3 hp records');
nexttile; hold on; offset=0;
for j=1:numel(names)
    f=test(test.Label==names(j),:);
    plot(offset+(1:height(f)),f.Score,'Color',colors(j,:),'LineWidth',1.5); offset=offset+height(f);
end
yline(model.threshold,'--r','Healthy-only threshold'); grid on;
xlabel('Windows grouped by record (not a continuous timeline)'); ylabel('Robust distance'); title('Decision evidence');
nexttile; confusion=[tn fp;fn tp]; imagesc(confusion); colormap(gca,parula); colorbar;
xticks(1:2); xticklabels({'Normal','Anomaly'}); yticks(1:2); yticklabels({'Healthy','Defect'});
xlabel('Predicted'); ylabel('Actual'); title('Window-level confusion matrix');
for r=1:2, for c=1:2
    color='w';if confusion(r,c)>max(confusion,[],'all')*.5,color='k';end
    text(c,r,string(confusion(r,c)),'HorizontalAlignment','center','Color',color,'FontSize',18,'FontWeight','bold');
end,end
nexttile; stairs(1:22,double(bearing.alarm([false(3,1);true(5,1);false(3,1);true(3,1);false(8,1)])),'LineWidth',2);
ylim([-.1 1.2]); grid on; xlabel('Example stream window'); ylabel('Alarm state'); title('Persistence: raise 3 / clear 5');
sgtitle('BEARING WATCH | Healthy-only anomaly screening');
exportgraphics(fig,fullfile(out,'benchmark.png'),'Resolution',160); close(fig);
disp(summary);
end
