function [F, forklaringsOutput] = forklarPolynom(f, t, s, params, forklaringsOutput)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Forklaring for polynomium
    grad = params.grad;
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Identificer funktionstypen som et polynomium', ...
        ['Funktionen er et polynomium af grad ' num2str(grad) ' i variablen t.'], ...
        ['f(t) = ' char(f)]);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend linearitet af Laplacetransformationen', ...
        'Vi kan opdele polynomiet i enkeltled og transformere hvert led separat.', ...
        'L{a·f(t) + b·g(t)} = a·L{f(t)} + b·L{g(t)}');
    
    % Opsplit polynomiet i led
    terms = children(expand(f));
    if ~iscell(terms)
        terms = {terms};
    end
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Brug standardformlen for potenser af t', ...
        'For et led af formen t^n gælder: L{t^n} = n!/s^(n+1).', ...
        'Dette giver os formlen til at transformere hvert led i polynomiet.');
    
    % Transformér hvert led og opbyg resultatet
    result_str = '';
    F_sym = sym(0);
    
    for i = 1:length(terms)
        term = terms{i};
        if has(term, t)
            % Find koefficient og potens af t
            [coef, vars] = coeffs(term, t);
            for j = 1:length(vars)
                var = vars(j);
                if var == t
                    n = 1;
                else
                    try
                        n = sym2poly(var/t);
                    catch
                        n = 1; % Simpel antagelse for ikke-polynomielle led
                    end
                end
                
                fact_n = factorial(n);
                if isempty(result_str)
                    result_str = [char(coef(j)) '·' num2str(fact_n) '/s^' num2str(n+1)];
                else
                    result_str = [result_str ' + ' char(coef(j)) '·' num2str(fact_n) '/s^' num2str(n+1)];
                end
                
                F_sym = F_sym + coef(j) * fact_n / s^(n+1);
            end
        else
            % Konstant led
            const_val = term;
            if isempty(result_str)
                result_str = [char(const_val) '/s'];
            else
                result_str = [result_str ' + ' char(const_val) '/s'];
            end
            
            F_sym = F_sym + const_val / s;
        end
    end
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
        'Sammenregn alle led', ...
        'Vi samler nu alle transformerede led for at få den samlede Laplacetransformation.', ...
        ['L{f(t)} = ' result_str]);
    
    % Resultat
    F = F_sym;
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 6, ...
        'Simplifiser resultatet', ...
        'Det endelige resultat kan evt. simplificeres yderligere.', ...
        ['L{f(t)} = ' char(F)]);
    
    return;
end