clear

syms E I x t By F a
% P = (85 + 13.476)*1.5;
P = 85;
L = 0.9;
dist1 = 0.1;
dist2 = 0.07;
E_acry = 1.1*10.^9;
I_section = 274097.2/(10.^12);

%%%%%%%%%%%%%%% Find By
% a is the distance from fix end to the nearest wheel
% Unit of a and numerical value of length is meter (m)
y_45_1 = y_after(F, E, I, x, a);
y_45_2 = y_after(F, E, I, x, a + dist1);
y_45_3 = y_after(F, E, I, x, a + dist1 + dist2);
y_45_4 = y_after(F, E, I, x, a + 2*dist1 + dist2);
y_45_5 = y_before(By, E, I, x, L);
y5 = simplify(y_45_1 + y_45_2 + y_45_3 + y_45_4 - y_45_5);
y5 = subs(y5, [F, x], [P/4, L]);

result_for_By = solve(y5 == 0, By, 'ReturnConditions',true);
result_for_By.By;

%%%%%% 
y01 = 0;
y12 = 0;
y23 = 0;
y34 = 0;
y45 = 0;
matrix = [0 0 0 0; 1 0 0 0; 1 1 0 0; 1 1 1 0; 1 1 1 1];
for row = 1:1:5
    % Segment 01
    if row == 1
        for col = 1:1:4
            if col == 1
                temp = a;
            elseif col == 2
                temp = a + dist1;
            elseif col == 3
                temp = a + dist1 + dist2;
            else
                temp = a + 2*dist1 + dist2;
            end
    
            if matrix(row, col) == 0
                y01 = y01 + y_before(F, E, I, x, temp);
            else 
                y01 = y01 + y_after(F, E, I, x, temp);
            end
        end
        y01 = y01 - y_before(result_for_By.By, E, I, x, L);
    % Segment 12
    elseif row == 2
        for col = 1:1:4
            if col == 1
                temp = a;
            elseif col == 2
                temp = a + dist1;
            elseif col == 3
                temp = a + dist1 + dist2;
            else
                temp = a + 2*dist1 + dist2;
            end
    
            if matrix(row, col) == 0
                y12 = y12 + y_before(F, E, I, x, temp);
            else 
                y12 = y12 + y_after(F, E, I, x, temp);
            end
        end
        y12 = y12 - y_before(result_for_By.By, E, I, x, L);

    % Segment 23
    elseif row == 3
        for col = 1:1:4
            if col == 1
                temp = a;
            elseif col == 2
                temp = a + dist1;
            elseif col == 3
                temp = a + dist1 + dist2;
            else
                temp = a + 2*dist1 + dist2;
            end
    
            if matrix(row, col) == 0
                y23 = y23 + y_before(F, E, I, x, temp);
            else 
                y23 = y23 + y_after(F, E, I, x, temp);
            end
        end
        y23 = y23 - y_before(result_for_By.By, E, I, x, L);

    % Segment 34
    elseif row == 4
        for col = 1:1:4
            if col == 1
                temp = a;
            elseif col == 2
                temp = a + dist1;
            elseif col == 3
                temp = a + dist1 + dist2;
            else
                temp = a + 2*dist1 + dist2;
            end
    
            if matrix(row, col) == 0
               y34 = y34 + y_before(F, E, I, x, temp);
            else 
                y34 = y34 + y_after(F, E, I, x, temp);
            end
        end
        y34 = y34 - y_before(result_for_By.By, E, I, x, L);

    % Segment 45
    elseif row == 5
        for col = 1:1:4
            if col == 1
                temp = a;
            elseif col == 2
                temp = a + dist1;
            elseif col == 3
                temp = a + dist1 + dist2;
            else
                temp = a + 2*dist1 + dist2;
            end
    
            if matrix(row, col) == 0
                y45 = y45 + y_before(F, E, I, x, temp);
            else 
                y45 = y45 + y_after(F, E, I, x, temp);
            end
        end
        y45 = y45 - y_before(result_for_By.By, E, I, x, L);
    end 
end 

%%%%%%%%%%%%%%%%%%%%%
y01 = subs(y01, [F, E, I], [P/4, E_acry, I_section]);
y12 = subs(y12, [F, E, I], [P/4, E_acry, I_section]);
y23 = subs(y23, [F, E, I], [P/4, E_acry, I_section]);
y34 = subs(y34, [F, E, I], [P/4, E_acry, I_section]);
y45 = subs(y45, [F, E, I], [P/4, E_acry, I_section]);

