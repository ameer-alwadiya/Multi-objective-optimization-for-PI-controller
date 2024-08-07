# Multi-objective Optimization for PI Controller

## Executive Summary

The objective of this project is to optimize the Proportional-Integral (PI) controller for a digital control system using multi-objective optimization techniques. The focus is on achieving a balance between multiple performance metrics, including closed-loop pole magnitude, gain margin, phase margin, rise time, overshoot, and settling time. The NSGA-II (Non-Dominated Sorting Genetic Algorithm II) optimizer is employed to explore the design space and identify optimal PI controller gains \( K_p \) and \( K_i \) that meet specified performance criteria. 

## Project Overview

This repository contains code and documentation for the multi-objective optimization of a PI controller. The approach involves:
1. Formulating the optimization problem with two design variables and ten objectives.
2. Using different sampling plans to explore the design space.
3. Applying NSGA-II to find the Pareto-optimal solutions.
4. Analyzing the results through various plots and metrics to evaluate the optimization performance.

## Table of Contents

1. [Introduction](#introduction)
2. [Sampling Plans](#sampling-plans)
3. [Optimization Process](#optimization-process)
4. [Results](#results)
5. [Sustainability Analysis](#sustainability-analysis)
6. [Recommendations](#recommendations)
7. [Functions](#functions)
8. [How to Use](#how-to-use)
9. [Contributing](#contributing)
10. [License](#license)

## Introduction

The goal of this project is to fine-tune a PI controller by optimizing multiple performance objectives using NSGA-II. The PI controller is crucial in maintaining the stability and performance of digital control systems. The project involves:
- Formulating the problem with design variables and performance objectives.
- Selecting appropriate sampling plans.
- Using NSGA-II for optimization.
- Analyzing and visualizing results.

## Sampling Plans

Three different sampling plans are utilized to explore the design space:

1. **Full Factorial Sampling**: Tests all possible combinations of factor levels.
2. **Latin Hypercube Sampling**: Efficiently explores parameter space with limited samples.
3. **Sobol Sequences**: Quasi-random sequences to ensure good coverage in multidimensional space.

Each sampling plan is evaluated using space-filling metrics to determine its effectiveness.

## Optimization Process

The optimization process uses NSGA-II, an evolutionary algorithm that performs the following steps:
1. **Non-Dominated Sorting**: Classify solutions into non-dominated sets.
2. **Determine Crowding Distance**: Measure the density of solutions around each candidate.
3. **Selection**: Use binary tournament selection with replacement.
4. **Crossover and Mutation**: Apply genetic operators to generate new solutions.
5. **Population Update**: Combine old and new populations and select the best.
6. **Termination**: Repeat until a stopping criterion is met (e.g., number of iterations).

## Results

### Hypervolume Analysis

Hypervolume is tracked throughout the optimization process to evaluate the quality of solutions. Results include:
- **Plot of Hypervolume Values**: Shows the change in hypervolume over iterations.
- **Sampling Plane Visualization**: Compares the distribution of samples before and after optimization.

### Objective Performance

- **Scatter Plots**: Display the relationship between different objectives.
- **Parallel Coordinates Plot**: Visualizes the performance of objectives at maximum hypervolume.

## Sustainability Analysis

Trade-offs between energy usage and performance metrics are analyzed. Lower energy usage often results in compromised transient performance, which is evaluated through updated sampling plans and optimization results.

## Recommendations

Based on optimization results, the following recommendations for PI controller gains are made:
- **Closed Loop Pole Magnitude**: Target less than 1.
- **Gain Margin**: At least 6 dB.
- **Phase Margin**: Between 30 and 70 degrees.
- **Rise Time**: Less than or equal to 2 seconds.
- **Peak Time**: Less than or equal to 10 seconds.
- **Overshoot**: Less than or equal to 10%.
- **Undershoot**: Less than or equal to 8%.
- **Settling Time**: Less than or equal to 20 seconds.

## Functions

### `normalize_data(data)`
Normalizes each column of the data to the [0, 1] range.

### `optimizeControlSystem(P)`
Evaluates the performance of the PI controller given a set of parameters \( P \).

### `rank_prf(Z, Goal, Priority)`
Ranks solutions based on goals and priorities.

### `crowding(Z, ranking)`
Calculates the crowding distance for each solution.

### `btwr(ranking_crowd, N)`
Performs binary tournament selection with replacement.

### `sbx(P, bounds)`
Applies simulated binary crossover to generate offspring.

### `polymut(offspring, bounds)`
Performs polynomial mutation on offspring.

### `reducerNSGA_II(P_C, ranking, crowd, N)`
Reduces the population based on non-dominated sorting and crowding distance.

### `Hypervolume_MEX(Z, HV_max)`
Calculates the hypervolume of the Pareto front.

## How to Use

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/ameer-alwadiya/Multi-objective-optimization-for-PI-controller.git
   ```

2. **Navigate to the Project Directory**:
   ```sh
   cd Multi-objective-optimization-for-PI-controller
   ```

3. **Run the Optimization**:
   Execute the main script to start the optimization process. Ensure that all dependencies are installed.

4. **Analyze Results**:
   Check the generated plots and figures to review the optimization results.
