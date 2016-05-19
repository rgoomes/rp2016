function myclassify()
%MYCLASSIFY   Main Classifier Function
%
%   This function reads the data file and calls all the necessary
%   functions to select and reduce features. A performance test is also run
%   after the data is processed
%
%   args:   None
%   output: None
    clc, clear all, close all
    
    %One column = one feature
    feats = csvread('data.csv', 2);
    
    %One line = one feature
    data.X = feats(:, 2:end - 1)';
    data.y = feats(:, end)';
    
    %Number of features
    data.dim = size(data.X, 1);
    %Number of samples
    data.num_data = size(data.X, 2);
    
    perft(data, 'Unprocessed Features', false);
    perft(scalestd(data), 'Feature Normalization', false);

    data = feature_selection(data, false);
    data = feature_reduction(data, false);
    perft(data, 'Complete Analysis', false);
end