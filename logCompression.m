% check for optional normalise input
if nargin == 2
    normalise = false;
end

% compress signal
if normalise
    mx = max(signal(:));
    signal = mx * (log10(1 + a * signal ./ mx) ./ log10(1 + a));
else 
    signal = log10(1 + a * signal) ./ log10(1 + a);
end