% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer\n% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede\n% trinvise forklaringer til matematiske operationer.\n%\n% Forfatter: Udvidelse af Frederik Tots' bibliotek\n% Version: 1.0\n% Dato: 4/4/2025\n\nclassdef ElektroMatBibTrinvis\n    methods(Static)\n        %% FORKLARINGSSYSTEM %%\n        forklaringsOutput startForklaring(titel)\n        forklaringsOutput tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)\n        forklaringsOutput afslutForklaring(forklaringsOutput, resultat)\n        %% LAPLACE TRANSFORMATIONER MED TRINVISE FORKLARINGER %%\n        [F, forklaringsOutput] laplace_med_forklaring(f, t, s)\n        [f, forklaringsOutput] inversLaplace_med_forklaring(F, s, t)\n        %% FUNKTIONSANALYSEFUNKTIONER %%\n        [ftype, params] analyserFunktion(f, t)\n        [Ftype, params] analyserLaplaceFunktion(F, s)\n        %% TRIN-FOR-TRIN FORKLARINGER FOR LAPLACE TRANSFORMATIONER %%\n        [F, forklaringsOutput] forklarKonstant(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarPolynom(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarExp(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarSin(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarCos(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarExpSin(f, t, s, params, forklaringsOutput)\n        [F, forklaringsOutput] forklarExpCos(f, t, s, params, forklaringsOutput)\n        forklaringsOutput forklarGenerel(f, t, s, forklaringsOutput)\n        %% TRIN-FOR-TRIN FORKLARINGER FOR INVERS LAPLACE TRANSFORMATIONER %%\n        [f, forklaringsOutput] forklarInversKonstant(F, s, t, params, forklaringsOutput)\n        [f, forklaringsOutput] forklarInversSimplePol(F, s, t, params, forklaringsOutput)\n        [f, forklaringsOutput] forklarInversDoublePol(F, s, t, params, forklaringsOutput)\n        [f, forklaringsOutput] forklarInversKvadratisk(F, s, t, params, forklaringsOutput)\n        [f, forklaringsOutput] forklarInversPartielBrok(F, s, t, params, forklaringsOutput)\n        forklaringsOutput forklarInversGenerel(F, s, t, forklaringsOutput)\n        %% LTI SYSTEM FUNKTIONER MED TRINVISE FORKLARINGER %%\n        [num, den, forklaringsOutput] diffLigningTilOverfoeringsfunktion_med_forklaring(b, a)\n        forklaringsOutput analyserDifferentialligning_med_forklaring(a)\n        [t, y, forklaringsOutput] beregnSteprespons_med_forklaring(num, den, t_range)\n        %%', overshoot), ...
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
        
        %%\n        forklaringsOutput visBodeDiagram_med_forklaring(num, den, omega_range)\n        %%
        
        function kompletSystemAanalyse(num, den, system_navn)
            % KOMPLETSYSTEMAANALYSE Udfører en komplet analyse af et LTI-system med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.kompletSystemAanalyse(num, den, system_navn)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   system_navn - navn på systemet (valgfrit)
            
            % Default navn hvis ikke angivet
            if nargin < 3
                system_navn = 'Lineært Tidsinvariant System';
            end
            
            disp(['===== KOMPLET ANALYSE AF ' upper(system_navn) ' =====']);
            disp(' ');
            
            % 1. Konverter til overføringsfunktion
            disp('1. OVERFØRINGSFUNKTION:');
            [~, ~, tf_forklaring] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktion_med_forklaring(num, den);
            disp(' ');
            
            % 2. Analysér differentialligningen
            disp('2. ANALYSE AF DIFFERENTIALLIGNING:');
            a = den;  % Koefficienterne a er nævnerpolynomiet
            forklaring = ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a);
            disp(' ');
            
            % 3. Beregn og visualisér steprespons
            disp('3. STEPRESPONS:');
            [~, ~, step_forklaring] = ElektroMatBibTrinvis.beregnSteprespons_med_forklaring(num, den, [0, 20]);
            disp(' ');
            
            % 4. Beregn og visualisér frekvensrespons
            disp('4. FREKVENSRESPONS (BODE-DIAGRAM):');
            bode_forklaring = ElektroMatBibTrinvis.visBodeDiagram_med_forklaring(num, den, [0.01, 100]);
            disp(' ');
            
            % Analysér stabilitet
            p = roots(den);
            unstable_poles = sum(real(p) >= 0);
            
            disp('5. STABILITETSVURDERING:');
            disp(['Poler: ' num2str(p')]);
            
            if unstable_poles > 0
                disp(['USTABILT SYSTEM! ' num2str(unstable_poles) ' pol(er) i højre halvplan.']);
            else
                disp('STABILT SYSTEM. Alle poler i venstre halvplan.');
            end
            
            disp(' ');
            disp(['===== ANALYSE AFSLUTTET FOR ' upper(system_navn) ' =====']);
        end
        
        function RLCKredsloebsAnalyse(R, L, C)
            % RLCKREDSLOEBSANALYSE Udfører en komplet analyse af et RLC-kredsløb med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.RLCKredsloebsAnalyse(R, L, C)
            %
            % Input:
            %   R - Modstand (Ohm)
            %   L - Induktans (Henry)
            %   C - Kapacitans (Farad)
            
            system_navn = sprintf('RLC-kredsløb (R=%.2f Ω, L=%.4f H, C=%.6f F)', R, L, C);
            
            disp(['===== KOMPLET ANALYSE AF ' upper(system_navn) ' =====']);
            disp(' ');
            
            % 1. Opskriv differentialligningen
            disp('1. DIFFERENTIALLIGNING:');
            disp(['L·d²i/dt² + R·di/dt + (1/C)·i = v(t)']);
            disp(['Med værdierne: L = ' num2str(L) ' H, R = ' num2str(R) ' Ω, C = ' num2str(C) ' F']);
            disp(['Giver: ' num2str(L) '·d²i/dt² + ' num2str(R) '·di/dt + ' num2str(1/C) '·i = v(t)']);
            
            % Definér differentialligningen
            a = [L R (1/C)];  % Koefficienter for i
            b = [1];          % Koefficient for v(t)
            
            disp(' ');
            
            % 2. Konverter til overføringsfunktion
            disp('2. OVERFØRINGSFUNKTION:');
            [num, den, tf_forklaring] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktion_med_forklaring(b, a);
            disp(' ');
            
            % 3. Beregn resonansfrekvens og dæmpning
            omega_0 = 1 / sqrt(L * C);  % Naturlig/resonansfrekvens
            zeta = R / (2 * sqrt(L / C));  % Dæmpningsforhold
            Q = 1 / (2 * zeta);  % Q-faktor
            
            disp('3. RESONANSANALYSE:');
            disp(['Resonansfrekvens: ω₀ = 1/√(LC) = ' num2str(omega_0,'%.4f') ' rad/s (' num2str(omega_0/(2*pi),'%.4f') ' Hz)']);
            disp(['Dæmpningsforhold: ζ = R/(2·√(L/C)) = ' num2str(zeta,'%.4f')]);
            disp(['Q-faktor: Q = 1/(2·ζ) = ' num2str(Q,'%.4f')]);
            
            % Klassificer respons
            if zeta > 1
                disp('Kredsløbet er overdæmpet (ζ > 1) - ingen oscillation');
            elseif abs(zeta - 1) < 1e-6
                disp('Kredsløbet er kritisk dæmpet (ζ = 1) - hurtigst mulig respons uden oscillation');
            elseif zeta > 0
                disp(['Kredsløbet er underdæmpet (0 < ζ < 1) - oscillation med amplitude der aftager']);
                
                % Beregn oversving
                overshoot = 100 * exp(-pi * zeta / sqrt(1 - zeta^2));
                disp(['Forventet oversving: ' num2str(overshoot,'%.2f') '%']);
                
                % Beregn båndbredde
                bandwidth = omega_0 * 2 * zeta;
                disp(['Båndbredde: ' num2str(bandwidth,'%.4f') ' rad/s']);
            else
                disp('Kredsløbet er udæmpet (ζ ≈ 0) - vedvarende oscillation');
            end
            
            disp(' ');
            
            % 4. Analysér differentialligningen
            disp('4. ANALYSE AF DIFFERENTIALLIGNING:');
            forklaring = ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a);
            disp(' ');
            
            % 5. Beregn og visualisér steprespons
            disp('5. STEPRESPONS:');
            [~, ~, step_forklaring] = ElektroMatBibTrinvis.beregnSteprespons_med_forklaring(num, den, [0, 10/omega_0]);
            disp(' ');
            
            % 6. Beregn og visualisér frekvensrespons
            disp('6. FREKVENSRESPONS (BODE-DIAGRAM):');
            bode_forklaring = ElektroMatBibTrinvis.visBodeDiagram_med_forklaring(num, den, [omega_0/10, omega_0*10]);
            disp(' ');
            
            disp('7. IMPEDANSANALYSE:');
            disp('Impedansen for RLC-seriekredsløb er:');
            disp('Z(jω) = R + jωL + 1/(jωC) = R + j(ωL - 1/(ωC))');
            
            % Beregn impedans ved resonans
            Z_res = R;
            disp(['Ved resonans (ω = ω₀) er impedansen rent resistiv: Z(jω₀) = ' num2str(Z_res) ' Ω']);
            
            % Beregn total impedans ved forskellige frekvenser
            omega_values = [omega_0/10, omega_0/2, omega_0, omega_0*2, omega_0*10];
            disp('Impedans ved forskellige frekvenser:');
            for i = 1:length(omega_values)
                omega = omega_values(i);
                Z_abs = abs(R + 1j*(omega*L - 1/(omega*C)));
                Z_phase = angle(R + 1j*(omega*L - 1/(omega*C))) * 180/pi;
                disp([num2str(omega,'%.4f') ' rad/s: |Z| = ' num2str(Z_abs,'%.4f') ' Ω, ∠Z = ' num2str(Z_phase,'%.2f') '°']);
            end
            
            disp(' ');
            disp(['===== ANALYSE AFSLUTTET FOR ' upper(system_navn) ' =====']);
        end
        
        function FourierAnalyse(f, t_range, f_navn)
            % FOURIERANALYSE Udfører en komplet Fourieranalyse af et signal med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.FourierAnalyse(f, t_range, f_navn)
            %
            % Input:
            %   f - funktion handle @(t) ...
            %   t_range - [t_min, t_max] tidsinterval
            %   f_navn - navn på funktionen (valgfrit)
            
            % Default navn hvis ikke angivet
            if nargin < 3
                f_navn = 'Signal';
            end
            
            disp(['===== FOURIER-ANALYSE AF ' upper(f_navn) ' =====']);
            disp(' ');
            
            % 1. Identificer signalet
            disp('1. SIGNALINFORMATION:');
            disp(['Signal: ' f_navn]);
            disp(['Tidsinterval: [' num2str(t_range(1)) ', ' num2str(t_range(2)) ']']);
            
            % Diskretiser signalet
            Fs = 1000;  % Samplingsfrekvens
            dt = 1/Fs;
            t = t_range(1):dt:t_range(2);
            x = arrayfun(f, t);
            
            disp(' ');
            
            % 2. Beregn statistiske egenskaber
            disp('2. STATISTISKE EGENSKABER:');
            mean_val = mean(x);
            std_val = std(x);
            rms_val = rms(x);
            max_val = max(x);
            min_val = min(x);
            dynamic_range = max_val - min_val;
            
            disp(['Middelværdi: ' num2str(mean_val,'%.6f')]);
            disp(['Standardafvigelse: ' num2str(std_val,'%.6f')]);
            disp(['RMS-værdi: ' num2str(rms_val,'%.6f')]);
            disp(['Maksimum: ' num2str(max_val,'%.6f')]);
            disp(['Minimum: ' num2str(min_val,'%.6f')]);
            disp(['Dynamisk område: ' num2str(dynamic_range,'%.6f')]);
            
            disp(' ');
            
            % 3. Plot signalet i tidsdomænet
            disp('3. TIDSDOMÆNE-VISUALISERING:');
            figure;
            plot(t, x, 'LineWidth', 1.5);
            grid on;
            xlabel('Tid (s)');
            ylabel('Amplitude');
            title(['Signal i tidsdomænet: ' f_navn]);
            
            disp('Signalet er nu plottet i tidsdomænet.');
            disp(' ');
            
            % 4. Beregn FFT
            disp('4. FREKVENSDOMÆNE-ANALYSE:');
            N = length(x);
            X = fft(x);
            
            % Frekvensakse (positiv side)
            freq = (0:N/2) * Fs / N;
            
            % Tag kun den første halvdel af frekvenserne (Nyquist)
            X_half = X(1:length(freq));
            
            % Beregn amplitude og fase
            amplitude = abs(X_half) / N;
            amplitude(2:end) = 2 * amplitude(2:end);  % Korrektion for ensidet spektrum
            phase = angle(X_half);
            
            % Plot amplitudespektrum
            figure;
            
            % Amplitudespektrum
            subplot(2, 1, 1);
            plot(freq, amplitude, 'LineWidth', 1.5);
            grid on;
            xlabel('Frekvens (Hz)');
            ylabel('Amplitude');
            title('Amplitudespektrum');
            
            % Fasespektrum
            subplot(2, 1, 2);
            plot(freq, phase, 'LineWidth', 1.5);
            grid on;
            xlabel('Frekvens (Hz)');
            ylabel('Fase (radianer)');
            title('Fasespektrum');
            
            disp('Frekvensdomæne-analyse er nu gennemført og plottet.');
            
            % Find dominerende frekvenskomponenter
            [sorted_amp, idx] = sort(amplitude, 'descend');
            dominant_freq = freq(idx(1:min(5, length(idx))));
            dominant_amp = sorted_amp(1:min(5, length(idx)));
            
            disp('Dominerende frekvenskomponenter:');
            for i = 1:length(dominant_freq)
                disp([num2str(dominant_freq(i),'%.2f') ' Hz (Amplitude: ' num2str(dominant_amp(i),'%.6f') ')']);
            end
            
            % Beregn båndbredde (frekvens hvor amplitude falder til 1% af maksimum)
            threshold = max(amplitude) * 0.01;
            bandwidth_idx = find(amplitude > threshold, 1, 'last');
            if ~isempty(bandwidth_idx)
                bandwidth = freq(bandwidth_idx);
                disp(['Estimeret båndbredde: ' num2str(bandwidth,'%.2f') ' Hz']);
            end
            
            % Beregn energi og effekt
            energy = sum(abs(x).^2) * dt;
            power = energy / (t_range(2) - t_range(1));
            
            disp(['Total energi: ' num2str(energy,'%.6f')]);
            disp(['Gennemsnitlig effekt: ' num2str(power,'%.6f')]);
            
            disp(' ');
            
            % 5. Spectrogram for tids-frekvensanalyse
            disp('5. TIDS-FREKVENSANALYSE:');
            figure;
            spectrogram(x, hamming(256), 128, 1024, Fs, 'yaxis');
            title(['Spectrogram - ' f_navn]);
            
            disp('Tids-frekvensanalyse er nu gennemført og plottet som spectrogram.');
            disp(' ');
            
            disp(['===== FOURIER-ANALYSE AFSLUTTET FOR ' upper(f_navn) ' =====']);
        end
        
        %%\n        kompletSystemAanalyse(num, den, system_navn)
            % KOMPLETSYSTEMAANALYSE Udfører en komplet analyse af et LTI-system med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.kompletSystemAanalyse(num, den, system_navn)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   system_navn - navn på systemet (valgfrit)
            
            % Default navn hvis ikke angivet
            if nargin < 3
                system_navn  'Lineært Tidsinvariant System';
            end
            
            disp([' KOMPLET ANALYSE AF ' upper(system_navn) ' ']);
            disp(' ');
            
            % 1. Konverter til overføringsfunktion
            disp('1. OVERFØRINGSFUNKTION:');
            [~, ~, tf_forklaring]  ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktion_med_forklaring(num, den);
            disp(' ');
            
            % 2. Analysér differentialligningen
            disp('2. ANALYSE AF DIFFERENTIALLIGNING:');
            a  den;  % Koefficienterne a er nævnerpolynomiet
            forklaring  ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a);
            disp(' ');
            
            % 3. Beregn og visualisér steprespons
            disp('3. STEPRESPONS:');
            [~, ~, step_forklaring]  ElektroMatBibTrinvis.beregnSteprespons_med_forklaring(num, den, [0, 20]);
            disp(' ');
            
            % 4. Beregn og visualisér frekvensrespons
            disp('4. FREKVENSRESPONS (BODE-DIAGRAM):');
            bode_forklaring  ElektroMatBibTrinvis.visBodeDiagram_med_forklaring(num, den, [0.01, 100]);
            disp(' ');
            
            % Analysér stabilitet
            p roots(den)\n        RLCKredsloebsAnalyse(R, L, C)
            % RLCKREDSLOEBSANALYSE Udfører en komplet analyse af et RLC-kredsløb med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.RLCKredsloebsAnalyse(R, L, C)
            %
            % Input:
            %   R - Modstand (Ohm)
            %   L - Induktans (Henry)
            %   C - Kapacitans (Farad)
            
            system_navn sprintf('RLC-kredsløb (R=%.2f Ω, L=%.4f H, C=%.6f F)\n        FourierAnalyse(f, t_range, f_navn)
            % FOURIERANALYSE Udfører en komplet Fourieranalyse af et signal med trinvise forklaringer
            %
            % Syntax:
            %   ElektroMatBibTrinvis.FourierAnalyse(f, t_range, f_navn)
            %
            % Input:
            %   f - funktion handle @(t) ...
            %   t_range - [t_min, t_max] tidsinterval
            %   f_navn - navn på funktionen (valgfrit)
            
            % Default navn hvis ikke angivet
            if nargin < 3
                f_navn  'Signal';
            end
            
            disp([' FOURIER-ANALYSE AF ' upper(f_navn) ' ']);
            disp(' ');
            
            % 1. Identificer signalet
            disp('1. SIGNALINFORMATION:');
            disp(['Signal: ' f_navn]);
            disp(['Tidsinterval: [' num2str(t_range(1)) ', ' num2str(t_range(2)) ']']);
            
            % Diskretiser signalet
            Fs  1000;  % Samplingsfrekvens
            dt  1/Fs;
            t t_range(1)\n        %%

function [h, forklaringsOutput] = foldning_med_forklaring(f, g, t, t_range)
    % FOLDNING_MED_FORKLARING Beregner foldningen af to funktioner med trinvis forklaring
    %
    % Syntax:
    %   [h, forklaringsOutput] = ElektroMatBibTrinvis.foldning_med_forklaring(f, g, t, t_range)
    %
    % Input:
    %   f - første funktion som symbolsk udtryk eller function handle
    %   g - anden funktion som symbolsk udtryk eller function handle
    %   t - tidsvariabel (symbolsk)
    %   t_range - [t_min, t_max] interval for numerisk beregning
    % 
    % Output:
    %   h - resultatet af foldningen
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Foldning af Funktioner');
    
    % Vis de oprindelige funktioner
    if isa(f, 'function_handle')
        f_str = func2str(f);
    else
        f_str = char(f);
    end
    
    if isa(g, 'function_handle')
        g_str = func2str(g);
    else
        g_str = char(g);
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer funktionerne', ...
        'Vi starter med at identificere de to funktioner, der skal foldes.', ...
        ['f(t) = ' f_str '\ng(t) = ' g_str]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér foldningsintegralet', ...
        'Foldningen af to funktioner er defineret som integralet:', ...
        '(f * g)(t) = ∫ f(τ) · g(t-τ) dτ fra -∞ til ∞');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Analysér funktionernes støtte', ...
        'For at optimere beregningen, undersøger vi hvornår funktionerne er forskellige fra nul.', ...
        'Dette hjælper os med at bestemme integrationsintervallet mere præcist.');
    
    % Numerisk beregning af foldningen
    dt = (t_range(2) - t_range(1)) / 1000;
    t_values = t_range(1):dt:t_range(2);
    
    % Evaluer funktioner hvis de er symbolske
    if ~isa(f, 'function_handle')
        syms tau;
        f_func = matlabFunction(subs(f, t, tau));
    else
        f_func = @(tau) f(tau);
    end
    
    if ~isa(g, 'function_handle')
        g_func = matlabFunction(g);
    else
        g_func = g;
    end
    
    % Beregn foldningen for hver t-værdi
    h_values = zeros(size(t_values));
    tau_range = t_range(1):dt:t_range(2);
    
    for i = 1:length(t_values)
        t_i = t_values(i);
        integrand = zeros(size(tau_range));
        
        for j = 1:length(tau_range)
            tau_j = tau_range(j);
            % Kontroller om vi er inden for domænet hvor begge funktioner er defineret
            try
                f_val = f_func(tau_j);
                g_val = g_func(t_i - tau_j);
                integrand(j) = f_val * g_val;
            catch
                integrand(j) = 0;
            end
        end
        
        h_values(i) = sum(integrand) * dt; % Tilnærmet integral
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Numerisk beregning af foldningen', ...
        'Vi beregner foldningen numerisk ved at approksimere integralet for hver værdi af t.', ...
        'For hver værdi af t evaluerer vi integralet ∫ f(τ) · g(t-τ) dτ numerisk.');
    
    % Resultat
    h = h_values;
    
    % Visualisér resultater
    figure('Position', [100, 100, 800, 600]);
    
    % Plot f(t)
    subplot(3, 1, 1);
    f_plot = zeros(size(t_values));
    for i = 1:length(t_values)
        try
            f_plot(i) = f_func(t_values(i));
        catch
            f_plot(i) = 0;
        end
    end
    plot(t_values, f_plot, 'LineWidth', 2);
    title('f(t)');
    grid on;
    
    % Plot g(t)
    subplot(3, 1, 2);
    g_plot = zeros(size(t_values));
    for i = 1:length(t_values)
        try
            g_plot(i) = g_func(t_values(i));
        catch
            g_plot(i) = 0;
        end
    end
    plot(t_values, g_plot, 'LineWidth', 2);
    title('g(t)');
    grid on;
    
    % Plot resultat
    subplot(3, 1, 3);
    plot(t_values, h_values, 'LineWidth', 2);
    title('(f * g)(t) - Foldning');
    grid on;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Visualisér resultater', ...
        'Vi plotter de oprindelige funktioner og resultatet af foldningen.', ...
        '');
    
    % Fortolkning af resultatet
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Fortolk foldningsresultatet', ...
        ['Foldning har følgende egenskaber:\n' ...
         '1. Kommutativitet: (f * g)(t) = (g * f)(t)\n' ...
         '2. Associativitet: (f * (g * h))(t) = ((f * g) * h)(t)\n' ...
         '3. Distributivitet: (f * (g + h))(t) = (f * g)(t) + (f * h)(t)'], ...
        '');
    
    % Sammenhæng med Laplacetransformation
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Relation til Laplacetransformation', ...
        'Foldningssætningen for Laplacetransformation fortæller os, at:', ...
        'L{(f * g)(t)} = L{f(t)} · L{g(t)} = F(s) · G(s)');
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Foldningen er beregnet numerisk og visualiseret.');
end

