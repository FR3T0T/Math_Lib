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
    
    % Vis resultat
    disp('RESULTAT:');
    disp(['   ' forklaringsOutput.resultat]);
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end