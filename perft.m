function perft(data, string)
%PERFT   Performance Test
%
%   This function runs a performance test using the input data and a
%   minimum-distance classifier. The data is divided randomly
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%           string: description that is printed along with the results
%   output: None
    fprintf('Performance Test: %s\n', string)
    right = 0;
    outs = [];

    ind0 = find(data.y == 0);
    ind1 = find(data.y == 1);
    [train_1, ~, test_1] = dividerand(size(ind1, 2), 0.7, 0, 0.3);
    [train_0, ~, test_0] = dividerand(size(ind0, 2), 0.7, 0, 0.3);
    
    train_data.X = horzcat(data.X(:, ind0(train_0)), data.X(:, ind1(train_1)));
    train_data.y = horzcat(data.y(:, ind0(train_0)), data.y(:, ind1(train_1)));
    test_data = horzcat(data.X(:, ind0(test_0)), data.X(:, ind1(test_1)));
    test_data_class = horzcat(data.y(:, ind0(test_0)), data.y(:, ind1(test_1)));
    
    classifier = min_dist_classifier(train_data);
    %Classify and calculate performance
    for i = 1:size(test_data, 2)
        input = test_data(:, i);
        dist_neg = 0;
        dist_pos = 0;
        
        for k = 1:size(test_data, 1)
            dist_neg = dist_neg + (classifier(k, 1) - input(k))^2;
            dist_pos = dist_pos + (classifier(k, 2) - input(k))^2;
        end
        dist_neg = sqrt(dist_neg);
        dist_pos = sqrt(dist_pos);
        if dist_neg < dist_pos
            output = 0;
        else
            output = 1;
        end
        if output == test_data_class(i)
           right = right + 1; 
        end

        outs = [outs output];
    end

    [C, d] = confusionmat(test_data_class, outs);
    C = C';
    plotconfusion(test_data_class, outs);

    perft_res = sprintf('Classifier Performance: %.2f %%\n', (right / size(test_data, 2)) * 100);
    disp(perft_res);
end