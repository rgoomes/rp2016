function data = feature_selection(data)
%FEATURE_SELECTION   Feature Selection using Kruskal-Wallis test
%
%   This function uses Kruskal-Wallis test to obtain the 5 features with
%   the best Chi-Sqr test and return them
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%   output: data:   structure containing the new set of features (data.X) and the
%                   classification for each example (data.y)
    data = kruskal_analysis(data, 'Kruskal Wallis');
end

function data = kruskal_analysis(data, string)
    for i = 1:data.dim
        [p,table,stats] = kruskalwallis(data.X(i, :), data.y', 'off');
        chi_sqr(i) = table(2, 5);
    end
    
    data.X = data.X(6:7, :);
end