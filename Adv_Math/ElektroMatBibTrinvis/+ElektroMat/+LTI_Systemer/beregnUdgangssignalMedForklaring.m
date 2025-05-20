function [y, forklaringsOutput] = beregnUdgangssignalMedForklaring(H_s, X_s, s, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % BEREGNUDGANGSSIGNAL_MED_FORKLARING Beregner udgangssignalet ved hjælp af overføringsfunktion og indgangssignal
    %
    % Syntax:
    %   [y, forklaringsOutput] = ElektroMatBibTrinvis.beregnUdgangssignalMedForklaring(H_s, X_s, s, t)
    %
    % Input:
    %   H_s - overføringsfunktion (symbolsk udtryk)
    %   X_s - Laplacetransformeret indgangssignal (symbolsk udtryk)
    %   s - kompleks variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   y - udgangssignal y(t) med kausalitetsbetingelse
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Beregning af udgangssignal');

    % Vis input
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer systemet og indgangssignalet', ...
        'Vi starter med at identificere systemets overføringsfunktion og indgangssignalets Laplacetransformation.', ...
        ['H(s) = ' char(H_s) '\nX(s) = ' char(X_s)]);

    % Multiplicer for at få Y(s)
    Y_s = H_s * X_s;
    Y_s_simpel = simplify(Y_s);

    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn udgangssignalets Laplacetransformation', ...
        'I frekvensdomænet er udgangssignalet produktet af overføringsfunktionen og indgangssignalet.', ...
        ['Y(s) = H(s) · X(s) = ' char(Y_s) '\nForenklet: Y(s) = ' char(Y_s_simpel)]);

    % Partialbrøkopløsning
    [num, den] = numden(Y_s_simpel);
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Forbered partialbrøkopløsning', ...
        'For at finde den inverse Laplacetransformation, skal vi først udføre en partialbrøkopløsning.', ...
        ['Y(s) = ' char(num) ' / ' char(den)]);

    % Forsøg partialbrøkopløsning med MATLAB's indbyggede funktion
    try
        [r, p, k] = residue(sym2poly(num), sym2poly(den));
        partial_str = '';
        for i = 1:length(r)
            if i == 1
                partial_str = [char(r(i)) '/(s-(' char(p(i)) '))'];
            else
                partial_str = [partial_str ' + ' char(r(i)) '/(s-(' char(p(i)) '))'];
            end
        end
        
        if ~isempty(k)
            for i = 1:length(k)
                if k(i) ~= 0
                    partial_str = [partial_str ' + ' char(k(i)) '*s^' char(length(k)-i)];
                end
            end
        end
        
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Udfør partialbrøkopløsning', ...
            'Vi opløser den rationelle funktion i simple brøker.', ...
            ['Y(s) = ' partial_str]);
    catch
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Partialbrøkopløsning', ...
            'Partialbrøkopløsningen er kompleks og kræver symbolsk beregning.', ...
            'Vi fortsætter med direkte invers Laplacetransformation.');
    end

    % Find den inverse Laplacetransformation
    [y, inv_forklaring] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(Y_s_simpel, s, t);

    % Tilføj yderligere trin fra den inverse Laplacetransformation
    for i = 2:length(inv_forklaring.trin)
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, i+3, ...
            inv_forklaring.trin{i}.titel, ...
            inv_forklaring.trin{i}.tekst, ...
            inv_forklaring.trin{i}.formel);
    end

    % TILFØJET: Sikre at kausalitet er inkluderet i udgangssignalet
    % (Denne kode er kun nødvendig hvis inversLaplaceMedForklaring ikke allerede tilføjer u(t))
    if ~has(y, 'u') && ~has(y, 'heaviside')
        try
            syms u;
            y_kausal = y * u(t);
            
            forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, ...
                length(forklaringsOutput.trin) + 1, ...
                'Sikre kausalt udgangssignal', ...
                'Vi sikrer at udgangssignalet er kausalt ved at tilføje enhedstrinfunktionen.', ...
                ['y(t) = ' char(y_kausal)]);
            
            y = y_kausal;
        catch
            % Hvis der opstår problemer med at definere symbolsk u(t), prøv med heaviside
            y_kausal = y * heaviside(t);
            
            forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, ...
                length(forklaringsOutput.trin) + 1, ...
                'Sikre kausalt udgangssignal', ...
                'Vi sikrer at udgangssignalet er kausalt ved at tilføje enhedstrinfunktionen.', ...
                ['y(t) = ' char(y_kausal)]);
            
            y = y_kausal;
        end
    end

    % Afslut forklaringen
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        ['Udgangssignalet er y(t) = ' char(y)]);
end