function [H, forklaringsOutput] = foldningssaetning_med_forklaring(F, G, s, t)
    % FOLDNINGSSAETNING_MED_FORKLARING Demonstrerer foldningssætningen med trinvis forklaring
    %
    % Syntax:
    %   [H, forklaringsOutput] = ElektroMatBibTrinvis.foldningssaetning_med_forklaring(F, G, s, t)
    %
    % Input:
    %   F - første Laplacetransformation som symbolsk udtryk
    %   G - anden Laplacetransformation som symbolsk udtryk
    %   s - Laplace-variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   H - produktet F(s)·G(s)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Foldningssætningen for Laplacetransformation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer Laplacetransformationerne', ...
        'Vi starter med de to Laplace-transformerede funktioner.', ...
        ['F(s) = ' char(F) '\nG(s) = ' char(G)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Forklar foldningssætningen', ...
        'Foldningssætningen siger, at produktet af to Laplacetransformationer svarer til Laplacetransformationen af foldningen af de oprindelige funktioner.', ...
        'L{(f * g)(t)} = F(s) · G(s)');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn produktet af Laplacetransformationerne', ...
        'Vi beregner produktet F(s) · G(s).', ...
        ['H(s) = F(s) · G(s) = ' char(F) ' · ' char(G)]);
    
    % Beregn produktet
    H = F * G;
    H_simplified = simplify(H);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Simplifiser resultatet', ...
        'Vi forenkler udtrykket om muligt.', ...
        ['H(s) = ' char(H_simplified)]);
    
    % Find den inverse Laplacetransformation
    try
        h = ElektroMatBib.inversLaplace(H_simplified, s, t);
        h_str = char(h);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Find den tilsvarende foldning i tidsdomænet', ...
            'Ved at anvende invers Laplacetransformation på H(s) finder vi den tilsvarende foldning i tidsdomænet.', ...
            ['h(t) = L^(-1){H(s)} = (f * g)(t) = ' h_str]);
    catch
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Find den tilsvarende foldning i tidsdomænet', ...
            'Den inverse Laplacetransformation kan være kompleks og kræve yderligere algebraiske manipulationer.', ...
            'h(t) = L^(-1){H(s)} = (f * g)(t)');
    end
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['H(s) = ' char(H_simplified)]);
end

