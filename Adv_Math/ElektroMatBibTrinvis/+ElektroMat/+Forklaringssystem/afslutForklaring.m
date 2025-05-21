% +ElektroMat/+Forklaringssystem/afslutForklaring.m
function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
    % Afslutter en forklaring med symbolsk resultat
    
    % Gem resultatet i output struktur
    if ischar(resultat)
        forklaringsOutput.resultat = resultat;
        % Prøv at konvertere til symbolsk
        try
            if contains(resultat, {'=', '+', '-', '*', '/', '^', 'int', 'sum', 'sqrt'})
                forklaringsOutput.symbolsk_resultat = str2sym(resultat);
            end
        catch
            % Fortsætter uden symbolsk resultat
        end
    elseif isa(resultat, 'sym')
        forklaringsOutput.resultat = char(resultat);
        forklaringsOutput.symbolsk_resultat = resultat;
    else
        forklaringsOutput.resultat = char(resultat);
    end
    
    % Vis resultat med Symbolic Math Toolbox
    disp('<strong>RESULTAT:</strong>');
    
    try
        if isa(resultat, 'sym')
            % Allerede et symbolsk udtryk
            formatSymbolsk(resultat);
        elseif ischar(resultat)
            % Prøv at konvertere til symbolsk hvis det ser ud som et matematisk udtryk
            if contains(resultat, {'=', '+', '-', '*', '/', '^', 'int', 'sum', 'sqrt'})
                try
                    symResult = str2sym(resultat);
                    formatSymbolsk(symResult);
                catch
                    disp(['   ' resultat]);
                end
            else
                disp(['   ' resultat]);
            end
        else
            disp(['   ' forklaringsOutput.resultat]);
        end
    catch e
        % Fallback hvis Symbolic Math Toolbox fejler
        warning(['Fejl ved symbolsk visning af resultat: ' e.message]);
        disp(['   ' forklaringsOutput.resultat]);
    end
    
    disp(' ');
    disp(['<strong>===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====</strong>']);
    disp(' ');
end

function formatSymbolsk(expr)
    % Helper funktion til at formatere symbolske udtryk
    try
        % For komplekse udtryk, brug latex og pæn udskrift
        latexStr = latex(expr);
        
        % Check om dette kører i Live Script miljø hvor vi kan bruge TeX
        if usejava('desktop') && ~isempty(which('matlab.internal.display.isHot')) && matlab.internal.display.isHot
            disp(['$' latexStr '$']);
        else
            % Ellers brug pretty print
            pretty(expr);
        end
    catch
        % Fallback hvis latex fejler
        pretty(expr);
    end
end