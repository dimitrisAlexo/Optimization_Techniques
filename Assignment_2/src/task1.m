% Plot of the function f = x^5 * exp(-x^2 - y^2)

clearvars
clc

x = linspace(-3, 3, 75);
y = linspace(-3, 3, 75);
[x, y] = meshgrid(x, y);
z = x.^5 .* exp(-x.^2 - y.^2);
surf(x,y,z)

title('Plot of the function f(x, y) = {x^5 * exp(-x^2 - y^2)}')
xlabel('x')
ylabel('y')
zlabel('f(x, y)')

colormap spring

c = colorbar;
c.Label.String = 'Values';