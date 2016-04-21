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
    data = kruskal_analysis(data, 'Kruskal Wallis', 5);
end

function data = kruskal_analysis(data, string, k)
    S = [];
    new_data = [];

    for i = 1:data.dim
        [p,table,stats] = kruskalwallis(data.X(i, :), data.y', 'off');
        S = [S struct('chi2', cell2mat(table(2, 5)), 'feat', i)];
    end

    [~, indx] = sort([S(:).chi2], 'descend');

    for i=1:k
        new_data = vertcat(new_data, data.X(S(indx(i)).feat, :));
    end
    
    data.X = new_data;
end