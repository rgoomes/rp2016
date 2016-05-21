function data = feature_selection(data, verbose)
%FEATURE_SELECTION   Feature Selection using Kruskal-Wallis test
%
%   This function uses Kruskal-Wallis test to obtain the 5 features with
%   the best Chi-Sqr test and return them
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%   output: data:   structure containing the new set of features (data.X) and the
%                   classification for each example (data.y)
    data = correlation_analysis(data, verbose);
    data = kruskal_analysis(data, 10, true, verbose);
end

function data = correlation_analysis(data, verbose)
    correlated_feats = [];
    C = corrcoef(data.X');

    % how much features have to be correlated to remove one of them. The
    % correlation varies between -1 and 1. A value of 1.0 means higly correlated
    MAX_CORRELATION = 0.9;

    % indx is an array with numbers that represents features. The array is
    % ordered by chi2 in decreasing order, for example if indx=[3,1,2]
    % feature 3 has greater chi2 than feature 1 and 2
    indx = kruskal_analysis(data, 0, false, verbose);

    for i=1:data.dim
        for j=i+1:data.dim
            % if features i and j are correlated
            if(C(i,j) > MAX_CORRELATION)
                indxI = find(indx == i, 1);
                indxJ = find(indx == j, 1);

                % append to correlated_feats the feature that has the
                % greater indxI/J. Bigger indxI/J, means lesser chi2
                if indxI > indxJ
                    correlated_feats = [correlated_feats, i];
                elseif indxJ > indxI
                    correlated_feats = [correlated_feats, j];
                end
            end
        end
    end

    % make sure to not remove the same features twice
    correlated_feats = unique(correlated_feats);

    if verbose == true
        fprintf('Highly correlated features: %s of %d\n', mat2str(correlated_feats), data.dim);
    end

    % remove the features and update dim
    data.X(correlated_feats, :) = [];
    data.dim = data.dim - size(correlated_feats, 2);
end

function D = kruskal_analysis(data, k, do_update, verbose)
    S = [];
    new_data = [];

    for i = 1:data.dim
        [p,table,stats] = kruskalwallis(data.X(i, :), data.y', 'off');
        S = [S struct('chi2', cell2mat(table(2, 5)), 'feat', i)];
    end

    [~, indx] = sort([S(:).chi2], 'descend');

    if do_update ~= true
        D = indx;
        return;
    end

    k = min(k, data.dim);

    if verbose == true
        fprintf('Kruskal selected features:  %s of %d\n', mat2str(indx(1:k)), data.dim);
    end

    for i=1:k
        feature_line = S(indx(i)).feat;
        new_data = vertcat(new_data, data.X(feature_line, :));
    end
    
    D.X = new_data;
    D.y = data.y;
    D.dim = k;
end
