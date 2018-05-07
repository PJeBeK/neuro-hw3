function ClassicMethod(s)
    %{
        Inputs:
            s: struct of subject data
        Outut:
            output: data after start target/non-target flashing of
            test/train for 800 miliseconds
    %}
    %filter
    set(0,'DefaultFigureVisible','off')
    bpf = BPF(1001, 0.5, 30, 256);
    set(0,'DefaultFigureVisible','on');
    for i=2:9
        s.test(i,:) = FilterDFT(s.test(i,:), bpf);
    end
    %extract trials
    [~,~,target, nontarget] = TrialExtraction(s);
    %calculate ERP
    targetERP = mean(target(2:9,:,:),2);
    targetSTD = std(target(2:9,:,:),0,2)/sqrt(205);
    nontargetERP = mean(nontarget(2:9,:,:),2);
    nontargetSTD = std(nontarget(2:9,:,:),0,2)/sqrt(205);
    %calculate time with frequency 256 for 0.8s
    time = 0:1/256:0.8;
    %plot
    figure(1); cla;
    for i=1:8
        subplot(2, 4, i);
        hold on
        plot(time, reshape(targetERP(i,1,:), [1 205]), 'LineWidth', 2, 'Color', 'r');
        plot(time, reshape(nontargetERP(i,1,:), [1 205]), 'LineWidth', 2, 'Color', 'b');
        legend('target','nontarget');
        title(strcat('Electrode ',num2str(i)));
        plot(time, reshape(targetERP(i,1,:)-targetSTD(1,1,:), [1 205]),...
            time, reshape(targetERP(i,1,:)+targetSTD(1,1,:), [1 205]), 'Color', 'r');
        plot(time, reshape(nontargetERP(i,1,:)-nontargetSTD(1,1,:), [1 205]),...
            time, reshape(nontargetERP(i,1,:)+nontargetSTD(1,1,:), [1 205]), 'Color', 'b');
    end
end