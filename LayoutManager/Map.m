classdef Map < handle
    properties
        hf;
        sz;
        main;
    end
    methods
        function obj = Map
            obj.hf = figure('Name','»­²¼','NumberTitle','off','MenuBar','none',...
                'Units','normalized','Position',[.1 .1 .8 .8],'SizeChangedFcn',@obj.Resize);
            set(obj.hf,'Units','pixels');
            obj.Update();
            obj.main = Panel(obj.sz);
        end
        function Update(obj)
            obj.sz = get(obj.hf,'Position');
            obj.sz([1,2]) = 0;
        end
        function Resize(obj,~,~)
            if ~isempty(obj.hf)
                obj.Update();
                obj.main.Position = obj.sz;
                obj.main.Update();
            end
        end
    end
end
