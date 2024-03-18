clear
% F = P/4
syms E I x t By F a
P = 85;
L = 0.9;
dist1 = 0.1;
dist2 = 0.07;
E_acry = 1.1*10.^9;
%%%%%%%%%%%%%%% Find By
% a is the distance from fix end to the nearest wheel
% Unit of a and numerical value of length is meter (m)
y_45_1 = y_after(F, E, I, x, a);
y_45_2 = y_after(F, E, I, x, a + dist1);
y_45_3 = y_after(F, E, I, x, a + dist1 + dist2);
y_45_4 = y_after(F, E, I, x, a + 2*dist1 + dist2);
y_45_5 = y_before(By, E, I, x, 90);
y5 = simplify(y_45_1 + y_45_2 + y_45_3 + y_45_4 + y_45_5);
y5 = subs(y5, [F, x], [P/4, L]);
result_for_By = solve(y5 == 0, By, 'ReturnConditions',true);
%%%%%%%%%%%%%%% Find maximum deflection
% The fixed end is location 0, consecutive load is 1 .... last load is 4
% and the simple support is 5
%%% Between the 2 nearest wheels of 2 cars

y_23_1 = y_after(F, E, I, x, a);
y_23_2 = y_after(F, E, I, x, a + dist1);
y_23_3 = y_before(F, E, I, x, a + dist1 + dist2);
y_23_4 = y_before(F, E, I, x, a + 2*dist1 + dist2);
y_23_5 = y_before(result_for_By.By, E, I, x, 90);
y_23_sum = y_23_1 + y_23_2 + y_23_3 + y_23_4 + y_23_5;
y_23_sum = simplify(y_23_sum);
y_23_sum = subs(y_23_sum, F, P/4);

y_23_sum = subs(y_23_sum, [E, I], [E_acry, 1]);
%
a_of_max_defl = 0;
x_of_max_defl = dist1;
max_deflection = subs(y_23_sum, [x, a], [x_of_max_defl, a_of_max_defl]);
for a_data = 0:(L - 2*dist1 - dist1)/99:(L - 2*dist1 - dist1)
    for x_data = a_data + dist1:dist2/99:a_data + dist1 + dist2
       result = subs(y_23_sum, [x, a], [x_data, a_data]);
       if result > max_deflection
           max_deflection = result;
           a_of_max_defl = a_data;
           x_of_max_defl = x_data;
       end
    end
end 
a_of_max_defl
a_of_max_defl/0.9
x_of_max_defl