%%\n        [h, forklaringsOutput] foldning_med_forklaring(f, g, t, t_range)\n        [H, forklaringsOutput] foldningssaetning_med_forklaring(F, G, s, t)\n        %%

function [F, forklaringsOutput] = deltaFunktion_med_forklaring(t0, t, s)
    % DELTAFUNKTION_MED_FORKLARING Forklarer Dirac's delta-funktion og dens Laplacetransformation
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.deltaFunktion_med_forklaring(t0, t, s)
    %
    % Input:
    %   t0 - tidspunkt for impulsen
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af delta(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Diracs Delta-funktion');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér delta-funktionen', ...
        'Diracs delta-funktion er en generaliseret funktion, der repræsenterer en uendelig smal og høj impuls.', ...
        ['δ(t-' char(t0) ') = { ∞ for t = ' char(t0) ', 0 for t ≠ ' char(t0) ' }']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Egenskaber for delta-funktionen', ...
        ['Følgende egenskaber gælder for delta-funktionen:\n' ...
         '1. ∫ δ(t-' char(t0) ') dt = 1 (areal = 1)\n' ...
         '2. ∫ f(t)·δ(t-' char(t0) ') dt = f(' char(t0) ') (sampling-egenskab)\n' ...
         '3. δ(t) = d/dt[u(t)] (differentialet af enhedstrinfunktionen)'], ...
        '');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend definitionen for Laplacetransformationen', ...
        'Vi anvender definitionen af Laplacetransformationen på delta-funktionen.', ...
        ['L{δ(t-' char(t0) ')} = ∫ δ(t-' char(t0) ')·e^(-st) dt fra 0- til ∞']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Udnyt sampling-egenskaben', ...
        ['Ved at bruge sampling-egenskaben med f(t) = e^(-st), får vi:'], ...
        ['∫ δ(t-' char(t0) ')·e^(-st) dt = e^(-s·' char(t0) ')']);
    
    % Resultat afhænger af t0
    if t0 < 0
        F = 0;
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Vurdér intervallet', ...
            ['Da ' char(t0) ' < 0, ligger delta-impulsen uden for integrationsområdet [0,∞).'], ...
            ['L{δ(t-' char(t0) ')} = 0 for ' char(t0) ' < 0']);
    else
        F = exp(-s*t0);
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn transformationen', ...
            ['Da ' char(t0) ' ≥ 0, har vi:'], ...
            ['L{δ(t-' char(t0) ')} = e^(-s·' char(t0) ')']);
    end
    
    % Specielt tilfælde hvis t0 = 0
    if t0 == 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
            'Specielt tilfælde for t0 = 0', ...
            'For t0 = 0 har vi delta-funktionen centreret i 0.', ...
            'L{δ(t)} = 1');
    end
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['L{δ(t-' char(t0) ')} = ' char(F)]);
end

