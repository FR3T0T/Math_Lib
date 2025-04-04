

function [F, forklaringsOutput] = deltaFunktion_med_forklaring(t0, t, s)
    % DELTAFUNKTION_MED_FORKLARING Forklarer Dirac's delta-funktion og dens Laplacetransformation
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.deltaFunktion_med_forklaring(t0, t, s)
    %
    % Input:
    %   t0 - tidspunkt for impulsen
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af delta(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Diracs Delta-funktion');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér delta-funktionen', ...
        'Diracs delta-funktion er en generaliseret funktion, der repræsenterer en uend