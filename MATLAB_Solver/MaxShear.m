clear

syms E I x t By F a
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

Ay = P - result_for_By.By;
V01 = Ay;
V12 = Ay - P/4;
V23 = V12 - P/4;
V34 = V23 - P/4;
V45 = V34 - P/4;
%%% Shear force
cs = 3;
a_case = [0 0.2604 0.3879];
a1_case = a_case;
a2_case = a1_case + dist1;
a3_case = a2_case + dist2;
a4_case = a3_case + dist1;
x_direct = linspace(0,0.9,201);
y = zeros(1, 201);
for ind = 1:201
    if x_direct(ind) > a4_case(cs)
        y(ind) = subs(V45, a, a_case(cs));
    elseif x_direct(ind) <= a4_case(cs) && x_direct(ind) > a3_case(cs)
        y(ind) = subs(V34, a, a_case(cs));
    elseif x_direct(ind) <= a3_case(cs) && x_direct(ind) > a2_case(cs)
        y(ind) = subs(V23, a, a_case(cs));
    elseif x_direct(ind) <= a2_case(cs) && x_direct(ind) > a1_case(cs)
        y(ind) = subs(V12, a, a_case(cs));
    else
        y(ind) = subs(V01, a, a_case(cs));
    end
end
figure(1)
plot(x_direct, y);
ylabel('Shear force (N)');
% xlabel('Place on beam for Max Shear Case');
% xlabel('Place on beam for Max Bending Moment Case');
xlabel('Place on beam for Max Deflection Moment Case');
%%%

%%%
cs = 3;
a_case = [0 0.2604 0.3879];
a1_case = a_case;
a2_case = a1_case + dist1;
a3_case = a2_case + dist2;
a4_case = a3_case + dist1;
x_direct = linspace(0,0.9,201);
step = 0.9/200;
y = zeros(1, 201);
Moment_at_A = P/4*(a1_case(cs) + a2_case(cs)+a3_case(cs)+a4_case(cs)) - subs(result_for_By.By*L, a, a_case(cs));
current_Moment = -Moment_at_A;
for ind = 1:201
    y(ind) = current_Moment;
    if x_direct(ind) > a4_case(cs)
        current_Moment = subs(V45, a, a_case(cs))*step + current_Moment;
    elseif x_direct(ind) <= a4_case(cs) && x_direct(ind) > a3_case(cs)
        current_Moment = subs(V34, a, a_case(cs))*step + current_Moment;
    elseif x_direct(ind) <= a3_case(cs) && x_direct(ind) > a2_case(cs)
        current_Moment = subs(V23, a, a_case(cs))*step + current_Moment;
    elseif x_direct(ind) <= a2_case(cs) && x_direct(ind) > a1_case(cs)
        current_Moment = subs(V12, a, a_case(cs))*step + current_Moment;
    else
        current_Moment = subs(V01, a, a_case(cs))*step + current_Moment;
    end
end
figure(2)
plot(x_direct, y);
ylabel('Bending Moment (Nm)');
% xlabel('Place on beam for Max Shear Case');
% xlabel('Place on beam for Max Bending Moment Case');
xlabel('Place on beam for Max Deflection Moment Case');

%%
V = zeros(100);
ind = 1;
for pos = 0:(L - 2*dist1 - dist2)/99:(L - 2*dist1 - dist2)
    V(ind) = subs(V01, a, pos);
    ind = ind + 1;
end
plot(V)
hold on
%%%% 
V = zeros(100);
ind = 1;
for pos = 0:(L - 2*dist1 - dist2)/99:(L - 2*dist1 - dist2)
    V(ind) = subs(V12, a, pos);
    ind = ind + 1;
end
plot(V)

%%%%
V = zeros(100);
ind = 1;
for pos = 0:(L - 2*dist1 - dist2)/99:(L - 2*dist1 - dist2)
    V(ind) = subs(V23, a, pos);
    ind = ind + 1;
end
plot(V)

%%%%
V = zeros(100);
ind = 1;
for pos = 0:(L - 2*dist1 - dist2)/99:(L - 2*dist1 - dist2)
    V(ind) = subs(V34, a, pos);
    ind = ind + 1;
end
plot(V)

%%%%
V = zeros(100);
ind = 1;
for pos = 0:(L - 2*dist1 - dist2)/99:(L - 2*dist1 - dist2)
    V(ind) = subs(V45, a, pos);
    ind = ind + 1;
end
plot(V)
hold off

%%%%
deri_V = diff(V01, a);
a_for_V_max = solve(deri_V == 0, a, 'ReturnConditions',true);

%%%%
MaxShearForce = double(subs(V01, a, 0))
