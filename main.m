clc, clear, clf, close all
set(0,'DefaultFigureWindowStyle','docked')
%% Lets Define the Arena
% Lets say the Arena is of 1000x1000mm
Arena.size = 1000;

%% Lets define 25 Targets randomly in this Arena

noOfTargets = 10;
setOfTargets = 1:noOfTargets;
setOfTargets = strtrim(cellstr(num2str(setOfTargets'))');
%setOfTargets = find(setOfTargets, 
% Keeping them in unit grids
Targets = ceil(Arena.size*rand(noOfTargets,2)); 
Tx = Targets(:,1);
Ty = Targets(:,2);
plot(Tx, Ty, 'o', 'MarkerEdgeColor', 'red');
hold on
ln = findobj('type','line');
set(ln,'marker','o','markers',10,'markerfa','w')
for i = 1:noOfTargets
    text(Tx(i), Ty(i), setOfTargets(i), 'HorizontalAlignment', 'center')
end

%% Lets Define Robots
% Lets Define the Fleet size to be K = 4, equal to the number of depots.
% Each Robot starts at a Depot
FleetSize = 4;
% Lets Define their start locations randomly. Lets also decide that the
% robots move in a grid with each cell of size 1x1mm
Robot(FleetSize).x = 0;
Robot(FleetSize).y = 0;

Robot(1).x = 250; %[250 250;750 250; 750 750; 250 750];
Robot(1).y = 250;
Rx(1) =  Robot(1).x;
Ry(1) = Robot(1).y;

Robot(2).x = 750; %[250 250;750 250; 750 750; 250 750];
Robot(2).y = 250;
Rx(2) =  Robot(2).x;
Ry(2) = Robot(2).y;

Robot(3).x = 750; %[250 250;750 250; 750 750; 250 750];
Robot(3).y = 750;
Rx(3) =  Robot(3).x;
Ry(3) = Robot(3).y;

Robot(4).x = 250; %[250 250;750 250; 750 750; 250 750];
Robot(4).y = 750;
Rx(4) =  Robot(4).x;
Ry(4) = Robot(4).y;


% for i = 1:FleetSize
%     Robot(i).x = [250 250;750 250; 750 750; 250 750];
%     Robot(i).y = ceil(1000*rand());
%     Rx(i) =  Robot(i).x;
%     Ry(i) = Robot(i).y;
% end

plot(Rx, Ry, '^', 'MarkerEdgeColor', 'blue' );
axis([0, 1000, 0, 1000])

%% Lets say each robot has a fuel Capacity between [0 1000], and it expends
% one unit of fuel for moving one grid cell straight or 1.5 units of fuel
% for moving diagonally. 
% Lets initialize all the robots with maxFuel. Also, maxFuel is always
% greater than twice the distance between a depot and furthest possible
% target. In current setting, the fuel is greater than 2*(250*sqrt(2))= 708
maxFuel = 710;
for i = 1:FleetSize
    Robot(i).Fuel = maxFuel;
end

%% Lets Define 4 Depots in this area with unlimited Fuel Capacity
% It seems that Sycara's paper distributes depots uniformly across the
% field, probably at equal distance from corners and each other, However,
% I couldn't find a specific mention. Lets assume 4 depots and place them 
% evenly. (I couldn't find how they place depots actually)
noOfDepots = 4;
Depots = [250 250;750 250; 750 750; 250 750]; 
Dx = Depots(:,1);
Dy = Depots(:,2);
plot(Dx, Dy, '*', 'MarkerFaceColor', 'Blue', 'color', 'Red', 'color' ,'Magenta');
legend('Targets','Robots','Depots', 'Location', 'best');
hold off
grid on
grid minor
% set(gca,'xtick',[0:1:1000])
% set(gca,'ytick',[0:1:1000])




%% Lets Define total no. of Nodes N = T U D
% where Nx and Ny denote X and Y of nodes respectively
noOfNodes = noOfTargets+noOfDepots;
Nx = [Tx; Dx];
Ny = [Ty; Dy];

% Lets create an adjacency matrix for these nodes
nodesAdjacencyMatrix = ones(noOfNodes) - eye(noOfNodes);

% NOw lets change nodesAdjacencyMatrix such that paths exist for
% targets only. Not Depots.

targetsAdjacencyMatrix = nodesAdjacencyMatrix;
for i = 1:noOfDepots
    for j = 1:noOfDepots
        %targetsAdjacencyMatrix(noOfTargets+i,noOfTargets+j) = 0;
        %targetsAdjacencyMatrix(noOfTargets+i,noOfTargets+j) = 0;
        targetsAdjacencyMatrix(noOfTargets+i,:) = 0;
        targetsAdjacencyMatrix(:,noOfTargets+j) = 0;

    end
end






%% Cost Matrix
% Now, Lets Define the Matrix that measures the cost from each node to
% each of the other node, where N = T U D. 

% We start the cost matrix considering all nodes, but compute initial costs
% for targets only, not considering the depots.
costMatrix = zeros(noOfNodes);
% Lets assume that a path exists from each target to each other target
% Lets Compute all the costs from each target to another target
% Lets define the cost as the Euclidean distance. Not a great approach but
% lets just go with it for the sake of time. Another way is by Ari,
% where you take the difference between x and y, take the smaller one and
% attach a sqrt(2) there, plus the difference we calcualted above

% The first implementation
 for i = 1:noOfNodes
      for j = 1:noOfNodes
          costMatrix(i,j) = sqrt((Nx(i)-Nx(j))^2 + (Ny(i)-Ny(j))^2)
      end
 end

% Ari's Method
% for i = 1:No_Of_Targets
%        for j = 1:No_Of_Targets
%            Target_Cost_Matrix(i,j) = Tx(i)-Ty(i) + 
%        end
%   end



%% Lets define a grpah based on the above cost, 
% 

G = graph
set_matrix(G,targetsAdjacencyMatrix)
figure
ndraw(G)


% MATLAB based graph constructor, not using it right now
% G = graph(costMatrix~=0)
% figure
% plot(G)
% figure
% % Add the costs as weights of the graph
% upperTriCostMatrix = triu(costMatrix);
% costVector = upperTriCostMatrix(:);
% costVector = costVector(costVector ~= 0);
% G.Edges.Weight = costVector;
% 
% plot(G,'EdgeLabel',G.Edges.Weight)
% 

%% Now we check each edge to see if it has a length less than maxFuel/2. 
% If the edge has a length higher than maxFuel/2 we add a detour. This
% detour is added through the closest depot. The edge cost is updated in
% the costMatrix, and path is added in the nodesAdjacencyMatrix passing through
% the  depot.

updatedPathsAdjacencyMatrix = targetsAdjacencyMatrix;
figure
for i = 1:noOfTargets
    for j = i:noOfTargets
        if i ~= j
            if costMatrix(i,j) > maxFuel/2
                % Reroute through the closest depot
                % First, decide the Depot to reroute from..
                % To do that, we compute the edge cost by passing through
                % all four depots, and see which depot has the least edge
                % cost among all four.
                [leastCostDepotNo, leastCostDepotX, leastCostDepotY, newCost] = ...
                    FindLeastCostDepot(Tx(i), Ty(i), Tx(j), Ty(j));
                % update the updatedPathsAdjacencyMatrix, and update it with
                % updated paths.
                % Remove the two edges between the targets
                updatedPathsAdjacencyMatrix(i,j) = 0;
                updatedPathsAdjacencyMatrix(j,i) = 0;
                clf;set_matrix(G,updatedPathsAdjacencyMatrix);ndraw(G);
                % Add edges from targets to depots
                updatedPathsAdjacencyMatrix(i, noOfTargets+leastCostDepotNo) = 1;
                %set_matrix(G,updatedPathsAdjacencyMatrix);ndraw(G);
                updatedPathsAdjacencyMatrix(noOfTargets+leastCostDepotNo,i) = 1;
                clf;set_matrix(G,updatedPathsAdjacencyMatrix);ndraw(G);
                updatedPathsAdjacencyMatrix(j, noOfTargets+leastCostDepotNo) = 1;
                %set_matrix(G,updatedPathsAdjacencyMatrix);ndraw(G);
                updatedPathsAdjacencyMatrix(noOfTargets+leastCostDepotNo,j) = 1;
                clf;set_matrix(G,updatedPathsAdjacencyMatrix);ndraw(G);
                
                % Update costMatrix
                costMatrix(i,j) = newCost;
                costMatrix(j,i) = newCost;
                            
                % Update Graph
                % set_matrix(G,updatedPathsAdjacencyMatrix)
                % ndraw(G)
                
                pause(0.3)
            end
        end
    end 
end

 %% Lets now compute a Hamiltonian path through these nodes

 
embedding = [Nx';Ny']';
embed(G, embedding);

% If a node is not connected, identify it and remove it from graph
nodesToBeDeleted = [];
for i = 1:noOfNodes
    if (deg(G,i) == 0)
        nodesToBeDeleted = [nodesToBeDeleted, i]
    end
end

if (~isempty (nodesToBeDeleted ))
    delete(G, nodesToBeDeleted)
end
c = hamiltonian_cycle(G);
n = nv(G);
h = graph(n);
for k=1:n-1
	add(h,c(k),c(k+1))
end
%add(h,c(1),c(n))
embed(h, getxy(G))

figure

ndraw(G, ':')
ndraw(h) 

%% Splitting Algorithm

% Lets first calculate the total cost of Hamiltonian Path
hamiltonianPathCost=[];
hamiltonianPathEdgesWithCost=[];
for i = 1:noOfNodes-1
    hamiltonianPathCost(i) = costMatrix(c(i), c(i+1));
    hamiltonianPathEdgesWithCost = [hamiltonianPathEdgesWithCost; ...
        [hamiltonianPathCost(i),c(i), c(i+1)]];
end

L_Crit = sum(hamiltonianPathCost)/FleetSize;

% Sort them in the order of descending cost

descendingHamiltonianPathCost = flipud(sortrows(hamiltonianPathEdgesWithCost,1));
% descendingHamiltonianPathCostIdx = flip(I); 



%% Removal of Edges
% Lets do this for n = 1. Lets remove one edge, and see what is the length
% of the makespan, by computing resulting costs.
ii=1;
hamiltonianAdjacencyMatrixUpdated = [];
hamiltonianAdjacencyMatrix = matrix(h);
hamiltonianAdjacencyMatrixUpdated.ii = matrix(h);
test = hamiltonianAdjacencyMatrixUpdated.ii;
% Lets remove one edge. The highest cost one

hamiltonianAdjacencyMatrixUpdated(descendingHamiltonianPathCost(1,2), ...
    descendingHamiltonianPathCost(1,3)) = 0;

hamiltonianAdjacencyMatrixUpdated(descendingHamiltonianPathCost(1,3), ...
    descendingHamiltonianPathCost(1,2)) = 0;

clf;set_matrix(h,test);ndraw(G,':');ndraw(h);

% Now lets check both of these two suslackb-paths to see if by the removal of an
% edge, the resulting sub-path(s) are less than L_crit


% First check if the resulting path is less than L_crit. If it is, then 

% Lets define n_req = n_req + max(ceil(cost(s)/L_crit),1)


%free(G)