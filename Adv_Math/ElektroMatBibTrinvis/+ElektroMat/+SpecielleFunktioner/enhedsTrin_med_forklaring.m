function [F, forklaringsOutput] = enhedsTrin_med_forklaring(t0, t, s)
    % ENHEDSTRIN_MED_FORKLARING Forklarer enhedstrinfunktionen og dens Laplacetransformation
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(t0, t, s)
    %
    % Input:
    %   t0 - forskydning af enhedstrinfunktionen
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af u(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Konverter t0 til streng på en robust måde
    if isa(t0, 'sym')
        try
            t0_str = symbolToString(t0);
        catch
            t0_str = char(t0);
        end
    elseif isnumeric(t0)
        t0_str = num2str(t0);
    else
        t0_str = char(t0);
    end
    
    % Starter forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Enhedstrinfunktionen');
    
    % Brug eksplicit t0_str overalt
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér enhedstrinfunktionen', ...
        'Enhedstrinfunktionen u(t) repræsenterer et spring fra 0 til 1 ved tiden t = 0.', ...
        ['u(t-' t0_str ') = { 1 for t ≥ ' t0_str ', 0 for t < ' t0_str ' }']);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Egenskaber for enhedstrinfunktionen', ...
        ['Følgende egenskaber gælder for enhedstrinfunktionen:\n' ...
        '1. u(t) er diskontinuert ved t = 0\n' ...
        '2. d/dt[u(t)] = δ(t) (enhedstrinfunktionen er integralet af delta-funktionen)\n' ...
        '3. f(t)·u(t-t0) "tænder" for f(t) ved tiden t = t0'], ...
        '');
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend definitionen for Laplacetransformationen', ...
        'Vi anvender definitionen af Laplacetransformationen på enhedstrinfunktionen.', ...
        ['L{u(t-' t0_str ')} = ∫ u(t-' t0_str ')·e^(-st) dt fra 0- til ∞']);
    
    % Resultat afhænger af t0
    % Tjek numerisk værdi af t0 for at bestemme flowet
    t0_val = double(t0);
    
    if t0_val > 0
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Opdel integralet', ...
            ['Da ' t0_str ' > 0, starter springet efter t = 0:'], ...
            ['∫ u(t-' t0_str ')·e^(-st) dt = ∫ 0·e^(-st) dt fra 0 til ' t0_str ' + ∫ 1·e^(-st) dt fra ' t0_str ' til ∞']);
        
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn integralet', ...
            ['Vi løser integralet:'], ...
            ['∫ e^(-st) dt fra ' t0_str ' til ∞ = [-e^(-st)/s]_' t0_str '^∞ = 0 - (-e^(-s·' t0_str ')/s) = e^(-s·' t0_str ')/s']);
        
        F = exp(-s*t0)/s;
    elseif t0_val == 0
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Simpelt tilfælde for t0 = 0', ...
            'For t0 = 0 har vi den klassiske enhedstrinfunktion u(t).', ...
            ['∫ u(t)·e^(-st) dt = ∫ 1·e^(-st) dt fra 0 til ∞ = [-e^(-st)/s]_0^∞ = 0 - (-1/s) = 1/s']);
        
        F = 1/s;
    else % t0 < 0
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Analysér tilfældet t0 < 0', ...
            ['Da ' t0_str ' < 0, starter springet før t = 0, så u(t-' t0_str ') = 1 for hele integrationsområdet [0,∞).'], ...
            ['∫ u(t-' t0_str ')·e^(-st) dt = ∫ 1·e^(-st) dt fra 0 til ∞ = 1/s']);
        
        F = 1/s;
    end
    
    % Anvend forsinkelsesreglen
    if t0_val > 0
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 6, ...
            'Brug forsinkelsesreglen', ...
            ['Vi kan også anvende forsinkelsesreglen direkte:'], ...
            ['L{u(t-' t0_str ')} = L{u(t)}·e^(-s·' t0_str ') = (1/s)·e^(-s·' t0_str ') = e^(-s·' t0_str ')/s']);
    end
    
    % Afslut - bemærk at vi her bruger ElektroMat.Forklaringssystem i stedet for ElektroMatBibTrinvis
    F_str = symbolToString(F);
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        ['L{u(t-' t0_str ')} = ' F_str]);
end