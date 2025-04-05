function [F, forklaringsOutput] = laplace_med_forklaring(f, t, s)
    % LAPLACE_MED_FORKLARING Beregner Laplacetransformationen med trinvis forklaring
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.laplace_med_forklaring(f, t, s)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   s - kompleks variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen F(s)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Laplacetransformation');
    
    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere den funktion, der skal transformeres.', ...
        ['f(t) = ' char(f)]);
    
    % Analyser funktionstypen
    [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t);
    
    % Uddybende forklaring baseret på funktionstype
    switch ftype
        case 'konstant'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarKonstant(f, t, s, params, forklaringsOutput);
        case 'polynom'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarPolynom(f, t, s, params, forklaringsOutput);
        case 'exp'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExp(f, t, s, params, forklaringsOutput);
        case 'sin'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarSin(f, t, s, params, forklaringsOutput);
        case 'cos'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarCos(f, t, s, params, forklaringsOutput);
        case 'exp_sin'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExpSin(f, t, s, params, forklaringsOutput);
        case 'exp_cos'
            [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExpCos(f, t, s, params, forklaringsOutput);
        otherwise
            % For alle andre tilfælde - beregn og brug generel forklaring
            F = laplace(f, t, s); % Brug MATLABs indbyggede funktion direkte
            forklaringsOutput = ElektroMatBibTrinvis.forklarGenerel(f, t, s, forklaringsOutput);
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ['F(s) = ' char(F)]);
            return;
    end
    
    % Beregn og vis det endelige resultat
    F_check = laplace(f, t, s);
    F_simple = simplify(F_check);
    
    % Verificer resultatet
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
        'Verificer resultatet', ...
        'Vi kan verificere resultatet ved at sammenligne med MATLAB''s symbolske beregning.', ...
        ['L{f(t)} = ' char(F_simple)]);
    
    % Afslut forklaringen
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, F);
end