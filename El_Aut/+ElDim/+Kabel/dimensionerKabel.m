function [resultat, forklaringsOutput] = dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype)
    % Indlæs kabeldatabase (brug kun standard data for at undgå Excel fejl)
    persistent kabel_database;
    if isempty(kabel_database)
        kabel_database = ElDim.Database.indlaesKabelData(false); % false = skip Excel
    end
    
    forklaringsOutput = ElDim.Forklaring.startForklaring('Kabeldimensionering');
    
    % FIX: Kabeltype navne - struct field navne og display navne
    kabel_type_struct = {'NYM', 'PFXP', 'NYY_J', 'NHXH'};  % Struct field navne
    kabel_type_display = {'NYM', 'PFXP', 'NYY-J', 'NHXH'}; % Display navne
    
    if kabeltype > length(kabel_type_struct)
        error('Ugyldigt kabeltype nummer: %d', kabeltype);
    end
    
    valgt_kabel_struct = kabel_type_struct{kabeltype};   % Til database lookup
    valgt_kabel_display = kabel_type_display{kabeltype}; % Til display
    
    forklaringsOutput = ElDim.Forklaring.tilfoejTrin(forklaringsOutput, 1, ...
        'Indlæs parametre', ...
        sprintf('Driftsstrøm Ib = %.2f A, Sikringsstrøm In = %.2f A, Kabeltype: %s', Ib, In, valgt_kabel_display), ...
        sprintf('Korrektionsfaktorer: Ca=%.2f, Cg=%.2f, Ci=%.2f', Ca, Cg, Ci));
    
    % Beregn minimum belastningsevne
    Iz_min = (Ib * 1.45) / (Ca * Cg * Ci);
    
    forklaringsOutput = ElDim.Forklaring.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn minimum belastningsevne', ...
        'Iz skal kunne bære driftsstrømmen med sikkerhedsfaktor og korrektioner', ...
        sprintf('Iz,min = (Ib × 1.45) / (Ca × Cg × Ci) = %.2f A', Iz_min));
    
    % Find passende kabel fra database - brug struct field navn
    data = kabel_database.(valgt_kabel_struct);
    valgt_areal = '';
    valgt_Iz = 0;
    valgt_producent = '';
    
    for i = 1:length(data.tvaersnit)
        if data.belastningsevne(i) >= Iz_min
            valgt_areal = data.tvaersnit{i};
            valgt_Iz = data.belastningsevne(i);
            if isfield(data, 'producent')
                valgt_producent = data.producent{i};
            end
            break;
        end
    end
    
    if ~isempty(valgt_areal)
        forklaringsOutput = ElDim.Forklaring.tilfoejTrin(forklaringsOutput, 3, ...
            'Vælg kabelareal fra database', ...
            sprintf('Første kabelareal der opfylder krav: %s mm² (%s %s)', valgt_areal, valgt_kabel_display, valgt_producent), ...
            sprintf('Iz = %.1f A ≥ %.2f A ✓', valgt_Iz, Iz_min));
        
        % Kontroller In ≤ Iz
        if In <= valgt_Iz
            status = 'OK ✓';
        else
            status = 'IKKE OK ✗';
        end
        
        forklaringsOutput = ElDim.Forklaring.tilfoejTrin(forklaringsOutput, 4, ...
            'Kontroller sikringskoordinering', ...
            'Sikringsstrømmen må ikke overstige kabelets belastningsevne', ...
            sprintf('In (%.1f A) ≤ Iz (%.1f A): %s', In, valgt_Iz, status));
        
        resultat = struct('areal', valgt_areal, 'Iz', valgt_Iz, 'status', status, ...
                         'kabeltype', valgt_kabel_display, 'producent', valgt_producent);
    else
        resultat = struct('areal', 'FEJL', 'Iz', 0, 'status', 'Intet kabel kan klare belastningen', ...
                         'kabeltype', valgt_kabel_display, 'producent', '');
    end
    
    forklaringsOutput = ElDim.Forklaring.afslutForklaring(forklaringsOutput, ...
        sprintf('Kabelareal: %s mm² %s (Iz = %.1f A)', resultat.areal, valgt_kabel_display, resultat.Iz));
end