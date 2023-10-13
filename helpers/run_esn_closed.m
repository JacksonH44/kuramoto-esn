% A function that runs a Kuramoto ESN that is fitted with the 'closed' form
% activation function (kuramoto_analytical). This is as opposed to the
% iterative update rule (I think this is used in the K) papers and the
% itrative update rule (kuramoto_gb) is used in WC1.
%
% Last Updated: July 20, 2022

function [esn, X, Y, gt, err] = run_esn_closed(train_data, test_data, esn, V, D)

    X = nan(esn.res_size, esn.T0 + esn.T_train + esn.T_test);

    % washout
    x = kuramoto_gb(esn, train_data(1), zeros(esn.res_size, 1));
    X( : , 1)  = x;
    for t = 2 : esn.T0
        x = kuramoto_analytical(esn, train_data(t), x, V, D);
%         x = kuramoto_gb(esn, train_data(t), x);
        X( : , t ) = x;
    end

    % training
    for t = (esn.T0 + 1) : (esn.T0 + esn.T_train)
        x = kuramoto_analytical(esn, train_data(t), x, V, D);
%         x = kuramoto_gb(esn, train_data(t), x);
        X( : , t ) = x;
        R( : , t - esn.T0 ) = x;
        Y_t( : , t - esn.T0 ) = train_data(t+1);
    end
    W_out = lsqminnorm(R',Y_t')';

    esn.W_out = W_out;

    % testing
     u = test_data(t+1);
    for t = ( esn.T0 + esn.T_train + 1) : ( esn.T0 + esn.T_train + esn.T_test)
        x = kuramoto_analytical(esn, u, x, V, D);
%         x = kuramoto_gb(esn, u, x);
        y = W_out * x;
        Y( : , t - esn.T0 - esn.T_train ) = y;
        X( : , t ) = x;
        u = y;
        gt( : , t - esn.T0 - esn.T_train ) = test_data(t+1); % ground truth
    end
     
    err = corr(Y(1,:)', gt(1,:)');   
end