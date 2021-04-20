%***************************************
%Author: Chaoqun Wang
%Date: 2019-10-15
%***************************************
%% ��ʼ��
clc
clear all; close all;
x_I=1; y_I=1;           % ���ó�ʼ��
% x_G=700; y_G=700;       % ����Ŀ���
x_G=760; y_G=500;  % narrow passage

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

pic_num =1;
tic; % tic, toc��ʱ

for iter = 1:5000
    
    %Step 1:�ڵ�ͼ���������һ����x_rand
    %��ʾ�ã�x_rand(1), x_rand(2)����ʾ�����в����������
    x_rand = randi(800, 1, 2);  % ȫ���������

    % ����ɫʵ�ĵ��ʾ������
    plot(x_rand(1), x_rand(2), 'ro', 'MarkerSize',8, 'MarkerFaceColor','b');

    %Step 2: ���������������ҵ�����ڽ���x_near
    %��ʾ��x_near�Ѿ�����T��
    [x_near, near_Idx] =Near(x_rand, T);

    %Step 3: ��չ�õ�x_new�ڵ�, ����������ԭ��
    x_new=Steer(x_rand, x_near, Delta);
 
    %Step 4�����ڵ��Ƿ���collision free
    if ~collisionChecking(x_near,x_new,Imp) 
        continue;
    end
    
    %Step 5: ��x_new����T���½ڵ�x_new�ĸ��ڵ�Ϊx_near
    T =  AddNode(T, x_new, x_near, near_Idx);

    %Step 6:����Ƿ�ﵽĿ��㸽��
    %��ʾ��x_new�� x_G֮��ľ����Ƿ�С��Thr��С��������for
    dis_goal = sqrt(power(x_new(1)-x_G,2) + power(x_new(2) - y_G, 2) );
    
    %Step 7:��x_near��x_new֮���·��������
    X = [x_new(1), x_near(1)];
    Y = [x_new(2), x_near(2)];
    x_steer = [x_new(1), x_rand(1)];
    y_steer = [x_new(2), x_rand(2)];
    plot(X, Y, '-ob', x_steer, y_steer, ':r');
    hold on; 
  % Step8: �ж��Ƿ񵽴��յ�
    if dis_goal<Thr
        bFind = true;
        break;  
    end

    pause(0.01); %��ͣһ�ᣬʹ��rrt��չ���׹۲�
    
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
if bFind
    path.pos(1).x = x_G; 
    path.pos(1).y = y_G;
    path.pos(2).x = T.v(end).x; path.pos(2).y = T.v(end).y;
    path_cost = sqrt(power(path.pos(1).x-path.pos(2).x ,2) + power(path.pos(1).y  - path.pos(2).y, 2)) + T.v(end).dist;
    
    pathIndex = T.v(end).indPrev; % �յ�����ֵ
    j=0;
    while 1
        path.pos(j+3).x = T.v(pathIndex).x;
        path.pos(j+3).y = T.v(pathIndex).y;
        pathIndex = T.v(pathIndex).indPrev;
        
        if pathIndex == 1
            break
        end
        j=j+1;
    end  % ͨ�����ڵ����������յ���ݵ����
    path.pos(end+1).x = x_I; path.pos(end).y = y_I; % ������·��
    for j = 2:length(path.pos)
        plot([path.pos(j).x; path.pos(j-1).x;], [path.pos(j).y; path.pos(j-1).y], 'b', 'Linewidth', 3);
        pause(0.01); %��ͣһ�ᣬʹ��rrt��չ���׹۲�
    
        % ����gif��ͼ
        F=getframe(gcf);
        I=frame2im(F);
        [I,map]=rgb2ind(I,256);
        imwrite(I,map,'test.gif','gif','WriteMode','append','DelayTime',0);
    end

    fprintf('Path cost is %.2f\n Sampling nodes: %d\n Tree nodes: %d',path_cost, iter, size(T.v,2))
else
    disp('Error, no path found!');
end
