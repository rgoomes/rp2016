function myclassify()
    clc, clear all, close all
    
    %One column = one feature
    feats = csvread('data.csv', 2);
    
    %One line = one feature
    data.X = feats(:, 1:end - 1)';
    data.y = feats(:, end)';

    %Number of features
    data.dim = size(data.X, 1);
    %Number of samples
    data.num_data = size(data.X, 2);
    
    
    perft(data);
    %for i = 1:data.dim
    %   for j = i + 1:data.dim
    %       data2.X = [data.X(i, :) ; data.X(j, :)];
    %       data2.y = data.y;
    %       ppatterns(data2)
    %       pause()
    %   end
    %end
end