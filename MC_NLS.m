%% parameters

n = 2; % state dimension
m = 4; % measurement dimension

M = [0 10 10  0; % measurement beacon locations
     0  0 10 10]; 

N = 5; % iterations

%% Standard GN

x0 = [5;5];
x = x0;

y = [2.2; 8.0; 12.0; 9.2]; % approx. measurements taken at x = [2;1]

for i = 1:N
    Ji = J(x,M);
    ri = g(x,M) - y;
    dx = inv(Ji'*Ji) * Ji'*ri;
    x = x - dx;
end

figure(1); hold on; grid on; axis equal
scatter(M(1,:)',M(2,:)','o');
scatter(x(1),x(2),'*');
for i = 1:4
    plot([M(1,i);x(1)],[M(2,i);x(2)],'--b');
end

%% Uncertain GN (sampling-based)

x0 = [5;5];
x = x0;

y_c = [2.2; 8.0; 12.0; 9.2]; 
y_G = 0.1*eye(4);
y = zonotope([y_c, y_G]);

% 100 samples within y
n_samp = 1000;
Y = sampleBox(y,n_samp); 

X = zeros(2,n_samp);

for j = 1:n_samp
    x = x0;
    for i = 1:N
        Ji = J(x,M);
        ri = g(x,M) - Y(:,j);
        dx = inv(Ji'*Ji) * Ji'*ri;
        x = x - dx;
    end
    X(:,j) = x;
end

x = X(1,:)'; y = X(2,:)';
k = boundary(x,y);

figure(1); hold on 
plot(x(k),y(k));
scatter(x,y);


%% Interval GN 

x0 = [5;5];
x = x0;

y_c = [2.2; 8.0; 12.0; 9.2]; 
y_w = 0.1*ones(4,1);
y = interval(y_c - y_w,y_c + y_w);

% uniformly sample interval
n_seg = 10;
Y = gridPoints(y,n_seg); 
n_samp = length(Y);

X = zeros(2,n_samp);

for j = 1:n_samp
    x = x0;
    for i = 1:N
        Ji = J(x,M);
        ri = g(x,M) - Y(:,j);
        dx = inv(Ji'*Ji) * Ji'*ri;
        x = x - dx;
    end
    X(:,j) = x;
end

x = X(1,:)'; y = X(2,:)';
k = convhull(x,y);
figure(1); hold on 
plot(x(k),y(k));
scatter(x,y);

% compute "vertices" of output set by taking extreme values of y
y_ext = y_c + diag(y_w) * 2 * (dec2bin(0:2^m-1)-'0' - 0.5)';
n_ext = length(y_ext);

X_ext = zeros(2,n_ext);
for j = 1:n_ext
    x = x0;
    for i = 1:N
        Ji = J(x,M);
        ri = g(x,M) - y_ext(:,j);
        dx = inv(Ji'*Ji) * Ji'*ri;
        x = x - dx;
    end
    X_ext(:,j) = x;
end

x = X_ext(1,:)'; y = X_ext(2,:)';
k = convhull(x,y);
figure(2); hold on 
plot(x(k),y(k));
scatter(x,y);

%% Gaussian uncertain GN

x0 = [5;5];
x = x0;

y_mu = [2.2; 8.0; 12.0; 9.2]; 
y_Sigma = 0.1*eye(4);

% 100 samples within y
n_samp = 1000;
Y = mvnrnd(y_mu,y_Sigma,n_samp)'; 

X = zeros(2,n_samp);

for j = 1:n_samp
    x = x0;
    for i = 1:N
        Ji = J(x,M);
        ri = g(x,M) - Y(:,j);
        dx = inv(Ji'*Ji) * Ji'*ri;
        x = x - dx;
    end
    X(:,j) = x;
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

% zonotope measurement function
function y = g_z(x,M)
    % check if x is 0-dimensional 
    if size(x.generators,2) == 0
        y = zonotope(vecnorm(M - x.center, 2, 1)');
        return
    end
    % otherwise, x is a nontrivial zonotope
    m = size(M,2);
    y_c = zeros(m,1);
    y_G = eye(m);
    for i = 1:m
        z = x - M(:,i);
        I = zono_norm(z);
        y_c(i) = I.center;
        y_G(i,i) = I.volume/2;
    end
    y = zonotope(y_c,y_G);
end

% zonotope measurement jacobian
function Ji = J_z(x,M)
    m = size(M,2); n = dim(x);
    J_c = zeros(m,n);
    % check if x is 0-dimensional 
    if size(x.generators,2) == 0
        x_c = x.center;
        for i = 1:m
            d = norm(M(:,i) - x_c);
            J_c(i,:) = [-(M(1,i)-x_c(1))/d, -(M(2,i)-x_c(2))/d];
        end
        Ji = intervalMatrix(J_c);
        return
    end
    % otherwise, x is a nontrivial zonotope
    J_g = zeros(m,n);
    for i = 1:m
        d_z = x - M(:,i); % zonotope
        d_I = zono_norm(d_z); % norm(zonotope) = interval
        Ji1 = (interval(project(x,1)) - M(1,i)) / d_I; % interval/interval = interval
        Ji2 = (interval(project(x,2)) - M(2,i)) / d_I;
        J_c(i,1) = Ji1.center; J_c(i,2) = Ji2.center;
        J_g(i,1) = Ji1.volume/2; J_g(i,2) = Ji2.volume/2;
    end
    Ji = intervalMatrix(J_c,J_g);
end