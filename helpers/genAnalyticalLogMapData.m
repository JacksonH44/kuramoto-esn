%% A function that generates logistic map data at a = 4 through two 
%% methods: 
%%
%% opt = 1: Using the windowed apporoach to generating the logistic map
%% opt = 0: Using the symbolic math approach to generating the logistic 
%% map. Note: this approach can only generate up to 2180 time steps

function data = genAnalyticalLogMapData(nt,x0, opt)

data = zeros(nt,1);

if opt

    windSize = 50;
    
    number_windows = ceil( nt / windSize );
    data( 1:windSize ) = 1/2 .* (1 - cos( (vpa(2).^(1:windSize)) .* acos( 1 - 2.*x0 ) ) );
    for ii = 2:number_windows
        idx = (windSize)*(ii-1) + (1:windSize);
        data( idx ) = 1/2 .* (1 - cos( (vpa(2).^(1:windSize)) .* acos( 1 - 2.*data( idx(1)-1 ) ) ) );
    end

%     for ii = 1:nt
%         j = mod(ii, windSize);
%         if ~j
%             j = windSize;
%         elseif j == 1 && ii ~= 1
%             x0 = data(ii-1);
%         end
%         data(ii) = 1/2 * (1 - cos( 2^j * acos( 1 - 2*x0 ) ));
%     end
   
else 
    data(1:nt) = 1/2 * (1 - cos( (vpa(2).^(1:nt)) * acos( 1 - 2*x0 )) ); 
end

end

