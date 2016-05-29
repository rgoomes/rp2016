function outs = min_dist_classifier(train_data, test_data)
%MIN_DIST_CLASSIFIER   Minimum-distance Classifier
%
%   This function will train a minimum distance classifier using the data
%   provided as input and return it
%
%   args:   data: structure containing a set of features (data.X) and the
%                 classification for each example (data.y)
%
%   output: outs: predictions
%   
    outs = [];

    feats = train_data.X;
    class = train_data.y;
    aux = size(train_data.X);
    classifier = zeros(aux(1), 2);
    for i = 1:aux(1)
       count_neg = 0;
       count_pos = 0;
       for k = 1:aux(2)
          if class(k) == 1
              classifier(i, 1) = classifier(i, 1) + feats(i, k);
              count_neg = count_neg + 1;
          elseif class(k) == 2
              classifier(i, 2) = classifier(i, 2) + feats(i, k);
              count_pos = count_pos + 1;
          end
       end
       classifier(i, 1) = classifier(i, 1) / count_neg;
       classifier(i, 2) = classifier(i, 2) / count_pos;
    end

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
            output = 1;
        else
            output = 2;
        end

        outs = [outs output];
    end
end