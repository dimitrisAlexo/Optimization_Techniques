function [alpha, beta, x1, x2, y1, y2] = bisectrix(f, a, b, len, epsilon)
    alpha = [];
    beta = [];
    alpha(1) = a;
    beta(1) = b;
    k = 1;
    x1 = [];
    x2 = [];
    y1 = [];
    y2 = [];
    
    while (beta(k) - alpha(k)) > len
        x1(k) = (alpha(k) + beta(k))/2 - epsilon;
        x2(k) = (alpha(k) + beta(k))/2 + epsilon;
        y1(k) = f(x1(k));
        y2(k) = f(x2(k));
        if f(x1(k)) < f(x2(k))
            alpha(k+1) = alpha(k);
            beta(k+1) = x2(k);
        else
            alpha(k+1) = x1(k);
            beta(k+1) = beta(k);
        end
        k = k + 1;
        if k > 1e5
            break
        end
    end
    if k < 1e5-1
        fprintf("Minimum of f is in the interval [" + string(alpha(k)) +" " + string(beta(k)) + "]\n")
        fprintf("Execution took " + string(k) + " iterations\n")
    else
        fprintf("Minimum not found\n")
    end
end