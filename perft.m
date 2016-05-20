function perft(data, string, verbose)
%PERFT   Performance Test
%
%   This function runs a performance test using the input data and a
%   minimum-distance classifier. The data is divided randomly
%
%   args:   data:    structure containing a set of features (data.X) and the
%                    classification for each example (data.y)
%           string:  description that is printed along with the results
%           verbose: display extra information. Valid values are true and false
%   output: None
    fprintf('Performance Test: %s\n', string)

    ind0 = find(data.y == 0);
    ind1 = find(data.y == 1);
    [train_1, ~, test_1] = dividerand(size(ind1, 2), 0.7, 0, 0.3);
    [train_0, ~, test_0] = dividerand(size(ind0, 2), 0.7, 0, 0.3);
    
    train_data.X = horzcat(data.X(:, ind0(train_0)), data.X(:, ind1(train_1)));
    train_data.y = horzcat(data.y(:, ind0(train_0)), data.y(:, ind1(train_1)));
    test_data = horzcat(data.X(:, ind0(test_0)), data.X(:, ind1(test_1)));
    test_data_class = horzcat(data.y(:, ind0(test_0)), data.y(:, ind1(test_1)));

    outs = min_dist_classifier(train_data, test_data);
    outs = knnclass(test_data, knnrule(train_data, 2));

    [C, d] = confusionmat(test_data_class, outs);
    C = C';
    if verbose == true
        plotconfusion(test_data_class, outs);
    end

    fprintf('Classifier Accuracy:\t%.2f %%\n', (1 - cerror(outs, test_data_class)) * 100);
    fprintf('Classifier Sensitivity:\t%.2f %%\n', (C(2,2) / (C(2,2) + C(1,2))) * 100);
    fprintf('Classifier Specificity:\t%.2f %%\n\n', (C(1,1) / (C(2,1) + C(1,1))) * 100);
end
