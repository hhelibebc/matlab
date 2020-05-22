function MagicCube

% colors = ['w','r','g','b','y','m','c'];
colors = [1,1,1;1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1];
UDT = [1,0,0;.5,1,0;0,0,1];
UDZ = [1,0,0;0,0.5,0;0,0,1];
LRT = [1,.5,0;0,1,0;0,0,1];
LRZ = [0.5,0,0;0,1,0;0,0,1];
data = struct('L',ones(3)*1,'R',ones(3)*2,'U',ones(3)*3,'D',...
    ones(3)*4,'F',ones(3)*5,'B',ones(3)*6);
imageData = ones(135,300,3);
optQueue = '';
optTable = {'U','R','F','D','L','B','U''','R''','F''','D''','L''','B''','U2','R2','F2','D2','L2','B2',...
    'r','f','l','b','u','d','M','r''','f''','l''','b''','u''','d''','M''',...
    'x','y','z','x''','y''','z'''};
seqTable = {'URU''R''U''F''UF','U''F''UFURU''R''','FRUR''U''F''','RUR''URU2R''','L''U''LU''L''U2L'};
h = Map;
edits = cell(6,1);
InitControls();

h.main.Update();
ha = axes(h.hf,'Units','pixels','Position',L1.Position);
hi = imshow(imageData);
ht = timer('Period',.5,'ExecutionMode','fixedRate','TimerFcn',@myTimer);
set(ha,'View',[0,-90]);
UpdatePages();
    function UpdateFaceColor
        set(edits{1},'BackgroundColor',colors(data.U(2,2)+1,:));
        set(edits{2},'BackgroundColor',colors(data.L(2,2)+1,:));
        set(edits{3},'BackgroundColor',colors(data.F(2,2)+1,:));
        set(edits{4},'BackgroundColor',colors(data.D(2,2)+1,:));
        set(edits{5},'BackgroundColor',colors(data.R(2,2)+1,:));
        set(edits{6},'BackgroundColor',colors(data.B(2,2)+1,:));
    end
    function InitControls
        L = HBox(h.main);
        L1 = Empty(L);
        L2 = VBox(L);
        L.SetParam('Spacing',30);
        L.SetHorizontal([-1,300]);
        L21 = VBox(L2);% 留白
        L27 = Panel(L2);
        L22 = Grid(L2);% 显示中心块颜色
        L28 = Panel(L2);
        L23 = Grid(L2);% 基础公式表
        L29 = Panel(L2);
        L24 = Grid(L2);% CFOP公式表
        L30 = Panel(L2);
        L25 = Grid(L2);% 转动魔方
        L26 = Empty(L2);% 留白
        L2.SetParam('Spacing',10);
        L2.SetVertical([180,20,90,20,180,20,120,20,60,-1]);
        
        L21.AddControl('string','随机打乱','HorizontalAlignment','left','Callback',@Upset);
        L21.AddControl('string',seqTable{1},'HorizontalAlignment','left','Callback',@ExcuteSequence);
        L21.AddControl('string',seqTable{2},'HorizontalAlignment','left','Callback',@ExcuteSequence);
        L21.AddControl('string',seqTable{3},'HorizontalAlignment','left','Callback',@ExcuteSequence);
        L21.AddControl('string',seqTable{4},'HorizontalAlignment','left','Callback',@ExcuteSequence);
        L21.AddControl('string',seqTable{5},'HorizontalAlignment','left','Callback',@ExcuteSequence);
        L21.SetVertical([-1,-1,-1,-1,-1,-1]);
        
        L27.AddControl('string','各面颜色','style','text','HorizontalAlignment','left');
        L28.AddControl('string','基础公式表','style','text','HorizontalAlignment','left');
        L29.AddControl('string','CFOP公式表','style','text','HorizontalAlignment','left');
        L30.AddControl('string','转动魔方','style','text','HorizontalAlignment','left');
        
        L22.AddControl('string','上','style','text');
        L22.AddControl('string','左','style','text');
        L22.AddControl('string','前','style','text');
        edits{1} = L22.AddControl('string','','style','edit');
        edits{2} = L22.AddControl('string','','style','edit');
        edits{3} = L22.AddControl('string','','style','edit');
        L22.AddControl('string','下','style','text');
        L22.AddControl('string','右','style','text');
        L22.AddControl('string','后','style','text');
        edits{4} = L22.AddControl('string','','style','edit');
        edits{5} = L22.AddControl('string','','style','edit');
        edits{6} = L22.AddControl('string','','style','edit');
        L22.SetHorizontal([-1,-1,-1,-1]);
        L22.SetVertical([-1,-1,-1]);
        
        L23.AddControl('string','U','Callback',@RotateU1);
        L23.AddControl('string','R','Callback',@RotateR1);
        L23.AddControl('string','F','Callback',@RotateF1);
        L23.AddControl('string','D','Callback',@RotateD1);
        L23.AddControl('string','L','Callback',@RotateL1);
        L23.AddControl('string','B','Callback',@RotateB1);
        L23.AddControl('string','U''','Callback',@RotateU_1);
        L23.AddControl('string','R''','Callback',@RotateR_1);
        L23.AddControl('string','F''','Callback',@RotateF_1);
        L23.AddControl('string','D''','Callback',@RotateD_1);
        L23.AddControl('string','L''','Callback',@RotateL_1);
        L23.AddControl('string','B''','Callback',@RotateB_1);
        L23.AddControl('string','U2','Callback',@RotateU2);
        L23.AddControl('string','R2','Callback',@RotateR2);
        L23.AddControl('string','F2','Callback',@RotateF2);
        L23.AddControl('string','D2','Callback',@RotateD2);
        L23.AddControl('string','L2','Callback',@RotateL2);
        L23.AddControl('string','B2','Callback',@RotateB2);
        L23.SetHorizontal([-1,-1,-1]);
        L23.SetVertical([-1,-1,-1,-1,-1,-1]);
        
        L24.AddControl('string','r','Callback',@Rotate_r);
        L24.AddControl('string','l','Callback',@Rotate_l);
        L24.AddControl('string','u','Callback',@Rotate_u);
        L24.AddControl('string','M','Callback',@Rotate_M);
        L24.AddControl('string','r''','Callback',@Rotate_r_1);
        L24.AddControl('string','l''','Callback',@Rotate_l_1);
        L24.AddControl('string','u''','Callback',@Rotate_u_1);
        L24.AddControl('string','M''','Callback',@Rotate_M_1);
        L24.AddControl('string','f','Callback',@Rotate_f);
        L24.AddControl('string','b','Callback',@Rotate_b);
        L24.AddControl('string','d','Callback',@Rotate_d);
        Empty(L24);
        L24.AddControl('string','f''','Callback',@Rotate_f_1);
        L24.AddControl('string','b''','Callback',@Rotate_b_1);
        L24.AddControl('string','d''','Callback',@Rotate_d_1);
        L24.SetHorizontal([-1,-1,-1,-1]);
        L24.SetVertical([-1,-1,-1,-1]);
        
        L25.AddControl('string','x(F->U)','Callback',@RotateUp);
        L25.AddControl('string','x''(F->D)','Callback',@RotateDown);
        L25.AddControl('string','y(F->L)','Callback',@RotateLeft);
        L25.AddControl('string','y''(F->R)','Callback',@RotateRight);
        L25.AddControl('string','z(U->R)','Callback',@Rotate90);
        L25.AddControl('string','z''(U->L)','Callback',@Rotate_90);
        L25.SetHorizontal([-1,-1,-1]);
        L25.SetVertical([-1,-1]);
        
        UpdateFaceColor();
    end
    function image = Arr2Image(arr,T1,T2)
        tmp = ones(90,90,3);
        for i = 1:3
            for j = 1:3
                for r = 2:29
                    for c = 2:29
                        tmp((i-1)*30+r,(j-1)*30+c,:) = colors(arr(i,j)+1,:);
                    end
                end
            end
        end
        if isempty(T1)
            image = tmp;
        else
            image = imwarp(tmp,imref2d(size(tmp)),affine2d(T1));
            image = imwarp(image,imref2d(size(image)),affine2d(T2));
        end
    end
    function ExtraWorks
        for i = 1:2:90
            imageData(90,i,:) = [0,0,0];
            imageData(i,90,:) = [0,0,0];
            imageData(45,210+i,:) = [0,0,0];
            imageData(45+i,210,:) = [0,0,0];
        end
        for i = 1:2:45
            imageData(90+i,90+i,:) = [0,0,0];
            imageData(i,165+i,:) = [0,0,0];
        end
        set(hi,'CData',imageData);
    end
    function UpdateUp
        tmp = Arr2Image(flip(data.U,2),UDT,UDZ);
        for i = 1:45
            for j = i:i+90
                imageData(136-i,301-j,:) = tmp(i,j,:);
            end
        end
        ExtraWorks();
    end
    function UpdateDown
        tmp = Arr2Image(data.D,UDT,UDZ);
        for i = 1:45
            for j = i:i+90
                imageData(i,j,:) = tmp(i,j,:);
            end
        end
        ExtraWorks();
    end
    function UpdateLeft
        tmp = Arr2Image(data.L,LRT,LRZ);
        for j = 1:45
            for i = j:j+90
                imageData(i,j,:) = tmp(136-i,46-j,:);
            end
        end
        ExtraWorks();
    end
    function UpdateRight
        tmp = Arr2Image(flip(data.R,2),LRT,LRZ);
        for j = 1:45
            for i = j:j+90
                imageData(136-i,301-j,:) = tmp(i,j,:);
            end
        end
        ExtraWorks();
    end
    function UpdateFront
        tmp = Arr2Image(data.F,[],[]);
        for i = 1:90
            for j = 1:90
                imageData(91-i,165+j,:) = tmp(i,j,:);
            end
        end
        ExtraWorks();
    end
    function UpdateBehind
        tmp = Arr2Image(data.B,[],[]);
        for i = 1:90
            for j = 1:90
                imageData(136-i,136-j,:) = tmp(i,j,:);
            end
        end
        ExtraWorks();
    end
    function UpdatePages
        UpdateUp();
        UpdateDown();
        UpdateLeft();
        UpdateRight();
        UpdateFront();
        UpdateBehind();
    end
    function Excute(cmd)
        switch cmd
            case optTable{1}
                RotateU1(0,0);
            case optTable{2}
                RotateR1([],0);
            case optTable{3}
                RotateF1([],0);
            case optTable{4}
                RotateD1([],0);
            case optTable{5}
                RotateL1([],0);
            case optTable{6}
                RotateB1([],0);
            case optTable{7}
                RotateU_1([],0);
            case optTable{8}
                RotateR_1([],0);
            case optTable{9}
                RotateF_1([],0);
            case optTable{10}
                RotateD_1([],0);
            case optTable{11}
                RotateL_1([],0);
            case optTable{12}
                RotateB_1([],0);
            case optTable{13}
                RotateU2([],0);
            case optTable{14}
                RotateR2([],0);
            case optTable{15}
                RotateF2([],0);
            case optTable{16}
                RotateD2([],0);
            case optTable{17}
                RotateL2([],0);
            case optTable{18}
                RotateB2([],0);
            otherwise
        end
    end
    function ExcuteSequence(o,~)
        optQueue = o.String;
        start(ht);
    end
    function Upset(~,~)
        for i = 1:50
            Excute(optTable{randi([2,6])});
        end
        UpdatePages();
    end
    function myTimer(~,~)
        if ~isempty(optQueue)
            if numel(optQueue)<2 || isletter(optQueue(2))
                Excute(optQueue(1));
                optQueue = optQueue(2:end);
            else
                Excute(optQueue(1:2));
                optQueue = optQueue(3:end);
            end
        else
            stop(ht);
        end
    end
