% +ElektroMat/+Forklaringssystem/afslutForklaring.m
function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % AFSLUTFORKLARING Afslutter en forklaring med et resultat
    %
    % Syntax:
    %   forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, resultat)
    %
    % Input:
    %   forklaringsOutput - Forklaringsoutput-struktur
    %   resultat - Slutresultat (tekst eller symbolsk)
    
    % Gem resultatet i output struktur
    if ischar(resultat)
        forklaringsOutput.resultat = resultat;
    elseif isa(resultat, 'sym')
        forklaringsOutput.resultat = char(resultat);
    else
        forklaringsOutput.resultat = char(resultat);
    end
    
    % Vis resultat med Symbolic Math Toolbox
    disp('RESULTAT:');
    try
        if isa(resultat, 'sym')
            % Allerede et symbolsk udtryk
            pretty(resultat);
        elseif ischar(resultat)
            % Prøv at konvertere til symbolsk hvis det ser ud som et matematisk udtryk
            if contains(resultat, {'=', '+', '-', '*', '/', '^'})
                try
                    symResult = str2sym(resultat);
                    pretty(symResult);
                catch
                    disp(['   ' resultat]);
                end
            else
                disp(['   ' resultat]);
            end
        else
            disp(['   ' forklaringsOutput.resultat]);
        end
    catch
        % Fallback hvis Symbolic Math Toolbox fejler
        disp(['   ' forklaringsOutput.resultat]);
    end
    
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end