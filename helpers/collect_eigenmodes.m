%% A function that collects the eigenmodes of a system 
%
% Last updated: July 14, 2022

function [eigenmodes] = collect_eigenmodes (esn, X)

    addpath(genpath('../'));

    % Collect ESN specifications
    W = esn.W; time = esn.T0 + esn.T_train + esn.T_test;

    % Compute eigenvalues and eigenvectors V - eigenvectors, D -
    % eigenvalues
    [V, ~] = circulant_eigensystem(W);

    % Compute eigenmodes
    N = size(W, 1);
    eigenmodes = nan(N, time);

    for ii = 1:time
        eigenmodes(:, ii) = compute_eigenmodes(ii, V, X);
    end
end