% 原子操作
    function RotateUp(o,~)
        tmp = data.F;
        data.F = data.D;
        data.D = rot90(data.B,2);
        data.B = rot90(data.U,2);
        data.U = tmp;
        data.L = rot90(data.L);
        data.R = rot90(data.R,3);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function RotateDown(o,~)
        tmp = data.F;
        data.F = data.U;
        data.U = rot90(data.B,2);
        data.B = rot90(data.D,2);
        data.D = tmp;
        data.L = rot90(data.L,3);
        data.R = rot90(data.R);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function RotateLeft(o,~)
        tmp = data.F;
        data.F = data.R;
        data.R = data.B;
        data.B = data.L;
        data.L = tmp;
        data.U = rot90(data.U,3);
        data.D = rot90(data.D);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function RotateRight(o,~)
        tmp = data.F;
        data.F = data.L;
        data.L = data.B;
        data.B = data.R;
        data.R = tmp;
        data.U = rot90(data.U);
        data.D = rot90(data.D,3);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function Rotate90(o,~)
        tmp = data.U;
        data.U = rot90(data.L,3);
        data.L = rot90(data.D,3);
        data.D = rot90(data.R,3);
        data.R = rot90(tmp,3);
        data.F = rot90(data.F,3);
        data.B = rot90(data.B);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function Rotate_90(o,~)
        tmp = data.U;
        data.U = rot90(data.R);
        data.R = rot90(data.D);
        data.D = rot90(data.L);
        data.L = rot90(tmp);
        data.F = rot90(data.F);
        data.B = rot90(data.B,3);
        if ~isempty(o)
            UpdatePages();
            UpdateFaceColor();
        end
    end
    function RotateU1(o,~)
        data.U = rot90(data.U,3);
        tmp = data.F(1,:);
        data.F(1,:) = data.R(1,:);
        data.R(1,:) = data.B(1,:);
        data.B(1,:) = data.L(1,:);
        data.L(1,:) = tmp;
        if ~isempty(o)
            UpdatePages();
        end
    end
