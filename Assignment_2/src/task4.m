% Levenberg-Marquardt Method

clearvars
clc

tic

syms x y func(x,y)
func(x,y) = x^5 * exp(-x^2 - y^2);

starting_points = [[0 0];[-1 1];[1 -1]];
point = 3;
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
    
    mk = 0;
    A = hessian_vector + mk*eye(2);
    
    [~,flag] = chol(A);   
    eigens = eig(hessian_vector);
    maxEigen = max(abs(eigens));
    while (flag ~= 0)
        mk = mk + maxEigen + 0.1;
        A = hessian_vector + mk*eye(2);
        [~,flag] = chol(A);
    end
    
    dk = linsolve(A, -gradient_vector);
    
    p = eig(A);
    if (all(p > 0))
        disp('Hessian is positive definite')
    else
        disp('Hessian is NOT positive definite')
        return
    end
       
    try chol(-transpose(gradient_vector)*dk);
    catch ME
        disp('Does not fullfill criteria 3, 4')
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

fprintf('B: Minimum at (%f, %f) with value of %f\n', xk(k), yk(k), func(xk(k),yk(k)))
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

%Using Armijo Rule

clear xk yk k

xk = [];
yk = [];
xk(1) = starting_points(point,1);
yk(1) = starting_points(point,2);

grad_f = gradient(func, [x y]);
hessian_f = hessian(func, [x y]);
k = 1;

a = 1e-1;
b = 1/2;
s = 8.5;

gradient_vector = grad_f(xk(1), yk(1));

while norm(gradient_vector) > epsilon

    gradient_vector = grad_f(xk(k), yk(k));
    hessian_vector = hessian_f(xk(k), yk(k));
    
    mk = 0;
    A = hessian_vector + mk*eye(2);
    
    [~,flag] = chol(A);   
    eigens = eig(hessian_vector);
    maxEigen = max(abs(eigens));
    while (flag ~= 0)
        mk = mk + maxEigen;
        A = hessian_vector + mk*eye(2);
        [~,flag] = chol(A);
    end
    
    dk = linsolve(A, -gradient_vector);
    
    p = eig(A);
    if (all(p > 0))
        disp('Hessian is positive definite')
    else
        disp('Hessian is NOT positive definite')
        return
    end
    
    try chol(-transpose(gradient_vector)*dk);
    catch ME
        disp('Does not fullfill criteria 3, 4')
        return
    end
    
    mk = 1;
    
    while 1
        if double(func(xk(k), yk(k))) > double(func(xk(k)+dk(1)*s*b^mk,yk(k)+dk(2)*s*b^mk))-a*s*b^mk*double(transpose(dk)*gradient_vector)
            break
        else
            mk = mk + 1;
        end
    end
    
    gamma_k = s*b^mk;
    
    xk(k+1) = xk(k) + gamma_k*dk(1);
    yk(k+1) = yk(k) + gamma_k*dk(2);
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
