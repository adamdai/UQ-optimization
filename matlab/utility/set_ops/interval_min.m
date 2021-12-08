function min_val = interval_min(interval)
% Return the minimum norm vector in a given interval

A = [interval.inf, interval.sup];

mask = sum(sign(A),2) / 2;
min_val = min(abs(A),[],2);
min_val = mask .* min_val;

end