function [alpha, beta, x1, x2, y1, y2] = fibonacci_alg(f, a, b, len)
    alpha = [];
    beta = [];
    alpha(1) = a;
    beta(1) = b;
    k = 1;
    epsilon = 1e-3;
    
    n = 1;
    while fibonacci(n) < (b - a)/len
        n = n + 1;
    end
    
    x1 = [];
    x2 = [];
    x1(1) = a + (fibonacci(n-2)/fibonacci(n))*(b - a);
    x2(1) = a + (fibonacci(n-1)/fibonacci(n))*(b - a);
    y1 = [];
    y2 = [];
    y1(1) = f(x1(1));
    y2(1) = f(x2(1));
    
    while k <= n-2
        if f(x1(k)) > f(x2(k))
            alpha(k+1) = x1(k);
            beta(k+1) = beta(k);
            x1(k+1) = x2(k);
            x2(k+1) = alpha(k+1) + (fibonacci(n-k-1)/fibonacci(n-k))*(beta(k+1) - alpha(k+1));
            y1(k+1) = f(x1(k+1));
            y2(k+1) = f(x2(k+1));
            k = k + 1;
        else
            alpha(k+1) = alpha(k);
            beta(k+1) = x2(k);
            x2(k+1) = x1(k);
            x1(k+1) = alpha(k+1) + (fibonacci(n-k-2)/fibonacci(n-k))*(beta(k+1) - alpha(k+1));
            y1(k+1) = f(x1(k+1));
            y2(k+1) = f(x2(k+1));
            k = k + 1;
        end
    end
    x1(n) = x1(n-1);
    x2(n) = x1(n-1) + epsilon;
    y1(n) = f(x1(n));
    y2(n) = f(x2(n));
    if f(x1(n)) > f(x2(n))
        alpha(n) = x1(n);
        beta(n) = beta(n-1);
    else
        alpha(n) = alpha(n-1);
        beta(n) = x2(n);
    end
    
    fprintf("Minimum of f is in the interval [" + string(alpha(n)) +" " + string(beta(n)) + "]\n")
    fprintf("Execution took " + string(n-2) + " iterations\n")
        
end
