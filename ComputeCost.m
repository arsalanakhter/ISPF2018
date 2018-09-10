function cost = ComputeCost(T1x, T1y, T2x, T2y)
    cost = sqrt((T1x - T2x)^2 + (T1y-T2y)^2);
