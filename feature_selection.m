function feature_selection(data)
    kruskal_analysis(data)
end

function kruskal_analysis(data, string)
    for i = 1:data.dim
        [p,table,stats] = kruskalwallis(data.X(i, :), data.y');
        chi_sqr(i) = table(2, 5);
    end
    
    data.X = data.X(6:11, :)
    perft(data, string)
end