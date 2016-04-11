function myclassify()
    clc, clear all, close all
    
    %One column = one feature
    feats = csvread('data.csv', 2);
    
    %One line = one feature
    data.X = feats(:, 1:end - 1)';
    data.y = feats(:, end)';
    
    %Number of features
    data.dim = size(data.X,1);
    %Number of samples
    data.num_data = size(data.X,2);
end