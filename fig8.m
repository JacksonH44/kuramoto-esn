%% A function that generates a prediction of the logistic map at a = 4
%% with an output matrix that has been trained and optimized for 
%% predicting at a = 3.9999
%
% Last Updated: August 16th, 2022

clf; clearvars;

% Add relevant paths
addpath(genpath('../kuramoto-model/helpers'));
addpath(genpath('../kuramoto-model/kuramoto'));
addpath(genpath('../examples/closed-update'));

% Generate logistic map data for the output matrix training case
nt = 1e4; x0 = 0.6; a = 3.9999;
data1 = genLogMapData( nt , x0 , a ); % (nt, x0, a)

% Generate logistic map data for the second case (different a value)
nt = 1e4; x0 = 0.6; a = 4;
data2 = genLogMapData(nt, x0, a);

% Load well-performing point in hyperparameter space
vec = load('../scan/vectors/roberto3_vec.mat');
epsilon = vec.good_vec(1); eta = vec.good_vec(2); 
kappa = vec.good_vec(3); beta = vec.good_vec(4);

% Specify reservoir size and times
sizes = [1 128 1];     % [inputSize reservoirSize outputSize]
time = [650 1500 40];    % [washout training testing]

% Generate pseudorandom input matrix
tmpData = genAnalyticalLogMapData( nt, x0, 1 );
W_in = tmpData(800:800 + sizes(2) - 1) - 0.5;

% Set up ESN
esn = setup_esn_gb('T0', time(1), ...
                   'T_train', time(2), ...
                   'T_test', time(3), ...
                   'in_size', sizes(1), ...
                   'res_size', sizes(2), ...
                   'out_size', sizes(3), ...
                   'knn', kappa, ...
                   'coupling_strength', epsilon, ...
                   'readin_scale', eta, ...
                   'bias', beta, ...
                   'W_in', W_in);

% Compute eigenvectors and eigenvalues
[V, D] = circulant_eigensystem(esn.W);


% Run ESN for the first case
[esn1, X1, Y1, gt1, err1] = run_esn_closed(data1, data1, esn, V, D);

% Run ESN for the second case
[esn2, X2, Y2, gt2, err2] = run_esn_closed(data2, data2, esn, V, D);

% Test new learning matrix
x = X2(:,end);
u = data2(esn2.T0 + esn2.T_train + 1);
for t = ( esn2.T0 + esn2.T_train + 1) : ( esn2.T0 + esn2.T_train + esn2.T_test)
    x = kuramoto_analytical(esn2, u, x, V, D);
    y = esn1.W_out * x;
    Y( : , t - esn1.T0 - esn1.T_train ) = y;
    u = y;
 end

% Compute and display performance
plot_data(X2, real(Y), 0, gt2);