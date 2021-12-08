function I = zono_norm(Z)
% zono_norm - find the interval imposed by taking the norm over all the 
%             points in a zonotope
%                  (cop out with sampling for now)
% 
% Syntax:
%   zono_norm(A)
% 
% Inputs:
%   Z - zonotope
%
% Outputs:
%   I - interval
% 
% Example:
%
%
% Author: Adam Dai
% Created: Nov 9 2021
% Updated: 

%------------- BEGIN CODE --------------

    % sample points
    N = 1000;
    X = sampleBox(Z,N);
    min_norm = inf;
    max_norm = 0;
    for i = 1:N
        x = X(:,i);
        d = norm(x);
        if d < min_norm
            min_norm = d;
        end
        if d > max_norm
            max_norm = d;
        end
    end

    I = interval(min_norm, max_norm);

end

%------------- END OF CODE --------------