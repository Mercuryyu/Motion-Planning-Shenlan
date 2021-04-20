function [x_min, min_idx] = ChooseParent(X_nears, x_new, T)
% ���ڽ�����X_nears�У��ҵ�ʹ��x_newͨ����������̵ĸ��ڵ�
nearest = [];
min_cost = 10000; %����x_new->nearest node->�����Ҫ��cost
count = size(X_nears, 2);

for i = 1:count
    nearest(1) = T.v(X_nears(i)).x;
    nearest(2) = T.v(X_nears(i)).y;
    cost = distance(nearest, x_new) + T.v(X_nears(i)).dist; 
    if cost<min_cost
        min_cost = cost;
        x_min = nearest;
        min_idx = X_nears(i);
    end
end
end
    