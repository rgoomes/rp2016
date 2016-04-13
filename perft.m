function perft(data)
    right = 0;
    full_data = cat(1, data.X, data.y);
    
    %Randomly divide the data into train and test datasets
    [ind_train, ~, ind_test] = dividerand(size(full_data, 2), 0.7, 0.0, 0.3);
    train = full_data(:, ind_train);
    test = full_data(:, ind_test);
    train_data.X = train(1:end - 1, :);
    train_data.y = train(end, :);
    test_data = test(1:end - 1, :);
    test_data_class = test(end, :);
    
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
    end
    perft_res = sprintf('Classifier Performance: %.2f %%', (right / size(test_data, 2)) * 100);
    disp(perft_res);
end