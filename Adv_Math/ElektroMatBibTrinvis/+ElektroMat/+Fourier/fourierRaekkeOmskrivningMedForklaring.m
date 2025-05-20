function [series_trig, forklaringsOutput] = fourierRaekkeOmskrivningMedForklaring(cn, t, T, N)
    % FOURIERRAEKKEOMSKRIVNING_MED_FORKLARING Omskriver Fourierrække fra 
    % eksponentiel til trigonometrisk form med trinvis forklaring
    %
    % Syntax:
    %   [series_trig, forklaringsOutput] = fourierRaekkeOmskrivningMedForklaring(cn, t, T, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   t - tidsvariabel (symbolsk)
    %   T - periode
    %   N - antal led i Fourierrækken
    % 
    % Output:
    %   series_trig - omskrevet trigonometrisk Fourierrække
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Starter forklaring
    forklaringsOutput = startForklaring('Omskrivning af Fourierrække');
    
    % Verificer at t er symbolsk
    if ~isa(t, 'sym')
        t = sym(t);
    end
    
    % Beregn grundfrekvensen
    omega = 2*pi/T;
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Definer grundfrekvensen og den generelle Fourierrække', ...
        ['Grundfrekvensen er omega_0 = 2pi/T = ' num2str(double(omega)) ' rad/s'], ...
        ['Den generelle eksponentielle Fourierrække har formen: f(t) = sum_{n=-oo}^{oo} c_n e^(j n omega_0 t)']);
    
    % Verificer koefficientstrukturen
    if ~isstruct(cn) || ~isfield(cn, 'c0')
        error('Koefficientstrukturen skal indeholde feltet c0 og c1, c2, ..., cm1, cm2, ...');
    end
    
    % Eksponentiel serie form
    exponential_series = cn.c0;
    has_nonzero_terms = abs(cn.c0) > 1e-10;
    
    series_text = '';
    if abs(cn.c0) > 1e-10
        series_text = ['c_0 = ' formatComplexNumber(cn.c0)];
    else
        series_text = 'c_0 = 0';
    end
    
    % Generer den eksponentielle serie og tjek symmetrier
    are_conjugate = true;     % c_{-n} = conj(c_n) (reelle funktioner)
    are_neg_conjugate = true; % c_{-n} = -conj(c_n) (rent imaginære funktioner)
    are_opposite = true;      % c_{-n} = -c_n (speciel)
    are_equal = true;         % c_{-n} = c_n (speciel)
    
    only_odd_coeffs = true;   % Kun ulige n har ikke-nul koefficienter
    only_even_coeffs = true;  % Kun lige n har ikke-nul koefficienter
    
    % Undersøg strukturen af koefficienter
    for n = 1:N
        c_n = cn.(['c' num2str(n)]);
        c_neg_n = cn.(['cm' num2str(n)]);
        
        % Tjek om koefficienten er tæt på nul
        if abs(c_n) > 1e-10
            has_nonzero_terms = true;
            
            if mod(n, 2) == 0
                only_odd_coeffs = false;
            else
                only_even_coeffs = false;
            end
            
            % Tilføj til serien
            exponential_series = exponential_series + c_n * exp(1i*n*omega*t);
            series_text = [series_text '\nc_' num2str(n) ' = ' formatComplexNumber(c_n)];
        else
            if mod(n, 2) == 0
                only_odd_coeffs = only_odd_coeffs && true;
            else
                only_even_coeffs = only_even_coeffs && true;
            end
        end
        
        if abs(c_neg_n) > 1e-10
            has_nonzero_terms = true;
            
            % Tilføj til serien
            exponential_series = exponential_series + c_neg_n * exp(-1i*n*omega*t);
            series_text = [series_text '\nc_-' num2str(n) ' = ' formatComplexNumber(c_neg_n)];
        end
        
        % Tjek symmetriforhold (kun hvis begge koefficienter er væsentligt forskellige fra nul)
        if abs(c_n) > 1e-10 && abs(c_neg_n) > 1e-10
            if abs(c_neg_n - conj(c_n)) > 1e-8
                are_conjugate = false;
            end
            
            if abs(c_neg_n + conj(c_n)) > 1e-8
                are_neg_conjugate = false;
            end
            
            if abs(c_neg_n + c_n) > 1e-8
                are_opposite = false;
            end
            
            if abs(c_neg_n - c_n) > 1e-8
                are_equal = false;
            end
        end
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 7, ...
    'Fourierrækken i trigonometrisk form', ...
    ['Fourierrækken kan nu skrives som:'], ...
    ['f(t) = a_0/2 + \\sum_{n=1}^{\\infty} [a_n \\cos(n \\omega_0 t) + b_n \\sin(n \\omega_0 t)]']);
    
    % Identificer og rapporterer specielle funktioner
    if ~has_nonzero_terms
        % Hvis alle koefficienter er 0, er funktionen 0
        series_trig = 0;
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
            'Identificer triviel funktion', ...
            ['Alle koefficienter er 0 eller meget små.'], ...
            ['Funktionen er identisk 0.']);
            
        forklaringsOutput = afslutForklaring(forklaringsOutput, ...
            'f(t) = 0');
        return;
    end
    
    % Rapporter symmetrier
    symmetry_text = '';
    if are_conjugate
        symmetry_text = [symmetry_text 'c_{-n} = c_n* (reel funktion)\n'];
    end
    
    if are_neg_conjugate
        symmetry_text = [symmetry_text 'c_{-n} = -c_n* (rent imaginær funktion)\n'];
    end
    
    if are_opposite
        symmetry_text = [symmetry_text 'c_{-n} = -c_n (speciel symmetri)\n'];
    end
    
    if are_equal
        symmetry_text = [symmetry_text 'c_{-n} = c_n (speciel symmetri)\n'];
    end
    
    if only_odd_coeffs
        symmetry_text = [symmetry_text 'Kun ulige n har ikke-nul koefficienter (halvperiode antisymmetri)\n'];
    end
    
    if only_even_coeffs
        symmetry_text = [symmetry_text 'Kun lige n har ikke-nul koefficienter (halvperiode symmetri)\n'];
    end
    
    if ~isempty(symmetry_text)
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
            'Identificer symmetriforhold', ...
            ['Følgende symmetriforhold er identificeret:'], ...
            symmetry_text);
    end
    
    % Omskriv til trigonometrisk form
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        'Omskriv til reelværdige trigonometriske funktioner', ...
        ['For et reelt signal kan Fourierrækken omskrives til:'], ...
        ['f(t) = c_0 + sum_{n=1}^{oo} [c_n e^(j n omega_0 t) + c_{-n} e^(-j n omega_0 t)]']);
    
    % Omskriv til cosinus og sinus
    if are_conjugate
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Anvend relationen c_{-n} = c_n*', ...
            ['For reelle funktioner gælder c_{-n} = c_n*. Vi indsætter dette:'], ...
            ['f(t) = c_0 + sum_{n=1}^{oo} [c_n e^(j n omega_0 t) + c_n* e^(-j n omega_0 t)]']);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 6, ...
            'Omskriv til a_n og b_n koefficienter', ...
            ['Vi kan omskrive til cosinus- og sinusled ved at sætte c_n = (a_n - j b_n)/2 hvor a_n og b_n er reelle:'], ...
            ['f(t) = c_0 + sum_{n=1}^{oo} [a_n cos(n omega_0 t) + b_n sin(n omega_0 t)]']);
        
        a0 = 2*real(cn.c0);
        a_coeffs = [];
        b_coeffs = [];
        
        for n = 1:N
            c_n = cn.(['c' num2str(n)]);
            if abs(c_n) > 1e-10
                a_n = 2*real(c_n);
                b_n = -2*imag(c_n);
                a_coeffs(n) = a_n;
                b_coeffs(n) = b_n;
            else
                a_coeffs(n) = 0;
                b_coeffs(n) = 0;
            end
        end
    elseif are_opposite
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Anvend den specielle relation c_{-n} = -c_n', ...
            ['Vi har identificeret at c_{-n} = -c_n, hvilket giver:'], ...
            ['f(t) = c_0 + sum_{n=1}^{oo} [c_n e^(j n omega_0 t) - c_n e^(-j n omega_0 t)]']);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 6, ...
            'Omskriv til sinus', ...
            ['Dette forenkles til:'], ...
            ['f(t) = c_0 + sum_{n=1}^{oo} c_n (e^(j n omega_0 t) - e^(-j n omega_0 t))' ...
             '\n      = c_0 + sum_{n=1}^{oo} c_n · 2j · sin(n omega_0 t)']);
        
        % Kun sinus led, ingen cosinus
        a0 = 2*real(cn.c0);
        a_coeffs = zeros(1, N);
        b_coeffs = zeros(1, N);
        
        for n = 1:N
            c_n = cn.(['c' num2str(n)]);
            if abs(c_n) > 1e-10
                b_n = 2*imag(c_n);  % Pga. 2j faktor
                b_coeffs(n) = b_n;
            end
        end
    else
        % Generel tilgang til a_n og b_n
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
            'Omskriv til cosinus og sinus', ...
            ['For generel kompleks c_n, kan vi bruge:'], ...
            ['e^(jθ) = cos(θ) + j·sin(θ)']);
        
        forklaringsOutput = tilfoejTrin(forklaringsOutput, 6, ...
            'Udregning af reelle koefficienter', ...
            ['Vi beregner de reelle koefficienter:'], ...
            ['a_0 = 2·Re{c_0}, a_n = 2·Re{c_n}, b_n = -2·Im{c_n}']);
        
        a0 = 2*real(cn.c0);
        a_coeffs = zeros(1, N);
        b_coeffs = zeros(1, N);
        
        for n = 1:N
            c_n = cn.(['c' num2str(n)]);
            c_neg_n = cn.(['cm' num2str(n)]);
            
            if abs(c_n) > 1e-10 || abs(c_neg_n) > 1e-10
                a_n = real(c_n + c_neg_n);
                b_n = imag(c_neg_n - c_n);
                a_coeffs(n) = a_n;
                b_coeffs(n) = b_n;
            end
        end
    end
    
    % Opbyg den trigonometriske serie
    series_trig = a0/2;  % c_0 = a_0/2
    trig_text = '';
    
    if abs(a0) > 1e-10
        trig_text = ['a_0/2 = ' num2str(a0/2)];
    else
        trig_text = 'a_0/2 = 0';
    end
    
    for n = 1:N
        if abs(a_coeffs(n)) > 1e-10
            series_trig = series_trig + a_coeffs(n) * cos(n*omega*t);
            trig_text = [trig_text '\na_' num2str(n) ' = ' num2str(a_coeffs(n))];
        end
        
        if abs(b_coeffs(n)) > 1e-10
            series_trig = series_trig + b_coeffs(n) * sin(n*omega*t);
            trig_text = [trig_text '\nb_' num2str(n) ' = ' num2str(b_coeffs(n))];
        end
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 7, ...
        'Fourierrækken i trigonometrisk form', ...
        ['Fourierrækken kan nu skrives som:'], ...
        ['f(t) = a_0/2 + sum_{n=1}^{oo} [a_n cos(n omega_0 t) + b_n sin(n omega_0 t)]']);
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 8, ...
        'De beregnede Fourierkoefficienter', ...
        ['Vi har fundet følgende reelle Fourierkoefficienter:'], ...
        trig_text);
    
    % Identificer specielle mønstre for b_n koefficienter (for sinus-led)
    if only_odd_coeffs && all(a_coeffs(1:N) < 1e-10)
        % Kun ulige sinus led, a_n = 0
        pattern = identifyPattern(b_coeffs);
        
        if ~isempty(pattern)
            forklaringsOutput = tilfoejTrin(forklaringsOutput, 9, ...
                'Identificer mønster i sinuskoefficienter', ...
                ['Der er et mønster i b-koefficienterne, der kan forenkle udtrykket:'], ...
                ['b_{2k-1} = ' pattern ', k = 1, 2, 3, ...']);
            
            % Omskrivning til sinus-form med 2k-1
            sin_series = sym(0);
            
            % Gennemfør omskrivning baseret på mønsteret
            if contains(pattern, '1/n')
                % Tilfælde for 1/n-type mønstre, typisk for firkantsignaler
                if contains(pattern, '4/pi')
                    % Her retter vi fejlen i linjen nedenfor
                    syms k
                    sin_series = (4/pi)*symsum(1/(2*k-1)*sin((2*k-1)*pi*t), k, 1, inf);
                elseif contains(pattern, '2/pi')
                    syms k
                    sin_series = (2/pi)*symsum(1/(2*k-1)*sin((2*k-1)*pi*t), k, 1, inf);
                end
                
                forklaringsOutput = tilfoejTrin(forklaringsOutput, 10, ...
                    'Omskriv til kompakt sinus-form', ...
                    ['Fourierrækken kan omskrives til:'], ...
                    ['f(t) = ' char(sin_series)]);
            end
        end
    end
    
    % Afslut forklaring
    series_simple = simplify(series_trig);
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        ['f(t) = ' char(series_simple)]);
end

