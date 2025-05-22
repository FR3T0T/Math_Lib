function [y, forklaringsOutput] = beregnUdgangssignalMedForklaring(H_s, X_s, s, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % BEREGNUDGANGSSIGNAL_MED_FORKLARING Beregner udgangssignalet ved hjælp af overføringsfunktion og indgangssignal
    %
    % Syntax:
    %   [y, forklaringsOutput] = beregnUdgangssignalMedForklaring(H_s, X_s, s, t)
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

    % INPUT VALIDERING
    if ~isa(H_s, 'sym') || ~isa(X_s, 'sym') || ~isa(s, 'sym') || ~isa(t, 'sym')
        error('Alle input skal være symbolske variable');
    end
    
    if ~has(H_s, s) || ~has(X_s, s)
        error('H_s og X_s skal være funktioner af s');
    end

    % Start forklaring
    forklaringsOutput = startForklaring('Beregning af udgangssignal');

    % Vis input
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer systemet og indgangssignalet', ...
        'Vi starter med at identificere systemets overføringsfunktion og indgangssignalets Laplacetransformation.', ...
        ['H(s) = ' char(H_s) char(10) 'X(s) = ' char(X_s)]);

    % Multiplicer for at få Y(s)
    Y_s = H_s * X_s;
    Y_s_simpel = simplify(Y_s);

    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn udgangssignalets Laplacetransformation', ...
        'I frekvensdomænet er udgangssignalet produktet af overføringsfunktionen og indgangssignalet.', ...
        ['Y(s) = H(s) · X(s) = ' char(Y_s) char(10) 'Forenklet: Y(s) = ' char(Y_s_simpel)]);

    % Forbered partialbrøkopløsning information
    [num, den] = numden(Y_s_simpel);
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
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
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
            'Udfør partialbrøkopløsning', ...
            'Vi opløser den rationelle funktion i simple brøker.', ...
            ['Y(s) = ' partial_str]);
    catch
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
            'Partialbrøkopløsning', ...
            'Partialbrøkopløsningen er kompleks og kræver symbolsk beregning.', ...
            'Vi fortsætter med direkte invers Laplacetransformation.');
    end

    % Find den inverse Laplacetransformation med konsistent kausalitetshåndtering
    [y, inv_forklaring] = ElektroMat.InversLaplace.inversLaplaceMedForklaring(Y_s_simpel, s, t);

    % Tilføj yderligere trin fra den inverse Laplacetransformation
    start_trin = 5;
    for i = 2:length(inv_forklaring.trin)
        forklaringsOutput = tilfoejTrin(forklaringsOutput, start_trin + i - 2, ...
            inv_forklaring.trin{i}.titel, ...
            inv_forklaring.trin{i}.tekst, ...
            inv_forklaring.trin{i}.formel);
    end

    % KONSISTENT KAUSALITETSHÅNDTERING - dette sker nu automatisk i inversLaplaceMedForklaring
    % Så vi behøver ikke at gøre det igen her

    % Afslut forklaringen
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['Udgangssignalet er y(t) = ' char(y)]);
end