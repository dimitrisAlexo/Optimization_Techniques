% Penalty Method

clearvars
clc

% define constants
a = [1.25 1.25 1.25 1.25 1.25 1.5 1.5 1.5 1.5 1.5 1 1 1 1 1 1 1];
c = [54.13 21.56 34.08 49.19 33.03 21.84 29.96 24.87 47.24 33.97 26.89 32.76 39.98 37.12 53.83 61.65 59.73];
V = 100;

% define range for input
bounds = [];
for i = 1 : 17
    bounds = [bounds; 0.0, c(i)];
end
% define the total iterations
n_iter = 100;
% bits per variable
n_bits = 16;
% define the population size
n_pop = 500;
% crossover rate
r_cross = 0.9;

global best_times;
best_times = [];

[best, best_eval] = genetic_alg(bounds, n_bits, n_iter, n_pop, r_cross, a, c, V);
fprintf('Done!\n');
decoded = decode(bounds, n_bits, best);
for i = 1 : 17
    fprintf('x(%d) = %f\n', i, decoded(i));
end

fprintf('Best Time = %f\n', best_eval(2)/V);

figure()
hold on
plot(1:size(best_times, 2), best_times ,'-o')
yline(best_times(size(best_times, 2)), 'r')
ylim([0 2000])
title('Evolution of the Population')
xlabel('generation')
ylabel('best time (min)')

function fitness = objective(x, a, c, V)
    persistent rk;
    rk = 1;
    fitness = [];
    sum = 0;
    for i = 1 : 17
        T = a(i)*x(i)/(1-x(i)/c(i));
        sum = sum + x(i)*T;
    end
    fitness(2) = sum; % time
    sum = sum + rk*((V-x(1)-x(2)-x(3)-x(4))^4 + (x(1)-x(5)-x(6))^4 + (x(2)-x(7)-x(8))^4 ...
        + (x(3)+x(8)+x(9)-x(13)-x(12)-x(11))^4 + (x(4)-x(9)-x(10))^4 + (x(5)+x(14)-x(16))^4 ...
        + (x(12)+x(17)+x(16)+x(15)-V)^4 + (x(10)+x(11)-x(17))^4 + (x(6)+x(7)+x(13)-x(14)-x(15))^4);
    rk = rk + 100;
    fitness(1) = sum;
end

function decoded = decode(bounds, n_bits, bitstring)
    decoded_temp = [];
    largest = 2^n_bits;
    for i = 1 : size(bounds, 1)
        start_w = (i-1) * n_bits + 1;
        end_w = (i-1) * n_bits + n_bits;
        substring = bitstring(start_w:end_w);
        integer = num2str(substring);
        integer(isspace(integer)) = '';
        integer = bin2dec(integer);
        value = bounds(i, 1) + (integer/largest) * (bounds(i, 2) - bounds(i,1));
        decoded_temp = [decoded_temp value];
    end
    decoded = decoded_temp;
end

function selected = selection(population, scores)
    selection_ix = randi(size(population, 1));
    for i = 1 : 3  % number of comparisons
        ix = randi(size(population, 1));
        if scores(ix, 1) < scores(selection_ix, 1)
            selection_ix = ix;
        end
    end
    selected = population(selection_ix,:);
end

function crossed = crossover(p1, p2, r_cross, n_bits)
    c1 = p1;
    c2 = p2;
    if rand() < r_cross
        pt = randi(16)*n_bits;
        c1 = cat(2, p1(1:pt), p2(pt+1:length(p2)));
        c2 = cat(2, p2(1:pt), p1(pt+1:length(p1)));
    end
    crossed = [c1; c2];
end

function bitstring = mutation(bitstring, n_bits)
    for i = 1 : n_bits : length(bitstring)
        for j = 1 : n_bits
            if betarnd(1, 2) >= (n_bits-j+1)/n_bits
                bitstring(i+j-1) = ~bitstring(i+j-1);
            end
        end
    end
end

function [best, best_eval] = genetic_alg(bounds, n_bits, n_iter, n_pop, r_cross, a, c, V)
    global best_times
    population = randi(2, n_pop, n_bits*size(bounds, 1))-1;
    best = 0;
    best_eval = objective(decode(bounds, n_bits, population(1,:)), a, c, V);
    for gen = 1 : n_iter
        decoded = [];
        for p = 1 : n_pop
            decoded = [decoded; decode(bounds, n_bits, population(p,:))];
        end
        scores = [];
        for d = 1 : n_pop
            scores = [scores; objective(decoded(d,:), a, c, V)];
        end
        for i = 1 : n_pop
            if scores(i, 1) < best_eval(1)
                best = population(i,:);
                best_eval = scores(i, :);
                for k = 1 : 17
                    fprintf('x(%d) = %f\n', k, decoded(i, k));
                end
                best_time = scores(i, 2)/V;
                fprintf('>%d, Time = %f\n', gen, best_time);
                best_times = [best_times best_time];
            end
        end
        selected = [];
        for s = 1 : n_pop
            selected = [selected; selection(population, scores)];
        end
        children = [];
        for i = 1 : 2 : n_pop
            p1 = selected(i,:);
            p2 = selected(i+1,:);
            siblings = crossover(p1, p2, r_cross, n_bits);
            for j = 1 : size(siblings, 1)
                siblings(j,:) = mutation(siblings(j,:), n_bits);
                children = [children; siblings(j,:)];
            end
        end
        population = children;
    end
end

