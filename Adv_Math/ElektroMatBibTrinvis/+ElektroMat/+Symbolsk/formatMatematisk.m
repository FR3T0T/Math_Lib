function formatteret = formatMatematisk(expr)
    % FORMATMATEMATISK Formaterer et udtryk til pæn matematisk notation
    %
    % Syntax:
    %   formatteret = ElektroMat.Symbolsk.formatMatematisk(expr)
    %
    % Input:
    %   expr - Symbolsk udtryk, string eller numerisk værdi
    %
    % Output:
    %   formatteret - Formateret streng med LaTeX notation hvis muligt
    
    if isempty(expr)
        formatteret = '';
        return;
    end
    
    % Håndter forskellige typer input
    if isa(expr, 'sym')
        % Symbolsk objekt - konverter direkte til LaTeX
        formatteret = ['$' latex(expr) '$'];
    elseif ischar(expr) || isstring(expr)
        % String - prøv at konvertere til symbolsk
        if contains(expr, {'=', '+', '-', '*', '/', '^', 'int', 'sum', 'sqrt'})
            try
                sym_expr = str2sym(expr);
                formatteret = ['$' latex(sym_expr) '$'];
            catch
                % Hvis konvertering fejler, behold som tekst
                formatteret = expr;
            end
        else
            % Ikke et matematisk udtryk
            formatteret = expr;
        end
    elseif isnumeric(expr)
        % Numerisk - formatér pænt
        if isscalar(expr)
            if mod(expr, 1) == 0
                % Heltal
                formatteret = ['$' num2str(expr) '$'];
            else
                % Decimaltal - formatér med 4 decimaler, fjern efterfølgende nuller
                formatteret = ['$' num2str(expr, '%.4f') '$'];
                formatteret = regexprep(formatteret, '0+\$', '\$'); % Fjern efterfølgende nuller
                formatteret = regexprep(formatteret, '\.\$', '\$'); % Fjern . hvis alle decimaler er 0
            end
        elseif iscomplex(expr)
            % Komplekst tal
            formatteret = ['$' num2str(real(expr)) ' + ' num2str(imag(expr)) 'i$'];
        else
            % Matrix eller vektor - brug LaTeX matrix notation
            [m, n] = size(expr);
            if m == 1 || n == 1
                % Vektor
                vec_str = '\begin{bmatrix} ';
                for i = 1:numel(expr)
                    vec_str = [vec_str, num2str(expr(i))];
                    if i < numel(expr)
                        vec_str = [vec_str, ' & '];
                    end
                end
                vec_str = [vec_str, ' \end{bmatrix}'];
                formatteret = ['$' vec_str '$'];
            else
                % Matrix
                mat_str = '\begin{bmatrix} ';
                for i = 1:m
                    for j = 1:n
                        mat_str = [mat_str, num2str(expr(i,j))];
                        if j < n
                            mat_str = [mat_str, ' & '];
                        end
                    end
                    if i < m
                        mat_str = [mat_str, ' \\ '];
                    end
                end
                mat_str = [mat_str, ' \end{bmatrix}'];
                formatteret = ['$' mat_str '$'];
            end
        end
    else
        % Andet - konverter til string
        formatteret = char(expr);
    end
end