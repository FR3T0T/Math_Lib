% +ElektroMat/+Forklaringssystem/startForklaring.m
function forklaringsOutput = startForklaring(titel)
    % Opretter en ny forklaring med symbolsk støtte
    
    % Initialisér strukturen
    forklaringsOutput = struct();
    forklaringsOutput.titel = titel;
    forklaringsOutput.trin = {};
    forklaringsOutput.figurer = {};
    forklaringsOutput.symbolske_elementer = {}; % Nyt felt til symbolske objekter
    forklaringsOutput.dato = datestr(now);
    forklaringsOutput.resultat = '';
    
    % Vis titel i et pænt format
    disp('');
    disp(['<strong>===== ' upper(titel) ' =====</strong>']);
    disp('');
end