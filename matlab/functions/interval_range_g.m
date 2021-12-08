% interval nonlinear range measurement function
% return column vector representing multidimensional interval
function y = interval_range_g(x,M)
    n = length(x)/2; m = size(M,2);
    y = zeros(2,m); % hard-coded measurement dimension = 1 for now
    for i = 1:m
        y(:,i) = vec_interval_norm(x - [M(:,i);zeros(n,1)]);
    end
    y = [y(1,:)';y(2,:)']; % generalize this later
end
