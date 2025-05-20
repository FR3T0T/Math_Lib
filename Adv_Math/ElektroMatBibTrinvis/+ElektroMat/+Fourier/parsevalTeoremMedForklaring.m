function [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
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
    
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Starter forklaring
    forklaringsOutput = startForklaring('Parsevals Teorem');
    
    % Trin 1: Definér Parsevals teorem
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        'Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:', ...
        '(1/T) \\cdot \\int |f(t)|^2 dt = |c_0|^2 + \\sum_{n=-\\infty}^{\\infty} |c_n|^2, \\, n \\neq 0');
    
    % Trin 2: Fortolk Parsevals teorem
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        'Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.', ...
        'Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.');
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    % Total effekt starter med DC
    P = c0_squared;
    
    % Opbyg teksten for effektbidrag
    bidrag_text = ['|c_0|^2 = ' num2str(c0_squared)];
    
    % For hvert frekvenspar, beregn effektbidraget
    for k = 1:N
        pos_power = 0;
        neg_power = 0;
        
        % Tjek positive frekvenser
        field_pos = ['c' num2str(k)];
        if isfield(cn, field_pos)
            pos_power = abs(cn.(field_pos))^2;
            P = P + pos_power;
        end
        
        % Tjek negative frekvenser
        field_neg = ['cm' num2str(k)];
        if isfield(cn, field_neg)
            neg_power = abs(cn.(field_neg))^2;
            P = P + neg_power;
        end
        
        % Tilføj bidrag til teksten hvis mindst én er ikke-nul
        if pos_power > 0 || neg_power > 0
            bidrag_linje = sprintf('|c_{-%d}|^2 + |c_{%d}|^2 = %g + %g = %g', ...
                k, k, neg_power, pos_power, neg_power + pos_power);
            bidrag_text = [bidrag_text '\n' bidrag_linje];
        end
    end
    
    % Trin 3: Vis detaljerede effektbidrag
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn effektbidrag fra hver frekvenskomponent', ...
        'Vi beregner effektbidraget fra hver enkelt frekvenskomponent:', ...
        bidrag_text);
    
    % Trin 4: Vis samlet effekt
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Summér effekter', ...
        'Den samlede middeleffekt er summen af alle effektbidrag:', ...
        ['P = ' num2str(P)]);
    
    % Vis effekt direkte for at sikre korrekt visning
    disp(' ');
    disp(['P = ' num2str(P)]);
    disp(' ');
    
    % Beregn relativ effektfordeling hvis relevant
    if P > 0 && c0_squared > 0
        dc_percent = 100 * c0_squared / P;
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn relativ effektfordeling', ...
            'Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:', ...
            ['DC-komponent (c_0): ' num2str(dc_percent, '%.2f') '%']);
    end
    
    % Afslut forklaring
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['Middeleffekten er P = ' num2str(P)]);
    
    % Tilføj visualisering
    try
        figure;
        
        % Forbered data til plot
        n_values = -N:N;
        power_values = zeros(size(n_values));
        
        % Fyld værdier ind
        for i = 1:length(n_values)
            n = n_values(i);
            if n == 0 && isfield(cn, 'c0')
                power_values(i) = abs(cn.c0)^2;
            elseif n > 0 && isfield(cn, ['c' num2str(n)])
                power_values(i) = abs(cn.(['c' num2str(n)]))^2;
            elseif n < 0 && isfield(cn, ['cm' num2str(abs(n))])
                power_values(i) = abs(cn.(['cm' num2str(abs(n))]))^2;
            end
        end
        
        % Plot effektspektrum med LaTeX-formatering
        stem(n_values, power_values, 'filled', 'LineWidth', 2);
        grid on;
        title('Effektspektrum |c_n|^2', 'Interpreter', 'tex');
        xlabel('n');
        ylabel('|c_n|^2');
    catch
        % Ignorér eventuelle plot-fejl
    end
end