function word = GetRCWord(model, test_a, test_b)
    ALPHABET='abcdefghijklmnopqrstuvwxyz0123456789';
    test_full = MergeByTime(test_a, test_b);
    rows = zeros(1, 5);
    cols = zeros(1, 5);
    for i = 1:5
        char_trial = test_full((i - 1) * 15 * 12 + 1:i * 15*12, :, :);
        [~, score, ~] = model.predict(FeatureMatrix(char_trial));
        target_score = score(:,2);
        buffers = char_trial(:,10,1);
        arr = accumarray(buffers, target_score);
        
        [~, cols(i)] = max(arr(1:6));
        [~, rows(i)] = max(arr(7:12));
    end
    word = ALPHABET((rows - 1) * 6 + cols);
end