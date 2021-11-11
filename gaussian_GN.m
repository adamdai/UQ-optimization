%% parameters

n = 2; % state dimension
m = 4; % measurement dimension

M = [0 10 10  0; % measurement beacon locations
     0  0 10 10]; 

N = 5; % iterations


%% Gaussian uncertain GN

x0 = [5;5];
x = x0;

y_mu = [2.2; 8.0; 12.0; 9.2]; 
y_Sigma = 0.1*eye(4);

% 1000 samples within y
n_samp = 1e5;
Y = mvnrnd(y_mu,y_Sigma,n_samp)'; 

X = zeros(2,n_samp);

for j = 1:n_samp
    X(:,j) = gauss_newton(@g,@J,Y(:,j),x0,M,N);
end

x = X(1,:)'; y = X(2,:)';
k = boundary(x,y);

figure(2); hold on 
plot(x(k),y(k));
scatter(x,y);

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