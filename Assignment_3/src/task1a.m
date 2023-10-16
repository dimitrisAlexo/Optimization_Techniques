% Plot of the function f = 1/3*x_1^2 + 3*x_2^2

clearvars
clc

x_1 = linspace(-5, 5, 50);
x_2 = linspace(-5, 5, 50);
[x_1, x_2] = meshgrid(x_1, x_2);
y = 1/3*x_1.^2 + 3*x_2.^2;
surf(x_1,x_2,y)

title('Plot of the function {f(x_1, x_2) = 1/3*x_1^2 + 3*x_2^2}')
xlabel('{x_1}')
ylabel('{x_2}')
zlabel('f({x_1, x_2})')

colormap spring

c = colorbar;
c.Label.String = 'Values';