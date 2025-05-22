function [Ftype, params] = analyserLaplaceFunktion(F, s)
    % ANALYSERLAPLACEFUNCTION Analyserer en Laplace-funktion og identificerer dens type
    %
    % Syntax:
    %   [Ftype, params] = analyserLaplaceFunktion(F, s)
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
        % Det er en brøk - undersøg strukturen
        
        % Konverter til polynomier for analyse
        try
            if isa(num, 'sym')
                num_poly = sym2poly(num);
            else
                num_poly = double(num);
            end
            
            if isa(den, 'sym')
                den_poly = sym2poly(den);
            else
                den_poly = double(den);
            end
            
            % Find poler
            poler = roots(den_poly);
            
            % Analyser polstrukturen
            if length(poler) == 1
                % En enkelt pol
                if abs(imag(poler(1))) < 1e-10
                    % Reel pol
                    Ftype = 'simpel_pol';
                    params.pol = poler(1);
                    return;
                end
            elseif length(poler) == 2
                % To poler
                if abs(poler(1) - poler(2)) < 1e-10
                    % Dobbelt pol
                    Ftype = 'dobbelt_pol';
                    params.pol = poler(1);
                    return;
                elseif abs(imag(poler(1))) > 1e-10 && abs(real(poler(1)) - real(poler(2))) < 1e-10
                    % Kompleks pol-par
                    Ftype = 'kvadratisk_naevner';
                    params.a = -real(poler(1));
                    params.b = abs(imag(poler(1)));
                    return;
                end
            end
            
            % Hvis vi kommer hertil, er det en generel rationel funktion
            Ftype = 'partiel_brok';
            params.num = num_poly;
            params.den = den_poly;
            params.poler = poler;
            return;
            
        catch
            % Hvis polynomium konvertering fejler
            Ftype = 'partiel_brok';
            params.num = num;
            params.den = den;
            return;
        end
        
    else
        % Ikke en brøk - undersøg andre mønstre
        
        % Tjek for simple former
        if isequal(F, s)
            Ftype = 'generel';
            params.form = 'lineær';
            return;
        end
        
        if has(F, s^2)
            Ftype = 'generel';
            params.form = 'polynomium';
            return;
        end
    end
    
    % Default: generel funktion
    Ftype = 'generel';
    params.udtryk = F;
end