% 复合操作
    function RotateU_1(~,~)
        RotateU1([],0);
        RotateU1([],0);
        RotateU1(0,0);
    end
    function RotateU2(~,~)
        RotateU1([],0);
        RotateU1(0,0);
    end
    function RotateR1(~,~)
        Rotate_90([],0);
        RotateU1([],0);
        Rotate90(0,0);
    end
    function RotateR_1(~,~)
        Rotate_90([],0);
        RotateU_1([],0);
        Rotate90(0,0);
    end
    function RotateR2(~,~)
        Rotate_90([],0);
        RotateU2([],0);
        Rotate90(0,0);
    end
    function RotateF1(~,~)
        RotateUp([],0);
        RotateU1([],0);
        RotateDown(0,0);
    end
    function RotateF_1(~,~)
        RotateUp([],0);
        RotateU_1([],0);
        RotateDown(0,0);
    end
    function RotateF2(~,~)
        RotateUp([],0);
        RotateU2([],0);
        RotateDown(0,0);
    end
    function RotateD1(~,~)
        Rotate_90([],0);
        Rotate_90([],0);
        RotateU1([],0);
        Rotate90([],0);
        Rotate90(0,0);
    end
    function RotateD_1(~,~)
        Rotate_90([],0);
        Rotate_90([],0);
        RotateU_1([],0);
        Rotate90([],0);
        Rotate90(0,0);
    end
    function RotateD2(~,~)
        Rotate_90([],0);
        Rotate_90([],0);
        RotateU2([],0);
        Rotate90([],0);
        Rotate90(0,0);
    end
    function RotateL1(~,~)
        Rotate90([],0);
        RotateU1([],0);
        Rotate_90(0,0);
    end
    function RotateL_1(~,~)
        Rotate90([],0);
        RotateU_1([],0);
        Rotate_90(0,0);
    end
    function RotateL2(~,~)
        Rotate90([],0);
        RotateU2([],0);
        Rotate_90(0,0);
    end
    function RotateB1(~,~)
        RotateDown([],0);
        RotateU1([],0);
        RotateUp(0,0);
    end
    function RotateB_1(~,~)
        RotateDown([],0);
        RotateU_1([],0);
        RotateUp(0,0);
    end
    function RotateB2(~,~)
        RotateDown([],0);
        RotateU2([],0);
        RotateUp(0,0);
    end

    function Rotate_r(~,~)
        RotateUp([],0);
        RotateL1(0,0);
    end
    function Rotate_r_1(~,~)
        RotateDown([],0);
        RotateL_1(0,0);
    end
    function Rotate_f(~,~)
        Rotate90([],0);
        RotateD1(0,0);
    end
    function Rotate_f_1(~,~)
        Rotate_90([],0);
        RotateD_1(0,0);
    end
    function Rotate_l(~,~)
        RotateDown([],0);
        RotateR1(0,0);
    end
    function Rotate_l_1(~,~)
        RotateUp([],0);
        RotateR_1(0,0);
    end
    function Rotate_b(~,~)
        Rotate_90([],0);
        RotateF1(0,0);
    end
    function Rotate_b_1(~,~)
        Rotate90([],0);
        RotateF_1(0,0);
    end
    function Rotate_u(~,~)
        RotateLeft([],0);
        RotateD1(0,0);
    end
    function Rotate_u_1(~,~)
        RotateRight([],0);
        RotateD_1(0,0);
    end
    function Rotate_d(~,~)
        RotateRight([],0);
        RotateU1(0,0);
    end
    function Rotate_d_1(~,~)
        RotateLeft([],0);
        RotateU_1(0,0);
    end
    function Rotate_M(~,~)
        RotateDown([],0);
        RotateL_1([],0);
        RotateR1(0,0);
    end
    function Rotate_M_1(~,~)
        RotateUp([],0);
        RotateL1([],0);
        RotateR_1(0,0);
    end
end
