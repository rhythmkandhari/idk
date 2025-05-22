a = [1 2 1 0 0 0 3; 4 3 0 1 0 0 6; 3 1 0 0 1 0 3];
BV = [3 5 6];
variables = ['X1' 'X2' 'S1' 'S2' 'A1' 'A2' 'Sol'];
cost = [0 0 0 0 -1 -1 0];
startBV = find(cost < 0);
zjcj = cost(BV) * a - cost;
RUN = true;

while RUN
    ZC = zjcj(1:end-1);
    if any(ZC < 0)
        fprintf('not optimal\n')
        [EV, PV] = min(ZC); %%% PV is pivot element
        sol = a(:, end);
        column = a(:, PV);
        
        if all(column <= 0)
            error('unbounded');
        else
            for i = 1:size(a,1)
                if column(i) > 0
                    ratio(i) = sol(i) / column(i);
                else
                    ratio(i) = inf; %% inf is infinity
                end
            end
            
            [minratio, PV_row] = min(ratio);
        end

        BV(PV_row) = PV;  %%% PV is pivot column
        PV_key = a(PV_row, PV);
        a(PV_row, :) = a(PV_row, :) / PV_key;

        for i = 1:size(a,1)
            if i ~= PV_row
                a(i, :) = a(i, :) - a(i, PV) * a(PV_row, :);
            end
        end

        zjcj = cost(BV) * a - cost;

    else
        RUN = false;
        fprintf('optimal solution found\n');
    end
end
