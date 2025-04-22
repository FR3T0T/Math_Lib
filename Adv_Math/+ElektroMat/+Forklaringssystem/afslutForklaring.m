function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
    % AFSLUTFORKLARING Afslutter en forklaring med et resultat
    %
    % Syntax:
    %   forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, resultat)
    %
    % Input:
    %   forklaringsOutput - Forklaringsoutput-struktur
    %   resultat - Slutresultat (tekst eller symbolsk)
    
    if ~ischar(resultat)
        try
            % Brug den nye hjælpefunktion til at konvertere symbolske udtryk
            resultat_str = symbolToString(resultat);
        catch
            % Fallback til standard konvertering
            resultat_str = char(resultat);
        end
    else
        resultat_str = resultat;
    end
    
    forklaringsOutput.resultat = resultat_str;
    
    % Vis resultat
    disp('RESULTAT:');
    disp(['   ' forklaringsOutput.resultat]);
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end