function [train_target, train_nontarget, test_target, test_nontarget] = TrialExtraction(s)
    %{
        Inputs:
            s: struct of subject data
        Outut:
            output: data after start target/non-target flashing of
            test/train for 800 miliseconds
    %}
    [ind_train_target, ind_train_nontarget, ind_test_target, ind_test_nontarget] = IndExtraction(s);
    train_target = SimpleTrialExtraction(s.train, ind_train_target);
    train_nontarget = SimpleTrialExtraction(s.train, ind_train_nontarget);
    test_target = SimpleTrialExtraction(s.test, ind_test_target);
    test_nontarget = SimpleTrialExtraction(s.test, ind_test_nontarget);
end

function Y = SimpleTrialExtraction(X, IND)
    %{
        Inputs:
            X: 11*n matrix which is test or train data
            IND: start of capturing data
        Outut:
            Y: data after start of IND indices for 800
            miliseconds
    %}
    TIME = 205;
    Y = zeros(11, length(IND), TIME);
    for i = 1:TIME
        Y(:,:,i) = X(:,IND+i-1);
    end
end