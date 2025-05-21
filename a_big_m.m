clc;
clear;


c = [-2 -1 0 0 -1e5 -1e5]; 


A = [-3 -1 1 0 1 0;
     -4 -3 0 1 0 1];


b = [-3; -6];

[m, n] = size(A);


bv_index = [5 6];


A = [A b];


for s = 1:50
    cb = c(bv_index);       
    Xb = A(:, end);           
    z = cb * Xb;              
    zj_cj = cb * A(:, 1:n) - c;  % zj - cj row

    fprintf('Iteration %d:\n', s);
    disp('Current BV index:'); disp(bv_index);
    disp('Tableau:'); disp(A);
    disp('zj - cj:'); disp(zj_cj);

    
    if all(zj_cj >= 0)
        disp('Optimal solution found.');
        break;
    end

   
    [~, pvt_col] = min(zj_cj);

    ratios = inf(m, 1);
    for i = 1:m
        if A(i, pvt_col) > 0
            ratios(i) = A(i, end) / A(i, pvt_col);
        end
    end

    if all(isinf(ratios))
        disp('Unbounded solution.');
        break;
    end


    [~, pvt_row] = min(ratios);
    bv_index(pvt_row) = pvt_col;

  
    pivot = A(pvt_row, pvt_col);
    A(pvt_row, :) = A(pvt_row, :) / pivot;

    for i = 1:m
        if i ~= pvt_row
            A(i, :) = A(i, :) - A(i, pvt_col) * A(pvt_row, :);
        end
    end
end


solution = zeros(1, n);
solution(bv_index) = A(:, end)';
disp('Final Basic Feasible Solution (x):');
disp(solution(1:4));  % Show only original + slack variables, not artificial

z_final = c(1:4) * solution(1:4)';
disp('Optimal Objective Function Value:');
disp(z_final);
