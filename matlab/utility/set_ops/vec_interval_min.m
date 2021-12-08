function min_vec = vec_interval_min(interval)
% Return the minimum norm vector in a given interval
% 
% interval is represented as a column vector in R^2n

n = length(interval) / 2;
c = interval(1:n); w = interval(n+1:end);
A = [c-w, c+w];

mask = sum(sign(A),2) / 2;
min_vec = min(abs(A),[],2);
min_vec = mask .* min_vec;

end