clc;
clear;

% Cost matrix (m x n)
cost = [19 30 50 10;
        70 30 40 60;
        40  8 70 20];

% Supply vector (rows)
supply = [7 9 18];

% Demand vector (columns)
demand = [5 8 7 14];

% Dimensions
[m, n] = size(cost);

% Allocation matrix
alloc = zeros(m, n);

% Make copies to work with
s = supply;
d = demand;

% Loop until all supplies or demands are met
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

    % Allocate the minimum of supply and demand
    allocAmt = min(s(row), d(col));
    alloc(row, col) = allocAmt;

    % Update supply and demand
    s(row) = s(row) - allocAmt;
    d(col) = d(col) - allocAmt;

    % Set row/column cost to inf if supply/demand is exhausted
    if s(row) == 0
        cost(row, :) = inf;
    end
    if d(col) == 0
        cost(:, col) = inf;
    end

    % Stop if all demands and supplies are satisfied
    if all(s == 0) && all(d == 0)
        break;
    end
end

% Display results
disp('Allocation Matrix (Initial Basic Feasible Solution using LCM):');
disp(alloc);

% Calculate total cost
totalCost = sum(sum(alloc .* [19 30 50 10;
                              70 30 40 60;
                              40  8 70 20]));
disp('Total Transportation Cost:');
disp(totalCost);