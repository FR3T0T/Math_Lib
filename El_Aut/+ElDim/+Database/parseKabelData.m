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
        
        % Spring tomme rækker over
        if isempty(row{1}) || isnan(row{1})
            continue;
        end
        
        % Udtræk data baseret på kolonnepositioner
        tvaersnit = num2str(row{1});
        
        % Find relevante kolonner (tilpas baseret på din Excel struktur)
        belastningsevne = parseNumeric(row, headers, 'Belastningsevne');
        modstand = parseNumeric(row, headers, 'Ledermodstand');
        max_temp = parseNumeric(row, headers, 'Maksimal temperatur');
        producent = parseText(row, headers, 'Producent');
        
        % Tilføj til struktur
        kabel_data.tvaersnit{end+1} = tvaersnit;
        kabel_data.belastningsevne(end+1) = belastningsevne;
        kabel_data.modstand(end+1) = modstand;
        kabel_data.maksimal_temperatur(end+1) = max_temp;
        kabel_data.producent{end+1} = producent;
    end
end