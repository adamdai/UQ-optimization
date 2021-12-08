% nonlinear range measurement function
function y = range_g(x,M)
    y = vecnorm(M - x, 2, 1)';
end

