function [model, train_accr, test_accr, cross_accr, train_word, test_word] = SubjectLDAAnalysis(subject_id)
    %load root
    [folder, ~, ~] = fileparts(which('SubjectLDAAnalysis'));
    root = strcat(folder, '/../');
    
    %load subject data
    subject = GetFilteredSubject(subject_id);

    % Get trials and downsample
    [train_a, train_b, test_a, test_b] = TrialExtraction(subject);
    train_a = DownSample(train_a);
    train_b = DownSample(train_b);
    test_a = DownSample(test_a);
    test_b = DownSample(test_b);
    
    % create train data
    train_X = cat(1, FeatureMatrix(train_a), FeatureMatrix(train_b));
    train_y = cat(1, ones(size(train_a, 1), 1), zeros(size(train_b, 1), 1));
    
    % train LDA
    model = fitcdiscr(train_X, train_y);
    
    % calculate train and test accuracy
    train_accr = (sum(model.predict(train_X) == train_y)/size(train_X, 1));
    test_X = cat(1, FeatureMatrix(test_a), FeatureMatrix(test_b));
    test_y = cat(1, ones(size(test_a, 1), 1), zeros(size(test_b, 1), 1));
    test_accr = sum(model.predict(test_X) == test_y)/size(test_X, 1);
    
    %perform 5-fold cross-validation
    cvmodel = crossval(model, 'KFold', 5);
    cross_accr = 1 - kfoldLoss(cvmodel);
        
    % predict spelled word
    if (subject_id == 1 || subject_id == 2)
        train_word = GetSCWord(model, train_a, train_b);
        test_word = GetSCWord(model, test_a, test_b);
    else
        train_word = GetRCWord(model, train_a, train_b);
        test_word = GetRCWord(model, test_a, test_b);
    end
    
    % draw per-electrode coefficients
    f1 = figure('visible', 'off');
    
    coeffs = model.Coeffs(1, 2).Linear;
    targetERP = mean(train_a(2:9,:,:),2);
    nontargetERP = mean(train_b(2:9,:,:),2);   
    electrode_count = size(train_X, 2) / 8;
    time = 0:1/64:0.8;
    %plot
    for i=1:8
        if(i<4) 
            subplot(2, 9, [2*i-1 2*i]);
        elseif(i==4)
            subplot(2, 9, [7 8 9]);
        else
            subplot(2, 9, [2*i 2*i+1]);
        end
        hold on
        cur_coeffs = coeffs(electrode_count * (i - 1) + 1:electrode_count * i);
        %cur_coeffs = ur_coeffs / sqrt(dot(cur_coeffs, cur_coeffs));
        plot(time, targetERP(i, :), 'Color', 'r');
        plot(time, cur_coeffs, 'Color', 'b');
        if(i==4)
            hleg = legend('target','non-target');
            set(hleg, 'Location', 'BestOutside');
        end
        title(strcat('Electrode ',num2str(i)));
    end
    % Saving image as png to output folder
    f1.Position(3) = 1400;
    f1.Position(4) = 700;
    all_fig_path = strcat(root, 'output/phase4/Subject', num2str(subject_id), '.png');
    [status, ~, ~] = mkdir(strcat(root,'output'));
    assert(status == 1, 'output directory creation failed');
    [status, ~, ~] = mkdir(strcat(root,'output/phase4/'));
    assert(status == 1, 'output directory creation failed');
    saveas(gcf, all_fig_path);
    close(f1);
end