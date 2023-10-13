%% A model that generates free-running predictions of the logistic map at
%% different values of a
%
% Last Updated: August 16th, 2022

% Clear variables
clf; clearvars;

% Add paths
addpath('./helpers');

% Load well-performing hyper parameter values
vec = load('../scan/vectors/roberto3_vec.mat');
epsilon = vec.good_vec(1); eta = vec.good_vec(2);
kappa = vec.good_vec(3); beta = vec.good_vec(4);

% Specify logistic map parameters
nt = 1e4; x0 = 0.6; a = [3.2 3.5441 3.7 4];

% Specify reservoir size and times
sizes = [1 128 1];     % [inputSize reservoirSize outputSize]
time = [650 1500 40];    % [washout training testing]

% Generate pseudorandom input matrix
tmpData = genAnalyticalLogMapData( nt, x0, 1 );
U = tmpData(800 : 800 + sizes(2) - 1) - 0.5;

for ii = 1 : 4
    % Generate logistic map data
    data = genLogMapData( nt, x0, a(ii) );

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
                    'W_in', U);

    % Compute eigenvalues and eigenvectors
    [V, D] = circulant_eigensystem(esn.W);

    % Run ESN (train and test)
    [esn, X, Y, gt, err] = run_esn_closed(data, data, esn, V, D);

    % Plot prediction
    disp(real(err));

    figure(ii);
    plot(real(gt'), 'b', 'LineStyle', '-.', 'Marker', '.');
    hold on;
    plot(real(Y'), 'r', 'Marker', '.');
    hold off;
    axis tight;
    title('Time Series Prediction');
    legend('Ground Truth', 'Free-running Prediction');
    xlabel('time'); ylabel('magnitude');
    ylim([0 1]);
end