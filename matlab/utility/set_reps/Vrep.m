classdef Vrep < handle
    % class: Vrep
    %
    % Vertex representation of a polytope
    %
    % Authors: Adam Dai
    % Created: 30 Nov 2021
    % Updated: 
    
    properties
        % complexity
        dimension = [];
        n_verts = [];
        V = []; % vertices
    end
    
    
    %% methods
    methods
        %% constructor
        function obj = Vrep(V)
            % obj = Vrep(vert)
            
            obj.V = V;
            obj.dimension = size(V,2);
            obj.n_verts = size(V,1);
        end
        
        function out = area(obj)
            % out = area(V)
            %
            % Compute the area of the polytope (only for 2D)
            
            if obj.dimension == 2
                out = polyarea(obj.V(1,:),obj.V(2,:));
            else
                disp('Area only works for 2D');
            end
        end
        
        function out = volume(obj)
            % out = area(V)
            %
            % Compute volume of polytope (only for 3D)
            
            shp = alphaShape
            
        end
        
        function out = Hrep(obj)
            % out = Hrep(obj)
            %
            % Convert from Vrep to Hrep
            
            [A,b,~,~] = vert2lcon(obj.V);
            out = Hrep(A,b);
        end
    end
end