function [F, forklaringsOutput] = enhedsTrin_med_forklaring(t0, t, s)
    % ENHEDSTRIN_MED_FORKLARING Forklarer enhedstrinfunktionen og dens Laplacetransformation
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.enhedsTrin_med_forklaring(t0, t, s)
    %
    % Input:
    %   t0 - forskydning af enhedstrinfunktionen
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af u(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Enhedstrinfunktionen');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér enhedstrinfunktionen', ...
        'Enhedstrinfunktionen u(t) repræsenterer et spring fra 0 til 1 ved tiden t = 0.', ...
        ['u(t-' char(t0) ') = { 1 for t ≥ ' char(t0) ', 0 for t < ' char(t0) ' }']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Egenskaber for enhedstrinfunktionen', ...
        ['Følgende egenskaber gælder for enhedstrinfunktionen:\n' ...
         '1. u(t) er diskontinuert ved t = 0\n' ...
         '2. d/dt[u(t)] = δ(t) (enhedstrinfunktionen er integralet af delta-funktionen)\n' ...
         '3. f(t)·u(t-t0) "tænder" for f(t) ved tiden t = t0'], ...
        '');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend definitionen for Laplacetransformationen', ...
        'Vi anvender definitionen af Laplacetransformationen på enhedstrinfunktionen.', ...
        ['L{u(t-' char(t0) ')} = ∫ u(t-' char(t0) ')·e^(-st) dt fra 0- til ∞']);
    
    % Resultat afhænger af t0
    if t0 > 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
            'Opdel integralet', ...
            ['Da ' char(t0) ' > 0, starter springet efter t = 0:'], ...
            ['∫ u(t-' char(t0) ')·e^(-st) dt = ∫ 0·e^(-st) dt fra 0 til ' char(t0) ' + ∫ 1·e^(-st) dt fra ' char(t0) ' til ∞']);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn integralet', ...
            ['Vi løser integralet:'], ...
            ['∫ e^(-st) dt fra ' char(t0) ' til ∞ = [-e^(-st)/s]_' char(t0) '^∞ = 0 - (-e^(-s·' char(t0) ')/s) = e^(-s·' char(t0) ')/s']);
        
        F = exp(-s*t0)/s;
    elseif t0 == 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
            'Simpelt tilfælde for t0 = 0', ...
            'For t0 = 0 har vi den klassiske enhedstrinfunktion u(t).', ...
            ['∫ u(t)·e^(-st) dt = ∫ 1·e^(-st) dt fra 0 til ∞ = [-e^(-st)/s]_0^∞ = 0 - (-1/s) = 1/s']);
        
        F = 1/s;
    else % t0 < 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
            'Analysér tilfældet t0 < 0', ...
            ['Da ' char(t0) ' < 0, starter springet før t = 0, så u(t-' char(t0) ') = 1 for hele integrationsområdet [0,∞).'], ...
            ['∫ u(t-' char(t0) ')·e^(-st) dt = ∫ 1·e^(-st) dt fra 0 til ∞ = 1/s']);
        
        F = 1/s;
    end
    
    % Anvend forsinkelsesreglen
    if t0 > 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
            'Brug forsinkelsesreglen', ...
            ['Vi kan også anvende forsinkelsesreglen direkte:'], ...
            ['L{u(t-' char(t0) ')} = L{u(t)}·e^(-s·' char(t0) ') = (1/s)·e^(-s·' char(t0) ') = e^(-s·' char(t0) ')/s']);
    end
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['L{u(t-' char(t0) ')} = ' char(F)]);
end

