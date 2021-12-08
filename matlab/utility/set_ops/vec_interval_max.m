function max_vec = vec_interval_max(interval)
% Return the maximum norm vector in a given interval
% 
% interval is represented as a column vector in R^2n

n = length(interval) / 2;
c = interval(1:n); w = interval(n+1:end);

max_vec = max(abs(c-w),abs(c+w));

end