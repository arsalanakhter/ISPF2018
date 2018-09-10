function [leastCostDepotNo, leastCostDepotX, leastCostDepotY, newCost] = ...
                    FindLeastCostDepot(T1x, T1y, T2x, T2y)
                
Depots = [250 250;750 250; 750 750; 250 750]; 
Dx = Depots(:,1);
Dy = Depots(:,2);

% Compute cost of T1 from 1st Depot
costT11 = ComputeCost(T1x, T1y, Dx(1), Dy(1));

% Compute cost of T2 from 1st Depot
costT21 = ComputeCost(T2x, T2y, Dx(1), Dy(1));

% Add the total cost.
costT1T2(1) = costT11 + costT21;

% Compute cost of T1 from 2nd Depot
costT12 = ComputeCost(T1x, T1y, Dx(2), Dy(2));

% Compute cost of T2 from 2nd Depot
costT22 = ComputeCost(T2x, T2y, Dx(2), Dy(2));

% Add the total cost.
costT1T2(2) = costT12 + costT22;

% Compute cost of T1 from 3rd Depot
costT13 = ComputeCost(T1x, T1y, Dx(3), Dy(3));

% Compute cost of T2 from 3rd Depot
costT23 = ComputeCost(T2x, T2y, Dx(3), Dy(3));

% Add the total cost.
costT1T2(3) = costT13 + costT23;

% Compute cost of T1 from 1st Depot
costT14 = ComputeCost(T1x, T1y, Dx(4), Dy(4));

% Compute cost of T2 from 1st Depot
costT24 = ComputeCost(T2x, T2y, Dx(4), Dy(4));

% Add the total cost.
costT1T2(4) = costT14 + costT24;

[leastCost, leastCostDepot]= min(costT1T2);


% Assign final values for returning
leastCostDepotNo = leastCostDepot;
leastCostDepotX = Dx(leastCostDepot);
leastCostDepotY = Dy(leastCostDepot);
newCost = leastCost;


