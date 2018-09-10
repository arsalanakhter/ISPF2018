% Algorithm 1 
% Polynomial-Time Factor 2 Approximation Algorithm for the TSP in Metric
% Space
% Input: Robot Locations, Service Locations
clc, clear all, close all
init.arenaSize = 100;
init.arenaFigHandle = defineArena(init.arenaSize);
init.noOfTasks = 25;
init.noOfWorkerRobots = 1;
init.noOfNodes = init.noOfTasks+init.noOfWorkerRobots;
init = defineTaskLocations(init);
init = defineRobotLocations(init);
init.setOfNodesX = [init.robotLocationsX; init.taskLocationsX];
init.setOfNodesY = [init.robotLocationsY; init.taskLocationsY];
init = createCostMatrix(init);
init = createGraphWithNodes(init);
init.MST = minspantree(init.graph);
plot(init.MST, 'XData', init.MST.Nodes.X, 'YData', init.MST.Nodes.Y)
% Lets compute a DFS on G
tau = dfsearch(init.graph, 'R1');


