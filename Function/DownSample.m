function trials_ds = DownSample(trials)
    % Downsampling from 256 to 64
    trials_mat = reshape(trials, [], size(trials, 3));
    trials_mat = downsample(trials_mat.', 256 / 64).';
    trials_ds = reshape(trials_mat, size(trials, 1), size(trials, 2), []);
    trials_ds = permute(trials_ds, [2 1 3]);
end

