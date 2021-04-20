function T = AddNode(T, x_new, x_near, near_Idx)
% ��collision_free��x_new�ڵ������T�У�����x_nearΪ���ڵ�
    count = size(T.v,2) + 1;
    T.v(count).x = x_new(1);
    T.v(count).y = x_new(2);
    T.v(count).xPrev = T.v(near_Idx).x;
    T.v(count).yPrev = T.v(near_Idx).y;
    T.v(count).dist=distance(x_new, x_near) + T.v(near_Idx).dist;  % �ýڵ㵽ԭ��ľ���
    T.v(count).indPrev = near_Idx;     %���ڵ��index
end
