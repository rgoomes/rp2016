function perft(data, verbose)
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

    if verbose == true
        ppatterns(data);
    end

    ind0 = find(data.y == 1);
    ind1 = find(data.y == 2);

    [train_0, ~, test_0] = dividerand(length(ind0), 0.7, 0, 0.3);
    [train_1, ~, test_1] = dividerand(length(ind1), 0.7, 0, 0.3);
    
    train_data.X = horzcat(data.X(:, ind0(train_0)), data.X(:, ind1(train_1)));
    train_data.y = horzcat(data.y(:, ind0(train_0)), data.y(:, ind1(train_1)));
    test_data.X  = horzcat(data.X(:, ind0(test_0)),  data.X(:, ind1(test_1)));
    test_data.y  = horzcat(data.y(:, ind0(test_0)),  data.y(:, ind1(test_1)));

    % update dim and num_data
    train_data.dim = data.dim;
    test_data.dim = data.dim;
    train_data.num_data = length(train_data.X);
    test_data.num_data = length(test_data.X);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    outs = min_dist_classifier(train_data, test_data.X);
    show_stats(test_data.y, outs, verbose, true, 'min dist classifier');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    model = fld(train_data);
    outs = linclass(test_data.X, model);
    show_stats(test_data.y, outs, verbose, true, 'lin classifier');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    outs = knnclass(test_data.X, knnrule(train_data, 50));
    show_stats(test_data.y, outs, verbose, true, 'knn classifier');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    inx0 = find(train_data.y == 1);
    inx1 = find(train_data.y == 2);

    train0 = train_data;
    train0.X = train_data.X(:, inx0);
    train0.y = train_data.y(inx0);
    train0.num_data = length(train0.X);

    train1 = train_data;
    train1.X = train_data.X(:, inx1);
    train1.y = train_data.y(inx1);
    train1.num_data = length(train1.X);

    model.Pclass{1} = mlcgmm(train0);
    model.Pclass{2} = mlcgmm(train1);
    model.Prior = [length(inx0) length(inx1)]/(length(inx0)+length(inx1));
    outs = bayescls(test_data.X, model);
    show_stats(test_data.y, outs, verbose, true, 'bayes classifier');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    opt = struct('ker', 'linear', 'C', 1.0e-2, 'eps', 1.0e-9);
    outs = svmclass(test_data.X, smo(train_data, opt));
    show_stats(test_data.y, outs, false, true, 'svm classifier');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    tune_parameters(data, train_data, test_data, verbose);
end

function tune_parameters(data, train_data, test_data, verbose)
    TuneC   = [1e-8, 1e-3, 0.01, 0.1];
    TuneEPS = [1e-12, 1e-9, 1e-6];

    best = 0.0;
    opt = struct('ker', 'linear');

    for i=1:length(TuneC)
        for j=1:length(TuneEPS)
            opt.C   = TuneC(i);
            opt.eps = TuneEPS(j);

            outs = svmclass(test_data.X, smo(train_data, opt));
            stats = show_stats(test_data.y, outs, false, false, 'svm classifier');
            fitness = sum(stats);

            if fitness > best
                best = fitness;

                fprintf('Parameters: C = %.2e, eps = %.2e\n', opt.C, opt.eps);
                fprintf('Fitness = %.2f, acc = %.2f%%, sen = %.2f%%, spe = %.2f%%\n\n', ...
                    fitness, stats(1), stats(2), stats(3));
            end
        end

        fprintf('Tuning: %.1f%%\n', i * 100 / length(TuneC));
    end
end

function fitness = show_stats(targets, outs, verbose, extra, string)
    [C, ~] = confusionmat(targets, outs);
    C = C';

    if verbose == true
        plotconfusion(targets, outs);
    end

    acc = (1 - cerror(outs, targets)) * 100;
    sen = (C(2,2) / (C(2,2) + C(1,2))) * 100;
    spe = (C(1,1) / (C(2,1) + C(1,1))) * 100;

    if extra == true
        fprintf('Performance Test: %s\n', string);
        fprintf('Classifier Accuracy:\t%.2f %%\n', acc);
        fprintf('Classifier Sensitivity:\t%.2f %%\n', sen);
        fprintf('Classifier Specificity:\t%.2f %%\n\n', spe);
    end

    fitness = [acc, sen, spe];
end
