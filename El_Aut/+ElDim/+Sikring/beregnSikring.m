function [resultat, forklaringsOutput] = beregnSikring(Ib, In, Iz, sikringstype)
    import ElDim.Forklaring.*
    
    sikrings_navn = {'MCB B-karakteristik', 'MCB C-karakteristik', 'Smeltesikring gG', 'Smeltesikring aM'};
    
    forklaringsOutput = startForklaring(sprintf('Sikringsberegning - %s', sikrings_navn{sikringstype}));
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Grundlæggende betingelser', ...
        'For korrekt sikringskoordinering skal tre betingelser være opfyldt', ...
        'Ib ≤ In ≤ Iz og I2 ≤ 1.45 × Iz');
    
    % Kontrol 1: Ib ≤ In
    check1 = Ib <= In;
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Betingelse 1: Driftsstrøm ≤ Sikringsstrøm', ...
        'Sikringen må ikke udløse under normale driftsforhold', ...
        sprintf('%.2f A ≤ %.2f A: %s', Ib, In, tf2str(check1)));
    
    % Kontrol 2: In ≤ Iz  
    check2 = In <= Iz;
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Betingelse 2: Sikringsstrøm ≤ Kabelbelastning', ...
        'Sikringen må ikke være større end kabelets kapacitet', ...
        sprintf('%.2f A ≤ %.2f A: %s', In, Iz, tf2str(check2)));
    
    % Kontrol 3: Udløsningsbetingelse
    switch sikringstype
        case {1, 2} % MCB
            I2 = In * 1.45;
            betingelse = '1.45 × In ≤ 1.45 × Iz';
        case {3, 4} % Smeltesikringer  
            I2 = In * 1.6;
            betingelse = '1.6 × In ≤ 1.45 × Iz';
    end
    
    check3 = I2 <= 1.45 * Iz;
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Betingelse 3: Udløsningsbetingelse', ...
        'Sikringen skal kunne beskytte kablet mod overbelastning', ...
        sprintf('%s: %.2f A ≤ %.2f A: %s', betingelse, I2, 1.45*Iz, tf2str(check3)));
    
    alle_ok = check1 && check2 && check3;
    
    resultat = struct('betingelse1', check1, 'betingelse2', check2, 'betingelse3', check3, 'resultat', alle_ok);
    
    if alle_ok
        status = 'Alle betingelser opfyldt ✓';
    else
        status = 'En eller flere betingelser ikke opfyldt ✗';
    end
    
    forklaringsOutput = afslutForklaring(forklaringsOutput, status);
end