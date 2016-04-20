function data = feature_reduction(data, verbose)
%FEATURE_REDUCTION   Feature Reduction using PCA and LDA
%
%   This function uses PCA and LDA to reduce the number of features in the
%   input structure and returns the output of the reduction
%
%   args:   data:   structure containing a set of features (data.X) and the
%                   classification for each example (data.y)
%   output: data:   structure containing the new set of features (data.X) and the
%                   classification for each example (data.y)
    data = pca_analysis(data, verbose, 'PCA Feature Reduction');
    data = lda_analysis(data, verbose, 'LDA Feature Reduction');
end

function data = pca_analysis(data, verbose, string)
    %Normalize features
    data = scalestd(data);
    
    model1 = pca(data.X);
    
    eigenvalues = model1.eigval;
    show_info(data, verbose, model1, eigenvalues);

    model2 = pca(data.X, kaiser_test(data, eigenvalues));
    out = linproj(data.X, model2);
    data.X = out;
end

function data = lda_analysis(data, verbose, string)
    model1 = lda(data);
    
    eigenvalues = eig(model1.eigval);
    show_info(data, verbose, model1, eigenvalues);

    model2 = lda(data, kaiser_test(data, eigenvalues));
    data = linproj(data, model2);
end

function feat_count = kaiser_test(data, eigenvalues)
    feat_count = 0;
    for i = 1:size(data.X, 1) 
       if eigenvalues(i) >= 1
           feat_count = feat_count + 1;
       end
    end
end

function show_info(data, verbose, model, eigenvalues)
    if verbose == 0
        return
    end

    aux = round(model.W * model.W');
    if isequal(aux, eye(size(data.X, 1)))
        fprintf('Ortogonal\n');
    end
    
    plot(eigenvalues,'o-');
    disp(eigenvalues);
    for i = 1:size(data.X, 1)
        contrib = (eigenvalues(i) / sum(eigenvalues)) * 100;
        fprintf('Contribution: %f\n', contrib);
    end
end
