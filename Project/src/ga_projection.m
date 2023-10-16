% Projection Method

clearvars
clc

% define constants
a = [1.25 1.25 1.25 1.25 1.25 1.5 1.5 1.5 1.5 1.5 1 1 1 1 1 1 1];
c = [54.13 21.56 34.08 49.19 33.03 21.84 29.96 24.87 47.24 33.97 26.89 32.76 39.98 37.12 53.83 61.65 59.73];
node_inputs = {0,1,2,[3,8,9],4,[5,14],[6,7,13],[16,15,12,17],[10,11]};
padding = zeros(9,4) - 1;
for k = 1:numel(node_inputs), padding(k,1:numel(node_inputs{k})) = node_inputs{k}; end
node_inputs = padding;

node_outputs = {[1,2,3,4],[5,6],[7,8],[11,12,13],[9,10],16,[14,15],0,17};
padding = zeros(9,4) - 1;
for k = 1:numel(node_outputs), padding(k,1:numel(node_outputs{k})) = node_outputs{k}; end
node_outputs = padding;

edge_sources = [1,1,1,1,2,2,3,3,5,5,4,4,4,7,7,6,9];

edge_destinations = [2,3,4,5,6,7,7,4,4,9,9,8,7,6,8,8,8];

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
% input flow
V = 100;

global best_times;
best_times = [];

[best, best_eval] = genetic_alg(bounds, n_bits, n_iter, n_pop, r_cross, a, c, node_inputs, node_outputs, edge_sources, edge_destinations, V);
                            
fprintf('Done!\n');

best = decode(bounds, n_bits, best);
updated_x = flow_conservation(best, V, size(bounds, 1), node_inputs, node_outputs, edge_sources);

for k = 1 : 17
       fprintf('x(%d) = %f\n', k, updated_x(k));
end
fprintf('Best Time = %f\n', best_eval/V);

figure()
hold on
plot(1:size(best_times, 2), best_times ,'-o')
yline(best_times(size(best_times, 2)), 'r')
ylim([0 800])
title('Evolution of the Population')
xlabel('generation')
ylabel('best time (min)')

function fitness = objective(x, a, c)
    
    T = [];
    sum = 0;
    for i = 1 : 17
        if x(i)>=c(i)
            sum = sum + 100000000;
        end
        T(i) = a(i)*x(i)/(1-x(i)/c(i));
        sum = sum + x(i)*T(i);
    end
    fitness = sum;
end

function decoded = decode(bounds, n_bits, decoded)
    decoded_temp = [];
    largest = 2^n_bits;
    for i = 1 : size(bounds, 1)
        start_w = (i-1) * n_bits + 1;
        end_w = (i-1) * n_bits + n_bits;
        substring = decoded(start_w:end_w);
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
        if scores(ix) < scores(selection_ix)
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

function updated_x = flow_conservation(flow, V, n_edges, node_inputs, node_outputs, edge_sources)

    n_inputs = size(node_inputs,2);
    n_outputs = size(node_outputs,2);
    updated_x = zeros(1,n_edges);

    for i = 1:n_edges
        source = edge_sources(i);
        input_flow = 0;
        for j = 1:n_inputs
            if node_inputs(source,j)==0
                input_flow = V;
                break;
            elseif node_inputs(source,j) == -1
                break;
            end
            input_flow = input_flow + updated_x(node_inputs(source,j));
        end
        source = edge_sources(i);
        output_flow = 0;
        for j = 1:n_outputs
            if node_outputs(source,j)==0
                output_flow = V;
                break;
            elseif node_outputs(source,j) == -1
                break;
            end
            output_flow = output_flow + flow(node_outputs(source,j));
        end
        
        updated_x(i) = flow(i) * (input_flow / output_flow);

    end

end

    
function [best, best_eval] = genetic_alg(bounds, n_bits, n_iter, n_pop,  r_cross,  a, c, node_inputs, node_outputs, edge_sources, edge_destinations, V)

    global best_times

    N = size(bounds, 1);
    population = randi(2, n_pop, n_bits*N)-1;

    x = [];
    for i = 1:n_pop
        x = [x; decode(bounds, n_bits, population(i,:))];

    end

    for i = 1:n_pop

        normalized_x(i, :) = flow_conservation(x(i,:), V, N, node_inputs, node_outputs, edge_sources);
        
    end

    best = 0;
    best_eval = objective(normalized_x(1,:), a, c);
    for gen = 1 : n_iter

        x = [];
        for i = 1:n_pop
            x = [x; decode(bounds, n_bits, population(i,:))];
        end
    
        for i = 1:n_pop
            normalized_x(i, :) = flow_conservation(x(i,:), V, N, node_inputs, node_outputs, edge_sources);
        end

        scores = [];
        for d = 1 : n_pop
            scores = [scores objective(normalized_x(d,:), a, c)];
        end

        for i = 1 : n_pop
            if scores(i) < best_eval
                best = population(i,:);
                best_eval = scores(i);
                for k = 1 : 17
                    fprintf('x(%d) = %f\n', k, normalized_x(i, k));
                end
                best_time = scores(i)/V;
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

