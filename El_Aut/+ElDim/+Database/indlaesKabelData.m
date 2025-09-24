function kabel_database = indlaesKabelData()
    % INDLÆSKABELDATA Indlæser kabeldata fra Excel-filer
    %
    % Output:
    %   kabel_database - struktur med alle kabeldata
    
    % Definer Excel-filer og kabeltyper
    excel_filer = {
        'KabelData_NYM.xlsx',      % NYM kabler
        'KabelData_PFXP.xlsx',     % PFXP kabler  
        'KabelData_NYYJ.xlsx',     % NYY-J kabler
        'KabelData_NHXH.xlsx'      % NHXH kabler
    };
    
    kabel_typer = {'NYM', 'PFXP', 'NYY-J', 'NHXH'};
    
    kabel_database = struct();
    
    for i = 1:length(excel_filer)
        fil = excel_filer{i};
        kabel_type = kabel_typer{i};
        
        try
            % Læs Excel-fil
            if exist(fil, 'file')
                [~, ~, raw_data] = xlsread(fil);
                
                % Parse data og opret struktur
                kabel_database.(kabel_type) = parseKabelData(raw_data);
                
                fprintf('✓ Indlæst kabeldata for %s fra %s\n', kabel_type, fil);
            else
                fprintf('⚠ Fil ikke fundet: %s. Bruger standard data.\n', fil);
                kabel_database.(kabel_type) = getStandardKabelData(kabel_type);
            end
        catch ME
            fprintf('✗ Fejl ved indlæsning af %s: %s\n', fil, ME.message);
            kabel_database.(kabel_type) = getStandardKabelData(kabel_type);
        end
    end
end