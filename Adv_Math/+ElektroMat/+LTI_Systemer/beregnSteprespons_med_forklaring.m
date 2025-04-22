function [t, y, forklaringsOutput] = beregnSteprespons_med_forklaring(num, den, t_range)
    % BEREGNSTEPRESPONS_MED_FORKLARING Beregner steprespons med trinvis forklaring
    %
    % Syntax:
    %   [t, y, forklaringsOutput] = ElektroMatBibTrinvis.beregnSteprespons_med_forklaring(num, den, t_range)
    %
    % Input:
    %   num - tæller polynomium
    %   den - nævner polynomium
    %   t_range - [t_min, t_max] tidsinterval
    % 
    % Output:
    %   t - tidsvektor
    %   y - steprespons
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Beregning af Steprespons');
    
    % Opret et symbolsk udtryk for overføringsfunktionen
    syms s;
    H_sym = poly2sym(num, s) / poly2sym(den, s);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer overføringsfunktionen', ...
        'Vi starter med at identificere systemets overføringsfunktion.', ...
        ['H(s) = ' char(H_sym)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér stepfunktionen', ...
        'Stepfunktionen (enhedsspring) er defineret som u(t), og dens Laplacetransformation er 1/s.', ...
        'L{u(t)} = 1/s');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn systemresponsen på step-input', ...
        'I Laplace-domænet er output = input × overføringsfunktion.', ...
        ['Y(s) = H(s) · (1/s) = ' char(H_sym) ' · (1/s)']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Anvend invers Laplacetransformation', ...
        'For at finde tidsresponsen skal vi transformere tilbage til tidsdomænet.', ...
        'y(t) = L^(-1){Y(s)} = L^(-1){H(s) · (1/s)}');
    
    % Beregn steprespons ved hjælp af MATLAB-funktioner
    sys = tf(num, den);
    [y, t] = step(sys, t_range);
    
    % Beregn nøglekarakteristika
    % Slutværdi
    final_value = y(end);
    
    % Stigetid (10% til 90%)
    rise_start = 0.1 * final_value;
    rise_end = 0.9 * final_value;
    t_start_idx = find(y >= rise_start, 1);
    t_end_idx = find(y >= rise_end, 1);
    
    if ~isempty(t_start_idx) && ~isempty(t_end_idx)
        t_start = t(t_start_idx);
        t_end = t(t_end_idx);
        rise_time = t_end - t_start;
        rise_time_text = ['Stigetid (10% til 90%): ' num2str(rise_time,'%.4f') ' sekunder'];
    else
        rise_time_text = 'Stigetid kunne ikke beregnes med de givne data';
    end
    
    % Maksimal værdi og oversving
    [peak_value, peak_idx] = max(y);
    overshoot = (peak_value - final_value) / final_value * 100;
    
    if overshoot > 0
        overshoot_text = ['Maksimal værdi: ' num2str(peak_value,'%.4f')];
        overshoot_text = [overshoot_text '\nOversving: ' num2str(overshoot,'%.2f') '%'];
        overshoot_text = [overshoot_text '\nTid til maksimum: ' num2str(t(peak_idx),'%.4f') ' sekunder'];
    else
        overshoot_text = 'Intet oversving detekteret';
    end
    
    % Indsvingningstid (til inden for 2% af slutværdien)
    settling_threshold = 0.02 * final_value;
    settled = false;
    
    for i = length(y):-1:1
        if abs(y(i) - final_value) > settling_threshold
            if i < length(y)
                settling_time = t(i+1);
                settled = true;
            end
            break;
        end
    end
    
    if settled
        settling_text = ['Indsvingningstid (2%): ' num2str(settling_time,'%.4f') ' sekunder'];
    else
        settling_text = 'Systemet når ikke ind inden for 2% tolerancen i det specificerede tidsinterval';
    end
    
    % Sammenfat alle karakteristika
    char_text = ['Stepresponsens nøglekarakteristika:\n\n'];
    char_text = [char_text 'Slutværdi: ' num2str(final_value,'%.4f') '\n'];
    char_text = [char_text rise_time_text '\n'];
    char_text = [char_text overshoot_text '\n'];
    char_text = [char_text settling_text];
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Analysér nøglekarakteristika', ...
        'Vi kan beskrive systemets opførsel med følgende nøgletal:', ...
        char_text);
    
    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Stepresponsen er nu beregnet og analyseret.');
    
    % Skab figuren
    figure;
    plot(t, y, 'LineWidth', 2);
    grid on;
    xlabel('Tid (sekunder)');
    ylabel('Amplitude');
    title('Steprespons');
    
    % Tilmarker nøglekarakteristika på plottet
    hold on;
    
    % Slutværdi
    yline(final_value, '--', 'Slutværdi', 'Color', [0.5 0.5 0.5]);
    
    % Stigetid
    if exist('rise_time', 'var')
        plot([t_start, t_start], [0, rise_start], 'r--');
        plot([t_end, t_end], [0, rise_end], 'r--');
        plot([t_start, t_end], [rise_start, rise_start], 'r-', 'LineWidth', 1.5);
        plot([t_start, t_end], [rise_end, rise_end], 'r-', 'LineWidth', 1.5);
        text(t_start + (t_end-t_start)/2, (rise_start + rise_end)/2, sprintf('Stigetid = %.3fs', rise_time), ...
             'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8]);
    end
    
    % Oversving
    if overshoot > 0
        plot(t(peak_idx), peak_value, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        text(t(peak_idx), peak_value*1.05, sprintf('Oversving = %.2f%%', overshoot), ...
             'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8]);
    end
    
    % Indsvingningstid
    if settled
        plot([settling_time, settling_time], [0, final_value], 'g--');
        text(settling_time, final_value/2, sprintf('Indsvingningstid = %.3fs', settling_time), ...
             'HorizontalAlignment', 'right', 'BackgroundColor', [1 1 0.8]);
        
        % Vis tolerancebånd
        plot([0, max(t)], [final_value + settling_threshold, final_value + settling_threshold], 'g:');
        plot([0, max(t)], [final_value - settling_threshold, final_value - settling_threshold], 'g:');
    end
end