function init = createGraphWithNodes(init)
targetNodeNames = 1:init.noOfTasks;
robotNodeNames = 1:init.noOfWorkerRobots;
init.targetNodeNames = strtrim(cellstr(num2str(targetNodeNames'))');
init.robotNodeNames =  strtrim(cellstr(num2str(robotNodeNames'))');
init.robotNodeNames = join(['R', init.robotNodeNames], '');
init.nodeNames = [init.robotNodeNames init.targetNodeNames];
init.graph = graph(init.nodesCostMatrix, init.nodeNames);
init.graph.Nodes.X = [init.robotLocationsX; init.taskLocationsX];
init.graph.Nodes.Y = [init.robotLocationsY; init.taskLocationsY];
figure
plot(init.graph, 'XData', init.graph.Nodes.X, 'YData', init.graph.Nodes.Y ...
    )