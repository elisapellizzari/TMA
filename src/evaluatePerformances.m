function [TP_vec, FN_vec, FP_vec, TN_vec] = evaluatePerformances(cross_correlation_cat, meals, do_plot)

% initialize vectors for true positives (TP), false negatives (FN), false positives (FP), and true negatives (TN)
TP_vec = zeros(1, length(meals));
FN_vec = zeros(1, length(meals));

% loop on meals for tp and fn
for m = 1:length(meals)
    % define a window around the meal [m-15min, m+2h]
    if m ~= length(meals)
        window = [max(1, meals(m)-3):meals(m)+24];
    else
        window = [max(1, meals(m)-3):min(meals(m)+24, length(cross_correlation_cat))];
    end

    % check if there is any cross-correlation peak within the window
    if sum(cross_correlation_cat(window)) > 0
        % if a peak is detected, mark it as a tp
        TP_vec(m) = 1;

        % eliminate the peak in the cross-correlation to avoid multiple detections
        peak_location = find(cross_correlation_cat(window));
        cross_correlation_cat(window(1)-1 + peak_location(1)) = 0;
    else
        % if no peak is detected mark it as fn
        FN_vec(m) = 1;
    end
end

FP_vec = cross_correlation_cat;
TN_vec = nan;
end