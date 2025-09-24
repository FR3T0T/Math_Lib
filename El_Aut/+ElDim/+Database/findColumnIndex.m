function idx = findColumnIndex(headers, col_name)
    idx = 0;
    for i = 1:length(headers)
        if ischar(headers{i}) || isstring(headers{i})
            if contains(lower(headers{i}), lower(col_name))
                idx = i;
                return;
            end
        end
    end
end