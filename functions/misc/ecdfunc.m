function [chx] = ecdfunc(x,binrng)
%cdfunc Emprical Cumulative Distribution Function
%   Detailed explanation goes here
hx = histc(x, binrng);                                      % Histogram Counts
chx = cumsum(hx)/numel(x);
end

