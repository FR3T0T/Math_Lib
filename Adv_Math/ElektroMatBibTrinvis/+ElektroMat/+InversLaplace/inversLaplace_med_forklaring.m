function [f, forklaringsOutput] = inversLaplace_med_forklaring(F, s, t)
    % INVERSLAPLACE_MED_FORKLARING Beregner invers Laplacetransformation med trinvis forklaring
    %
    % Syntax:
    %   [f, forklaringsOutput] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F, s, t)
    %
    % Input:
    %   F - funktion af s (symbolsk)
    %   s - kompleks variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   f - Den oprindelige funktion f(t)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Invers Laplacetransformation');
    
    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere Laplace-transformationen, som skal konverteres tilbage til tidsdomænet.', ...
        ['F(s) = ' char(F)]);
    
    % Analyser funktionstypen
    [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s);
    
    % Uddybende forklaring baseret på funktionstype
    switch Ftype
        case 'konstant'
            [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversKonstant(F, s, t, params, forklaringsOutput);
        case 'simpel_pol'
            [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversSimplePol(F, s, t, params, forklaringsOutput);
        case 'dobbelt_pol'
            [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversDoublePol(F, s, t, params, forklaringsOutput);
        case 'kvadratisk_naevner'
            [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversKvadratisk(F, s, t, params, forklaringsOutput);
        case 'partiel_brok'
            [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversPartielBrok(F, s, t, params, forklaringsOutput);
        otherwise
            % For alle andre tilfælde - beregn og brug generel forklaring
            f = ElektroMatBib.inversLaplace(F, s, t);
            forklaringsOutput = ElektroMatBibTrinvis.forklarInversGenerel(F, s, t, forklaringsOutput);
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ['f(t) = ' char(f)]);
            return;
    end
    
    % Beregn og vis det endelige resultat
    f_check = ElektroMatBib.inversLaplace(F, s, t);
    f_simple = simplify(f_check);
    
    % Verificer resultatet
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
        'Verificer resultatet', ...
        'Vi kan verificere resultatet ved at sammenligne med MATLAB''s symbolske beregning.', ...
        ['L^(-1){F(s)} = ' char(f_simple)]);
    
    % Afslut forklaringen
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, f);
end