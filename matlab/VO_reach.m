%% Standard VO
% Use a direct approach (operate directly on pixel intensities)

% read in images
I0 = imread('000000.png'); % reference frame
I1 = imread('000001.png'); % current frame



% extract features
% F1 = detectFASTFeatures(I1);
% F2 = detectFASTFeatures(I2);
% 
% figure(1);
% imshow(I1); hold on;
% plot(F1.selectStrongest(50));
% 
% figure(2);
% imshow(I2); hold on;
% plot(F2.selectStrongest(50));

% perform 


%% VO reach

% imread img 1
% imread img 2

% add noise to imgs and convert to zonotopes 

% extract features


%% functions

% re-projection function
function w = reproject(p,X)
    
end


function J_ic = inv_comp_jacobian()
end