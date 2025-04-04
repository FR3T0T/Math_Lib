
        
        function forklaringsOutput = visBodeDiagram_med_forklaring(num, den, omega_range)
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