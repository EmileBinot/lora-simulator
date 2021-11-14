function y = d2b(x,m)
    c = max(0,floor(log2(x))) + 1; % Number of divisions necessary ( rounding up the log2(x) )
    if nargin<2
        m=c;
    end
    shift = m-c;
    y(m) = 0; % Initialize output array
    
    for i = 1:c
        r = floor(x / 2);
        y(shift+c+1-i) = x - 2*r;
        x = r;
    end
end