function init = defineTaskLocations(init)
init.taskLocationsX = init.arenaSize * rand(init.noOfTasks, 1);
init.taskLocationsY = init.arenaSize * rand(init.noOfTasks, 1);
hold on 
plot(init.taskLocationsX, init.taskLocationsY, '.b');
hold off
init.arenaFigHandle = gca;
