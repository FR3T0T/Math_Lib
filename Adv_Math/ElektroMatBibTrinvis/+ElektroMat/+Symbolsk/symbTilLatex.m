function latex_str = symbTilLatex(expr)
    % SYMBTILLATEX Konverterer et symbolsk udtryk til LaTeX-streng
    %
    % Syntax:
    %   latex_str = ElektroMat.Symbolsk.symbTilLatex(expr)
    %
    % Input:
    %   expr - Symbolsk udtryk eller konverterbart udtryk
    %
    % Output:
    %   latex_str - LaTeX formateret streng
    
    if ~isa(expr, 'sym')
        % Prøv at konvertere til symbolsk
        try
            expr = sym(expr);
        catch
            latex_str = char(expr);
            return;
        end
    end
    
    % Konverter til LaTeX
    latex_str = latex(expr);
    
    % Foretag specielle forbedringer for vores matematiske kontekst
    
    % Erstat |c_n|^2 med korrekt formatering
    latex_str = regexprep(latex_str, '\|c_([^\|]+)\|(\^2)', '\\left|c_{$1}\\right|$2');
    
    % Erstat almindelige Fourier-relaterede symboler for at gøre dem pænere
    latex_str = regexprep(latex_str, 'c0', 'c_0');
    latex_str = regexprep(latex_str, 'cn', 'c_n');
    latex_str = regexprep(latex_str, 'cmn', 'c_{-n}');
    
    % Erstat omega0 med \omega_0
    latex_str = regexprep(latex_str, 'omega0', '\\omega_0');
    
    % Sæt LaTeX dollartegn omkring
    latex_str = ['$' latex_str '$'];
end