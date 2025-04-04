
        
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
            amplitude(2:end