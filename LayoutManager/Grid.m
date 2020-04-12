classdef Grid < Panel
    properties
    end
    methods
        function obj = Grid(arg,varargin)
            obj.SetParam('wEnable',1);
            obj.SetParam('hEnable',1);
            if nargin ~= 0
                arg.AddChild(obj);
                obj.SetParam(varargin{:});
            end
        end
    end
end
