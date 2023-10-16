function [alpha, beta, x, y] = bisectrix_derivative(f, a, b, len)

    df = matlabFunction(diff(f));

    alpha = [];
    beta = [];
    alpha(1) = a;
    beta(1) = b;
    der = [];
    k = 1;

    n = 1;
    while 0.5^n > len/(b-a)
        n = n + 1;
    end
    
    x = [];
    y = [];
    
    while k <= n
        x(k) = (alpha(k) + beta(k))/2;
        y(k) = f(x(k));
        der(k) = df(x(k));
        if der(k) == 0
            fprintf(string(x(k)) + " is where the min of the function occurs\n");
            return;
        elseif der(k) > 0
            alpha(k+1) = alpha(k);
            beta(k+1) = x(k);
            k = k + 1;
        else
            alpha(k+1) = x(k);
            beta(k+1) = beta(k);
            k = k + 1;
        end
    end
    fprintf("Minimum of f is in the interval [" + string(alpha(n+1)) +" " + string(beta(n+1)) + "]\n")
    fprintf("Execution took " + string(k) + " iterations\n")
end
