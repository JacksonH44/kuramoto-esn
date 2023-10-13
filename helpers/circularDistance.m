%% A function that returns a distance matrix of size NxN 

function D = circularDistance(N)
    D = nan(N);
    for ii = 1 : N
        for jj = 1 : N
            % For each pair of nodes, compute the circular distance between
            % them. Notice that necessarily the circular distance between a
            % node and itself is 0
            tmp = abs(ii-jj);
            D(ii,jj) = min(tmp,N-tmp);
        end
    end
end