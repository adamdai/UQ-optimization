module gauss_GN

include("functions.jl")

using MonteCarloMeasurements, Distributions, LinearAlgebra, Plots, StatsPlots

# Parameters
N = 20 # number of particles to use
iters = 5 # number of iterations of Gauss Newton to run
M = [0 10 0 10;
     0 0 10 10] # measurement beacon locations
y = [2.2; 8.0; 12.0; 9.2] # range measurements

# Initialize guess x0 (2D position)
x0 = [Particles(N,Normal(5,1)),Particles(N,Normal(5,1))]

x = x0
for i in 1:iters
    Ji = J(x,M)
    ri = g(x,M) - y
    dx = inv(Ji'*Ji) * Ji' * ri
    global x -= dx
end

print(x)
display(plot(x))
display(density(x))

end