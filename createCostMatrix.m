function init = createCostMatrix(init)
init.nodesCostMatrix = zeros(init.noOfTasks+init.noOfWorkerRobots);
 for i = 1:init.noOfNodes
      for j = 1:init.noOfNodes
          init.nodesCostMatrix(i,j) = sqrt((init.setOfNodesX(i)-init.setOfNodesX(j))^2 ...
                          + (init.setOfNodesY(i)-init.setOfNodesY(j))^2);
      end
 end