function [F, forklaringsOutput] = forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
    % FORSINKELSESREGEL_MED_FORKLARING Forklarer forsinkelsesreglen (Second Shift Theorem)
    %
    % Syntax:
    %   [F, forklaringsOutput] = ElektroMatBibTrinvis.forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
    %
    % Input:
    %   f_expr - oprindelig funktion som symbolsk udtryk
    %   t0 - forsinkelsestid
    %   t - tidsvariabel (symbolsk)
    %   s - Laplace-variabel (symbolsk)
    % 
    % Output:
    %   F - Laplacetransformationen af f(t-t0)u(t-t0)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Forsinkelsesreglen for Laplacetransformation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér den oprindelige funktion', ...
        'Vi starter med den oprindelige funktion f(t).', ...
        ['f(t) = ' char(f_expr)]);
    
    % Beregn Laplacetransformationen af den oprindelige funktion
    F_orig = ElektroMatBib.laplace(f_expr, t, s);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Find Laplacetransformationen af f(t)', ...
        'Vi beregner først Laplacetransformationen af den oprindelige funktion.', ...
        ['L{f(t)} = ' char(F_orig)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Definér den forsinkede funktion', ...
        ['Vi ønsker at finde Laplacetransformationen af den forsinkede funktion f(t-' char(t0) ')u(t-' char(t0) ').'], ...
        ['Dette repræsenterer f(t) forskudt ' char(t0) ' tidenheder og "tændt" ved t = ' char(t0) '.']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Forklar forsinkelsesreglen', ...
        'Forsinkelsesreglen (Second Shift Theorem) siger:', ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = e^(-s·' char(t0) ') · L{f(t)}    for ' char(t0) ' > 0']);
    
    % Anvend forsinkelsesreglen
    F = exp(-s*t0) * F_orig;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Anvend forsinkelsesreglen', ...
        ['Vi anvender formlen direkte:'], ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = e^(-s·' char(t0) ') · ' char(F_orig) ' = ' char(F)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Fortolk resultatet', ...
        ['Forsinkelsesreglen viser, at en forsinkelse i tidsdomænet svarer til multiplikation med e^(-s·t0) i s-domænet.'], ...
        ['Dette er særligt nyttigt ved løsning af differentialligninger med forsinkede inputsignaler.']);
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['L{f(t-' char(t0) ')u(t-' char(t0) ')} = ' char(F)]);
end

