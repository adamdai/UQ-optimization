function At = intMat_transpose(A)
% intMat_transpose - Returns the transpose of an interval matrix 
% 
% Syntax:
%   intMat_transpose(A)
% 
% Inputs:
%   A - interval matrix
%
% Outputs:
%   Ainv - transposed interval matrix
% 
% Example:
%   C = [2 3; 4 5];
%   G = [1 0.5; 0.2 2];
%   A = intervalMatrix(C,G);
%   At = intMat_transpose(A);
%
% Author: Adam Dai
% Created: Nov 9 2021
% Updated: 

%------------- BEGIN CODE --------------

    Ct = center(A)';
    Rt = rad(A)';
    At = intervalMatrix(Ct,Rt);
end

%------------- END OF CODE --------------