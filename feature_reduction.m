function feature_reduction(data, verbose)
    pca_analysis(data, verbose, 'PCA Feature Reduction');
    lda_analysis(data, verbose, 'LDA Feature Reduction');
end

function pca_analysis(data, verbose, string)
    %Normalize features
    data = scalestd(data);
    
    model1 = pca(data.X);
    
    eigenvalues = model1.eigval;
    show_info(data, verbose, model1, eigenvalues);

    model2 = pca(data.X, kaiser_test(data, eigenvalues));
    out = linproj(data.X, model2);
    data.X = out;
    perft(data, string);
end

function lda_analysis(data, verbose, string)
    model1 = lda(data);
    
    eigenvalues = eig(model1.eigval);
    show_info(data, verbose, model1, eigenvalues);

    model2 = lda(data, kaiser_test(data, eigenvalues));
    new_data = linproj(data, model2);
    perft(new_data, string);
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
