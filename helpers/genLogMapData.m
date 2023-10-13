%% A function that generates a time series of logistic map data through
%% discrete recursion

function data = genLogMapData( nt , x0 , r )
% nt -- # of time points
% x0 -- initial state value
% r -- parameter value

data = nan(nt,1);
data(1) = logmap(x0,r);
for t = 2 : nt
    data(t) = logmap( data(t-1) , r );
end