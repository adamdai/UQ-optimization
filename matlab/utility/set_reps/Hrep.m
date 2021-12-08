classdef Hrep < handle
    % class: Hrep
    %
    % Halfspace representation of a polytope
    %
    % Authors: Adam Dai
    % Created: 30 Nov 2021
    % Updated:
    
    properties
        % complexity
        dimension = [];
        n_hspaces = [];
        A = []; 
        b = [];
    end
    
    
    %% methods
    methods
        %% constructor
        function obj = Hrep(A,b)
            % obj = Vrep(vert)
            
            obj.A = A;
            obj.b = b;
            obj.dimension = size(A,2);
            obj.n_hspaces = size(A,1);
        end
        
        function out = Vrep(obj)
            % out = Vrep(obj)
            %
            % Convert from Hrep to Vrep
            
            v = lcon2vert(obj.A,obj.b);
            v = v(convhull(v),:);
            out = Vrep(v);
        end
        
        function out = isempty(obj)
            % out = isempty(obj)
            %
            % Check if empty: true if empty, false if nonempty
            
%             % linprog feasibility program
%             options = optimoptions('linprog','Display','none');
%             out = isempty(linprog(zeros(obj.dimension,1),obj.A,obj.b,[],[],[],[],options));
            % initial guess
            x0 = obj.A\obj.b;
            % check if guess is satisfied
            out = ~all(obj.A*x0 <= obj.b);
        end
        
        function out = and(obj1,obj2)
            % out = and(obj1,obj2)
            % out = obj1 & obj2
            %
            % Intersection. Overloads & operator
            
            Acat = [obj1.A; obj2.A];
            bcat = [obj1.b; obj2.b];
            out = Hrep(Acat,bcat);
        end

        function out = in(obj,pt)
            % out = in(obj,pt)
            %
            % Checks if a point resides inside the H-rep
            out = all(obj.A*pt <= obj.b);
        end
        
    end
end