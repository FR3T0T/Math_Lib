function kabel_data = parseKabelData(raw_data)
    % PARSEKABELDATA Parser Excel-data til MATLAB struktur
    
    % Find headers (første række)
    headers = raw_data(1, :);
    
    % Initialiser struktur
    kabel_data = struct();
    kabel_data.tvaersnit = {};
    kabel_data.belastningsevne = [];
    kabel_data.modstand = [];
    kabel_data.maksimal_temperatur = [];
    kabel_data.producent = {};
    
    % Parse hver række (spring header over)
    for i = 2:size(raw_data, 1)
        row = raw_data(i, :);
        
        % FIX: Meget robust check for tomme rækker
        cell_value = row{1};
        
        % Check om cellen er tom på flere måder
        should_skip = false;
        
        if isempty(cell_value)
            should_skip = true;
        elseif isnumeric(cell_value)
            if isscalar(cell_value) && isnan(cell_value)
                should_skip = true;
            end
        elseif ischar(cell_value)
            if isempty(cell_value) || strcmp(cell_value, 'NaN') || strcmp(cell_value, '')
                should_skip = true;
            end
        elseif isstring(cell_value)
            if isempty(cell_value) || strcmp(cell_value, 'NaN') || strcmp(cell_value, "")
                should_skip = true;
            end
        end
        
        % Spring tomme rækker over
        if should_skip
            continue;
        end
        
        % Udtræk data baseret på kolonnepositioner
        tvaersnit = num2str(cell_value);
        
        % Find relevante kolonner
        belastningsevne = ElDim.Database.parseNumeric(row, headers, 'Belastningsevne');
        modstand = ElDim.Database.parseNumeric(row, headers, 'Ledermodstand');
        max_temp = ElDim.Database.parseNumeric(row, headers, 'Maksimal temperatur');
        producent = ElDim.Database.parseText(row, headers, 'Producent');
        
        % Tilføj til struktur
        kabel_data.tvaersnit{end+1} = tvaersnit;
        kabel_data.belastningsevne(end+1) = belastningsevne;
        kabel_data.modstand(end+1) = modstand;
        kabel_data.maksimal_temperatur(end+1) = max_temp;
        kabel_data.producent{end+1} = producent;
    end
end