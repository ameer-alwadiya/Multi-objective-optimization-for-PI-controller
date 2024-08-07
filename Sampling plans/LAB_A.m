clear, clc
%% LAB (1)
%% Task A.0
Z_init = evaluateControlSystem([1, 10]);


%%  Task A.1 fullfactorial

% (1) Call the fullfactorial function
q = [10, 10];  % 10 points in first dimension, 10 points in second dimension

Xff = fullfactorial(q, 2);
Xff = 10*Xff + eps;

% (2) Call the rlh function
Xrlh = rlh(100, 2, 5);
Xrlh = 10*Xrlh + eps;

% (3) Call the sobolset function
P = sobolset(2);
Xsobol = net(P,100);
Xsobol = 10*Xsobol + eps;

% Scatter plot the data points
figure;
scatter(Xff(:, 1), Xff(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('Full Factorial Sampling')

figure;
scatter(Xrlh(:, 1), Xrlh(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('rlh Sampling (2D)')

figure;
scatter(Xsobol(:, 1), Xsobol(:, 2))
xlabel('Dimension 1')
ylabel('Dimension 2')
title('sobol  Sampling (2D)')

score_fullfracotrial = mmphi(Xff, 5, 2)
score_rlh = mmphi(Xrlh, 5, 2)
score_sobol = mmphi(Xsobol, 5, 2)

Z = evaluateControlSystem(Xff);

%% Task A.2
% Assuming Z is a matrix with 10 variables
labels = { ...
    'Close loop pole', ...
    'Gain Margin', ...
    'Phase Margin', ...
    'Rise Time', ...
    'Peak Time', ...
    'Overshoot', ...
    'Undershoot', ...
    'ettling Time', ...
    'Steady-State Error', ...
    'Effort' ...
};

% Create the scatter plot matrix
[H, AX] = plotmatrix(Z);

% Add a title above the plot matrix
sgtitle('Scatter Plot Matrix');

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
p = parallelplot(Z);

% Set custom axis labels
p.CoordinateTickLabels = labels;

% Add a title to the parallel coordinates plot
title('Parallel Coordinates Plot');

%% kmeans
% Perform hierarchical clustering using clusterdata
k = 10;
T = clusterdata(Z, 'maxclust', k); % k is the number of clusters you want

% Visualize the clusters
figure;
scatter3(Z(:,1), Z(:,2), Z(:,3), [], T, 'filled');
xlabel('Dimension 1');
ylabel('Dimension 2');
zlabel('Dimension 3');
title('Hierarchical Clustering');

% Perform kmeans clustering
[idx, C] = kmeans(Z, k); % k is the number of clusters you want

% Visualize the clusters
figure;
scatter3(Z(:,1), Z(:,2), Z(:,3), [], idx, 'filled');
hold on;
scatter3(C(:,1), C(:,2), C(:,3), 'r', 'filled');
xlabel('Dimension 1');
ylabel('Dimension 2');
zlabel('Dimension 3');
title('K-Means Clustering');
legend('Cluster Data', 'Centroids');
