function [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % PARSEVALTEOREM_MED_FORKLARING Forklarer Parsevals teorem og beregner signalets effekt
    % med symbolsk formatering
    %
    % Syntax:
    %   [P, forklaringsOutput] = ElektroMatBibTrinvis.parsevalTeoremMedForklaring(cn, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   N - maksimalt indekstal for koefficienterne
    % 
    % Output:
    %   P - signalets middeleffekt
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = startForklaring('Parsevals Teorem');
    
    % Opret symbolske variabler til forklaring
    syms t T n;
    
    % Definer Parsevals teorem med symbolsk notation
    parsevals_eq = sym('(1/T)*int(abs(f(t))^2, t, 0, T) = abs(c_0)^2 + sum(abs(c_n)^2, n, -inf, inf, n ~= 0)');
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        ['Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:'], ...
        parsevals_eq);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        ['Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.'], ...
        ['Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.']);
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    % Opret symbolske udtryk for power_sum
    power_text = sym(['abs(c_0)^2 = ' num2str(c0_squared, '%.6f')]);
    power_sum = c0_squared;
    
    % Opsaml bidrag fra hver frekvenskomponent med symbolske udtryk
    power_terms = sym('0');
    
    for k = 1:N
        pos_term = 0;
        neg_term = 0;
        
        if isfield(cn, sprintf('c%d', k))
            pos_term = abs(cn.(sprintf('c%d', k)))^2;
            power_sum = power_sum + pos_term;
        end
        
        if isfield(cn, sprintf('cm%d', k))
            neg_term = abs(cn.(sprintf('cm%d', k)))^2;
            power_sum = power_sum + neg_term;
        end
        
        % Opbyg symbolsk sum
        if pos_term > 0 || neg_term > 0
            term_sym = sym(['abs(c_{-' num2str(k) '})^2 + abs(c_' num2str(k) ')^2 = ' ...
                       num2str(neg_term, '%.6f') ' + ' num2str(pos_term, '%.6f') ...
                       ' = ' num2str(neg_term + pos_term, '%.6f')]);
            
            power_terms = [power_terms; term_sym];
        end
    end
    
    % Vis effektbidrag med symbolsk formatering
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn effektbidrag fra hver frekvenskomponent', ...
        ['Vi beregner effektbidraget fra hver enkelt frekvenskomponent:'], ...
        power_terms);
    
    % Trin 4: Summér effekter med symbolsk formatering
    power_sum_sym = sym(['P = ' num2str(power_sum, '%.6f')]);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Summér effekter', ...
        ['Den samlede middeleffekt er summen af alle effektbidrag:'], ...
        power_sum_sym);
    
    % Trin 5: Beregn relativ effektfordeling
    if power_sum > 0
        dc_percentage = 100*c0_squared/power_sum;
        dc_percentage_sym = sym(['DC-komponent (c_0): ' num2str(dc_percentage, '%.2f') '%']);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn relativ effektfordeling', ...
            ['Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:'], ...
            dc_percentage_sym);
    end
    
    % Resultat
    P = power_sum;
    
    % Afslut med et symbolsk resultat
    result_sym = sym(['P = ' num2str(P, '%.6f')]);
    
    forklaringsOutput = afslutForklaring(forklaringsOutput, result_sym);
    
    % Visualiser effektspektrum
    figure;
    
    % Forbered data til plot
    n_values = -N:N;
    power_values = zeros(size(n_values));
    
    for i = 1:length(n_values)
        if n_values(i) == 0 && isfield(cn, 'c0')
            power_values(i) = abs(cn.c0)^2;
        elseif n_values(i) > 0 && isfield(cn, sprintf('c%d', n_values(i)))
            power_values(i) = abs(cn.(sprintf('c%d', n_values(i))))^2;
        elseif n_values(i) < 0 && isfield(cn, sprintf('cm%d', abs(n_values(i))))
            power_values(i) = abs(cn.(sprintf('cm%d', abs(n_values(i)))))^2;
        end
    end
    
    % Plot effektspektrum
    stem(n_values, power_values, 'filled', 'LineWidth', 2);
    grid on;
    title('Effektspektrum |c_n|^2');
    xlabel('n');
    ylabel('|c_n|^2');
end