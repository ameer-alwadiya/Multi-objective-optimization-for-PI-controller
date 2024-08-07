% the prefered sampling plan
P = fullfactorial([10, 10], 2);
P = 10*P + eps;
% P = log(P);

% the post-processed evaluation function
Z = optimizeControlSystem(P);
% Z = normalize_data(Z);


%% NSGA-II design

% Performing variation
bounds = [0.1 0.1; 10 10];
HV_max = [max(Z)];
HV_values = [];

% Initialize variables to track the maximum HV and corresponding Z_eval
max_HV = -inf;
Optimal_P = [];
Optimal_Z = [];

i = 1;
n_iterations = 250;
while i < n_iterations 

    % Priority levels: Hard constraint = 3; High = 2; Moderate = 1; Low = 0;
    switch true
        case i <= 50
            Goal = [0.8 -inf -inf -inf -inf -inf -inf -inf -inf -inf];
            Priority = [1 0 0  0 0 0 0 0 0 0];

        case i > 50 && i <= 100
            Goal = [0.8 -6 50 -inf -inf -inf -inf -inf -inf -inf];
            Priority = [2 0 0 0 0 0 0 0 0 1];

        case i > 100 && i <= 150
            Goal = [0.8 -6 50 2 10 10 8 20 1 0.63];
            Priority = [3 2 2 1 0 1 0 0 1 2];

        otherwise
            Goal = [0.8 -6 50 2 10 10 8 20 1 0.63];
            Priority = [3 2 2 1 0 1 0 0 1 1];
    end

    % (1) Non-dominated sorting
    [ranking, Class] = rank_prf(Z, Goal, Priority);
    % ranking = rank_nds(Z);

    % (2) Crowding distance
    crowd = crowding(Z, ranking);

    % (3) Performing selection-for-variation (Binary Tournament Selection with
    % Replacement)
    % fitness = max(ranking) - ranking;
    selectThese = btwr([ranking, crowd], 100); 
    
    % Perform simulated binary crossover (sbx)
    offspring = sbx(P(selectThese, :), bounds);

    % Perform polynomial mutation (polymut)
    postMute = polymut(offspring, bounds);

    % (4) Performing selection-for-survival
    P_C = [P; postMute];

    % Evaluate the new population
    Z = optimizeControlSystem(P_C);
    % Z = normalize_data(Z);

    % Non-dominated sorting
    [ranking, Class] = rank_prf(Z, Goal, Priority);
    % ranking = rank_nds(Z);
    
    % Crowding distance
    crowd = crowding(Z, ranking);

    reduced_idx = reducerNSGA_II(P_C, ranking, crowd, 100);

    P_C_reduced = P_C(reduced_idx, :);
    
    Z = optimizeControlSystem(P_C_reduced);
    % Z = normalize_data(Z);
    
    P = P_C_reduced;

    HV = Hypervolume_MEX(Z, HV_max);
    HV_values = [HV_values; HV];

    % Track the maximum HV and corresponding Z_eval
    if HV > max_HV
        max_HV = HV;
        Optimal_P = P;
        Optimal_Z = Z;
    end

    disp(i);
    i = i+1;
end
%% plots
% Plot the hypervolume values.
figure;
plot(HV_values);
title('Plot of HV Values');

figure;
scatter(P(:, 1), P(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('Sampling plane after optimization')

figure;
scatter(Optimal_P(:, 1), Optimal_P(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('Sampling plane after optimization at the maximum hypervolume')
%%
% Assuming Z is a matrix with 10 variables
labels = { ...
    'Close loop pole', ...
    'Gain Margin', ...
    'Phase Margin', ...
    'Rise Time', ...
    'Peak Time', ...
    'Overshoot', ...
    'Undershoot', ...
    'Settling Time', ...
    'Steady-State Error', ...
    'Effort' ...
};

% Create the scatter plot matrix
[H, AX] = plotmatrix(Z);

% Add a title above the plot matrix
sgtitle('Scatter Plot Matrix at Maximum Hypervolume');

% Label the axes
numVars = size(Z, 2);
for i = 1:numVars
    AX(numVars, i).XLabel.String = labels{i}; % X-labels for the bottom row
    AX(i, 1).YLabel.String = labels{i}; % Y-labels for the first column

     % Tilt the Y-labels for the first column
    AX(i, 1).YLabel.Rotation = 45;
    AX(i, 1).YLabel.HorizontalAlignment = 'right';
end

%% Create the parallel coordinates plot
figure;
p = parallelplot(Optimal_Z);

% Set custom axis labels
p.CoordinateTickLabels = labels;

% Add a title to the parallel coordinates plot
title('Parallel Coordinates Plot at Maximum Hypervolume');

%% Extract samples that satisfy the criteria
% Z=Optimal_Z;
Z(:, 2) = -1*Z(:, 2);
Z(:, 3) = Z(:, 3) + 50;

selected_samples = [];

for i = 1:size(Z, 1)
    if Z(i, 1) < 1 && ...
       Z(i, 2) >= 6 && ...
       Z(i, 3) >= 30 && Z(i, 3) <= 70 && ...
       Z(i, 4) <= 2 && ...
       Z(i, 5) <= 10 && ...
       Z(i, 6) <= 10 && ...
       Z(i, 7) <= 8 && ... 
       Z(i, 7) <= 20 && ... 
       Z(i, 7) <= 1 && ... 
       Z(i, 10) <= 0.67
   
        selected_samples = [selected_samples; z(i, :)];
    end
end

%% functions
function data_normalized = normalize_data(data)
    % Normalize each column (objective) to [0, 1] range
    min_vals = min(data);
    max_vals = max(data);
    data_normalized = (data - min_vals) ./ (max_vals - min_vals);
end
