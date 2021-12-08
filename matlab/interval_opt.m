clear; close all; clc;

%% parameters

n = 2; % state dimension
m = 4; % measurement dimension

M = [0 10 10  0; % measurement beacon locations
     0  0 10 10]; 

N = 5; % iterations

%% Optimization over interval parameters
% represent intervals as vector [c;w]

% initial guess
x0 = [5;5;0.1;0.1];

% uncertain measurement interval
y_c = [2.2; 8.0; 12.0; 9.2]; 
y_w = [0.1; 0.1; 0.1; 0.1];
y = [y_c;y_w];

% objective
fun = @(x) vec_interval_cost(y - interval_range_g(x,M));

x = fmincon(fun,x0,[],[]);

y_sol = interval_range_g(x,M);

figure(1); hold on; axis equal 
x_c = x(1:2); x_w = abs(x(3:4));
x_plot = interval(x_c - x_w,x_c + x_w);
plot(x_plot);

%% Sampled Extreme Bounds

% compute "vertices" of output set by taking extreme values of y
Y_ext = y_c + diag(y_w) * 2 * (dec2bin(0:2^m-1)-'0' - 0.5)';
n_ext = length(Y_ext);

X_ext = zeros(2,n_ext);
for j = 1:n_ext
    X_ext(:,j) = gauss_newton(@range_g,@range_J,Y_ext(:,j),x0(1:2),M,N);
end

% take interval hull
X_lb = min(X_ext,[],2);
X_ub = max(X_ext,[],2);
X_hull_c = (X_lb + X_ub)/2;
X_hull_w = (X_ub - X_lb)/2;
X_hull = [X_hull_c; X_hull_w];

x_pts = X_ext(1,:)'; y_pts = X_ext(2,:)';
k = convhull(x_pts,y_pts);
figure(1); hold on; axis equal 
plot(x_pts(k),y_pts(k));
%scatter(x_pts,y_pts);

