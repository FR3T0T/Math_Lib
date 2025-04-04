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