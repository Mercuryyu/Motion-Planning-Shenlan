function x_rand = Sample(iter, xL, yL, x_G, y_G)
    this_batch = fix(iter/10);  % ÿ��batch����10��,ȡ��
    if this_batch<=7
        low_bound = this_batch*100; % ��������
        upper_bound = low_bound+100;
    else
        goal_xbatch = fix(x_G/100); % ȷ�������߽�
        goal_ybatch = fix(y_G/100);
        low_xbound = goal_xbatch*100;
        upper_xbound = low_xbound+100;
        low_ybound = goal_ybatch*100;
        upper_ybound = low_ybound+100;
    end

    if mod(iter,2)  % �����������ڸ���5����
        if this_batch<=7
            x_rand(1) = randi([low_bound, upper_bound], 1, 1);
            x_rand(2) = randi([0, upper_bound], 1, 1);
        else
            x_rand(1) = randi([low_xbound, upper_xbound], 1, 1);
            x_rand(2) = randi(yL, 1, 1);
        end
    
    else
        if this_batch<=7
            x_rand(1) = randi([0, upper_bound], 1, 1);
            x_rand(2) = randi([low_bound, upper_bound], 1, 1);
        else
            x_rand(1) = randi([0, xL], 1, 1);
            x_rand(2) = randi([low_ybound, upper_ybound], 1, 1);
        end

    end
end