# Nonlinear range measurement function
function g(x,M) 
    return norm.(eachcol(broadcast(-,M,x)))
end

# Measurement Jacobian
function J(x,M)
    m = size(M,2); n = size(x,1)
    # Ji = [1±1 1±1; 1±1 1±1; 1±1 1±1; 1±1 1±1]
    d = g(x,M)
    Ji = [-(M[1,1] - x[1])/d[1] -(M[2,1] - x[2])/d[1]; 
          -(M[1,2] - x[1])/d[2] -(M[2,2] - x[2])/d[2]; 
          -(M[1,3] - x[1])/d[3] -(M[2,3] - x[2])/d[3]; 
          -(M[1,4] - x[1])/d[4] -(M[2,4] - x[2])/d[4]]
    # for i = 1:m 
    #     d = norm(M[:,i] - x)
    #     Ji[i,:] = [-(M[1,i] - x[1])/d, -(M[2,i] - x[2])/d]
    # end
    return Ji
end