clear; close all; clc;

%% parameters

n = 2; % state dimension
m = 4; % measurement dimension

M = [0 10 10  0; % measurement beacon locations
     0  0 10 10]; 

N = 5; % iterations


%% Gaussian uncertain GN

x0 = [1;1];
x = x0;

%y_mu = [2.2; 8.0; 12.0; 9.2]; 
y_mu = [7.07; 7.07; 7.07; 7.07]; 
y_sigma = [0.1,1.0,1.0,0.1];

% 1000 samples within y
n_samp = 1e5;
Y = mvnrnd(y_mu,y_sigma,n_samp)'; 

X = zeros(2,n_samp);

for j = 1:n_samp
    X(:,j) = gauss_newton(@range_g,@range_J,Y(:,j),x0,M,N);
end

x = X(1,:)'; y = X(2,:)';

figure(1); hold on; axis equal
scatter(x,y,'.');

%% Confidence interval

P = 0.5; % probability threshold

y_c = y_mu; 
y_w = norminv((P+1)/2,zeros(m,1),sqrt(y_sigma)');
y_CI = interval(y_c - y_w,y_c + y_w); % confidence interval

% test to see how many Gaussian samples lie in the confidence interval
vec_in = 0; % scalar count for how many of the measurement vectors lie within the CI
point_in = zeros(m,1); % count for how many of each individual measurement lie within the corresponding CI
for i = 1:n_samp
    if in(y_CI,Y(:,i))
        vec_in = vec_in + 1;
    end
    for j = 1:m
        if in(y_CI(j),Y(j,i))
            point_in(j) = point_in(j) + 1;
        end
    end
end

% compute "vertices" of output set by taking extreme values of y
Y_ext = y_c + diag(y_w) * 2 * (dec2bin(0:2^m-1)-'0' - 0.5)';
n_ext = length(Y_ext);

X_ext = zeros(2,n_ext);
for j = 1:n_ext
    X_ext(:,j) = gauss_newton(@range_g,@range_J,Y_ext(:,j),x0,M,N);
end

x_pts = X_ext(1,:)'; y_pts = X_ext(2,:)';
k = convhull(x_pts,y_pts);
figure(1); hold on; axis equal 
plot(x_pts(k),y_pts(k));
%scatter(x_pts,y_pts);

% check how many of the Gaussian GN solutions lie within the interval GN
% solution region
H = Hrep(Vrep([x_pts(k),y_pts(k)]));

disp(['Number of points inside interval bound: ', num2str(sum(in(H,X)))]);