% Hjælpefunktion til formatering af komplekse tal med korrekt 'i'
function str = formatComplexNumber(z)
    % Formaterer et komplekst tal til tekst med korrekt ASCII 'i'
    re = real(z);
    im = imag(z);
    
    % Tilføj en lille buffer for at undgå numeriske fejl
    eps = 1e-10;
    
    if abs(re) < eps && abs(im) < eps
        % Nul
        str = '0.000000';
    elseif abs(re) < eps
        % Rent imaginært
        if abs(im - 1) < eps
            str = 'i';  % Bare 'i' for i
        elseif abs(im + 1) < eps
            str = '-i'; % Bare '-i' for -i
        else
            str = sprintf('%.6fi', im);  % Bruger ASCII 'i'
        end
    elseif abs(im) < eps
        % Rent reelt
        str = sprintf('%.6f', re);
    else
        % Blandet komplekst tal
        if im > 0
            str = sprintf('%.6f+%.6fi', re, im);  % Bruger ASCII 'i'
        else
            str = sprintf('%.6f%.6fi', re, im);   % Bruger ASCII 'i' (minus kommer automatisk)
        end
    end
end

% Hjælpefunktion til at identificere mønstre i koefficienter
function pattern = identifyPattern(coeffs)
    % Identificerer mønstre i koefficienter
    pattern = '';
    
    % Fjern nulkoefficienter og find de ikke-nul koefficienter
    idx = find(abs(coeffs) > 1e-10);
    values = coeffs(idx);
    
    if isempty(values)
        return;
    end
    
    % Tjek om indekserne svarer til ulige tal
    if all(mod(idx, 2) == 1)
        % Konverter indeks til k-værdi hvor n = 2k-1
        k_values = (idx + 1) / 2;
        
        % Tjek om værdier falder med 1/n
        n_values = 2*k_values - 1;
        scaled_values = values .* n_values;
        
        if std(scaled_values) / mean(scaled_values) < 0.01
            % Værdierne følger 1/n mønsteret
            scale = mean(scaled_values);
            
            % Tjek for almindelige skaleringsfaktorer
            if abs(scale - 4/pi) < 0.01
                pattern = '4/pi * 1/n';
            elseif abs(scale - 2/pi) < 0.01
                pattern = '2/pi * 1/n';
            else
                pattern = [num2str(scale) ' * 1/n'];
            end
        end
    end
end