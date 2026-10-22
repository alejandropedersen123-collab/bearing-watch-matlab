function active = alarm(flag,raiseAfter,clearAfter)
%ALARM Persistence/hysteresis for an ordered stream. Reset between assets.
arguments
    flag (:,1) logical
    raiseAfter (1,1) double {mustBeInteger,mustBePositive} = 3
    clearAfter (1,1) double {mustBeInteger,mustBePositive} = 5
end
active = false(size(flag)); state = false; high = 0; low = 0;
for k = 1:numel(flag)
    if flag(k)
        high = high+1; low = 0;
        if high >= raiseAfter, state = true; end
    else
        low = low+1; high = 0;
        if low >= clearAfter, state = false; end
    end
    active(k) = state;
end
end
