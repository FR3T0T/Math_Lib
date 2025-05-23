function [F, forklaringsOutput] = forklarKonstant(f, t, s, params, forklaringsOutput)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Forklaring for konstant funktion
    const_val = params.value;
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Identificer funktionstypen som konstant', ...
        'Da funktionen ikke afhænger af t, er den en konstant funktion.', ...
        ['f(t) = ' char(const_val)]);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend definitionen af Laplacetransformationen', ...
        'Vi begynder med definitionen af Laplacetransformationen og indsætter vores funktion.', ...
        ['L{f(t)} = ∫ ' char(const_val) ' · e^(-st) dt fra 0 til ∞']);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Træk konstanten uden for integralet', ...
        'Da konstanten ikke afhænger af integrationsvariablen, kan vi trække den uden for integralet.', ...
        ['L{f(t)} = ' char(const_val) ' · ∫ e^(-st) dt fra 0 til ∞']);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
        'Beregn integralet af den eksponentielle funktion', ...
        'Integralet af e^(-st) med hensyn til t er -e^(-st)/s.', ...
        ['L{f(t)} = ' char(const_val) ' · [-e^(-st)/s]_0^∞']);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 6, ...
        'Indsæt integrationsgrænserne', ...
        'Ved at indsætte de øvre og nedre grænser får vi:',  ...
        ['L{f(t)} = ' char(const_val) ' · (0 - (-1/s)) = ' char(const_val) ' · (1/s)']);
    
    % Resultat
    F = const_val / s;
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 7, ...
        'Simplifiser resultatet', ...
        'Vi kan nu udtrykke det endelige resultat i simpleste form.', ...
        ['L{f(t)} = ' char(const_val) '/s = ' char(F)]);
    
    return;
end