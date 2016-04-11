function output = min_dist_classifier(data, input)
    %Calc centroid for each feature and class = 0
    %Calc centroid for each feature and class = 1
    %Calc sum of distance to centroid for each feature of input, for each class
    %Return the class with the minimum value
    %***Each line of data is one feature!!!***
    feats = data.X;
    class = data.y;
    aux = size(data.X);
    classifier = zeros(aux(1), 2);
    for i = 1:aux(1)
       count_neg = 0;
       count_pos = 0;
       for k = 1:aux(2)
          if class(k) == 0
              classifier(i, 1) = classifier(i, 1) + feats(i, k);
              count_neg = count_neg + 1;
          elseif class(k) == 1
              classifier(i, 2) = classifier(i, 2) + feats(i, k);
              count_pos = count_pos + 1;
          end
       end
       classifier(i, 1) = classifier(i, 1) / count_neg;
       classifier(i, 2) = classifier(i, 2) / count_pos;
    end
    
    dist_neg = 0;
    dist_pos = 0;
    for i = 1:aux(1)
        dist_neg = dist_neg + (classifier(i, 1) - input(i))^2;
        dist_pos = dist_pos + (classifier(i, 2) - input(i))^2;
    end
    if dist_neg < dist_pos
        output = 0;
    else
        output = 1;
    end
end