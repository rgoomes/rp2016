function data = feature_selection(data)
    data = kruskal_analysis(data, 'Kruskal Wallis');
end

function data = kruskal_analysis(data, string)
    for i = 1:data.dim
        [p,table,stats] = kruskalwallis(data.X(i, :), data.y', 'off');
        chi_sqr(i) = table(2, 5);
    end
    
    data.X = data.X(6:7, :);
end