function summary = run_demo
%RUN_DEMO Deterministic offline synthetic smoke demo. Not a real benchmark.
root=fileparts(mfilename('fullpath')); addpath(root); rng(42,'twister');
N=4096; fs=12000; t=(0:N*30-1)'/fs;
healthy=.08*sin(2*pi*30*t)+.025*randn(size(t));
train=bearing.features(healthy); cal=bearing.features(.08*sin(2*pi*30*t)+.026*randn(size(t)));
model=bearing.fit(train,cal);
fault=healthy; pulse=zeros(size(t)); pulse(1:120:end)=1;
fault=fault+filter(1,[1 -1.4 .8],pulse)*.4;
[~,detected]=bearing.score(bearing.features(fault),model);
summary=struct('data','Synthetic smoke test only','detectedWindows',sum(detected),'windows',numel(detected));
disp(summary);
end
