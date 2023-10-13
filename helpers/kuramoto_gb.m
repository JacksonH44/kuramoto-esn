%% A function that updates reservoir weights according to the 
%% Kuramoto model
% The update equation is as follows:
% 
% theta_i[t] - theta_i[t-1] = 
%   omega_i + epsilon * sum_{j} W_{ij} * sin( theta_j[t-1] - theta_i[t-1] )
%
% Then rearranging, we get:
%
% theta_i[t] = omega_i + 
%              epsilon * sum_{j} W_{ij} * sin( theta_j[t-1] - theta_i[t-1] )
%              + theta_i[t-1]
%
% Note: omega_i is defined as the input multiplied by the readin matrix,
% W_in*u
% theta_i is abbreviated to ct in this program

function x = kuramoto_gb(esn,u,x)
    ct = -1i*exp(-1i*x) .* esn.W * exp(1i*x); % coupling term
    x = x + ( esn.W_in*(u+esn.bias) + ct );
    x = x ./ abs(x);
end