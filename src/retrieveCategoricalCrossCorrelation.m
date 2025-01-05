function categorical_cross_correlation = retrieveCategoricalCrossCorrelation(glucose_data, cross_correlation, threshold, template, to_be_silenced)
% Transform cross-correlation into a categorical vector and handle alarms to be silenced

% compute categorical cross-correlation
[~, cc_pks_locs, ~, ~] = findpeaks(cross_correlation, 'MinPeakHeight', threshold);
categorical_cross_correlation = zeros(1, length(cross_correlation));
categorical_cross_correlation(cc_pks_locs) = 1;

% silence alarms near NaN islands
TT = timetable(glucose_data, 'TimeStep', minutes(5));
TT.Properties.VariableNames = {'glucose'};
[~, ~, nanStart, nanEnd] = findNanIslands(TT, 1);
time_window = 12; % 12 samples = 1 hour

for n = 1:length(nanStart)
    % before the NaN island
    for ev = 1:length(to_be_silenced)
        if to_be_silenced(ev) < nanStart(n) && to_be_silenced(ev) > max(nanStart(n) - 2 * time_window, 1)
            % meal within 2 hours before a NaN island, silence its window
            categorical_cross_correlation(max(1, to_be_silenced(ev) - 3):to_be_silenced(ev) + 24) = 0;
        end
    end
    % silence alarms 1 hour before NaN islands
    categorical_cross_correlation(max(nanStart(n) - time_window, 1):nanStart(n)) = 0;

    % after the NaN island
    for ev = 1:length(to_be_silenced)
        if to_be_silenced(ev) < (min(nanEnd(n) + length(template), length(cross_correlation))) && to_be_silenced(ev) > nanEnd(n)
            % meal within template length from the end of a NaN island, silence its window
            categorical_cross_correlation(max(1, to_be_silenced(ev) - 3):to_be_silenced(ev) + 24) = 0;
        end
    end
end