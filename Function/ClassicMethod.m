function ClassicMethod(subject_id)
    %{
        Inputs:
            subject_id: ID of subject
        Outut:
            output: data after start target/non-target flashing of
            test/train for 800 miliseconds
    %}
    %load root
    [folder, ~, ~] = fileparts(which('ClassicMethod'));
    root = strcat(folder, '/../');
    f1 = figure('visible', 'on');
    %filter
    s = GetFilteredSubject(subject_id);
    %extract trials
    [~,~,target, nontarget] = TrialExtraction(s);
    %calculate ERP
    targetERP = mean(target(2:9,:,:),2);
    nontargetERP = mean(nontarget(2:9,:,:),2);
    %caluculate STD of mean
    targetSTD = std(target(2:9,:,:),0,2)/sqrt(size(target,2));
    nontargetSTD = std(nontarget(2:9,:,:),0,2)/sqrt(size(nontarget,2));
    %calculate time with frequency 256 for 0.8s
    time = 0:1/256:0.8;
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
        plot(time, reshape(targetERP(i,1,:), [1 205]), 'LineWidth', 2, 'Color', 'r');
        plot(time, reshape(nontargetERP(i,1,:), [1 205]), 'LineWidth', 2, 'Color', 'b');
        if(i==4)
            hleg = legend('target','nontarget');
            set(hleg, 'Location', 'BestOutside');
        end
        title(strcat('Electrode ',num2str(i)));
        plot(time, reshape(targetERP(i,1,:)-targetSTD(1,1,:), [1 205]),...
            time, reshape(targetERP(i,1,:)+targetSTD(1,1,:), [1 205]), 'Color', 'r');
        plot(time, reshape(nontargetERP(i,1,:)-nontargetSTD(1,1,:), [1 205]),...
            time, reshape(nontargetERP(i,1,:)+nontargetSTD(1,1,:), [1 205]), 'Color', 'b');
    end
    % Saving image as png to output folder
    f1.Position(3) = 1400;
    f1.Position(4) = 700;
    all_fig_path = strcat(root, 'output/phase3/Subject', num2str(subject_id), '.png');
    saveas(gcf, all_fig_path);
    close(f1);
end