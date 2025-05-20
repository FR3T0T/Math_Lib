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
    
    if ischar(resultat)
        forklaringsOutput.resultat = resultat;
    else
        forklaringsOutput.resultat = char(resultat);
    end
    
    % Formatér resultat med LaTeX for pænere display i Live Scripts
    latex_resultat = formatUtils.konverterTilLatex(forklaringsOutput.resultat);
    
    % Del på linjer hvis der er \n
    resultat_linjer = strsplit(latex_resultat, '\n');
    
    % Vis resultat
    % Vis resultat
    disp('RESULTAT:');
    for i = 1:length(resultat_linjer)
        % Formatér med LaTeX til Live Script
        latex_line = formatUtils.konverterTilLatex(resultat_linjer{i});
        
        % Brug direkte displayFormula funktionen
        try
            displayFormula(latex_line);
        catch
            % Simpel fallback
            disp(['   ' resultat_linjer{i}]);
        end
    end
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end