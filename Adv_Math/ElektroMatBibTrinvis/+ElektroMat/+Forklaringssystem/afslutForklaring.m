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
    
    % Del på linjer hvis der er \n
    resultat_linjer = strsplit(forklaringsOutput.resultat, '\n');
    
    % Vis resultat
    disp('RESULTAT:');
    
    for i = 1:length(resultat_linjer)
        % Hvis linjen er tom, spring over
        if isempty(resultat_linjer{i})
            continue;
        end
        
        % Brug disp direkte for ren tekst
        disp(['   ' resultat_linjer{i}]);
    end
    
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end