function value = parseText(row, headers, col_name)
    col_idx = findColumnIndex(headers, col_name);
    
    if col_idx > 0 && col_idx <= length(row)
        value = row{col_idx};
        if isempty(value) || (isnumeric(value) && isnan(value))
            value = 'Ukendt';
        end
    else
        value = 'Ukendt';
    end
end