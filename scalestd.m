%data.X = one feature per line
function data = scalestd(data)
    %Calculate mean and stdev of each feature
    d = data.X;
    m = mean(d');
    s = std(d');
    
    %Normalize each feature using the mean and stdev
    out = zeros(size(d, 1), size(d, 2));
    for i = 1:size(d, 1)
        out(i, :) = (d(i, :) - m(i)) / s(i);
    end
    data.X = out;
end