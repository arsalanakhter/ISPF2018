function fig = defineArena(arenaSize)
set(0,'DefaultFigureWindowStyle','docked')% Dock the figure
fig = figure;
hold on
axis([0 arenaSize 0 arenaSize]);
title('Test Arena');
xlabel('x-axis')
ylabel('y-axis')
grid on
end