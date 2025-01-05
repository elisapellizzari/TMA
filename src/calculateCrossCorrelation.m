function cc = calculateCrossCorrelation(glucose, mean_glucose, template, delay)
% Calculate cross-correlation between glucose data and the template

% ----- Preprocessing -----
% subtract mean
template = template - mean(template);
glucose = glucose - mean_glucose;

% handle missiing values
TT = timetable(glucose, 'TimeStep', minutes(5));
[~, ~, nanStart, nanEnd] = findNanIslands(TT, 1);
nan_idx = find(isnan(glucose));

filled_glucose = fillmissing(glucose, 'linear', 'EndValues', 'nearest');

% filter data
[b, a] = butter(4, 0.25);
filled_filtered_glucose = filtfilt(b, a, filled_glucose);


% ----- Template match -----
b = fliplr(template');
a = 1;
y = filter(b, a, filled_filtered_glucose);

% apply delay and remove transient value
cc = zeros(length(y), 1);
cc(1:length(y) - delay) = y(delay + 1:end);
cc(1:length(template)) = NaN;


% ----- Post-processing -----
% restore missing values
cc(nan_idx) = NaN;

% insert length(tmplate) NaNs after missing values
l = length(template);
for n = 1:length(nanStart)
    cc(nanEnd(n):min(nanEnd(n) + l, length(cc))) = NaN;
end

end
