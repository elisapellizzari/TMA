function summarizeResults(results)
    % This function calculates and displays the overall results.
    
    tp_overall = sum(results.tp);
    fp_overall = sum(results.fp);
    fn_overall = sum(results.fn);
    tn_overall = sum(results.tn);

    fprintf('TP=%d, FP=%d, FN=%d, TN=%d\n', tp_overall, fp_overall, fn_overall, tn_overall);
    r = tp_overall/(tp_overall+fn_overall);
    p = tp_overall/(tp_overall+fp_overall);
    f1 = 2 * p * r / (r+p);
    fprintf('Recall=%.4f, Precision=%.4f, F1-score=%.4f\n', r, p, f1);
end
