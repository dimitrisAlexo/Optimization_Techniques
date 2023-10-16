function [minimum] = golden_section(f, a, b, len)
    alpha = [];
    beta = [];
    alpha(1) = a;
    beta(1) = b;
    k = 1;
    gamma = 0.618;
    x1 = [];
    x2 = [];
    x1(1) = a + (1-gamma)*(b-a);
    x2(1) = a + gamma*(b-a);
    y1 = [];
    y2 = [];
    y1(1) = f(x1(1));
    y2(1) = f(x2(1));
    
    while (beta(k) - alpha(k)) > len
        if f(x1(k)) > f(x2(k)) 
            alpha(k+1) = x1(k);
            beta(k+1) = beta(k);
            x2(k+1) = alpha(k+1) + gamma*(beta(k+1) - alpha(k+1));
            x1(k+1) = x2(k);
            y1(k+1) = f(x1(k));
            y2(k+1) = f(x2(k+1));
        else
            alpha(k+1) = alpha(k);
            beta(k+1) = x2(k);
            x2(k+1) = x1(k);
            x1(k+1) = alpha(k+1) + (1-gamma)*(beta(k+1) - alpha(k+1));
            y1(k+1) = f(x1(k+1));
            y2(k+1) = f(x2(k+1));
        end
        k = k + 1;
        if k > 1e5
            break
        end
    end
    
    minimum = (alpha(k)+beta(k))/2;
end