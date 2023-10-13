%% A function that creates an ESN with all relevant parameters specified 
%% by the user
%
% May 18th, 2022

function esn = setup_esn_gb(args)

    arguments
       args.T0
       args.T_train
       args.T_test
       args.in_size
       args.res_size
       args.out_size
       args.knn
       args.readin_scale
       args.coupling_strength
       args.bias
       args.W_in
    end
    
    % Assign args attributes to the ESN
    esn.T0 = args.T0;
    esn.T_train = args.T_train;
    esn.T_test = args.T_test;
    esn.in_size = args.in_size;
    esn.res_size = args.res_size;
    esn.out_size = args.out_size;
    esn.knn = args.knn;
    esn.readin_scale = args.readin_scale;
    esn.coupling_strength = args.coupling_strength;
    esn.bias = args.bias;
    
    % Randomly generate the weights for the readin matrix and scale it
    % accordingly
%     esn.W_in = esn.readin_scale * ones(esn.res_size,esn.in_size);
    if isfield(args,'W_in')
        esn.W_in = args.W_in .* esn.readin_scale;
    else
        esn.W_in = ( rand( esn.res_size, esn.in_size) - 0.5 ) .* esn.readin_scale;
    end

    % Generate a ring graph as the reservoir matrix
    esn.W = esn.coupling_strength * ring_graph(esn.res_size, esn.knn);

end