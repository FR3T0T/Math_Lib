function visFormelPaent(formelTekst)
    % VISFORMELPÆNT Viser en formel pænt formateret i MATLAB
    %
    % Syntax:
    %   visFormelPaent(formelTekst)
    %
    % Input:
    %   formelTekst - Tekst med LaTeX-kode
    
    % Fjern $ tegn hvis de findes
    formelTekst = strrep(formelTekst, '$', '');
    
    % Konverter standard notation til LaTeX
    formelTekst = strrep(formelTekst, 'sum_', '\sum_');
    formelTekst = strrep(formelTekst, 'int_', '\int_');
    formelTekst = strrep(formelTekst, 'omega_0', '\omega_0');
    formelTekst = strrep(formelTekst, 'pi', '\pi');
    formelTekst = strrep(formelTekst, 'delta', '\delta');
    formelTekst = strrep(formelTekst, '{-oo}', '{-\infty}');
    formelTekst = strrep(formelTekst, '{oo}', '{\infty}');
    
    % Opret en figur og brug text() med latex interpreter
    fig = figure('Position', [100, 100, 800, 200], 'Visible', 'on', 'Color', 'w');
    axes('Position', [0, 0, 1, 1], 'Visible', 'off');
    
    % Vis formlen med LaTeX-rendering
    text(0.5, 0.5, ['$' formelTekst '$'], ...
         'Interpreter', 'latex', ...
         'FontSize', 16, ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle');
    
    % Opdater figuren for at sikre at den vises korrekt
    drawnow;
end