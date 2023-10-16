% Newton Method

clearvars
clc

tic

syms x y func(x,y)
func(x,y) = x^5 * exp(-x^2 - y^2);

starting_points = [[0 0];[-1 1];[1 -1]];
point = 2;
epsilon = 0.001;

xk = [];
yk = [];
xk(1) = starting_points(point,1);
yk(1) = starting_points(point,2);

grad_f = gradient(func, [x y]);
hessian_f = hessian(func, [x y]);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    hessian_vector = hessian_f(xk(k), yk(k));
    dk = -inv(hessian_vector)*gradient_vector;
    
    p = eig(hessian_vector);
    if (all(p > 0))
        disp('Hessian is positive definite')
    else
        disp('Hessian is NOT positive definite')
        return
    end
    
    g = @(gamma) func(xk(k)+gamma*dk(1), yk(k)+gamma*dk(2));
    gamma_k = golden_section(g, 0, 10, 1e-3);
    
    xk(k+1) = xk(k) + gamma_k*dk(1);
    yk(k+1) = yk(k) + gamma_k*dk(2);
    k = k + 1;
    
    if k > 10000
        fprintf("INFINITE LOOP\n");
        toc
        return
    end
end

fprintf('Minimum at (%f, %f) with value of %f\n', xk(k), yk(k), func(xk(k),yk(k)))
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