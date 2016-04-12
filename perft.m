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
    
    %Classify and calculate performance
    for i = 1:size(data_test, 2)
       out = min_dist_classifier(train_data, test_data(:, i));
       if out == test_data_class(:, i)
          right = right + 1; 
       end
    end
    perft_res = sprintf('Classifier Performance: %.2f %%', right / size(data_test, 2));
    disp(perft_res);
end