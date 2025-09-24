function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
    forklaringsOutput.resultat = resultat;
    
    fprintf('RESULTAT: %s\n', resultat);
    fprintf('===== AFSLUTTET: %s =====\n\n', upper(forklaringsOutput.titel));
end