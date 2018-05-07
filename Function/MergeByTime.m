function test_full = MergeByTime(test_a, test_b)
    test_full = cat(1, test_a, test_b);
    test_full_mat = reshape(test_full, size(test_full, 1), []);
    test_full_mat = sortrows(test_full_mat);
    test_full = reshape(test_full_mat, size(test_full));
end