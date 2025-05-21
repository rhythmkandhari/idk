clc;
clear all;

a = [1 4 0; 3 1 0; 1 2 0];
b = [29; 21; 18];
c = [5 0 0];

[m, n] = size(a);
s = eye(m);
A = [a s b];
cost = zeros(1, size(A,2));
cost(1:n) = c;
bv = n+1:n+m;

zj_cj = cost(bv) * A - cost;
zcj = [A; zj_cj];

RUN = true;
iter = 0;
max_iter = 100;

while RUN && iter < max_iter
    iter = iter + 1;
    
    if all(zj_cj(1:end-1) >= 0)
        fprintf('The current solution is optimal\n');
        break
    end

    [min_value, pvt_col] = min(zj_cj(1:end-1));

    if all(A(:, pvt_col) <= 0)
        error('LPP is unbounded');
    else
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
        bv(pvt_row) = pvt_col;

        pvt_key = A(pvt_row, pvt_col);

        A(pvt_row, :) = A(pvt_row, :) / pvt_key;

        for i = 1:size(A,1)
            if i ~= pvt_row
                A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
            end
        end

        zj_cj = cost(bv) * A - cost;
        zcj = [A; zj_cj];
    end
end

solution = zeros(1, size(A,2)-1);
solution(bv) = A(:, end)';

fprintf('\nFinal Optimal Solution:\n');
disp('Variable Values (Only original decision variables):')
disp(solution(1:n))

fprintf('Optimal Value of Objective Function:\n');
optimal_value = c * solution(1:n)';
disp(optimal_value);
