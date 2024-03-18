clear

syms E I x t By F a
% P = (85 + 13.476)*1.5;
P = 85;
F = P/4;
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

examining_a = 0;
By_Max_Curvature = subs(result_for_By.By, a, examining_a);


a1 = examining_a; 
a2 = a1 + dist1; 
a3 = a2 + dist2; 
a4 = a3 + dist1;
Ma = F*(a1 + a2 + a3 + a4) - By_Max_Curvature*L;
Curvature = Ma/E_acry/I_section;
Radius_of_Curvature = 1/Curvature
8342731484538630029296875/217242693270058961993728