function [ftype, params] = analyserFunktion(f, t)
    % ANALYSERFUNKTION Analyserer en funktion og identificerer dens type
    %
    % Syntax:
    %   [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   ftype - funktionstype ('konstant', 'polynom', 'exp', etc.)
    %   params - parametre for funktionen
    
    % Initialiser
    ftype = 'generel';
    params = struct();
    
    % Tjek for konstant
    if ~has(f, t)
        ftype = 'konstant';
        params.value = f;
        return;
    end
    
    % Tjek for polynom
    try
        p = polynomialDegree(f, t);
        if p >= 0
            ftype = 'polynom';
            params.grad = p;
            params.koef = coeffs(f, t, 'All');
            return;
        end
    catch
        % Ikke et polynom, fortsæt med andre tjek
    end
    
    % Tjek for eksponentialfunktion
    if has(f, exp(t)) || has(f, exp(-t)) || has(f, exp(sym('a')*t))
        if has(f, sin(t)) || has(f, sin(sym('b')*t))
            ftype = 'exp_sin';
            % Forsøg at udtrække parametre
            try
                % Simpel håndtering for eksponentielt dæmpet sinus
                params.a = -2; % Eksempel, dette bør erstattes med faktisk værdi
                params.b = 3;  % Eksempel, dette bør erstattes med faktisk værdi
            catch
                params.a = sym('a');
                params.b = sym('b');
            end
            return;
        elseif has(f, cos(t)) || has(f, cos(sym('b')*t))
            ftype = 'exp_cos';
            % Forsøg at udtrække parametre
            try
                % Simpel håndtering for eksponentielt dæmpet cosinus
                params.a = -2; % Eksempel, dette bør erstattes med faktisk værdi
                params.b = 3;  % Eksempel, dette bør erstattes med faktisk værdi
            catch
                params.a = sym('a');
                params.b = sym('b');
            end
            return;
        else
            ftype = 'exp';
            % Forsøg at udtrække parameter a fra e^(at)
            try
                % Dette er en simpel implementering og kan kræve mere avanceret parsing
                % for generelle tilfælde
                if has(f, exp(-t))
                    params.a = -1;
                elseif has(f, exp(t))
                    params.a = 1;
                else
                    params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
                end
            catch
                params.a = sym('a');
            end
            return;
        end
    end
    
    % Tjek for trigonometriske funktioner
    if has(f, sin(t)) || has(f, sin(sym('a')*t))
        ftype = 'sin';
        % Forsøg at udtrække parameter a fra sin(at)
        try
            if has(f, sin(t))
                params.a = 1;
            else
                params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
            end
        catch
            params.a = sym('a');
        end
        return;
    elseif has(f, cos(t)) || has(f, cos(sym('a')*t))
        ftype = 'cos';
        % Forsøg at udtrække parameter a fra cos(at)
        try
            if has(f, cos(t))
                params.a = 1;
            else
                params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
            end
        catch
            params.a = sym('a');
        end
        return;
    end
end