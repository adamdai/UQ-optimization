%% description
% Test fitting the norm of a 2D multivariate normal distribution to a 1D
% normal distribution

N_samples = 1e5;
mu = [15;15];
Sigma = [10 0;
         0 10];

X = mvnrnd(mu,Sigma,N_samples);
Y = vecnorm(X,2,2);

histogram(Y);
fitdist(Y,'Normal')