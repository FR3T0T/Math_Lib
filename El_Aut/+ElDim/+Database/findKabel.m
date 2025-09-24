function [belastningsevne, modstand, producent] = findKabel(kabel_database, kabel_type, tvaersnit)
    % FINDKABEL Finder specifik kabel i databasen
    
    if ~isfield(kabel_database, kabel_type)
        error('Kabeltype %s ikke fundet i database', kabel_type);
    end
    
    data = kabel_database.(kabel_type);
    
    % Find index for ønsket tværsnit
    tvaersnit_str = num2str(tvaersnit);
    idx = find(strcmp(data.tvaersnit, tvaersnit_str), 1);
    
    if isempty(idx)
        error('Tværsnit %s mm² ikke fundet for kabeltype %s', tvaersnit_str, kabel_type);
    end
    
    belastningsevne = data.belastningsevne(idx);
    modstand = data.modstand(idx);
    
    if isfield(data, 'producent') && length(data.producent) >= idx
        producent = data.producent{idx};
    else
        producent = 'Ukendt';
    end
end