function matrix = FeatureMatrix(data)
    %{
        Inputs:
            data: data of trials
        Output:
            output: concatenated data of all 8 channels
    %}
    matrix = reshape(data(:,2:9,:), size(data, 1),[]);
end