function classifier = min_dist_classifier(data)
%MIN_DIST_CLASSIFIER   Minimum-distance Classifier
%
%   This function will train a minimum distance classifier using the data
%   provided as input and return it
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%   output: classifier: Matrix that can be used as a min-dist classifier.
%                        Each column is the centroid of a different class 
%   
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
end