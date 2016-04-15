function kruskal_analysis(data)
    data = scaledstd(data);
    [p, table, stats] = kruskallwillis(data.X');
end