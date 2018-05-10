function [train_target, train_nontarget, test_target, test_nontarget] = IndExtraction(s)
    %{
        Inputs:
            s: struct of subject data
        Output:
            output: all indices for start target/non-target flashing of
            test/train
    %}
    [train_target, train_nontarget] = SimpleIndExtraction(s.train(10:11,:));
    [test_target, test_nontarget] = SimpleIndExtraction(s.test(10:11,:));
end

function [target, nontarget] = SimpleIndExtraction(X)
    %{
        Inputs:
            X: 2*n matrix which is 10 and 11 row of test or train data
        Outut:
            output: all indices for start target/non-target flashing of X
    %}
    X1=cat(2,X,[0;0]);
    X2=cat(2,[0;0],X);
    integers = 1:length(X1);
    starts = X1(1,:)~=0 & X2(1,:)~=X1(1,:);
    target = integers(starts & X1(2,:)==1);
    nontarget = integers(starts & X1(2,:)==0);
end