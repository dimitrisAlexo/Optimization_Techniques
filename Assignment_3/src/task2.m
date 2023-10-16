% Steepest Descent Method with Projection

clearvars
clc

tic

syms x y func(x,y)
func(x,y) = 1/3*x^2 + 3*y^2;

starting_point = [-5 10];
epsilon = 0.01;

% Using a constant gamma_k
gamma_k = 0.1;
sigma_k = 3;
grad_f = gradient(func, [x y]);
xk = [];
yk = [];
xk_bar = [];
yk_bar = [];

constraint = [-10 5; -8 12];

sp = projection(starting_point, constraint);
xk(1) = sp(1);
yk(1) = sp(2);
k = 1;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    double(norm(gradient_vector))
    point = [(xk(k) - sigma_k*gradient_vector(1)) (yk(k) - sigma_k*gradient_vector(2))];
    proj = projection(point, constraint);
    xk_bar(k) = proj(1);
    yk_bar(k) = proj(2);
    
    xk(k+1) = xk(k) + gamma_k*(xk_bar(k) - xk(k));
    yk(k+1) = yk(k) + gamma_k*(yk_bar(k) - yk(k));
    
    k = k + 1;
    
    if k > 150
        fprintf("INFINITE LOOP\n");
        toc
        break
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