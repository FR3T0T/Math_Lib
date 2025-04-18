function [F, forklaringsOutput] = forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
    % FORSINKELSESREGEL_MED_FORKLARING Forklarer forsinkelsesreglen (Second Shift Theorem)
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
    %
    % Input:
    %   f_expr - oprindelig funktion som symbolsk udtryk
    %   t0 - forsinkelsestid
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af f(t-t0)u(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Forsinkelsesreglen for Laplacetransformation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér den oprindelige funktion', ...
        'Vi starter med den oprindelige funktion f(t).', ...
        ['f(t) = ' char(f_expr)]);
    
    % Beregn Laplacetransformationen af den oprindelige funktion
    F_orig = laplace(f_expr, t, s);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Find Laplacetransformationen af f(t)', ...
        'Vi beregner først Laplacetransformationen af den oprindelige funktion.', ...
        ['L{f(t)} = ' char(F_orig)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Definér den forsinkede funktion', ...
        ['Vi ønsker at finde Laplacetransformationen af den forsinkede funktion f(t-' char(t0) ')u(t-' char(t0) ').'], ...
        ['Dette repræsenterer f(t) forskudt ' char(t0) ' tidenheder og "tændt" ved t = ' char(t0) '.']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Forklar forsinkelsesreglen', ...
        'Forsinkelsesreglen (Second Shift Theorem) siger:', ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = e^(-s·' char(t0) ') · L{f(t)}    for ' char(t0) ' > 0']);
    
    % Anvend forsinkelsesreglen
    F = exp(-s*t0) * F_orig;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Anvend forsinkelsesreglen', ...
        ['Vi anvender formlen direkte:'], ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = e^(-s·' char(t0) ') · ' char(F_orig) ' = ' char(F)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Fortolk resultatet', ...
        ['Forsinkelsesreglen viser, at en forsinkelse i tidsdomænet svarer til multiplikation med e^(-s·t0) i s-domænet.'], ...
        ['Dette er særligt nyttigt ved løsning af differentialligninger med forsinkede inputsignaler.']);
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = ' char(F)]);
end