function pca_analysis(data, verbose, string)
    %Normalize features
    data = scalestd(data);
    
    model = pca(data.X);
    
    aux = round(model.W * model.W');
    if isequal(aux, eye(23))
        if verbose == 1
            fprintf('Ortogonal\n');
        end
    end
    
    if verbose == 1
        plot(model.eigval,'o-');
        disp(model.eigval);
        for i = 1:size(data.X, 1)
            contrib = (model.eigval(i) / sum(model.eigval)) * 100;
            fprintf('Contribution: %f\n', contrib);
        end
    end
    
    feat_count = 0;
    for i = 1:size(data.X, 1) 
       if model.eigval(i) >= 1
           feat_count = feat_count + 1;
       end
    end
   
   model2 = pca(data.X, feat_count); 
   out = linproj(data.X, model2);
   data.X = out;
   perft(data, string);
   
end

