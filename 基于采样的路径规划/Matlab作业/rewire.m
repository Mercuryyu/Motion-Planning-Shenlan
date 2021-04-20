function T = rewire(T, X_nears, x_new, Imp)
% ���ڳ�������ڵ�x_near����ڽ��ڵ���˵ ��ͨ��x_newʹ�䵽���ľ�����̣�����x_new��Ϊ���ĸ��ڵ㣬
count = size(X_nears, 2);
new_idx = size(T.v, 2);

for i = 2:count
    pre_cost = T.v(X_nears(i)).dist; 
    near_node(1) = T.v(X_nears(i)).x;
    near_node(2) = T.v(X_nears(i)).y;
    tentative_cost = distance(near_node, x_new) + T.v(new_idx).dist; % ͨ��x_new������cost
    if ~collisionChecking(near_node, x_new,Imp)  % rewire������ҲҪ��ײ���
        continue;
    end
    if tentative_cost<pre_cost  % ��ͨ�����ʹcost���ͣ��ı��丸�ڵ�Ϊx_new
        T.v(X_nears(i)).xPrev = x_new(1);
        T.v(X_nears(i)).yPrev = x_new(2);
        T.v(X_nears(i)).dist = tentative_cost;
        T.v(X_nears(i)).indPrev = new_idx;
    end
end

end