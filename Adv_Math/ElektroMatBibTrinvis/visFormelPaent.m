function visFormelPaent(formelTekst)
    % VISFORMELPÆNT Viser en formel pænt formateret i MATLAB Live Script
    %
    % Syntax:
    %   visFormelPaent(formelTekst)
    %
    % Input:
    %   formelTekst - Tekst med LaTeX-kode
    
    % Formatér til LaTeX
    formelTekst = strrep(formelTekst, '$', '');
    
    % Matematiske symboler
    formelTekst = strrep(formelTekst, 'sum_', '\sum_');
    formelTekst = strrep(formelTekst, 'int_', '\int_');
    formelTekst = strrep(formelTekst, 'omega_0', '\omega_0');
    formelTekst = strrep(formelTekst, 'pi', '\pi');
    formelTekst = strrep(formelTekst, 'infinity', '\infty');
    formelTekst = strrep(formelTekst, 'inf', '\infty');
    
    % Trigonometriske funktioner
    formelTekst = regexprep(formelTekst, '([^a-zA-Z])sin\(', '$1\sin(');
    formelTekst = regexprep(formelTekst, '^sin\(', '\sin(');
    formelTekst = regexprep(formelTekst, '([^a-zA-Z])cos\(', '$1\cos(');
    formelTekst = regexprep(formelTekst, '^cos\(', '\cos(');
    
    % Komplekse tal
    formelTekst = regexprep(formelTekst, '([0-9])i([^a-zA-Z0-9])', '$1\mathrm{i}$2');
    formelTekst = regexprep(formelTekst, '([0-9])i$', '$1\mathrm{i}');
    
    % Fjern særlige problemer
    formelTekst = strrep(formelTekst, 'p\mathrm{i}ecew\mathrm{i}se', 'piecewise');
    
    % Konverter til dobbelte backslash for LaTeX
    formelTekst = strrep(formelTekst, '\', '\\');
    
    % Brug displayFormula (MATLAB Live Script funktion)
    try
        displayFormula(formelTekst);
    catch
        % Hvis displayFormula ikke findes, brug disp som fallback
        disp(['LaTeX: ' formelTekst]);
    end
end