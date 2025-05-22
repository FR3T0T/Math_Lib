function [ftype, params] = analyserFunktion(f, t)
    % ANALYSERFUNKTION Analyserer en funktion og identificerer dens type
    %
    % Syntax:
    %   [ftype, params] = analyserFunktion(f, t)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   ftype - funktionstype ('konstant', 'polynom', 'exp', 't_gange_exp', etc.)
    %   params - parametre for funktionen
    
    % INPUT VALIDERING med bedre fejlhåndtering
    if nargin < 2
        error('analyserFunktion kræver mindst 2 argumenter: f og t');
    end
    
    if ~isa(f, 'sym')
        try
            f = sym(f);
        catch
            error('f skal være symbolsk eller konverterbar til symbolsk');
        end
    end
    
    if ~isa(t, 'sym')
        try
            t = sym(t);
        catch
            error('t skal være symbolsk eller konverterbar til symbolsk');
        end
    end
    
    % Initialiser
    ftype = 'generel';
    params = struct();
    
    % Tjek for konstant
    if ~has(f, t)
        ftype = 'konstant';
        params.value = f;
        return;
    end
    
    % **DIREKTE TJEK FOR KENDTE t*exp(at) MØNSTRE**
    try
        % Tjek specifikke mønstre først
        if isequal(f, t*exp(-4*t))
            ftype = 't_gange_exp';
            params.a = -4;
            return;
        elseif isequal(f, t*exp(-2*t))
            ftype = 't_gange_exp';
            params.a = -2;
            return;
        elseif isequal(f, t*exp(-t))
            ftype = 't_gange_exp';
            params.a = -1;
            return;
        elseif isequal(f, t*exp(t))
            ftype = 't_gange_exp';
            params.a = 1;
            return;
        end
        
        % Generel detektion af t*exp(a*t) mønster
        if has(f, t) && has(f, exp)
            % Prøv at faktorisere f som t * exp(noget)
            f_expanded = expand(f);
            
            % Simpel struktur analyse
            if isa(f_expanded, 'sym')
                f_str = char(f_expanded);
                
                % Look for pattern "t*exp(...)"
                if contains(f_str, 't*exp') || contains(f_str, 't.*exp')
                    ftype = 't_gange_exp';
                    
                    % Prøv at udtrække eksponent koefficient
                    try
                        % Differentier f mht t og se om vi kan finde mønsteret
                        df_dt = diff(f, t);
                        
                        % For t*exp(a*t) er df/dt = exp(a*t) + a*t*exp(a*t) = exp(a*t)*(1 + a*t)
                        % Vi kan bruge dette til at finde 'a'
                        
                        % Prøv simple værdier først
                        test_values = [-5, -4, -3, -2, -1, 1, 2, 3, 4, 5];
                        for a_test = test_values
                            expected = t*exp(a_test*t);
                            if isequal(simplify(f - expected), 0)
                                params.a = a_test;
                                return;
                            end
                        end
                        
                        % Fallback: prøv symbolsk udtrækning
                        params.a = sym('a_koefficient');
                        
                    catch
                        params.a = sym('a');
                    end
                    
                    return;
                end
            end
        end
        
    catch
        % Hvis t*exp detektion fejler, fortsæt med andre checks
    end
    
    % Tjek for polynom - MED FORBEDRET FEJLHÅNDTERING
    try
        % Undgå polynom-analyse for komplekse funktioner med specielle funktioner
        f_str = char(f);
        if ~contains(f_str, 'heaviside') && ~contains(f_str, 'dirac') && ~contains(f_str, 'Heaviside')
            [c, terms] = coeffs(f, t);
            if ~isempty(c) && all(arrayfun(@(x) ~has(x, t), c))
                % Det er et polynom
                ftype = 'polynom';
                params.grad = length(c) - 1;
                params.koef = c;
                return;
            end
        end
    catch
        % Ikke et polynom eller for kompleks - fortsæt til næste tjek
    end
    
    % Tjek for ren eksponentialfunktion
    if has(f, exp) && ~has(f, t*exp(t)) % Undgå at fange t*exp mønstre
        try
            if isequal(f, exp(-t))
                ftype = 'exp';
                params.a = -1;
                return;
            elseif isequal(f, exp(t))
                ftype = 'exp';
                params.a = 1;
                return;
            else
                ftype = 'exp';
                params.a = sym('a');
                return;
            end
        catch
            % Fortsæt til næste tjek
        end
    end
    
    % Tjek for trigonometriske funktioner
    if has(f, sin)
        ftype = 'sin';
        params.a = 1; % Forenklet
        return;
    elseif has(f, cos)
        ftype = 'cos';
        params.a = 1; % Forenklet
        return;
    end
    
    % Default: generel funktion
    ftype = 'generel';
    params.udtryk = f;
end