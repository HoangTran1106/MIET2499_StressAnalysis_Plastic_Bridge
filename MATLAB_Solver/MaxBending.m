clear 
%%%%%%%%%%%%% Bending with 1 point load
%%%%%%% Initation
syms E I x t By F a
P = 85;
L = 0.9;
dist1 = 0.07;
dist2 = 0.1;
E_acry = 1.1*10.^9;
I_section = 274097.2/(10.^12);

%%%%%%% MAIN
%%% 
%
y12 = y_after(P, E, I, x, a) - y_before(By, E, I, x, L);
y12_at_B = subs(y12, [E, I, x], [E_acry, I_section, L]);
result_for_By = solve(y12_at_B == 0, By, 'ReturnConditions',true);

% 
Moment_at_A = P*a - result_for_By.By*L;

y = zeros(100);
ind = 1;
for pos = 0:L/99:L
    y(ind) = subs(Moment_at_A, a, pos);
    ind = ind + 1;
end
plot(y)

derivative_of_Moment_at_A = diff(Moment_at_A, a);
a_for_Max_moment_at_A = solve(derivative_of_Moment_at_A == 0, a);
dist_fix_end_to_the_nearest_wheel = a_for_Max_moment_at_A - dist2/2-dist1;
subs(Moment_at_A, a, a_for_Max_moment_at_A)
%%% 14.7224
Curvature = 14.7224 /I_section/E_acry
Radius_of_Curvature = 1/Curvature