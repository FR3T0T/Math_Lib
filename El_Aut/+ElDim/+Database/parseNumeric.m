function value = parseNumeric(row, headers, col_name)
    % Find kolonne baseret på header navn
    col_idx = findColumnIndex(headers, col_name);
    
    if col_idx > 0 && col_idx <= length(row)
        value = row{col_idx};
        if ischar(value) || isstring(value)
            value = str2double(value);
        end
        if isnan(value)
            value = 0;
        end
    else
        value = 0;
    end
end