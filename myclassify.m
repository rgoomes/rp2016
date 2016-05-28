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
    data.y = data.y + 1;
    
    %Number of features
    data.dim = size(data.X, 1);
    %Number of samples
    data.num_data = size(data.X, 2);

    data = equalize(data);
    data = reduce(data, 0.5);
    data = scalestd(data);

    data = feature_selection(data, false);
    data = feature_reduction(data, false);
    perft(data, false);
end

function data = reduce(data, reduce_factor)
    reduce_factor = max(reduce_factor, 0.0001);
    reduce_factor = min(reduce_factor, 1.0000);

    ind0 = find(data.y == 1);
    ind1 = find(data.y == 2);

    ind1 = ind1(randperm(length(ind1)));
    ind1 = ind1(1: round(reduce_factor * length(ind1)));

    ind0 = ind0(randperm(length(ind0)));
    ind0 = ind0(1: round(reduce_factor * length(ind0)));

    ind = [ind0 ind1];

    data.X = data.X(:, ind);
    data.y = data.y(:, ind);
    data.num_data = length(data.X);
end

function data = equalize(data)
    ind0 = find(data.y == 1);
    ind1 = find(data.y == 2);

    ind1 = ind1(randperm(length(ind1)));
    ind1 = ind1(1: length(ind1));

    ind0 = ind0(randperm(length(ind0)));
    ind0 = ind0(1: length(ind0)-length(ind1));

    % remove picked indices
    data.X(:, ind0) = [];
    data.y(:, ind0) = [];

    % update data size
    data.num_data = length(data.X);
end