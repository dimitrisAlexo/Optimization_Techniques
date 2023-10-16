% Steepest Descent Method for f = 1/3*x_1^2 + 3*x_2^2

clearvars
clc

tic

syms x y func(x,y)
func(x,y) = 1/3*x^2 + 3*y^2;

starting_point = [7 -7];
epsilon = 0.001;

% Using a constant gamma_k
gamma_k = 0.3;
grad_f = gradient(func, [x y]);
xk = [];
yk = [];
xk(1) = starting_point(1);
yk(1) = starting_point(2);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    dk = -gradient_vector;
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
title('Contour for starting point = [' + string(starting_point(1)) + ' ' + string(starting_point(2)) + ']')
hold on;
xlim([-10 10]);
ylim([-10 10]);
plot(xk(:),yk(:),'--r');
plot(xk(1),yk(1),'*-r');
plot(xk(k),yk(k),'*-g');
legend('graph', 'route', 'starting point', 'ending point')
xlabel('{x_k}')
ylabel('{y_k}')
hold off;
figure()
plot(1:k, func(xk,yk),'-o')
title('Convergence of f')
xlabel('k')
ylabel('{f(x_k, y_k)}')

toc
