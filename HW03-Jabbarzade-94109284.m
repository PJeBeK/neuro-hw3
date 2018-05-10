% Initialization
addpath('./Function');
addpath('./Data');

% Part 2
DetermineProtocol();

% Part 3
for i= 1:10
    ClassicMethod(i);
end

% Part 4
t = table();
for i = 1:10
    [model, train_accr, test_accr, cross_accr, train_word, test_word] = SubjectLDAAnalysis(i);
    train_word = {train_word};
    test_word = {test_word};
    t = [t;table(train_accr, test_accr, cross_accr, train_word, test_word)];
end

writetable(t, 'output/phase4/subject-data.csv');
hist(t.test_accr);

% Part 5
t = table();
for i = 1:10
    [model, train_accr, test_accr, cross_accr, train_word, test_word] = SubjectLDAAnalysisWithRegularization(i);
    train_word = {train_word};
    test_word = {test_word};
    t = [t;table(train_accr, test_accr, cross_accr, train_word, test_word)];
end

writetable(t, 'output/phase5/subject-data.csv');
hist(t.test_accr);