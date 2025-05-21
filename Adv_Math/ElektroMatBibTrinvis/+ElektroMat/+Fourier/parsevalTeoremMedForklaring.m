function [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
    % PARSEVALTEOREM_MED_FORKLARING Forklarer Parsevals teorem og beregner signalets effekt
    % med ægte symbolsk formatering
    %
    % Syntax:
    %   [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   N - maksimalt indekstal for koefficienterne
    % 
    % Output:
    %   P - signalets middeleffekt
    %   forklaringsOutput - Struktur med grundlæggende information (for kompatibilitet)
    
    % Simpel output struktur for kompatibilitet
    forklaringsOutput = struct('titel', 'Parsevals Teorem', 'trin', {}, 'resultat', '');
    
    % Vis titel
    disp('');
    disp('===== PARSEVALS TEOREM =====');
    disp('');
    
    % Opret symbolske variabler
    syms T t f(t) c0 cn n
    
    % Trin 1: Opbyg Parsevals teorem med symbolske operationer (IKKE strenge)
    disp('TRIN 1: Definér Parsevals teorem');
    disp('Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:');
    
    lhs = (1/T) * int(abs(f(t))^2, t, 0, T);
    rhs = abs(c0)^2 + symsum(abs(cn)^2, n, 1, inf);
    eq = lhs == rhs;
    
    % Vis det symbolske udtryk
    disp(eq);
    disp(' ');
    
    % Trin 2: Fortolkning
    disp('TRIN 2: Fortolk Parsevals teorem');
    disp('Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere');
    disp('kvadraterne af amplituderne af alle frekvenskomponenter.');
    disp('Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.');
    disp(' ');
    
    % Trin 3: Beregn effektbidrag
    disp('TRIN 3: Beregn effektbidrag fra hver frekvenskomponent');
    disp('Vi beregner effektbidraget fra hver enkelt frekvenskomponent:');
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    power_sum = c0_squared;
    
    % Vis DC-bidrag hvis det ikke er nul
    if c0_squared > 0
        % Create symbolske variabler for DC-komponenten
        c_0 = sym('c_0');
        dc_eq = abs(c_0)^2 == c0_squared;
        disp(dc_eq);
    end
    
    % Behandl hvert frekvenspar
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
        
        % Vis bidraget hvis mindst én term er ikke-nul
        if pos_term > 0 || neg_term > 0
            % For at undgå fejl med ikke-variable symboler, opret symbolske variable
            % med hvert indeks og lad matricen håndtere visningen
            c_neg_k = sym(['c_neg_' num2str(k)]);
            c_pos_k = sym(['c_pos_' num2str(k)]);
            
            % Opret ligningen direkte med reelle tal
            % Opbyg en mere beskrivende forklaring ved hver komponent
            term_sum = neg_term + pos_term;
            disp(['|c_{-' num2str(k) '}|² + |c_{' num2str(k) '}|² = ' num2str(neg_term) ' + ' num2str(pos_term) ' = ' num2str(term_sum)]);
        end
    end
    disp(' ');
    
    % Trin 4: Summér effekter
    disp('TRIN 4: Summér effekter');
    disp('Den samlede middeleffekt er summen af alle effektbidrag:');
    
    % Brug symbolsk Power variabel til at vise resultatet
    P_sym = sym('P');  
    P_eq = P_sym == power_sum;
    disp(P_eq);
    disp(' ');
    
    % Trin 5: Beregn relativ effektfordeling
    if power_sum > 0
        disp('TRIN 5: Beregn relativ effektfordeling');
        disp('Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:');
        
        % Beregn procentvis DC-bidrag
        dc_percentage = 100*c0_squared/power_sum;
        
        % Vis som en ligning
        DC_percent = sym('DC_{percent}');
        dc_eq = DC_percent == dc_percentage;
        disp(['DC-komponent (c₀): ' num2str(dc_percentage) '%']);
        disp(' ');
    end
    
    % Resultat
    P = power_sum;
    
    % Afslutning
    disp('RESULTAT:');
    result_eq = sym('P') == P;
    disp(result_eq);
    disp(' ');
    disp('===== AFSLUTTET: PARSEVALS TEOREM =====');
    disp(' ');
    
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
    
    % For bedre visuel forståelse: Beregn total effekt for hvert indeks (f.eks. n=±1, n=±2, osv.)
    % og vis som procentbidrag
    if power_sum > 0
        % Beregn bidrag per frekvensindeks
        freq_contrib = zeros(1, N+1);  % +1 for DC-komponenten
        freq_contrib(1) = c0_squared / power_sum * 100;  % DC-bidrag
        
        for k = 1:N
            pos_term = 0;
            neg_term = 0;
            
            if isfield(cn, sprintf('c%d', k))
                pos_term = abs(cn.(sprintf('c%d', k)))^2;
            end
            
            if isfield(cn, sprintf('cm%d', k))
                neg_term = abs(cn.(sprintf('cm%d', k)))^2;
            end
            
            freq_contrib(k+1) = (pos_term + neg_term) / power_sum * 100;
        end
        
        % Lav et søjlediagram over effektfordeling
        figure;
        bar(0:N, freq_contrib, 0.6);
        title('Effektfordeling per frekvensindeks');
        xlabel('n (frekvensindeks)');
        ylabel('Bidrag (%)');
        grid on;
        
        % Tilføj labels over søjlerne
        for i = 1:length(freq_contrib)
            if freq_contrib(i) > 1  % Vis kun betydelige bidrag
                text(i-1, freq_contrib(i) + 1, [num2str(freq_contrib(i), '%.1f') '%'], ...
                     'HorizontalAlignment', 'center');
            end
        end
    end
end