function data = scalestd(data)
%SCALESTD   Feature Standardization
%
%   This function standardizes features by removing the mean and scaling
%   to unit variance
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%
%   output: data:   structure containing the new set of features (data.X) and the
%                   classification for each example (data.y)   
    d = data.X;
    m = mean(d');
    s = std(d');
    
    out = zeros(size(d, 1), size(d, 2));
    for i = 1:size(d, 1)
        out(i, :) = (d(i, :) - m(i)) / s(i);
    end
    data.X = out;
end