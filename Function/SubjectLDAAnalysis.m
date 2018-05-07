function SubjectLDAAnalysis(subject_id)
    subject = GetFilteredSubject(subject_id);

    % Get trials and downsample
    [train_a, train_b, test_a, test_b] = TrialExtraction(subject);
    train_a = DownSample(train_a);
    train_b = DownSample(train_b);
    test_a = DownSample(test_a);
    test_b = DownSample(test_b);

    train_X = cat(1, FeatureMatrix(train_a), FeatureMatrix(train_b));
    train_y = cat(1, ones(size(train_a, 1), 1), zeros(size(train_b, 1), 1));
    model = fitcdiscr(train_X, train_y);
    train_accr = (sum(model.predict(train_X) == train_y)/size(train_X, 1));
    test_X = cat(1, FeatureMatrix(test_a), FeatureMatrix(test_b));
    test_y = cat(1, ones(size(test_a, 1), 1), zeros(size(test_b, 1), 1));
    test_accr = sum(model.predict(test_X) == test_y)/size(test_X, 1);
    cvmodel = crossval(model, 'KFold', 5);
    cross_accr = 1 - kfoldLoss(cvmodel);
    
    if (subject_id == 1 || subject_id == 2)
        train_word = GetSCWord(model, train_a, train_b);
        test_word = GetSCWord(model, test_a, test_b);
    else
        train_word = GetRCWord(model, train_a, train_b);
        test_word = GetRCWord(model, test_a, test_b);
    end
    display(train_accr);
    display(test_accr);
    display(cross_accr);
    display(train_word);
    display(test_word);
end