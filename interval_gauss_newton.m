clear; close all; clc;

%% parameters

n = 2; % state dimension
m = 4; % measurement dimension

M = [0 10 10  0; % measurement beacon locations
     0  0 10 10]; 

N = 5; % iterations


%% Monte Carlo Interval GN 

x0 = [5;5];

y_c = [2.2; 8.0; 12.0; 9.2]; 
%y_w = 0.1*ones(4,1);
y_w = [1.0; 0.01; 0.01; 1.0];
y = interval(y_c - y_w,y_c + y_w);

% uniformly sample interval
n_seg = 10;
Y = gridPoints(y,n_seg); 
n_samp = length(Y);

X = zeros(2,n_samp);

for j = 1:n_samp
    X(:,j) = gauss_newton(@g,@J,Y(:,j),x0,M,N);
end

x_pts = X(1,:)'; y_pts = X(2,:)';
k = convhull(x_pts,y_pts);
figure(1); hold on; axis equal
plot(x_pts(k),y_pts(k));
scatter(x_pts,y_pts);

% compute "vertices" of output set by taking extreme values of y
Y_ext = y_c + diag(y_w) * 2 * (dec2bin(0:2^m-1)-'0' - 0.5)';
n_ext = length(Y_ext);

X_ext = zeros(2,n_ext);
for j = 1:n_ext
    X_ext(:,j) = gauss_newton(@g,@J,Y_ext(:,j),x0,M,N);
end

x_pts = X_ext(1,:)'; y_pts = X_ext(2,:)';
k = convhull(x_pts,y_pts);
figure(2); hold on; axis equal 
plot(x_pts(k),y_pts(k));
scatter(x_pts,y_pts);


%% functions

% nonlinear range measurement function
function y = g(x,M)
    y = vecnorm(M - x, 2, 1)';
end

% measurement jacobian
function Ji = J(x,M)
    m = size(M,2); n = size(x,1);
    Ji = zeros(m,n);
    for i = 1:m
        d = norm(M(:,i) - x);
        Ji(i,:) = [-(M(1,i)-x(1))/d, -(M(2,i)-x(2))/d];
    end
end