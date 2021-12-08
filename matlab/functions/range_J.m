% range measurement jacobian
function Ji = range_J(x,M)
    m = size(M,2); n = size(x,1);
    Ji = zeros(m,n);
    for i = 1:m
        d = norm(M(:,i) - x);
        Ji(i,:) = [-(M(1,i)-x(1))/d, -(M(2,i)-x(2))/d];
    end
end
