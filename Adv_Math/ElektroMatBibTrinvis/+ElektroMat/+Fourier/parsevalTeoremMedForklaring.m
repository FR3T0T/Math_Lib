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
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Parsevals Teorem');
    
    % Undgå symbolske operationer i starten, brug almindeligt tekstformat
    parsevals_tekst = '(1/T) · ∫ |f(t)|² dt = |c₀|² + ∑ |cₙ|² fra n = -∞ til ∞, n ≠ 0';
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        ['Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:'], ...
        parsevals_tekst);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        ['Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.'], ...
        ['Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.']);
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    % Opret et tekstbaseret output for trin 3
    power_text = ['|c₀|² = ' num2str(c0_squared, '%.6f')];
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
        
        % Tilføj denne term til teksten
        term_text = ['\n|c₋' num2str(k) '|² + |c' num2str(k) '|² = ' ...
                    num2str(neg_term, '%.6f') ' + ' num2str(pos_term, '%.6f') ...
                    ' = ' num2str(neg_term + pos_term, '%.6f')];
        power_text = [power_text term_text];
    end
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn effektbidrag fra hver frekvenskomponent', ...
        ['Vi beregner effektbidraget fra hver enkelt frekvenskomponent:'], ...
        power_text);
    
    % Trin 4: Summér effekter - uden symbolsk formatering
    power_sum_text = ['P = ' num2str(power_sum, '%.6f')];
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Summér effekter', ...
        ['Den samlede middeleffekt er summen af alle effektbidrag:'], ...
        power_sum_text);
    
    % Trin 5: Beregn relativ effektfordeling
    if power_sum > 0
        dc_percentage = 100*c0_squared/power_sum;
        dc_percentage_text = ['DC-komponent (c₀): ' num2str(dc_percentage, '%.2f') '%'];
        
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn relativ effektfordeling', ...
            ['Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:'], ...
            dc_percentage_text);
    end
    
    % Resultat
    P = power_sum;
    
    % Afslut med et tekstresultat
    result_text = ['Middeleffekten er ' num2str(P, '%.6f')];
    
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        result_text);
    
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