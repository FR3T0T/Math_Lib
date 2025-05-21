function forbedretExpr = forbedreSymbolskVisning(expr)
    % FORBEDRESYMBOLSKVISNING Forbedrer visningen af symbolske udtryk specifikt til elektromagnetisme
    %
    % Syntax:
    %   forbedretExpr = ElektroMat.Symbolsk.forbedreSymbolskVisning(expr)
    %
    % Input:
    %   expr - Symbolsk udtryk
    %
    % Output:
    %   forbedretExpr - Forbedret symbolsk udtryk med pænere notation
    
    % Hvis ikke symbolsk, konverter til symbolsk
    if ~isa(expr, 'sym')
        try
            expr = sym(expr);
        catch
            forbedretExpr = expr;
            return;
        end
    end
    
    % Få LaTeX-streng
    latex_str = latex(expr);
    
    % Foretag specifikke ændringer for at forbedre visningen
    
    % Fourier-notationer
    latex_str = regexprep(latex_str, 'c_([0-9])', 'c_{$1}');  % Gør indekser pænere
    latex_str = regexprep(latex_str, '\|c_([^\|]+)\|(\^2)', '\\left|c_{$1}\\right|$2');  % Korrekte lodrette streger
    
    % Parsevalteorem-specifikke symboler
    latex_str = regexprep(latex_str, '\\int\\left|f\\left(t\\right)\\right|(\^2)', '\\int_{0}^{T} \\left|f\\left(t\\right)\\right|$1'); % Tilføj integrationgrænser
    
    % Effekt- og energisymboler
    latex_str = regexprep(latex_str, 'P_avg', 'P_{avg}');
    latex_str = regexprep(latex_str, 'E_tot', 'E_{tot}');
    
    % Forbedre brøker
    latex_str = regexprep(latex_str, '(\\frac{[^}]+}{[^}]+})', '$1');
    
    % Konverter tilbage til symbolsk udtryk
    try
        forbedretExpr = str2sym(['sympy("' latex_str '")']);
    catch
        % Hvis det mislykkes, brug det oprindelige udtryk
        forbedretExpr = expr;
    end
end