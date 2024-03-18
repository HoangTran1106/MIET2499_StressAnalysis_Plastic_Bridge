function y = y_before(P, E, I, x, a)  
    y = P*a*x.^2/2/E/I - P*x.^3/6/E/I;
end 