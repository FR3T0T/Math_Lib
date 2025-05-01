% +ElektroMat/+Forklaringssystem/startForklaring.m
function forklaringsOutput = startForklaring(titel)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % STARTFORKLARING Initialiserer et nyt forklaringsoutput-objekt
    %
    % Syntax:
    %   forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring(titel)
    %
    % Input:
    %   titel - Titel på forklaringen
    %
    % Output:
    %   forklaringsOutput - Struktur til opbevaring af forklaringstrin
    
    forklaringsOutput = struct();
    forklaringsOutput.titel = titel;
    forklaringsOutput.trin = {};
    forklaringsOutput.figurer = {};
    forklaringsOutput.dato = datestr(now);
    forklaringsOutput.resultat = '';
    
    % Vis titel
    disp(['===== ' upper(titel) ' =====']);
    disp(' ');
end