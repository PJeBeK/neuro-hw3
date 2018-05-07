function matrix = FeatureMatrix(data)
    matrix = reshape(data(:,2:9,:), size(data, 1),[]);
end