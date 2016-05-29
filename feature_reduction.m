function data = feature_reduction(data, do_pca, do_lda, verbose)
%FEATURE_REDUCTION   Feature Reduction using PCA and LDA
%
%   This function uses PCA and LDA to reduce the number of features in the
%   input structure and returns the output of the reduction
%
%   args:   data:    structure containing a set of features (data.X) and the
%                    classification for each example (data.y)
%           verbose: display extra information. Valid values are true and false
%   output: data:    structure containing the new set of features (data.X) and the
%                    classification for each example (data.y)

    if do_pca == true
        data = pca_analysis(data, verbose);
    end

    if do_lda == true
        data = lda_analysis(data);
    end
end

function data = pca_analysis(data, verbose)
    model1 = pca(data.X);
    
    eigenvalues = model1.eigval;
    show_info(data, verbose, eigenvalues);

    model2 = pca(data.X, kaiser_test(eigenvalues));
    out = linproj(data.X, model2);
    data.X = out;

    % also update dim
    data.dim = size(out, 1);
end

function data = lda_analysis(data)
    model = lda(data, 2);
    data = linproj(data, model);

    % set dim and num_data
    data.dim = size(data.X, 1);
    data.num_data = size(data.X, 2);
end

function feat_count = kaiser_test(eigenvalues)
    feat_count = sum(eigenvalues >= 1.0);
end

function show_info(data, verbose, eigenvalues)
    if verbose == true
        figure; plot(eigenvalues,'o-');
        disp(eigenvalues);
        for i = 1:size(data.X, 1)
            contrib = (eigenvalues(i) / sum(eigenvalues)) * 100;
            fprintf('Contribution: %f\n', contrib);
        end
    end
end