%%%%%%%%%%%%%% TEST %%%%%%%%%%
% a_test = 0.3;
% y = zeros(100);
% ind = 1;
% for x_test = a_test + 2*dist1 + dist2:(L - (a_test + 2*dist1 + dist2))/99:L
%     y(ind) = subs(y45, [x, a], [x_test, a_test]);
%     ind = ind + 1;
% end 
% plot(y)
%%%%%%%%%%%%%% TEST %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%
a_max_defl = 0;
x_max_defl = 0;
max_deflection = subs(y01, [x, a], [x_max_defl, a_max_defl]);
y = zeros(100);
ind = 1;
a_data = 0.2604;
for x_data = 0:L/99:L
    if 0 <= x_data && x_data < a_data
       result = subs(y01, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_max_defl = a_data;
           x_max_defl = x_data;
       end
    elseif a_data<= x_data && x_data < a_data + dist1
       result = subs(y12, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_max_defl = a_data;
           x_max_defl = x_data;
       end
    elseif a_data + dist1 <= x_data && x_data < a_data + dist1 + dist2
       result = subs(y23, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_max_defl = a_data;
           x_max_defl = x_data;
       end
    elseif a_data + dist1 + dist2 <= x_data && x_data < a_data + 2*dist1 + dist2
       result = subs(y34, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_max_defl = a_data;
           x_max_defl = x_data;
       end
    else 
       result = subs(y45, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_max_defl = a_data;
           x_max_defl = x_data;
       end
    end
    if a_data == 0.2604
        if 0 <= x_data && x_data < a_data
            result1 = subs(y01, [x, a], [x_data, a_data]);
        elseif a_data <= x_data && x_data < a_data + dist1
            result1 = subs(y12, [x, a], [x_data, a_data]);
        elseif a_data + dist1 <= x_data && x_data < a_data + dist1 + dist2
            result1 = subs(y23, [x, a], [x_data, a_data]);
        elseif a_data + dist1 + dist2 <= x_data && x_data < a_data + 2*dist1 + dist2
            result1 = subs(y34, [x, a], [x_data, a_data]);
        else
            result1 = subs(y45, [x, a], [x_data, a_data]);
        end
        y(ind) = result1;
        ind = ind + 1;
    end
end

x_max_defl
%%
a1 = a_data; a2 = a1 + dist1; a3 = a2 + dist2; a4 = a3 + dist1;
x_direct = linspace(0, 0.9, 101);
a_pos = zeros(1, 4);
done_seg_1 = 0; done_seg_2 = 0; done_seg_3 = 0; done_seg_4 = 0; 
for pos = 1:101
    if x_direct(pos) + L/100 > a4
        if done_seg_4 == 1
            continue
        end
        a_pos(4) = pos;
        done_seg_4 = 1;
    elseif x_direct(pos) + L/100 > a3
        if done_seg_3 == 1
            continue
        end
        a_pos(3) = pos;
        done_seg_3 = 1;
    elseif x_direct(pos) + L/100 > a2
        if done_seg_2 == 1
            continue
        end
        a_pos(2) = pos;
        done_seg_2 = 1;
    elseif x_direct(pos) + L/100 > a1
        if done_seg_1 == 1
            continue
        end
        a_pos(1) = pos;
        done_seg_1 = 1;
    end
end 
segment = {1:a_pos(1), a_pos(1):a_pos(2), a_pos(2):a_pos(3), a_pos(3):a_pos(4), a_pos(4):101};
if y(44) > 0
    y = -y;
end
hold on
plot(x_direct(1:a_pos(1)), y(1:a_pos(1)))
plot(x_direct(a_pos(1):a_pos(2)), y(a_pos(1):a_pos(2)))
plot(x_direct(a_pos(2):a_pos(3)), y(a_pos(2):a_pos(3)))
plot(x_direct(a_pos(3):a_pos(4)), y(a_pos(3):a_pos(4)))
plot(x_direct(a_pos(4):101), y(a_pos(4):101))
plot(x_direct(55), y(55), 'r*')
xlabel('Place on Beam')
ylabel('Deflection')
hold off
y(55)