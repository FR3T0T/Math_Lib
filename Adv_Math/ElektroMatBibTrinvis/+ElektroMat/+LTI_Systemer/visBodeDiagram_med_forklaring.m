function forklaringsOutput = visBodeDiagram_med_forklaring(num, den, omega_range)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % VISBODEDIAGRAM_MED_FORKLARING Visualiserer Bode-diagram med trinvis forklaring
    %
    % Syntax:
    %   forklaringsOutput = ElektroMatBibTrinvis.visBodeDiagram_med_forklaring(num, den, omega_range)
    %
    % Input:
    %   num - tæller polynomium
    %   den - nævner polynomium
    %   omega_range - [omega_min, omega_max] frekvensinterval
    %
    % Output:
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Analyse af Frekvensrespons (Bodediagram)');
    
    % Opret et symbolsk udtryk for overføringsfunktionen
    syms s;
    H_sym = poly2sym(num, s) / poly2sym(den, s);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer overføringsfunktionen', ...
        'Vi starter med at identificere systemets overføringsfunktion.', ...
        ['H(s) = ' char(H_sym)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Introducér frekvensrespons-begrebet', ...
        ['Frekvensresponset fås ved at evaluere H(s) langs den imaginære akse, dvs. s = jω.'], ...
        ['H(jω) beskriver systemets respons på sinusformede input med frekvens ω.']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Definér amplitude- og faserespons', ...
        ['Amplituderesponset |H(jω)| viser, hvordan systemet forstærker eller dæmper forskellige frekvenser.', ...
         '\nFaseresponset ∠H(jω) viser faseforsinkelsen ved forskellige frekvenser.'], ...
        ['Ofte plottes amplituden i decibel: 20·log₁₀|H(jω)| dB']);
    
    % Genererer frekvensakse (logaritmisk)
    omega = logspace(log10(omega_range(1)), log10(omega_range(2)), 1000);
    
    % Beregn amplitude og fase
    [mag, phase] = ElektroMatBib.bode(num, den, omega);
    
    % Konverter amplitude til dB
    mag_db = 20 * log10(mag);
    
    % Konverter fase til grader
    phase_deg = phase * 180 / pi;
    
    % Analyser nøglekarakteristika
    % DC Gain (forstærkning ved ω = 0)
    dc_gain = ElektroMatBib.overfoer(num, den, 0);
    dc_gain_db = 20 * log10(abs(dc_gain));
    
    % Resonansfrekvens og resonansforstærkning
    [peak_mag, peak_idx] = max(mag);
    
    if peak_mag > dc_gain
        resonance_freq = omega(peak_idx);
        resonance_gain = peak_mag;
        resonance_gain_db = 20 * log10(resonance_gain);
        resonance_text = ['Resonansfrekvens: ' num2str(resonance_freq,'%.4f') ' rad/s'];
        resonance_text = [resonance_text '\nResonansforstærkning: ' num2str(resonance_gain,'%.4f') ' (' num2str(resonance_gain_db,'%.2f') ' dB)'];
    else
        resonance_text = 'Ingen resonansfrekvens detekteret';
    end
    
    % Båndbredde (-3 dB fra DC gain)
    bw_threshold = abs(dc_gain) / sqrt(2);  % -3 dB i lineær skala
    bw_idx = find(mag < bw_threshold, 1);
    
    if ~isempty(bw_idx) && bw_idx > 1
        bandwidth = omega(bw_idx);
        bandwidth_text = ['Båndbredde (-3 dB): ' num2str(bandwidth,'%.4f') ' rad/s'];
    else
        bandwidth_text = 'Båndbredde ligger uden for det specificerede frekvensområde';
    end
    
    % Fasemargin beregning
    % Find frekvensen hvor forstærkningen krydser 0 dB
    unity_gain_idx = find(mag_db >= 0, 1, 'last');
    
    if ~isempty(unity_gain_idx)
        unity_gain_freq = omega(unity_gain_idx);
        unity_gain_phase = phase_deg(unity_gain_idx);
        phase_margin = 180 + unity_gain_phase;  % Fasemargin = 180° + fase ved 0 dB
        
        phase_margin_text = ['Fasemargin: ' num2str(phase_margin,'%.2f') ' grader ved ' num2str(unity_gain_freq,'%.4f') ' rad/s'];
        
        % Kommenter på stabiliteten
        if phase_margin > 45
            stability_text = 'Systemet har god stabilitet (fasemargin > 45°)';
        elseif phase_margin > 0
            stability_text = 'Systemet er stabilt men med begrænset robusthed (0° < fasemargin < 45°)';
        else
            stability_text = 'Systemet er ustabilt (fasemargin < 0°)';
        end
    else
        phase_margin_text = 'Forstærkningen krydser ikke 0 dB i det specificerede frekvensområde';
        stability_text = 'Stabiliteten kan ikke vurderes baseret på fasemaginen alene';
    end
    
    % Saml alle karakteristika
    char_text = ['Frekvensresponsens nøglekarakteristika:\n\n'];
    char_text = [char_text 'DC forstærkning: ' num2str(abs(dc_gain),'%.4f') ' (' num2str(dc_gain_db,'%.2f') ' dB)\n'];
    char_text = [char_text resonance_text '\n'];
    char_text = [char_text bandwidth_text '\n'];
    char_text = [char_text phase_margin_text '\n'];
    char_text = [char_text stability_text];
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Analysér nøglekarakteristika', ...
        'Vi analyserer systemets frekvensrespons ud fra følgende nøgletal:', ...
        char_text);
    
    % Plot Bode-diagram
    figure;
    
    % Amplituderespons
    subplot(2, 1, 1);
    semilogx(omega, mag_db, 'LineWidth', 2);
    grid on;
    xlabel('Frekvens (rad/s)');
    ylabel('Amplitude (dB)');
    title('Bodediagram - Amplituderespons');
    
    % Markér DC gain
    hold on;
    yline(dc_gain_db, '--', 'DC gain', 'Color', [0.5 0.5 0.5]);
    
    % Markér resonansfrekvens hvis den findes
    if exist('resonance_freq', 'var') && peak_mag > dc_gain
        plot(resonance_freq, resonance_gain_db, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        text(resonance_freq, resonance_gain_db+3, sprintf('Resonans: %.2f rad/s', resonance_freq), ...
             'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8]);
    end
    
    % Markér båndbredde hvis den findes
    if exist('bandwidth', 'var')
        bw_gain_db = 20 * log10(bw_threshold);
        plot(bandwidth, bw_gain_db, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        text(bandwidth, bw_gain_db-3, sprintf('Båndbredde: %.2f rad/s', bandwidth), ...
             'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8]);
    end
    
    % Faserespons
    subplot(2, 1, 2);
    semilogx(omega, phase_deg, 'LineWidth', 2);
    grid on;
    xlabel('Frekvens (rad/s)');
    ylabel('Fase (grader)');
    title('Bodediagram - Faserespons');
    
    % Markér fasemargin hvis den findes
    if exist('unity_gain_freq', 'var')
        hold on;
        plot(unity_gain_freq, unity_gain_phase, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'm');
        text(unity_gain_freq, unity_gain_phase-20, sprintf('Fasemargin: %.2f°', phase_margin), ...
             'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 0.8]);
        
        % Tegn linjer til at illustrere fasemargin
        plot([omega(1), unity_gain_freq], [-180, -180], 'r--');
        plot([unity_gain_freq, unity_gain_freq], [unity_gain_phase, -180], 'm--');
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Fortolk bodediagrammet', ...
        'Et Bode-diagram giver vigtig information om systemets ydeevne og stabilitet:', ...
        ['1. Faldende amplitudekurve indikerer lavpaskarakteristik\n' ...
         '2. Stejl hældning ved høje frekvenser indikerer systemets orden\n' ...
         '3. Resonanstop indikerer underdæmpning (ζ < 0.707)\n' ...
         '4. Fasemargin er et mål for systemets stabilitet']);
    
    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Frekvensrespons-analysen er nu gennemført.');
end