function y = y_after(P, E, I, x, a)  
    y = P*a.^2*x/2/E/I - P*a.^3/6/E/I;
end 