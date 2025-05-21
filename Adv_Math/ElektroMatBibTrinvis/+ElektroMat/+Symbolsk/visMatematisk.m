function visMatematisk(expr, titel)
    % VISMATEMATISK Viser et matematisk udtryk pænt i kommandovinduet eller Live Script
    %
    % Syntax:
    %   ElektroMat.Symbolsk.visMatematisk(expr)
    %   ElektroMat.Symbolsk.visMatematisk(expr, titel)
    %
    % Input:
    %   expr - Symbolsk udtryk, string eller numerisk værdi
    %   titel - (valgfri) Titel der vises før udtrykket
    
    % Check for titel
    if nargin > 1 && ~isempty(titel)
        disp([titel ':']);
    end
    
    % Check miljø (Live Script eller kommandovindue)
    inLiveScript = usejava('desktop') && ~isempty(which('matlab.internal.display.isHot')) && matlab.internal.display.isHot;
    
    % Håndter forskellige typer input
    if isa(expr, 'sym')
        if inLiveScript
            disp(['$' latex(expr) '$']);
        else
            pretty(expr);
        end
    elseif ischar(expr) || isstring(expr)
        % String - prøv at konvertere til symbolsk
        if contains(expr, {'=', '+', '-', '*', '/', '^', 'int', 'sum', 'sqrt'})
            try
                sym_expr = str2sym(expr);
                if inLiveScript
                    disp(['$' latex(sym_expr) '$']);
                else
                    pretty(sym_expr);
                end
            catch
                % Hvis konvertering fejler, behold som tekst
                disp(expr);
            end
        else
            % Ikke et matematisk udtryk
            disp(expr);
        end
    elseif isnumeric(expr)
        % For numeriske værdier
        if inLiveScript && (iscomplex(expr) || (ismatrix(expr) && ~isscalar(expr)))
            % Vis komplekse tal eller matricer i LaTeX format
            formatted = ElektroMat.Symbolsk.formatMatematisk(expr);
            disp(formatted);
        else
            % Almindelig visning for simple tal
            disp(expr);
        end
    else
        % Andet - vis som tekst
        disp(char(expr));
    end
end