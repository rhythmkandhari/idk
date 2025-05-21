clc;
clear all;

% Input Data
a = [1 4 0; 3 1 0; 1 2 0];        % Coefficients of constraints
b = [29; 21; 18];                 % RHS values
c = [5 0 0];                      % Cost vector

% Construct Simplex Table
[m, n] = size(a);
s = eye(m);                       % Slack variables
A = [a s b];                      % Augmented matrix with slack and RHS
cost = zeros(1, size(A,2));
cost(1:n) = c;                    % Cost vector with 0s for slack
bv = n+1:n+m;                     % Basic variable indices

% Initial zj - cj row
zj_cj = cost(bv) * A - cost;
zcj = [A; zj_cj];                 % Simplex table with zj - cj

% Iterative Process
RUN = true;
iter = 0;
max_iter = 100;                   % Safety limit

while RUN && iter < max_iter
    iter = iter + 1;
    
    if all(zj_cj(1:end-1) >= 0)
        fprintf('The current solution is optimal\n');
        break
    end

    % Step 1: Pivot Column
    [min_value, pvt_col] = min(zj_cj(1:end-1));

    % Step 2: Check for Unboundedness
    if all(A(:, pvt_col) <= 0)
        error('LPP is unbounded');
    else
        % Step 3: Pivot Row
        sol = A(:, end);
        column = A(:, pvt_col);
        ratio = zeros(size(A,1),1);
        for i = 1:size(A,1)
            if column(i) > 0
                ratio(i) = sol(i) / column(i);
            else
                ratio(i) = inf;
            end
        end
        [leaving_val, pvt_row] = min(ratio);
        bv(pvt_row) = pvt_col;                 % Update basic variable

        % Step 4: Pivot Key
        pvt_key = A(pvt_row, pvt_col);

        % Step 5: Update Pivot Row
        A(pvt_row, :) = A(pvt_row, :) / pvt_key;

        % Step 6: Update Other Rows
        for i = 1:size(A,1)
            if i ~= pvt_row
                A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
            end
        end

        % Step 7: Update zj - cj
        zj_cj = cost(bv) * A - cost;
        zcj = [A; zj_cj];    % Updated Simplex Table
    end
end

% Final Solution
solution = zeros(1, size(A,2)-1);  % Decision + slack variables
solution(bv) = A(:, end)';         % Fill values for basic variables

fprintf('\nFinal Optimal Solution:\n');
disp('Variable Values (Only original decision variables):')
disp(solution(1:n))

fprintf('Optimal Value of Objective Function:\n');
optimal_value = c * solution(1:n)';  % FIXED LINE
disp(optimal_value);