%%\n        [F, forklaringsOutput] deltaFunktion_med_forklaring(t0, t, s)\n        [F, forklaringsOutput] enhedsTrin_med_forklaring(t0, t, s)\n        [F, forklaringsOutput] forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)\n        %%

function [cn, forklaringsOutput] = fourierKoefficienter_med_forklaring(f, t, T)
    % FOURIERKOEFFICIENTER_MED_FORKLARING Beregner Fourierkoefficienter med trinvis forklaring
    %
    % Syntax:
    %   [cn, forklaringsOutput] = ElektroMatBibTrinvis.fourierKoefficienter_med_forklaring(f, t, T)
    %
    % Input:
    %   f - periodisk funktion som symbolsk udtryk
    %   t - tidsvariabel (symbolsk)
    %   T - periode
    % 
    % Output:
    %   cn - struktur med Fourierkoefficienter
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Beregning af Fourierkoefficienter');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den periodiske funktion', ...
        ['Vi starter med den periodiske funktion f(t) med periode T = ' char(T) '.'], ...
        ['f(t) = ' char(f)]);
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Definér grundfrekvensen', ...
        ['Grundfrekvensen beregnes som ω₀ = 2π/T.'], ...
        ['ω₀ = 2π/' char(T) ' = ' char(omega) ' rad/s']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Definér formlen for Fourierkoefficienter', ...
        ['Fourierkoefficienten cₙ er defineret som:'], ...
        ['cₙ = (1/T) · ∫ f(t) · e^(-jnω₀t) dt fra -T/2 til T/2']);
    
    % Beregn koefficienter
    syms n;
    cn_expr = (1/T) * int(f * exp(-1i*n*omega*t), t, -T/2, T/2);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Opsæt integralet', ...
        ['Vi indsætter funktionen i formlen:'], ...
        ['cₙ = (1/' char(T) ') · ∫ ' char(f) ' · e^(-jn·' char(omega) '·t) dt fra -' char(T/2) ' til ' char(T/2)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Løs integralet symbolsk', ...
        ['Vi integrerer udtrykket med hensyn til t:'], ...
        ['cₙ = ' char(cn_expr)]);
    
    % Beregn specifikke koefficienter
    max_n = 5;
    c_values = struct();
    c_values.c0 = double(subs(cn_expr, n, 0));
    
    coef_text = ['c₀ = ' num2str(c_values.c0, '%.6f')];
    
    for k = 1:max_n
        c_values.(sprintf('c%d', k)) = double(subs(cn_expr, n, k));
        c_values.(sprintf('cm%d', k)) = double(subs(cn_expr, n, -k));
        
        coef_text = [coef_text '\nc₋' num2str(k) ' = ' num2str(c_values.(sprintf('cm%d', k)), '%.6f')];
        coef_text = [coef_text '\nc' num2str(k) ' = ' num2str(c_values.(sprintf('c%d', k)), '%.6f')];
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Beregn specifikke koefficienter', ...
        ['Vi beregner koefficienterne c₀, c₁, c₋₁, ..., c' num2str(max_n) ', c₋' num2str(max_n) ':'], ...
        coef_text);
    
    % Symmetriegenskaber
    if isreal(f)
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
            'Undersøg symmetriegenskaber', ...
            ['Da f(t) er en reel funktion, gælder: c₋ₙ = cₙ*'], ...
            ['Hvor * angiver den komplekst konjugerede.']);
        
        % Tjek for lige/ulige symmetri
        try
            f_even = subs(f, t, -t);
            if isequal(f_even, f)
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer lige symmetri', ...
                    ['Funktionen har lige symmetri: f(-t) = f(t)'], ...
                    ['Dette giver reelle Fourierkoefficienter.']);
            elseif isequal(f_even, -f)
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                    'Identificer ulige symmetri', ...
                    ['Funktionen har ulige symmetri: f(-t) = -f(t)'], ...
                    ['Dette giver rent imaginære Fourierkoefficienter.']);
            end
        catch
            % Kunne ikke undersøge symbolsk
        end
    end
    
    % Returnér koefficienter
    cn = c_values;
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Fourierkoefficienter er beregnet.');
    
    % Visualiser amplitudespektrum
    figure;
    
    % Ekstrahér koefficienter til plot
    n_values = -max_n:max_n;
    c_plot = zeros(size(n_values));
    
    for i = 1:length(n_values)
        if n_values(i) == 0
            c_plot(i) = abs(c_values.c0);
        elseif n_values(i) > 0
            c_plot(i) = abs(c_values.(sprintf('c%d', n_values(i))));
        else
            c_plot(i) = abs(c_values.(sprintf('cm%d', abs(n_values(i)))));
        end
    end
    
    % Plot amplitudespektrum
    stem(n_values, c_plot, 'filled', 'LineWidth', 2);
    grid on;
    title('Amplitudespektrum |cₙ|');
    xlabel('n');
    ylabel('|cₙ|');
