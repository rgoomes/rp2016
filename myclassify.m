function results = myclassify(do_equalize, do_reduce, reduce_ratio_txt, ...
    do_normalize, do_feature_selection, kruskalK, max_correlation, ...
    do_pca, do_lda, split_percentage, classifier_type, knn_k, verbose)

%MYCLASSIFY   Main Classifier Function
%
%   This function reads the data file and calls all the necessary
%   functions to select and reduce features. A performance test is also run
%   after the data is processed
%
%   args:   None
%   output: None

    clc
    
    %One column = one feature
    feats = csvread('data.csv', 2);
    
    %One line = one feature
    data.X = feats(:, 2:end - 1)';
    data.y = feats(:, end)';
    data.y = data.y + 1;
    
    %Number of features
    data.dim = size(data.X, 1);
    %Number of samples
    data.num_data = size(data.X, 2);

    if do_equalize == true
        data = equalize(data);
    end

    if do_reduce == true
        data = reduce(data, reduce_ratio_txt);
    end

    if do_normalize == true
        data = scalestd(data);
    end

    %tune_features(data);
    if do_feature_selection == true
        data = feature_selection(data, kruskalK, max_correlation, false, verbose);
    end

    data = feature_reduction(data, do_pca, do_lda, verbose);
    results = perft(data, split_percentage, classifier_type, knn_k, verbose);
end

function r = getGlobalBS()
    global best_score
    r = best_score;
end

function setGlobalBS(val)
    global best_score
    best_score = val;
end

function r = getGlobalBF()
    global best_features
    r = best_features;
end

function setGlobalBF(val)
    global best_features
    best_features = val;
end

function r = getGlobalTOTAL()
    global total
    r = total;
end

function setGlobalTOTAL(val)
    global total
    total = val;
end

function dfs(feats, allfeats, pointer, inc, data)
    if inc == true
        setGlobalTOTAL(getGlobalTOTAL() + 1);
        perftData = data;
        perftData.X = perftData.X(feats, :);
        perftData.dim = length(feats);
        results = perft(perftData, 0.7, 'knn', '50', false);
        b = sum(results);

        if b > getGlobalBS()
            setGlobalBS(b);
            setGlobalBF(feats);
            fprintf('Fitness: %.2f, Features: %s, Total = %d\n', b, mat2str(getGlobalBF()), getGlobalTOTAL());
        end
    end

    if pointer == length(allfeats);
        return
    end

    next = pointer+1;

    dfs([feats allfeats(pointer)], allfeats, next, true, data);
    dfs(feats, allfeats, next, false, data);
end

function data = tune_features(data)
    setGlobalTOTAL(0);
    setGlobalBS(0);
    setGlobalBF([]);

    allfeats = 1:data.dim;
    to_remove = feature_selection(data, 0, 0.9, true, false);
    allfeats(to_remove) = [];

    dfs([], allfeats, 1, false, data);

    data.X = data.X(getGlobalBF(), :);
    data.dim = size(data.X, 1);

    disp('Feature tuning ended');
end

function data = reduce(data, reduce_factor)
    reduce_factor = max(reduce_factor, 0.0001);
    reduce_factor = min(reduce_factor, 1.0000);

    ind0 = find(data.y == 1);
    ind1 = find(data.y == 2);

    ind1 = ind1(randperm(length(ind1)));
    ind1 = ind1(1: round(reduce_factor * length(ind1)));

    ind0 = ind0(randperm(length(ind0)));
    ind0 = ind0(1: round(reduce_factor * length(ind0)));

    ind = [ind0 ind1];

    data.X = data.X(:, ind);
    data.y = data.y(:, ind);
    data.num_data = length(data.X);
end

function data = equalize(data)
    ind0 = find(data.y == 1);
    ind1 = find(data.y == 2);

    ind1 = ind1(randperm(length(ind1)));
    ind1 = ind1(1: length(ind1));

    ind0 = ind0(randperm(length(ind0)));
    ind0 = ind0(1: length(ind0)-length(ind1));

    % remove picked indices
    data.X(:, ind0) = [];
    data.y(:, ind0) = [];

    % update data size
    data.num_data = length(data.X);
end