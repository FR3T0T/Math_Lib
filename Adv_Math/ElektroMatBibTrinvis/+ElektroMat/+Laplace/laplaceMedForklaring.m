function [F, forklaringsOutput] = laplaceMedForklaring(f, t, s)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % LAPLACE_MED_FORKLARING Beregner Laplacetransformationen med trinvis forklaring
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMat.Laplace.laplaceMedForklaring(f, t, s)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen F(s)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = startForklaring('Laplacetransformation');

    % Vis den oprindelige funktion
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere den funktion, der skal transformeres.', ...
        ['f(t) = ' char(f)]);

    % Analyser funktionen
    [ftype, params] = ElektroMat.Funktionsanalyse.analyserFunktion(f, t);
    
    % Baseret på funktionstypen, anvend forskellige tilgange
    switch ftype
        case 'konstant'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarKonstant(f, t, s, params, forklaringsOutput);
        
        case 'polynom'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarPolynom(f, t, s, params, forklaringsOutput);
        
        case 'exp'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExp(f, t, s, params, forklaringsOutput);
            
        case 'sin'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarSin(f, t, s, params, forklaringsOutput);
            
        case 'cos'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarCos(f, t, s, params, forklaringsOutput);
            
        case 'exp_sin'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpSin(f, t, s, params, forklaringsOutput);
            
        case 'exp_cos'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpCos(f, t, s, params, forklaringsOutput);
            
        otherwise
            % For generelle funktioner, brug symbolsk beregning hvis muligt
            try
                F = laplace(f, t, s);
                
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
                    'Beregn Laplacetransformationen symbolsk', ...
                    'Vi beregner integralet symbolsk:', ...
                    ['F(s) = ' char(F)]);
            catch
                F = sym('Complex Laplace Transform');
                
                forklaringsOutput = ElektroMat.Laplace.forklarGenerel(f, t, s, forklaringsOutput);
            end
    end
    
    % Afslut forklaring hvis den ikke allerede er afsluttet
    if ~isfield(forklaringsOutput, 'resultat') || isempty(forklaringsOutput.resultat)
        forklaringsOutput = afslutForklaring(forklaringsOutput, ['F(s) = ' char(F)]);
    end
end