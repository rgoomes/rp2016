function pca_analysis(data)
    %Normalize features
    data = scalestd(data);
    
    model = pca(data.X);
    
    aux = round(model.W * model.W');
    if isequal(aux, eye(23))
       fprintf('Ortogonal\n');
    end
    
    plot(model.eigval,'o-');
    disp(model.eigval);
    for i = 1:size(data.X, 1)
        contrib = (model.eigval(i) / sum(model.eigval)) * 100;
        fprintf('Contribution: %f\n', contrib);
    end
    
    kaiser_feats = [];
    for i = 1:size(data.X, 1) 
       if model.eigval(i) >= 1
           kaiser_feats = [kaiser_feats i];
       end
    end
    disp(kaiser_feats);
end

