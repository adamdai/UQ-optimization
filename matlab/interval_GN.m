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
    X(:,j) = gauss_newton(@range_g,@range_J,Y(:,j),x0,M,N);
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
    X_ext(:,j) = gauss_newton(@range_g,@range_J,Y_ext(:,j),x0,M,N);
end

x_pts = X_ext(1,:)'; y_pts = X_ext(2,:)';
k = convhull(x_pts,y_pts);
figure(2); hold on; axis equal 
plot(x_pts(k),y_pts(k));
scatter(x_pts,y_pts);


%% Interval-based GN

% initial guess
x0 = [5;5] + interval([-0.1; -0.1],[0.1; 0.1]);

% uncertain measurements
y_c = [2.2; 8.0; 12.0; 9.2]; 
%y_w = 0.1*ones(4,1);
y_w = [1.0; 0.01; 0.01; 1.0];
y = interval(y_c - y_w,y_c + y_w);


x = x0;

Ji = J_int(x,M)

%% functions


% interval nonlinear range measurement function
function y = g_int(x,M)
    m = size(M,2);
    y = interval(zeros(m,1),ones(m,1)); % initialize measurement as m-dimensional interval
    for i = 1:m
        y(i) = interval_norm(M(:,i) - x);
    end
end


% interval measurement jacobian
function Ji = J_int(x,M)
    m = size(M,2); n = dim(x);
    J_c = zeros(m,n);
    J_g = zeros(m,n);
    for i = 1:m
        d_z = x - M(:,i); % interval
        d_I = interval_norm(d_z); % norm(interval) = interval
        Ji1 = (interval(project(x,1)) - M(1,i)) / d_I; % interval/interval = interval
        Ji2 = (interval(project(x,2)) - M(2,i)) / d_I;
        J_c(i,1) = Ji1.center; J_c(i,2) = Ji2.center;
        J_g(i,1) = Ji1.volume/2; J_g(i,2) = Ji2.volume/2;
    end
    Ji = intervalMatrix(J_c,J_g);
end