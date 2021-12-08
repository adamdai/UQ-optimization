function int = vec_interval_norm(interval)
% interval_norm - Computes the norm of an interval as a 1D interval
%
% interval is represented as a column vector in R^2n
%
% Authors: Adam Dai
% Created: 27 Sept 2021
% Updated:

    lb = norm(vec_interval_min(interval));
    ub = norm(vec_interval_max(interval));
    c = (lb + ub) / 2;
    w = (ub - lb) / 2;
    int = [c;w];
end