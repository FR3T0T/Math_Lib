function kabel_database = indlaesKabelData(use_excel)
    % INDLÆSKABELDATA Indlæser kabeldata fra Excel-filer eller standard data
    %
    % Input:
    %   use_excel - (optional) true for at prøve Excel-filer, false for kun standard data
    %
    % Output:
    %   kabel_database - struktur med alle kabeldata
    
    if nargin < 1
        use_excel = true; % Default: prøv Excel-filer
    end
    
    % Definer Excel-filer og kabeltyper
    excel_filer = {
        'KabelData_NYM.xlsx',      % NYM kabler
        'KabelData_PFXP.xlsx',     % PFXP kabler  
        'KabelData_NYYJ.xlsx',     % NYY-J kabler
        'KabelData_NHXH.xlsx'      % NHXH kabler
    };
    
    % Struct field navne og display navne
    kabel_typer = {'NYM', 'PFXP', 'NYY_J', 'NHXH'};
    display_navne = {'NYM', 'PFXP', 'NYY-J', 'NHXH'};
    
    kabel_database = struct();
    
    % Check om nogen Excel-filer eksisterer
    excel_files_exist = false;
    if use_excel
        for i = 1:length(excel_filer)
            if exist(excel_filer{i}, 'file')
                excel_files_exist = true;
                break;
            end
        end
    end
    
    if ~use_excel || ~excel_files_exist
        if ~use_excel
            fprintf('ℹ Bruger kun standard kabeldata (Excel deaktiveret)\n');
        else
            fprintf('ℹ Ingen Excel-filer fundet - bruger standard data for alle kabler\n');
        end
        
        % Brug standard data for alle
        for i = 1:length(kabel_typer)
            kabel_type = kabel_typer{i};
            display_navn = display_navne{i};
            
            kabel_database.(kabel_type) = ElDim.Database.getStandardKabelData(display_navn);
            fprintf('✓ Standard data indlæst for %s\n', display_navn);
        end
        return;
    end
    
    % Prøv at indlæse Excel-filer
    for i = 1:length(excel_filer)
        fil = excel_filer{i};
        kabel_type = kabel_typer{i};
        display_navn = display_navne{i};
        
        try
            % Læs Excel-fil
            if exist(fil, 'file')
                [~, ~, raw_data] = xlsread(fil);
                
                % Parse data og opret struktur
                kabel_database.(kabel_type) = ElDim.Database.parseKabelData(raw_data);
                
                fprintf('✓ Excel data indlæst for %s fra %s\n', display_navn, fil);
            else
                fprintf('⚠ Fil ikke fundet: %s. Bruger standard data.\n', fil);
                kabel_database.(kabel_type) = ElDim.Database.getStandardKabelData(display_navn);
            end
        catch ME
            fprintf('✗ Fejl ved indlæsning af %s: %s\n', fil, ME.message);
            fprintf('  → Bruger standard data i stedet.\n');
            kabel_database.(kabel_type) = ElDim.Database.getStandardKabelData(display_navn);
        end
    end
end