function c = vec_interval_cost(x)
% vec_interval_cost
%
% minimize c^2 + w^2 for an interval defined as [c;w]
% 
% x is an n-dimensional interval represented as a column vector in R^2n
%   the first n elements form the center of the x (c) and the next n 
%   elements are the widths across each dimension (w)

n = length(x) / 2;
c = norm(x(1:n)) + norm(x(n+1:end));

end