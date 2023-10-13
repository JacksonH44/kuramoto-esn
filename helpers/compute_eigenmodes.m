%% A function that computes the eigenmodes of a state matrix
%
% Last updated: June 2, 2022

function modes = compute_eigenmodes(t, eigenvecs, X)

    N = size(X, 1);
    modes = nan(N,1);

    for ii = 1:N
        modes(ii,:) = eigenvecs(:,ii)' * X(:,t); % Compute dot product
    end

end