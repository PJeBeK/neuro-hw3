function word = GetSCWord(model, test_a, test_b)
    %{
        Inputs:
            model: trained LDA
            test_a, test_b: they will be merged and sorted by time, then
            divded to 36 * 15 epochs. each epoch determines one character.
        Output:
            output: the detected word
    %}
    ALPHABET='abcdefghijklmnopqrstuvwxyz0123456789';
    test_full = MergeByTime(test_a, test_b);
    results = zeros(1, 5);
    for i = 1:5
        char_trial = test_full((i - 1) * 15 * 36 + 1:i * 15*36, :, :);
        [~, score, ~] = model.predict(FeatureMatrix(char_trial));
        target_score = score(:,2);
        buffers = char_trial(:,10,1);
        [~, results(i)] = max(accumarray(buffers, target_score));
    end
    word = ALPHABET(results);
end