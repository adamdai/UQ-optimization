function At = matZ_transpose(A)
% matZ_transpose - Returns the transpose of a matrix zonotope 
% 
% Syntax:
%   matZ_transpose(A)
% 
% Inputs:
%   A - matrix zonotope
%
% Outputs:
%   At - tranposed matrix zonotope
% 
% Example:
%   C = [0 0; 0 0];
%   G{1} = [1 3; -1 2];
%   G{2} = [2 0; 1 -1];
%   A = matZonotope(C,G);
%   At = matZ_transpose(A);
%
% Author: Adam Dai
% Created: Nov 9 2021
% Updated: 

%------------- BEGIN CODE --------------

    Ct = A.center';
    if isempty(A.generator)
        At = matZonotope(Ct);
    else
        Gt = cellfun(@transpose,A.generator,'UniformOutput',false);
        At = matZonotope(Ct,Gt);
    end
end

%------------- END OF CODE --------------