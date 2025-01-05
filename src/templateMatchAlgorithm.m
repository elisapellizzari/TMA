function [tp, fp, fn, tn] = templateMatchAlgorithm(data, mean_train_glucose, template, delay, threshold, meals_idx, to_be_silenced, do_plot)
% calculates the performance of the template match algorithm

% cross-correlation
cross_correlation = calculateCrossCorrelation(data.glucose, mean_train_glucose, template, delay);

% categorical cross-correlation
categorical_cross_correlation = retrieveCategoricalCrossCorrelation(data.glucose, cross_correlation, threshold, template, to_be_silenced);

% evaluate performances
[TP_vec, FN_vec, FP_vec, TN_vec] = evaluatePerformances(categorical_cross_correlation, meals_idx, do_plot);

tp = sum(TP_vec, 'omitnan');
fp = sum(FP_vec, 'omitnan');
fn = sum(FN_vec, 'omitnan');
tn = sum(TN_vec, 'omitnan');
end
