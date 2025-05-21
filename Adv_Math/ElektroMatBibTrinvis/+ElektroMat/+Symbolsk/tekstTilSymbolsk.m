function sym_expr = tekstTilSymbolsk(tekst)
    % TEKSTTILSYMBOLSK Konverterer en tekststreng til et symbolsk objekt
    %
    % Syntax:
    %   sym_expr = ElektroMat.Symbolsk.tekstTilSymbolsk(tekst)
    %
    % Input:
    %   tekst - Tekst der indeholder matematisk notation
    %
    % Output:
    %   sym_expr - Symbolsk objekt
    
    % Erstat almindelig notation med symbolsk notation
    % f.eks. erstat sqrt med symbolsk kvadratrod, osv.
    
    % Erstat græske bogstaver
    tekst = regexprep(tekst, 'alpha', 'α');
    tekst = regexprep(tekst, 'beta', 'β');
    tekst = regexprep(tekst, 'gamma', 'γ');
    tekst = regexprep(tekst, 'delta', 'δ');
    tekst = regexprep(tekst, 'epsilon', 'ε');
    tekst = regexprep(tekst, 'zeta', 'ζ');
    tekst = regexprep(tekst, 'eta', 'η');
    tekst = regexprep(tekst, 'theta', 'θ');
    tekst = regexprep(tekst, 'iota', 'ι');
    tekst = regexprep(tekst, 'kappa', 'κ');
    tekst = regexprep(tekst, 'lambda', 'λ');
    tekst = regexprep(tekst, 'mu', 'μ');
    tekst = regexprep(tekst, 'nu', 'ν');
    tekst = regexprep(tekst, 'xi', 'ξ');
    tekst = regexprep(tekst, 'omicron', 'ο');
    tekst = regexprep(tekst, 'pi(?![a-zA-Z])', 'π');  % Kun 'pi' som helt ord
    tekst = regexprep(tekst, 'rho', 'ρ');
    tekst = regexprep(tekst, 'sigma', 'σ');
    tekst = regexprep(tekst, 'tau', 'τ');
    tekst = regexprep(tekst, 'upsilon', 'υ');
    tekst = regexprep(tekst, 'phi', 'φ');
    tekst = regexprep(tekst, 'chi', 'χ');
    tekst = regexprep(tekst, 'psi', 'ψ');
    tekst = regexprep(tekst, 'omega', 'ω');
    
    % Erstat specifikke symboler for Fourier-notationer
    tekst = regexprep(tekst, 'c_0', 'c0');
    tekst = regexprep(tekst, 'c_n', 'cn');
    tekst = regexprep(tekst, 'c_-n', 'cmn');
    
    % Erstat specielle matematiske symboler og operatorer
    tekst = regexprep(tekst, 'inf', 'Inf');
    tekst = regexprep(tekst, '\\int', 'int');
    tekst = regexprep(tekst, '\\sum', 'sum');
    tekst = regexprep(tekst, '\\prod', 'prod');
    tekst = regexprep(tekst, '\\sqrt', 'sqrt');
    
    % Erstat almindelige matematiske notationer
    tekst = regexprep(tekst, '·', '*');  % Erstat prik-operator med *
    tekst = regexprep(tekst, '×', '*');  % Erstat gange-symbol med *
    tekst = regexprep(tekst, '÷', '/');  % Erstat divisionssymbol med /
    
    % Erstat kvadratrod notation
    tekst = regexprep(tekst, '√([^(])', 'sqrt($1)');
    tekst = regexprep(tekst, '√\(([^)]+)\)', 'sqrt($1)');
    
    % Erstat brøkstreger med divisionstegn
    tekst = regexprep(tekst, '(\d+)/(\d+)', '$1/$2');
    
    % Erstat indekser
    tekst = regexprep(tekst, '([a-zA-Z])_(\d+)', '$1$2');
    tekst = regexprep(tekst, '([a-zA-Z])_{([^}]+)}', '$1$2');
    
    % Prøv at konvertere til symbolsk udtryk
    try
        sym_expr = str2sym(tekst);
    catch e
        warning('Kunne ikke konvertere til symbolsk udtryk: %s', e.message);
        warning('Problematisk tekst: "%s"', tekst);
        % Prøv en simplere tilgang
        try
            sym_expr = sym(tekst);
        catch
            % Hvis alt fejler, returner et symbolsk objekt med teksten
            sym_expr = sym('Kunne ikke konvertere');
        end
    end
end