clc;
clear;

% Cost vector (including artificial variables with Big M penalty)
c = [-2 -1 0 0 -1e5 -1e5];  % original c + slack + artificial variables (with -M)

% Coefficient matrix with slack and artificial variables added
A = [-3 -1 1 0 1 0;
     -4 -3 0 1 0 1];

% RHS
b = [-3; -6];

[m, n] = size(A);

% Initial basic variable indices (slack or artificial)
bv_index = [5 6];

% Create the full tableau (include b)
A = [A b];

% Start simplex iterations
for s = 1:50
    cb = c(bv_index);         % Cost coefficients of basic variables
    Xb = A(:, end);           % RHS values
    z = cb * Xb;              % Current value of objective function
    zj_cj = cb * A(:, 1:n) - c;  % zj - cj row

    fprintf('Iteration %d:\n', s);
    disp('Current BV index:'); disp(bv_index);
    disp('Tableau:'); disp(A);
    disp('zj - cj:'); disp(zj_cj);

    % Check for optimality
    if all(zj_cj >= 0)
        disp('Optimal solution found.');
        break;
    end

    % Find entering variable (most negative zj - cj)
    [~, pvt_col] = min(zj_cj);

    % Compute ratios for leaving variable
    ratios = inf(m, 1);
    for i = 1:m
        if A(i, pvt_col) > 0
            ratios(i) = A(i, end) / A(i, pvt_col);
        end
    end

    % Check for unboundedness
    if all(isinf(ratios))
        disp('Unbounded solution.');
        break;
    end

    % Find leaving variable (minimum ratio)
    [~, pvt_row] = min(ratios);
    bv_index(pvt_row) = pvt_col;

    % Pivot operation
    pivot = A(pvt_row, pvt_col);
    A(pvt_row, :) = A(pvt_row, :) / pivot;

    for i = 1:m
        if i ~= pvt_row
            A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
        end
    end
end

% Display final results
solution = zeros(1, n);
solution(bv_index) = A(:, end)';
disp('Final Basic Feasible Solution (x):');
disp(solution(1:4));  % Show only original + slack variables, not artificial

% Objective value
z_final = c(1:4) * solution(1:4)';
disp('Optimal Objective Function Value:');
disp(z_final);