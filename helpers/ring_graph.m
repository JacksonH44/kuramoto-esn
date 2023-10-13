%% A function that generates a ring graph of size N and with k nearest 
%% neighbours
%
% May 16th, 2022

function A = ring_graph(N, k)
    % Generate a matrix of all circular distances between nodes
    D = circularDistance(N);
    A = D;
    K = k;
    
    % If the circular distance is greater than that of the kth nearest
    % neighbour, set that value to 0 (no connection)
    % If the circular distance is less than that of the kth nearest
    % neighbour, set that value to 1 (connection)
    A(A>K) = 0;
    A(A~=0) = 1;
end