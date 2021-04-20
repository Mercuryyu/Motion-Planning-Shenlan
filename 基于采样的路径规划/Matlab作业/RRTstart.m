%***************************************
%Author: Chaoqun Wang
%Date: 2019-10-15
%***************************************
%% ��ʼ��
clc
clear all; close all;
x_I=1; y_I=1;           % ���ó�ʼ��
x_G=700; y_G=700;       % ����Ŀ���
% x_G=327; y_G=285;       % ����Ŀ���
% x_G=760; y_G=500;  % narrow passage

Thr=50;                 % ����Ŀ�����ֵ(��Ŀ��㸽����Զ����Ϊ�յ�)
Delta= 30;              % ������չ����
%%������ʼ��
T.v(1).x = x_I;         % T������v�ǽڵ㣬�Ȱ���ʼ���������
T.v(1).y = y_I; 
T.v(1).xPrev = x_I;     %��ʼ�ڵ�ĸ��ڵ���Ȼ���䱾��
T.v(1).yPrev = y_I;
T.v(1).dist=0;          % ���ڵ㵽�ýڵ�ľ��룬��ȡŷ�Ͼ���
T.v(1).indPrev = 0;     %���ڵ��index
%% 
figure(1);
ImpRgb=imread('newmap.png');
Imp=rgb2gray(ImpRgb);
imshow(Imp) %800*800
xL=size(Imp,2);%��ͼx�᳤��
yL=size(Imp,1);%��ͼy�᳤��
hold on
plot(x_I, y_I, 'ro', 'MarkerSize',10, 'MarkerFaceColor','r');
plot(x_G, y_G, 'go', 'MarkerSize',10, 'MarkerFaceColor','g');% ��������Ŀ���
bFind = false;

min_path_cost = 10000;
this_path = plot([0,1],[1,1]); % ����һ���߶ξ����������������·���Ĵ����ɾ��
pic_num = 1;
tic; % tic, toc��ʱ

for iter = 1:800
    
    %Step 1:�ڵ�ͼ���������һ����x_rand
    %��ʾ�ã�x_rand(1), x_rand(2)����ʾ�����в����������
%     if bFind
%         x_rand = randi(800, 1, 2);  % �ҵ�·���� ȫ������������Ż�·��
%     else
%         x_rand = Sample(iter, xL, yL, x_G, y_G);  % ��ȫ�ֺ��ص��������������·��
%     end

    x_rand = randi(800, 1, 2);  % �ҵ�·���� ȫ������������Ż�·��

%     % ����ɫʵ�ĵ��ʾ������
    plot(x_rand(1), x_rand(2), 'ro', 'MarkerSize',4, 'MarkerFaceColor','b');


    %Step 2: ���������������ҵ�����ڽ���x_near
    %��ʾ��x_near�Ѿ�����T��
    [x_near, near_Idx] =Near(x_rand, T);

    %Step 3: ��չ�õ�x_new�ڵ�, ����������
    %ע��ʹ����չ����Delta
    x_new=Steer(x_rand, x_near, Delta);
    plot(x_new(1), x_new(2), 'ro', 'MarkerSize',2);
    
    %���ڵ��Ƿ���collision free
    if ~collisionChecking(x_near,x_new,Imp) 
        continue;
    end
    % �ҵ�x_new���ٽ��ڵ�
    X_nears = NearC(T, x_new, near_Idx);
    % �ҵ�ʹ��x_new�����cost��С�ĸ��ڵ�x_min
    [x_min, min_Idx] = ChooseParent(X_nears, x_new, T);
%  ��x_min��Ϊx_new�ĸ��ڵ��������
    T =  AddNode(T, x_new, x_min, min_Idx);
%   �����ٽ��ڵ�ĸ��ڵ�
    T = rewire(T, X_nears, x_new, Imp);
    
    
    X = [x_new(1), x_min(1)];
    Y = [x_new(2), x_min(2)];
%     x_steer = [x_new(1), x_rand(1)];
%     y_steer = [x_new(2), x_rand(2)];
    plot(X, Y, '-b');
    hold on; 
    
    %Step 5:����Ƿ�ﵽĿ��㸽��
    %��ʾ��x_new�� x_G֮��ľ����Ƿ�С��Thr��С��������for
    if bFind == false    % �ж��Ƿ��Ѿ��ҵ�·��
        dis_goal = sqrt(power(x_new(1)-x_G,2) + power(x_new(2) - y_G, 2) );
        if dis_goal<Thr
            bFind = true;
            end_Idx = T.v(end).indPrev;  %��¼��ʱ������ֵ
%         break;  % ���������Ż�����·��
        end
    else  % �ҵ�·���򲻶ϸ���·�����
        path.pos(1).x = x_G;
        path.pos(1).y = y_G;
        path.pos(2).x = T.v(end_Idx).x; path.pos(2).y = T.v(end_Idx).y;
        

        path_cost = sqrt(power(path.pos(1).x-path.pos(2).x ,2) + power(path.pos(1).y  - path.pos(2).y, 2)) + T.v(end_Idx).dist;
        pathIndex = T.v(end_Idx).indPrev; % �յ�����ֵ
        
        if path_cost<min_path_cost %�ҵ�����·��
            min_path_cost = path_cost;
            j=0;
            while 1 % ����·��
                path.pos(j+3).x = T.v(pathIndex).x;
                path.pos(j+3).y = T.v(pathIndex).y;
                pathIndex = T.v(pathIndex).indPrev;

                if pathIndex == 1
                    break
                end
                j=j+1;
            end  % ���յ���ݵ����
            path.pos(end+1).x = x_I; path.pos(end).y = y_I; % ������·��
            path_X = [];
            path_Y = [];
            for j = 1:length(path.pos)
                path_X(j) = path.pos(j).x;
                path_Y(j) = path.pos(j).y;
            end
            delete(this_path); %ɾ����·��
            this_path = plot(path_X, path_Y, 'b', 'Linewidth', 3); % ������·��
            fprintf('\n Path cost is %.2f\n Sampling nodes: %d\n Tree nodes: %d\n',path_cost, iter, size(T.v,2))
        end
    end
    
    %Step 6:��x_near��x_new֮���·��������
    %��ʾ1��ʹ��plot���ƣ���Ҫ��λ��ƣ�����hold on
    %��ʾ2���ж���ֹ��������ǰ���Ƚ�x_near��x_new֮���·��������


%     pause(0.01); %��ͣһ�ᣬʹ��rrt��չ���׹۲�
    
    % ����gif��ͼ
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);

    if pic_num == 1
    imwrite(I,map,'test.gif','gif','Loopcount',inf,'DelayTime',0);

    else
    imwrite(I,map,'test.gif','gif','WriteMode','append','DelayTime',0);

    end

    pic_num = pic_num + 1;
end
toc
%% ·���Ѿ��ҵ��������ѯ
