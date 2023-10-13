% A function that updates the Kuramoto analytical solution as follows:
%
% theta[t] = e^{idiag(Ux[t])} * Ve^{Dt}V^{-1} * x[t-1]
%
% Last Updated: July 20, 2022

function x_t = kuramoto_analytical(esn, u, x, V, D)
    % Windowed Approach
    t = 1;
    x_t = exp(1i*esn.W_in*(u+esn.bias)*t) .* (V * expm(D * t) * V') * x;
    x_t = x_t ./ (abs(x_t));
end