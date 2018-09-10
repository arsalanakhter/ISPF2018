function init = defineRobotLocations(init)
init.robotLocationsX = init.arenaSize * rand(init.noOfWorkerRobots, 1);
init.robotLocationsY = init.arenaSize * rand(init.noOfWorkerRobots, 1);
hold on 
plot(init.robotLocationsX, init.robotLocationsY, '*r');
hold off
init.arenaFigHandle = gca;
