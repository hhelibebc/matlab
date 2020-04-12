classdef Panel < handle
    properties
        Position;
    end
    properties(SetAccess = private)
        desc = struct('Spacing',0,'Padding',0,'horizontal',0,'vertical',0,...
            'wEnable',0,'hEnable',0,'Visible',0,'Enable',0,'Flexible',0);
        Parent = [];
        Child = {};
    end
    methods(Hidden = true,Access = protected)
        function DisposeLeft(obj,r,c)
            for ii = 1:c
                ind = (ii-1)*r;
                if ii == 1
                    v = obj.Position(1) + obj.desc.Padding;
                else
                    v = v + obj.Child{ind}.Position(3) + obj.desc.Spacing;
                end
                for jj = 1:r
                    obj.Child{ind+jj}.Position(1) = v;
                end
            end
        end
        function DisposeTop(obj,r,c)
            for ii = 1:c
                ind = (ii-1)*r;
                for jj = 1:r
                    if jj==1
                        v = obj.Position(2) + obj.desc.Padding;
                    else
                        v = v + obj.Child{ind+jj-1}.Position(4) + obj.desc.Spacing;
                    end
                    obj.Child{ind + jj}.Position(2) = v;
                end
            end
        end
        function DisposeWidth(obj,r,c)
            list = obj.desc.horizontal;
            if all(list>0)
                list = -list;
            end
            [zero,pos,neg] = GetIndex(list);
            for ii = 1:numel(zero)
                for jj = 1:r
                    obj.Child{(zero(ii)-1)*r+jj}.desc.Visible = 0;
                end
            end
            absWidth = 2*obj.desc.Padding + (c-1)*obj.desc.Spacing + sum(list(pos));
            for ii = 1:numel(pos)
                for jj = 1:r
                    obj.Child{(pos(ii)-1)*r+jj}.Position(3) = list(pos(ii));
                end
            end
            others = obj.Position(3) - absWidth;
            list = list(neg);
            for ii = 1:numel(neg)
                for jj = 1:r
                    obj.Child{(neg(ii)-1)*r+jj}.Position(3) = others*list(ii)/sum(list);
                end
            end
        end
        function DisposeHeight(obj,r,c)
            list = obj.desc.vertical;
            if all(list>0)
                list = -list;
            end
            [zero,pos,neg] = GetIndex(list);
            for ii = 1:numel(zero)
                for jj = 1:c
                    obj.Child{(jj-1)*r+zero(ii)}.desc.Visible = 0;
                end
            end
            absHeight = 2*obj.desc.Padding + (r-1)*obj.desc.Spacing + sum(list(pos));
            for ii = 1:numel(pos)
                for jj = 1:c
                    obj.Child{(jj-1)*r+pos(ii)}.Position(4) = list(pos(ii));
                end
            end
            others = obj.Position(4) - absHeight;
            list = list(neg);
            for ii = 1:numel(neg)
                for jj = 1:c
                    obj.Child{(jj-1)*r+neg(ii)}.Position(4) = others*list(ii)/sum(list);
                end
            end
        end
        function SetParent(obj,arg)
            if isa(arg,'Empty')
                error('Empty can''t be a Parent of other''s obj!');
            end
            if ~isempty(obj.Parent)
                for ind = 1:numel(obj.Parent.Child)
                    if isequal(obj.Parent.Child,obj)
                        break;
                    end
                end
                obj.Parent.Child = obj.Parent.Child([1:ind-1,ind+1:end]);
                arg.Child{end+1,1} = obj;
            end
            obj.Parent = arg;
        end
        function AddChild(obj,arg)
            obj.Child{end+1,1} = arg;
            if isa(arg,'Panel') && ~isa(arg,'Empty')
                arg.SetParent(obj);
            end
        end
    end
    methods
        function obj = Panel(arg,varargin)
            if nargin ~= 0
                if isa(arg,'Panel')
                    arg.AddChild(obj);
                else
                    obj.Position = arg;
                end
                obj.SetParam(varargin{:});
            end
        end       
        function out = AddControl(obj,varargin)% uicontrol
            out = uicontrol(gcf,varargin{:});
            obj.AddChild(out);
        end
        function SetHorizontal(obj,arg)
            if obj.desc.wEnable==1
                t1 = numel(obj.Child);
                t2 = numel(arg);
                if t1<=t2 && ~isa(obj,'Grid')
                    obj.desc.horizontal = arg;
                    for ii = t1:t2-1
                        obj.AddChild(Empty);
                    end
                elseif t1>t2 && isa(obj,'Grid')
                    obj.desc.horizontal = arg;
                else
                    error('Input numbers for set size are not enough!');
                end
            else
                error([class(obj),' not support this property!']);
            end
        end
        function SetVertical(obj,arg)
            if obj.desc.hEnable==1
                t1 = numel(obj.Child);
                t2 = numel(arg);
                if t1<=t2 && ~isa(obj,'Grid')
                    for ii = t1:t2-1
                        obj.AddChild(Empty);
                    end
                    obj.desc.vertical = arg;
                elseif t1>t2 && isa(obj,'Grid')
                    obj.desc.vertical = arg;
                else
                    error('Input numbers for set size are not enough!');
                end
            else
                error([class(obj),' not support this property!']);
            end
        end
        function SetParam(obj,varargin)
            if isempty(varargin)
                return;
            end
            cnt = numel(varargin);
            if mod(cnt,2)~=0
                error('Input param should be in pairs!');
            else
                for i = 1:2:cnt
                    if isfield(obj.desc,varargin{i})
                        obj.desc.(varargin{i}) = varargin{i+1};
                    else
                        error(['Can''t find field ''',varargin{i},''' in this struct']);
                    end
                end
            end
        end
        function Update(obj)
            figure_size = get(gcf,'InnerPosition');
            t1 = numel(obj.Child);
            if t1~=0
                t2 = numel(obj.desc.horizontal);
                t3 = numel(obj.desc.vertical);
                maxcnt = t2*t3;
                switch class(obj)
                    case 'Panel'
                        obj.Child{1}.Position = obj.Position+obj.desc.Padding*[1,1,-2,-2];
                    case 'Grid'
                        if t1>maxcnt
                            error('Input numbers for set size is not enough!');
                        else
                            for i = t1:maxcnt-1
                                obj.AddChild(Empty);
                            end
                            obj.DisposeWidth(t3,t2);
                            obj.DisposeHeight(t3,t2);
                            obj.DisposeLeft(t3,t2);
                            obj.DisposeTop(t3,t2);
                        end
                    case 'HBox'
                        obj.DisposeWidth(t3,t2);
                        obj.DisposeLeft(t3,t2);
                        for i = 1:t1
                            obj.Child{i}.Position([2,4]) = obj.Position([2,4]) + [1,-2]*obj.desc.Padding;
                        end
                    case 'VBox'
                        obj.DisposeHeight(t3,t2);
                        obj.DisposeTop(t3,t2);
                        for i = 1:t1
                            obj.Child{i}.Position([1,3]) = obj.Position([1,3]) + [1,-2]*obj.desc.Padding;
                        end
                    otherwise
                end
                obj.Position(2) = figure_size(4) - obj.Position(2) - obj.Position(4);
                for i = 1:numel(obj.Child)
                    tmpobj = obj.Child{i};
                    if isa(tmpobj,'Panel') && ~isa(tmpobj,'Empty')
                        tmpobj.Update();
                    elseif isa(tmpobj,'matlab.ui.control.UIControl')
                        tmpobj.Position(2) = figure_size(4) - tmpobj.Position(2) - tmpobj.Position(4);
                    end 
                end
            end
            
        end
    end
end
function [zero,pos,neg] = GetIndex(arg)
    zero = find(arg == 0);
    pos = find(arg > 0);
    neg = find(arg < 0);
end
