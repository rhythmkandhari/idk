clc;
clear;


cost = [19 30 50 10;
        70 30 40 60;
        40  8 70 20];


supply = [7 9 18];


demand = [5 8 7 14];


[m, n] = size(cost);


alloc = zeros(m, n);


s = supply;
d = demand;


while true
    % Find the least cost cell
    minVal = inf;
    for i = 1:m
        for j = 1:n
            if cost(i,j) < minVal && s(i) > 0 && d(j) > 0
                minVal = cost(i,j);
                row = i;
                col = j;
            end
        end
    end

   
    allocAmt = min(s(row), d(col));
    alloc(row, col) = allocAmt;

   
    s(row) = s(row) - allocAmt;
    d(col) = d(col) - allocAmt;


    if s(row) == 0
        cost(row, :) = inf;
    end
    if d(col) == 0
        cost(:, col) = inf;
    end

    if all(s == 0) && all(d == 0)
        break;
    end
end


disp('Allocation Matrix (Initial Basic Feasible Solution using LCM):');
disp(alloc);

totalCost = sum(sum(alloc .* [19 30 50 10;
                              70 30 40 60;
                              40  8 70 20]));
disp('Total Transportation Cost:');
disp(totalCost);
