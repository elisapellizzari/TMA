clearvars;
close all;
clc;

addpath(genpath('src'))

do_plot = 0;

% get list of patient directories in the data folder
listing = dir(fullfile('data'));
listing = listing(arrayfun(@(x) x.name(1) ~= '.', listing));  % exclude hidden files
name = {listing.name}';

% initialize results table
num_patients = length(listing);
results = table('Size', [num_patients, 5], ...
    'VariableTypes', {'string', 'double', 'double', 'double', 'double'}, ...
    'VariableNames', {'name', 'tp', 'fp', 'fn', 'tn'});

% iterate through each patient directory
for i = 1:length(listing)
    current_pat = name{i};
    results.name(i) = current_pat;

    input_folder = fullfile('data', current_pat);

    % load optimal threshold
    try
        load(fullfile(input_folder, 'optimal_threshold'));
    catch ME
        warning('Failed to load optimal threshold for patient %s: %s', current_pat, ME.message);
        continue;
    end

    % load personalized template
    try
        load(fullfile(input_folder, 'personalized_template'));
    catch ME
        warning('Failed to load template for patient %s: %s', current_pat, ME.message);
        continue;
    end

    % load test data
    try
        load(fullfile(input_folder, ['test_data_', current_pat]));
    catch ME
        warning('Failed to load test data for patient %s: %s', current_pat, ME.message);
        continue;
    end

    [tp, fp, fn, tn] = templateMatchAlgorithm(patientData, mean_train_glucose, template, delay, optimal_threshold, meals_idx, to_be_silenced, do_plot);
    results.tp(i) = tp;
    results.fp(i) = fp;
    results.fn(i) = fn;
    results.tn(i) = tn;
end

% summarize and display results
summarizeResults(results);
