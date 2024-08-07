% the prefered sampling plan
P = fullfactorial([10, 10], 1);
P = 10*P + eps;
% P = log(P);

% the post-processed evaluation function
Z = optimizeControlSystem(P);

Z = normalize_data(Z);


%% NSGA-II design

% Performing variation
bounds = [0.1 0.1; 10 10];
HV_max = [max(Z)];
HV_values = [];

i = 1;
n_iterations = 250;
while i < n_iterations 

    % (1) Non-dominated sorting
    ranking = rank_nds(Z);

    % (2) Crowding distance
    crowd = crowding(Z, ranking);

    % (3) Performing selection-for-variation (Binary Tournament Selection with
    % Replacement)
    selectThese = btwr([-1*ranking, crowd], 100); 
    
    % Perform simulated binary crossover (sbx)
    offspring = sbx(P(selectThese, :), bounds);

    % Perform polynomial mutation (polymut)
    postMute = polymut(offspring, bounds);

    % (4) Performing selection-for-survival
    P_C = [P; postMute];

    % Evaluate the new population
    Z = optimizeControlSystem(P_C);
    
    % Non-dominated sorting
    ranking = rank_nds(Z);
    
    % Crowding distance
    crowd = crowding(Z, ranking);

    reduced_idx = reducerNSGA_II(P_C, ranking, crowd, 100);

    P_C_reduced = P_C(reduced_idx, :);
    
    Z = optimizeControlSystem(P_C_reduced);

    P = P_C_reduced;

    HV = Hypervolume_MEX(Z, HV_max);
    HV_values = [HV_values; HV];

    i = i+1;
    disp(i);
end

figure;
scatter(P(:, 1), P(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('Full Factorial Sampling (2D)')

%% functions
function data_normalized = normalize_data(data)
    % Normalize each column (objective) to [0, 1] range
    min_vals = min(data);
    max_vals = max(data);
    data_normalized = (data - min_vals) ./ (max_vals - min_vals);
end
