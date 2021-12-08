function x = gauss_newton(g,J,y,x0,M,N)
% gauss_newton(g,J,x0)
%
% Given a measurement function, corresponding Jacobian, measurements, and 
% initial guess perform Gauss Newton to solve the nonlinear least squares 
% problem.
%
% Authors: Adam Dai 
% Created: 9 Nov 2021 
% Updated: 

x = x0;
for i = 1:N
    Ji = J(x,M);
    ri = g(x,M) - y;
    dx = inv(Ji'*Ji) * Ji'*ri;
    x = x - dx;
end

end