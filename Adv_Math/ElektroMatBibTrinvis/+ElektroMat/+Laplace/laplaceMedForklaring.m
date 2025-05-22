function [F, forklaringsOutput] = laplaceMedForklaring(f, t, s)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % LAPLACE_MED_FORKLARING Beregner Laplacetransformationen med trinvis forklaring
    %
    % Syntax:
    %   [F, forklaringsOutput] = laplaceMedForklaring(f, t, s)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen F(s)
    %   forklaringsOutput - Struktur med forklaringstrin

    % INPUT VALIDERING
    if ~isa(f, 'sym') || ~isa(t, 'sym') || ~isa(s, 'sym')
        error('Alle input skal være symbolske variable');
    end
    
    if ~has(f, t)
        error('f skal være en funktion af t');
    end

    % Start forklaring
    forklaringsOutput = startForklaring('Laplacetransformation');

    % Vis den oprindelige funktion
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med at identificere den funktion, der skal transformeres.', ...
        ['f(t) = ' char(f)]);

    % Analyser funktionen med forbedret fejlhåndtering
    try
        [ftype, params] = ElektroMat.Funktionsanalyse.analyserFunktion(f, t);
    catch ME
        warning('Funktionsanalyse fejlede: %s', ME.message);
        ftype = 'generel';
        params = struct();
    end
    
    % Baseret på funktionstypen, anvend forskellige tilgange
    switch ftype
        case 'konstant'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarKonstant(f, t, s, params, forklaringsOutput);
        
        case 'polynom'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarPolynom(f, t, s, params, forklaringsOutput);
        
        case 'exp'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExp(f, t, s, params, forklaringsOutput);
            
        case 't_gange_exp'  % NY CASE
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarTGangeExp(f, t, s, params, forklaringsOutput);
            
        case 'sin'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarSin(f, t, s, params, forklaringsOutput);
            
        case 'cos'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarCos(f, t, s, params, forklaringsOutput);
            
        case 'exp_sin'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpSin(f, t, s, params, forklaringsOutput);
            
        case 'exp_cos'
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpCos(f, t, s, params, forklaringsOutput);
            
        otherwise
            % For generelle funktioner, brug symbolsk beregning med forbedret fejlhåndtering
            try
                F = laplace(f, t, s);
                
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
                    'Beregn Laplacetransformationen symbolsk', ...
                    'Vi beregner integralet symbolsk:', ...
                    ['F(s) = ' char(F)]);
                    
            catch ME
                warning('Symbolsk Laplacetransformation fejlede: %s', ME.message);
                F = sym('KompleksLaplaceTransformation_KraeverSpecielleTeknikker');
                
                forklaringsOutput = ElektroMat.Laplace.forklarGenerel(f, t, s, forklaringsOutput);
                
                % Tilføj fejlbesked til forklaring
                forklaringsOutput = tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
                    'Bemærkning om beregningskompleksitet', ...
                    ['Automatisk beregning fejlede: ' ME.message], ...
                    'Konsulter tabeller over Laplacetransformationer eller brug specialiserede teknikker.');
            end
    end
    
    % Tilføj bemærkning om konvergensområde og kausalitet
    if ~contains(char(F), 'KompleksLaplaceTransformation') && ~contains(char(F), 'TransformationEksistererIkke')
        forklaringsOutput = tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
            'Bemærkning om konvergensområde', ...
            'Laplacetransformationen er kun gyldig i det relevante konvergensområde.', ...
            'For kausale funktioner (f(t) = 0 for t < 0) gælder transformationen for Re{s} større end den største realdel af polerne.');
    end
    
    % Afslut forklaring hvis den ikke allerede er afsluttet
    if ~isfield(forklaringsOutput, 'resultat') || isempty(forklaringsOutput.resultat)
        forklaringsOutput = afslutForklaring(forklaringsOutput, ['F(s) = ' char(F)]);
    end
end