end

function [f_approx, forklaringsOutput] = fourierRaekke_med_forklaring(cn, t, T, N)
    % FOURIERRAEKKE_MED_FORKLARING Beregner Fourierrækkeapproksimation med trinvis forklaring
    %
    % Syntax:
    %   [f_approx, forklaringsOutput] = ElektroMatBibTrinvis.fourierRaekke_med_forklaring(cn, t, T, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   t - tidsvariabel (symbolsk)
    %   T - periode
    %   N - antal led i Fourierrækken
    % 
    % Output:
    %   f_approx - approksimation af den periodiske funktion
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Fourierrækkeapproksimation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Fourierrækken', ...
        ['Fourierrækken for en periodisk funktion med periode T er givet ved:'], ...
        ['f(t) = ∑ cₙ·e^(jnω₀t) fra n = -∞ til ∞, hvor ω₀ = 2π/T']);
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn grundfrekvensen', ...
        ['Grundfrekvensen er ω₀ = 2π/T.'], ...
        ['ω₀ = 2π/' char(T) ' = ' char(omega) ' rad/s']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Begræns antallet af led', ...
        ['Vi approksimerer Fourierrækken med et begrænset antal led:'], ...
        ['f(t) ≈ ∑ cₙ·e^(jnω₀t) fra n = -' num2str(N) ' til ' num2str(N)]);
    
    % Opbyg rækkens udtryk
    f_approx_sym = 0;
    
    % Tilføj c₀-leddet
    if isfield(cn, 'c0')
        f_approx_sym = f_approx_sym + cn.c0;
    end
    
    % Tilføj de positive n-led
    for k = 1:N
        field_name = sprintf('c%d', k);
        if isfield(cn, field_name)
            f_approx_sym = f_approx_sym + cn.(field_name) * exp(1i*k*omega*t);
        end
    end
    
    % Tilføj de negative n-led
    for k = 1:N
        field_name = sprintf('cm%d', k);
        if isfield(cn, field_name)
            f_approx_sym = f_approx_sym + cn.(field_name) * exp(-1i*k*omega*t);
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Opbyg Fourierrækkeudtrykket', ...
        ['Vi indsætter de beregnede koefficienter:'], ...
        ['f(t) ≈ ' char(f_approx_sym)]);
    
    % Forenkl til reel form (cos/sin)
    try
        f_approx_real = simplify(f_approx_sym, 'IgnoreAnalyticConstraints', true);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Omskriv til cosinus/sinus-form', ...
            ['Vi kan omskrive udtrykt til reelle cosinus- og sinusfunktioner:'], ...
            ['f(t) ≈ ' char(f_approx_real)]);
    catch
        % Kunne ikke forenkle symbolsk
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Fourierrækken i eksponentiel form', ...
            ['Fourierrækken er udtrykt i eksponentiel form.'], ...
            ['']);
    end
    
    % Beregn effekten af signalet
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    power_sum = c0_squared;
    for k = 1:N
        if isfield(cn, sprintf('c%d', k))
            power_sum = power_sum + abs(cn.(sprintf('c%d', k)))^2;
        end
        if isfield(cn, sprintf('cm%d', k))
            power_sum = power_sum + abs(cn.(sprintf('cm%d', k)))^2;
        end
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
        'Beregn effekten af approksimationen', ...
        ['Signaleffekten kan beregnes ved hjælp af Parsevals teorem:'], ...
        ['P = |c₀|² + ∑ |cₙ|² fra n = -∞ til ∞, n ≠ 0']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
        'Estimér signalets effekt', ...
        ['Den estimerede effekt med ' num2str(2*N+1) ' led er:'], ...
        ['P ≈ ' num2str(power_sum)]);
    
    % Resultat
    f_approx = f_approx_sym;
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['Fourierrækkeapproksimationen er beregnet med ' num2str(2*N+1) ' led.']);
    
    % Plot approksimationen
    figure;
    
    % Generer t-værdier for 3 perioder
    t_values = linspace(-1.5*T, 1.5*T, 1000);
    
    % Evaluer funktionen
    f_values = zeros(size(t_values));
    for i = 1:length(t_values)
        f_values(i) = double(subs(f_approx, t, t_values(i)));
    end
    
    % Plot
    plot(t_values, real(f_values), 'LineWidth', 2);
    grid on;
    title(['Fourierrækkeapproksimation (N = ' num2str(N) ')']);
    xlabel('t');
    ylabel('f(t)');
    
    % Markér periodeintervallet
    xline(-T/2, '--', 'T/2');
    xline(T/2, '--', 'T/2');
    
    % Markér middelværdien
    if isfield(cn, 'c0')
        yline(real(cn.c0), '-.', 'c₀');
    end
