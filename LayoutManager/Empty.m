classdef Empty < Panel
    properties
    end
    methods
        function obj = Empty(arg)
            if nargin == 1
                arg.AddChild(obj);
            end
        end
    end
end