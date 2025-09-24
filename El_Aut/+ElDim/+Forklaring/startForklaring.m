function forklaringsOutput = startForklaring(titel)
    forklaringsOutput = struct();
    forklaringsOutput.titel = titel;
    forklaringsOutput.trin = {};
    forklaringsOutput.dato = datestr(now);
    forklaringsOutput.resultat = '';
    
    fprintf('\n===== %s =====\n', upper(titel));
    fprintf('Startet: %s\n\n', forklaringsOutput.dato);
end