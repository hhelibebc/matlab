classdef VBox < Panel
    properties
    end
    methods
        function obj = VBox(arg,varargin)
            obj.SetParam('hEnable',1);
            if nargin ~= 0
                arg.AddChild(obj);
                obj.SetParam(varargin{:});
            end
        end
    end
end