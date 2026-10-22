# Engineering decisions

## Why a small detector

This use case starts with healthy baseline data, not a reliable history of every possible failure. A transparent two-feature distance gives a reviewer a clear explanation of why a window is unusual. It is deliberately compared with an RMS-only baseline. If RMS alone reaches the same result, the extra feature has not demonstrated an accuracy benefit on this split.

## Data contract

- A record is one real numeric acceleration vector with a known acquisition setup.
- Every sample must be finite. NaN and infinity are rejected, not silently imputed.
- A window with RMS at or below 1e-12 after DC removal is rejected as flat/disconnected.
- A short record is rejected. Trailing partial windows are excluded.
- Different assets and records reset the alarm state.
- Sensor units and gain must be consistent between calibration and inference.

## What the benchmark does not hide

Training: 97 and 98. Calibration: 99. Test: 100, 108, 121, 133. CWRU record 99 contains extra X098 variables, so loading the exact X099 channel is mandatory. There is no overlapping-window or random row split.

All records still come from the same apparatus, and each test class is represented by one recording. Consecutive windows are correlated. The reported sensitivity and false-alarm rate are descriptive measurements for this experiment; there are too few independent records to estimate production uncertainty credibly. Acquisition/sample-rate differences and the large seeded faults can make this benchmark easy. No frequency-domain diagnosis is claimed.

The acquisition-gain experiment rescales test RMS by 0.5, 1 and 2 while preserving kurtosis, exactly as an ideal constant sensor gain would. The detector is not refitted. Report the loss of performance instead of retuning the threshold after seeing the test results.

## Deployment path

1. Record calibrated healthy data across actual speeds, loads and temperatures.
2. Preserve machine, sensor, date and operating-mode groups in all splits.
3. Evaluate against a simple RMS threshold, technician inspections and known failure events.
4. Monitor missing data and distribution shifts; separate sensor faults from machine warnings.
5. Introduce advisory alarms with operator review and a documented recalibration process.

Possible follow-on work: validated sample-rate metadata, envelope analysis, speed-conditioned baselines, streaming acquisition and independent-machine validation. None is claimed as implemented.
