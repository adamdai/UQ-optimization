function int = interval_norm(obj)
% interval_norm - Computes the norm of an interval as a 1D interval
%
% Authors: Adam Dai
% Created: 27 Sept 2021
% Updated:

    lb = norm(interval_min(obj));
    ub = norm(obj,2);
    int = interval(lb, ub);
end