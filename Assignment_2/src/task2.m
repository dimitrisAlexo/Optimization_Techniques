% Steepest Descent Method

clearvars
clc

tic

syms x y func(x,y)
func(x,y) = x^5 * exp(-x^2 - y^2);

starting_points = [[0 0];[-1 1];[1 -1]];
point = 3;
epsilon = 0.001;

%A - Using a constant gamma_k
gamma_k = 0.5;
grad_f = gradient(func, [x y]);
xk = [];
yk = [];
xk(1) = starting_points(point,1);
yk(1) = starting_points(point,2);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    xk(k+1) = xk(k) - gamma_k*gradient_vector(1);
    yk(k+1) = yk(k) - gamma_k*gradient_vector(2);
    k = k + 1;
    
    if k > 10000
        fprintf("INFINITE LOOP\n");
        toc
        return
    end
end

fprintf('A: Minimum at (%f, %f) with value of %f\n', xk(k), yk(k), func(xk(k),yk(k)))
fprintf('k = %d\n', k)
figure()
fcontour(func, 'Fill', 'On');
title('Contour for starting point = [' + string(starting_points(point,1)) + ' ' + string(starting_points(point,2)) + ']')
hold on;
plot(xk(1),yk(1),'*-r');
plot(xk(k),yk(k),'*-g');
legend('graph', 'starting point', 'ending point')
xlabel('{x_k}')
ylabel('{y_k}')
hold off;
figure()
plot(1:k, func(xk,yk),'-o')
title('Convergence of f')
xlabel('k')
ylabel('{f(x_k, y_k)}')

toc

%B - Finding the minimum of gamma_k

clear xk yk k

xk = [];
yk = [];
xk(1) = starting_points(point,1);
yk(1) = starting_points(point,2);

grad_f = gradient(func, [x y]);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    
    g = @(gamma) func(xk(k)-gamma*gradient_vector(1), yk(k)-gamma*gradient_vector(2));
    gamma_k = golden_section(g, 0, 10, 1e-3);
    
    xk(k+1) = xk(k) - gamma_k*gradient_vector(1);
    yk(k+1) = yk(k) - gamma_k*gradient_vector(2);
    k = k + 1;
    
    if k > 10000
        fprintf("INFINITE LOOP\n");
        toc
        return
    end
end

fprintf('B: Minimum at (%f, %f) with value of %f\n', xk(k), yk(k), func(xk(k),yk(k)))
fprintf('k = %d\n', k)
figure()
fcontour(func, 'Fill', 'On');
hold on;
title('Contour for starting point = [' + string(starting_points(point,1)) + ' ' + string(starting_points(point,2)) + ']')
hold on;
plot(xk(1),yk(1),'*-r');
plot(xk(k),yk(k),'*-g');
legend('graph', 'starting point', 'ending point')
xlabel('{x_k}')
ylabel('{y_k}')
hold off;
figure()
plot(1:k, func(xk,yk),'-o')
title('Convergence of f')
xlabel('k')
ylabel('{f(x_k, y_k)}')

toc

%C - Armijo Rule for gamma_k

clear xk yk k

a = 1e-1;
b = 1/2;
s = 7.5;

xk = [];
yk = [];
xk(1) = starting_points(point,1);
yk(1) = starting_points(point,2);

grad_f = gradient(func, [x y]);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    
    mk = 1;
    
    while 1
        if double(func(xk(k), yk(k))) > double(func(xk(k)-gradient_vector(1)*s*b^mk,yk(k)-gradient_vector(2)*s*b^mk))-a*s*b^mk*double(transpose(-gradient_vector)*gradient_vector)
            break
        else
            mk = mk + 1;
        end
    end
    
    gamma_k = s*b^mk;
    
    xk(k+1) = xk(k) - gamma_k*gradient_vector(1);
    yk(k+1) = yk(k) - gamma_k*gradient_vector(2);
    k = k + 1;
    
    if k > 10000
        fprintf("INFINITE LOOP\n");
        toc
        return
    end
end

fprintf('C: Minimum at (%f, %f) with value of %f\n', xk(k), yk(k), func(xk(k),yk(k)))
fprintf('k = %d\n', k)
figure()
fcontour(func, 'Fill', 'On');
title('Contour for starting point = [' + string(starting_points(point,1)) + ' ' + string(starting_points(point,2)) + ']')
hold on;
plot(xk(1),yk(1),'*-r');
plot(xk(k),yk(k),'*-g');
legend('graph', 'starting point', 'ending point')
xlabel('{x_k}')
ylabel('{y_k}')
hold off;
figure()
plot(1:k, func(xk,yk),'-o')
title('Convergence of f')
xlabel('k')
ylabel('{f(x_k, y_k)}')

toc