end

function [P, forklaringsOutput] = parsevalTeorem_med_forklaring(cn, N)
    % PARSEVALTEOREM_MED_FORKLARING Forklarer Parsevals teorem og beregner signalets effekt
    %
    % Syntax:
    %   [P, forklaringsOutput] = ElektroMatBibTrinvis.parsevalTeorem_med_forklaring(cn, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   N - maksimalt indekstal for koefficienterne
    % 
    % Output:
    %   P - signalets middeleffekt
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Parsevals Teorem');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        ['Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:'], ...
        ['(1/T) · ∫ |f(t)|² dt = |c₀|² + ∑ |cₙ|² fra n = -∞ til ∞, n ≠ 0']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        ['Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.'], ...
        ['Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.']);
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end
    
    power_text = ['|c₀|² = ' num2str(c0_squared)];
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
        
        power_text = [power_text '\n|c₋' num2str(k) '|² + |c' num2str(k) '|² = ' num2str(neg_term) ' + ' num2str(pos_term) ' = ' num2str(neg_term + pos_term)];
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn effektbidrag fra hver frekvenskomponent', ...
        ['Vi beregner effektbidraget fra hver enkelt frekvenskomponent:'], ...
        power_text);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Summér effekter', ...
        ['Den samlede middeleffekt er summen af alle effektbidrag:'], ...
        ['P = ' num2str(power_sum)]);
    
    % Beregn relativ effektfordeling
    if power_sum > 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Beregn relativ effektfordeling', ...
            ['Vi kan også beregne, hvor meget hver frekvenskomponent bidrager til den samlede effekt:'], ...
            ['DC-komponent (c₀): ' num2str(100*c0_squared/power_sum, '%.2f') '%']);
    end
    
    % Resultat
    P = power_sum;
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['Middeleffekten er ' num2str(P)]);
    
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
    title('Effektspektrum |cₙ|²');
    xlabel('n');
    ylabel('|cₙ|²');
end

%%\n        [cn, forklaringsOutput] fourierKoefficienter_med_forklaring(f, t, T)\n        [f_approx, forklaringsOutput] fourierRaekke_med_forklaring(cn, t, T, N)\n        [P, forklaringsOutput] parsevalTeorem_med_forklaring(cn, N)\n        [E, forklaringsOutput] energiTaethed_med_forklaring(F, omega)\n        [P, forklaringsOutput] effektTaethed_med_forklaring(F, omega)\n    end\nend\n