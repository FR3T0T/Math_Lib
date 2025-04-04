function [Ftype, params] = analyserLaplaceFunktion(F, s)
    % ANALYSERLAPLACEFUNCTION Analyserer en Laplace-funktion og identificerer dens type
    %
    % Syntax:
    %   [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s)
    %
    % Input:
    %   F - funktion af s (symbolsk)
    %   s - kompleks variabel (symbolsk)
    % 
    % Output:
    %   Ftype - funktionstype ('konstant', 'simpel_pol', 'dobbelt_pol', etc.)
    %   params - parametre for funktionen
    
    % Initialiser
    Ftype = 'generel';
    params = struct();
    
    % Tjek for konstant
    if ~has(F, s)
        Ftype = 'konstant';
        params.value = F;
        return;
    end
    
    % Tjek om det er en brøk
    [num, den] = numden(F);
    
    if den ~= 1
        % Det er en brøk
        
        % Tjek for simple poler
        if den == s - sym('a')
            Ftype = 'simpel_pol';
            params.pol = sym('a');
            return;
        elseif den == s + sym('a')
            Ftype = 'simpel_pol';
            params.pol = -sym('a');
            return;
        elseif den == (s - sym('a'))^2
            Ftype = 'dobbelt_pol';
            params.pol = sym('a');
            return;
        elseif den == (s + sym('a'))^2
            Ftype = 'dobbelt_pol';
            params.pol = -sym('a');
            return;
        end
        
        % Tjek for kvadratisk nævner
        try
            den_expanded = expand(den);
            if polynomialDegree(den_expanded, s) == 2
                % Kvadratisk nævner
                coef = coeffs(den_expanded, s, 'All');
                if length(coef) == 3
                    a = coef(2) / coef(1);
                    b_squared = coef(3) / coef(1);
                    
                    if b_squared > 0 % Skal være positivt for komplekse rødder
                        Ftype = 'kvadratisk_naevner';
                        params.a = a/2;
                        params.b = sqrt(b_squared - (a/2)^2);
                        return;
                    end
                end
            end
        catch
            % Ikke kvadratisk eller kunne ikke analyseres
        end
        
        % Tjek for partiel brøk
        try
            % Forsøg at konvertere til polynomier
            num_poly = sym2poly(num);
            den_poly = sym2poly(den);
            Ftype = 'partiel_brok';
            params.num = num_poly;
            params.den = den_poly;
            % Normalt ville vi beregne rester og poler her, men for enkelheds skyld
            % opretholder vi kun polynomierne
            return;
        catch
            % Ikke en rationel funktion der kan konverteres til polynomier
        end
    end
end