clc;
clear;

% Input values
c = [-2 -1 0 0 0];
A = [-3 -1 1 0 0;
     -4 -3 0 1 0;
     -1 -2 0 0 1];
b = [-3; -6; -3];

[m, n] = size(A);  % m = number of constraints, n = number of variables
bv_index = n - m + 1 : 1 : n;  % Basic variable indices (slack variables)
A = [A b];  % Augment A with b to include RHS

% Dual Simplex iterations
for s = 1:50
    cb = c(bv_index);           % Coefficients of basic variables
    Xb = A(:, end);             % Current solution (RHS)
    z = cb * Xb;                % Objective function value
    zj_cj = cb * A(:, 1:n) - c; % Compute zj - cj row

    % Check optimality condition (Dual Simplex requires zj - cj >= 0)
    if all(zj_cj >= 0)
        disp('Optimal -> Go to Dual method complete');
    else
        disp('Not optimal');
        break;
    end

    % Feasibility check (Dual Simplex works with infeasible solutions: any Xb < 0)
    if all(Xb >= 0)
        disp('Feasible solution');
        break;
    end

    % Find pivot row (most negative RHS)
    [~, pvt_row] = min(Xb);

    % Ratio test to find pivot column
    for j = 1:n
        if A(pvt_row, j) < 0
            ratio(j) = abs(zj_cj(j) / A(pvt_row, j));
        else
            ratio(j) = inf;
        end
    end

    % Handle unboundedness
    if all(isinf(ratio))
        disp('Unbounded solution');
        break;
    end

    [~, pvt_col] = min(ratio);
    bv_index(pvt_row) = pvt_col;  % Update basic variable

    % Pivot operation
    pivot = A(pvt_row, pvt_col);
    A(pvt_row, :) = A(pvt_row, :) / pivot;

    for i = 1:m
        if i ~= pvt_row
            A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
        end
    end
end

% Display final solution
final_solution = zeros(1, n);
final_solution(bv_index) = A(:, end)';
disp('Final Optimal Solution:');
disp(final_solution);

optimal_value = c(bv_index) * A(:, end);
disp('Optimal Objective Function Value:');
disp(optimal_value);