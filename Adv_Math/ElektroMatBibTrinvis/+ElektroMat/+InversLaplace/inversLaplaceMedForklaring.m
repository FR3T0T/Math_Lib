function [f, forklaringsOutput] = inversLaplaceMedForklaring(F, s, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % INVERSLAPLACE_MED_FORKLARING Beregner invers Laplacetransformation med trinvis forklaring
    %
    % Syntax:
    %   [f, forklaringsOutput] = inversLaplaceMedForklaring(F, s, t)
    %
    % Input:
    %   F - funktion af s (symbolsk)
    %   s - kompleks variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   f - Den oprindelige funktion f(t) med kausalitetsbetingelse (u(t))
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % INPUT VALIDERING
    if ~isa(F, 'sym') || ~isa(s, 'sym') || ~isa(t, 'sym')
        error('Alle input skal være symbolske variable');
    end
    
    if ~has(F, s)
        error('F skal være en funktion af s');
    end
    
    % Starter forklaring
    forklaringsOutput = startForklaring('Invers Laplacetransformation');
    
    % Vis den oprindelige funktion
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere Laplace-transformationen, som skal konverteres tilbage til tidsdomænet.', ...
        ['F(s) = ' char(F)]);
    
    % Analyser funktionstypen
    [Ftype, params] = ElektroMat.Funktionsanalyse.analyserLaplaceFunktion(F, s);
    
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
            % Brug MATLAB's ilaplace som backup med bedre fejlhåndtering
            try
                f = ilaplace(F, s, t);
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
                    'Brug MATLAB''s indbyggede ilaplace funktion', ...
                    'Funktionen er kompleks, så vi bruger MATLAB''s symbolske motor.', ...
                    ['Resultat: ' char(f)]);
            catch ME
                warning('Kunne ikke beregne invers Laplace-transformation: %s', ME.message);
                f = sym('UdefineredTransformation');
                forklaringsOutput = ElektroMat.InversLaplace.forklarInversGenerel(F, s, t, forklaringsOutput);
            end
    end
    
    % FORBEDRET KAUSALITETSHÅNDTERING
    % Tjek om vi har en rationel funktion af s, hvilket normalt indikerer et LTI-system
    needsCausality = false;
    try
        [num, den] = numden(F);
        if isa(den, 'sym') && has(den, s) && ~isequal(den, 1)
            needsCausality = true;
        elseif isa(den, 'double') && den ~= 1
            needsCausality = true;
        end
        
        % Tjek også om resultatet ikke allerede indeholder kausalitet
        if needsCausality && ~contains(char(f), 'heaviside') && ~contains(char(f), 'u(') && ~isequal(f, 0)
            needsCausality = true;
        else
            needsCausality = false;
        end
    catch
        % Hvis vi ikke kan afgøre det, antager vi at kausalitetsbetingelsen er nødvendig
        % men kun hvis f ikke er 0 eller indeholder fejlmeddelelser
        if ~isequal(f, 0) && ~contains(char(f), 'UdefineredTransformation')
            needsCausality = true;
        end
    end
    
    % Tilføj kausalitetsbetingelsen konsistent
    if needsCausality
        try
            f_kausal = f * heaviside(t);
            
            % Tilføj et forklaringstrin om kausalitetsbetingelsen
            forklaringsOutput = tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
                'Tilføj kausalitetsbetingelse', ...
                'For LTI-systemer skal vi sikre at responset er 0 for t < 0, så vi tilføjer enhedstrinfunktionen u(t).', ...
                ['f(t) = (' char(f) ') · u(t) = ' char(f_kausal)]);
            
            % Opdater resultatet
            f = f_kausal;
        catch
            % Hvis heaviside ikke virker, tilføj det som tekst
            forklaringsOutput = tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
                'Kausalitetsbetingelse', ...
                'Resultatet gælder kun for t ≥ 0 (kausalt system).', ...
                ['f(t) = (' char(f) ') · u(t) for t ≥ 0']);
        end
    end
    
    % Hvis forklaringen ikke allerede er afsluttet, gør vi det nu
    if ~isfield(forklaringsOutput, 'resultat') || isempty(forklaringsOutput.resultat)
        forklaringsOutput = afslutForklaring(forklaringsOutput, ['f(t) = ' char(f)]);
    end
end