clearvars
clc

%functions to be used
syms f1(x) f2(x) f3(x)
f1(x) = (x-2)^2 + x*log(x+3);
f2(x) = 5^x + (2-cos(x))^2;
f3(x) = exp(x)*(x^3-1) + (x-1)*sin(x);

len = [1e-2 1e-3 1e-4 1e-5];
a = -1;
b = 3;

%running the bisectrix with derivative algorithm for f1
fprintf("Function f1:\n")
for i = 1 : length(len)
    tic
    [alpha, beta, x, y] = bisectrix_derivative(f1, a, b, len(i));
    fprintf("L is %.6f\n", len(i))
    fprintf("Execution time: " + toc + " seconds\n\n")
end
fprintf("\n")

%running the bisectrix with derivative algorithm for f2
fprintf("Function f2:\n")
for i = 1 : length(len)
    tic
    [alpha, beta, x, y] = bisectrix_derivative(f2, a, b, len(i));
    fprintf("L is %.6f\n", len(i))
    fprintf("Execution time: " + toc + " seconds\n\n")
end
fprintf("\n")

%running the bisectrix with derivative algorithm for f3
fprintf("Function f3:\n")
for i = 1 : length(len)
    tic
    [alpha, beta, x, y] = bisectrix_derivative(f3, a, b, len(i));
    fprintf("L is %.6f\n", len(i))
    fprintf("Execution time: " + toc + " seconds\n\n")
end
fprintf("\n")

warning off
mkdir task4_graphs
cd task4_graphs

%graphs for f1
for i = 1 : length(len)
    figure();
    set(gcf, 'Visible', 'off');
    [alpha, beta, x, y] = bisectrix_derivative(f1, a, b, len(i));
    
    subplot(1, 2, 1);
    plot(alpha, '.-');
    xlabel('k');
    ylabel("{\alpha}")
    title("1. len = " + string(len(i)) + ": {\alpha_k}");

    hold on;
    
    subplot(1, 2, 2);
    plot(beta, '.-');
    xlabel('k');
    ylabel("{\beta}")
    title("2. len = " + string(len(i)) + ": {\beta_k}");
   
    saveas(gcf, "4_f1_ab_k_" + string(i) + ".png");
    
    figure();
    set(gcf, 'Visible', 'off');
    
    hold on
    scatter(x, y, '.r');
    fplot(f1, 'g');
    hold off
    xlabel('x');
    xlim([-1 3]);
    ylim([0 10]);
    title("Function f1");
    
    saveas(gcf, "4_f1_x1x2_" + string(i) + ".png");

end

%graphs for f2
for i = 1 : length(len)
    figure();
    set(gcf, 'Visible', 'off');
    [alpha, beta, x, y] = bisectrix_derivative(f2, a, b, len(i));
    
    subplot(1, 2, 1);
    plot(alpha, '.-');
    xlabel('k');
    ylabel("{\alpha}")
    title("1. len = " + string(len(i)) + ": {\alpha_k}");

    hold on;
    
    subplot(1, 2, 2);
    plot(beta, '.-');
    xlabel('k');
    ylabel("{\beta}")
    title("2. len = " + string(len(i)) + ": {\beta_k}");
   
    saveas(gcf, "4_f2_ab_k_" + string(i) + ".png");
    
    figure();
    set(gcf, 'Visible', 'off');
    
    hold on
    scatter(x, y, '.r');
    fplot(f2, 'g');
    hold off
    xlabel('x1');
    xlim([-1 3]);
    ylim([-5 100]);
    title("Function f2");
    
    saveas(gcf, "4_f2_x1x2_" + string(i) + ".png");

end

%graphs for f3
for i = 1 : length(len)
    figure();
    set(gcf, 'Visible', 'off');
    [alpha, beta, x, y] = bisectrix_derivative(f3, a, b, len(i));
    
    subplot(1, 2, 1);
    plot(alpha, '.-');
    xlabel('k');
    ylabel("{\alpha}")
    title("1. len = " + string(len(i)) + ": {\alpha_k}");

    hold on;
    
    subplot(1, 2, 2);
    plot(beta, '.-');
    xlabel('k');
    ylabel("{\beta}")
    title("2. len = " + string(len(i)) + ": {\beta_k}");
   
    saveas(gcf, "4_f3_ab_k_" + string(i) + ".png");
    
    figure();
    set(gcf, 'Visible', 'off');
    
    hold on
    scatter(x, y, '.r');
    fplot(f3, 'g');
    hold off
    xlabel('x1');
    xlim([-1 3]);
    ylim([-5 100]);
    title("Function f3");
    
    saveas(gcf, "4_f3_x1x2_" + string(i) + ".png");

end
