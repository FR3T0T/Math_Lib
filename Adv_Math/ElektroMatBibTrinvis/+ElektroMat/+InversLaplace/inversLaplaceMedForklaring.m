function [f, forklaringsOutput] = inversLaplaceMedForklaring(F, s, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % INVERSLAPLACE_MED_FORKLARING Beregner invers Laplacetransformation med trinvis forklaring
    %
    % Syntax:
    %   [f, forklaringsOutput] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(F, s, t)
    %
    % Input:
    %   F - funktion af s (symbolsk)
    %   s - kompleks variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   f - Den oprindelige funktion f(t) med kausalitetsbetingelse (u(t))
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Invers Laplacetransformation');
    
    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere Laplace-transformationen, som skal konverteres tilbage til tidsdomænet.', ...
        ['F(s) = ' char(F)]);
    
    % Analyser funktionstypen
    [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s);
    
    % Uddybende forklaring baseret på funktionstype
    switch Ftype
        case 'konstant'
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKonstant(F, s, t, params, forklaringsOutput);
        
        case 'simpel_pol'
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversSimplePol(F, s, t, params, forklaringsOutput);
        
        case 'dobbelt_pol'
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversDoublePol(F, s, t, params, forklaringsOutput);
            
        case 'kvadratisk_naevner'
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKvadratisk(F, s, t, params, forklaringsOutput);
            
        case 'partiel_brok'
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversPartielBrok(F, s, t, params, forklaringsOutput);
            
        otherwise
            % For alle andre tilfælde - beregn og brug generel forklaring
            f = ilaplace(F, s, t); % Brug MATLABs indbyggede funktion direkte
            forklaringsOutput = ElektroMat.InversLaplace.forklarInversGenerel(F, s, t, forklaringsOutput);
    end
    
    % OPDATERING: Tilføj kausalitetsbetingelse (u(t)) til resultatet
    % Tjek om vi har en rationel funktion af s, hvilket normalt indikerer et LTI-system
    try
        [num, den] = numden(F);
        isRational = ~has(num, s) || polynomialDegree(num, s) <= polynomialDegree(den, s);
        
        % Oversætter til "en rationel funktion hvor nævnerens grad er mindst så stor som tællerens"
        needsCausality = isRational && ~isequal(f, 0);
    catch
        % Hvis vi ikke kan afgøre det, antager vi at kausalitetsbetingelsen er nødvendig
        needsCausality = true;
    end
    
    % Tilføj kausalitetsbetingelsen hvis nødvendigt
    if needsCausality
        % Tilføj enhedstrinfunktionen
        try
            % Forsøg at bruge en symbolsk u(t) funktion
            syms u;
            f_kausal = f * u(t);
        catch
            % Fallback til heaviside hvis u ikke er defineret
            f_kausal = f * heaviside(t);
        end
        
        % Tilføj et forklaringstrin om kausalitetsbetingelsen
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
            'Tilføj kausalitetsbetingelse', ...
            'For LTI-systemer skal vi sikre at responset er 0 for t < 0, så vi tilføjer enhedstrinfunktionen u(t).', ...
            ['f(t) = ' char(f) ' · u(t) = ' char(f_kausal)]);
        
        % Opdater resultatet
        f = f_kausal;
    end
    
    % Hvis forklaringen ikke allerede er afsluttet, gør vi det nu
    if ~isfield(forklaringsOutput, 'resultat') || isempty(forklaringsOutput.resultat)
        forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ['f(t) = ' char(f)]);
    end
end