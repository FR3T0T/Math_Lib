function [resultat, forklaringsOutput] = dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype)
    import ElDim.Forklaring.*
    
    forklaringsOutput = startForklaring('Kabeldimensionering');
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Indlæs parametre', ...
        sprintf('Driftsstrøm Ib = %.2f A, Sikringsstrøm In = %.2f A', Ib, In), ...
        sprintf('Korrektionsfaktorer: Ca=%.2f, Cg=%.2f, Ci=%.2f', Ca, Cg, Ci));
    
    % Beregn minimum belastningsevne
    Iz_min = (Ib * 1.45) / (Ca * Cg * Ci);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn minimum belastningsevne', ...
        'Iz skal kunne bære driftsstrømmen med sikkerhedsfaktor og korrektioner', ...
        sprintf('Iz,min = (Ib × 1.45) / (Ca × Cg × Ci) = %.2f A', Iz_min));
    
    % Kabeldata
    kabel_data = containers.Map();
    kabel_data('1.5') = [18.5, 15.5, 13.5]; % NYM, PFXP, NYY-J
    kabel_data('2.5') = [25, 21, 18];
    kabel_data('4') = [32, 27, 24];
    kabel_data('6') = [41, 35, 31];
    kabel_data('10') = [57, 48, 42];
    kabel_data('16') = [76, 63, 56];
    kabel_data('25') = [101, 84, 73];
    kabel_data('35') = [125, 104, 90];
    
    % Find passende kabelareal
    areas = {'1.5', '2.5', '4', '6', '10', '16', '25', '35'};
    valgt_areal = '';
    valgt_Iz = 0;
    
    for i = 1:length(areas)
        area = areas{i};
        capacities = kabel_data(area);
        if capacities(kabeltype) >= Iz_min
            valgt_areal = area;
            valgt_Iz = capacities(kabeltype);
            break;
        end
    end
    
    if ~isempty(valgt_areal)
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
            'Vælg kabelareal', ...
            sprintf('Første kabelareal der opfylder krav: %s mm²', valgt_areal), ...
            sprintf('Iz = %.1f A ≥ %.2f A ✓', valgt_Iz, Iz_min));
        
        % Kontroller In ≤ Iz
        if In <= valgt_Iz
            status = 'OK ✓';
        else
            status = 'IKKE OK ✗';
        end
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
            'Kontroller sikringskoordinering', ...
            'Sikringsstrømmen må ikke overstige kabelets belastningsevne', ...
            sprintf('In (%.1f A) ≤ Iz (%.1f A): %s', In, valgt_Iz, status));
        
        resultat = struct('areal', valgt_areal, 'Iz', valgt_Iz, 'status', status);
    else
        resultat = struct('areal', 'FEJL', 'Iz', 0, 'status', 'Intet kabel kan klare belastningen');
    end
    
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        sprintf('Kabelareal: %s mm² (Iz = %.1f A)', resultat.areal, resultat.Iz));
end