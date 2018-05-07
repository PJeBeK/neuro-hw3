function subject = GetFilteredSubject(subject_id)
    subject = load(strcat('s', int2str(subject_id), '.mat'));
    fns = fieldnames(subject);
    subject = subject.(fns{1});

    % Filter subject here
    bpf = BPF(1001, 0.5, 30, 256);
    for i = 2:9
        subject.train(i,:) = FilterDFT(subject.train(i,:), bpf);
        subject.test(i,:) = FilterDFT(subject.test(i,:), bpf);
    end
end