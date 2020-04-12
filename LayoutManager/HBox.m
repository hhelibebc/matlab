classdef HBox < Panel
    properties
    end
    methods
        function obj = HBox(arg,varargin)
            obj.SetParam('wEnable',1);
            if nargin ~= 0
                arg.AddChild(obj);
                obj.SetParam(varargin{:});
            end
        end
    end
end