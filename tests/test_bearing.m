function tests = test_bearing
tests=functiontests(localfunctions);
end
function testSineFeatures(testCase)
N=4096; x=2*sin(2*pi*(0:N-1)'/64)+7;
F=bearing.features(x,N);
verifyEqual(testCase,F.RMS,sqrt(2),'AbsTol',1e-10);
verifyEqual(testCase,F.Kurtosis,1.5,'AbsTol',1e-10);
verifyEqual(testCase,F.CrestFactor,sqrt(2),'AbsTol',1e-10);
end
function testBadSensorsRejected(testCase)
verifyError(testCase,@()bearing.features(ones(4096,1)),'bearing:FlatSignal');
verifyError(testCase,@()bearing.features(ones(10,1)),'bearing:ShortRecord');
end
function testNoOverlapOrPartialWindow(testCase)
x=sin((1:9000)'); F=bearing.features(x,4096); verifyEqual(testCase,height(F),2);
end
function testPersistence(testCase)
flag=logical([0 1 1 0 1 1 1 0 0 0 0 0]');
verifyEqual(testCase,bearing.alarm(flag),logical([0 0 0 0 0 0 1 1 1 1 1 0]'));
end
function testDCInvariant(testCase)
x=sin((1:8192)'); a=bearing.features(x); b=bearing.features(x+100);
verifyEqual(testCase,a.RMS,b.RMS,'AbsTol',1e-12);
end
function testDetectsAmplitudeShift(testCase)
rng(7); a=bearing.features(randn(4096*20,1)); c=bearing.features(randn(4096*20,1));
m=bearing.fit(a,c); [~,flag]=bearing.score(bearing.features(5*randn(4096*10,1)),m);
verifyTrue(testCase,all(flag)); verifyGreaterThan(testCase,m.threshold,0);
end
function testRecordSelectionPreventsLeakage(testCase)
folder=tempname;mkdir(folder); cleanup=onCleanup(@()rmdir(folder,'s'));
X098_DE_time=ones(32,1); X099_DE_time=(1:32)'; %#ok<NASGU>
file=fullfile(folder,'99.mat');save(file,'X098_DE_time','X099_DE_time');
verifyEqual(testCase,bearing.read_record(file),(1:32)');
end
