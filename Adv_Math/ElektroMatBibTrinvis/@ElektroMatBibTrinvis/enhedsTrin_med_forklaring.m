

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
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Enhedstrinfunktionen');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér enhedstrinfunktionen', ...
        'Enhedstrinfunktionen u(t) repræsenterer et spring fra 0 til 1 ved tiden t = 0.', ...
        ['u(t-' char(t0) ') = { 1 for t ≥ ' char(t0) ', 0 for t < ' char(t0) ' }']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Egenskaber for enhedstrinfunktionen', ...
        ['Følgend