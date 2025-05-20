function [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % PARSEVALTEOREM_MED_FORKLARING Forklarer Parsevals teorem og beregner signalets effekt
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
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        ['Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:'], ...
        ['(1/T) \\cdot \\int |f(t)|^2 dt = |c_0|^2 + \\sum_{n=-\\infty}^{\\infty} |c_n|^2, \\, n \\neq 0']);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        ['Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.'], ...
        ['Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.']);
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    % Formatér med LaTeX-notationen
    c0_format = formatUtils.formatNumber(c0_squared);
    power_text = ['|c_0|^2 = ' c0_format];
    power_sum = c0_squared;
    
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
        
        pos_term_format = formatUtils.formatNumber(pos_term);
        neg_term_format = formatUtils.formatNumber(neg_term);
        sum_format = formatUtils.formatNumber(neg_term + pos_term);
        
        power_text = [power_text '\n|c_{-' num2str(k) '}|^2 + |c_' num2str(k) '}|^2 = ' neg_term_format ' + ' pos_term_format ' = ' sum_format];
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn effektbidrag fra hver frekvenskomponent', ...
        ['Vi beregner effektbidraget fra hver enkelt frekvenskomponent:'], ...
        power_text);
    
    power_sum_format = formatUtils.formatNumber(power_sum);
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Summér effekter', ...
        ['Den samlede middeleffekt er summen af alle effektbidrag:'], ...
        ['P = ' power_sum_format]);
    
    % Beregn relativ effektfordeling
    if power_sum > 0
        dc_percent = 100*c0_squared/power_sum;
        dc_percent_format = formatUtils.formatNumber(dc_percent);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn relativ effektfordeling', ...
            ['Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:'], ...
            ['\\text{DC-komponent } (c_0): ' dc_percent_format '\\%']);
    end
    
    % Resultat
    P = power_sum;
    
    % Afslut
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['\\text{Middeleffekten er } P = ' power_sum_format]);
    
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
    
    % Plot effektspektrum med LaTeX-formatering
    stem(n_values, power_values, 'filled', 'LineWidth', 2);
    grid on;
    title('Effektspektrum $|c_n|^2$', 'Interpreter', 'latex', 'FontSize', 14);
    xlabel('$n$', 'Interpreter', 'latex', 'FontSize', 12);
    ylabel('$|c_n|^2$', 'Interpreter', 'latex', 'FontSize', 12);
end