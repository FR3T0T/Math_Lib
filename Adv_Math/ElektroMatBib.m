% ElektroMatBib.m - MATLAB Matematisk Bibliotek til 62735 "Videregående Matematik for Diplom Elektroteknologi"
% Dette bibliotek giver praktiske funktioner til at løse opgaver indenfor:
% - Laplace transformation
% - Fourier transformation og rækker
% - Lineære tidsinvariante systemer
% - Differentialligninger

classdef ElektroMatBib
    methods(Static)
        %% HJÆLPEFUNKTIONER %%
        
        function tekst = unicode_dansk(inputTekst)
            % Konverterer mellem almindelige erstatninger og unicode for danske tegn
            % Fx. 'oe' -> Unicode for 'ø'
            
            % Definer de danske tegn som Unicode escape-koder
            ae_small = char(230);  % æ
            oe_small = char(248);  % ø
            aa_small = char(229);  % å
            
            AE_cap = char(198);    % Æ
            OE_cap = char(216);    % Ø
            AA_cap = char(197);    % Å
            
            % Erstat typiske mønstre
            tekst = strrep(inputTekst, 'oe', oe_small);
            tekst = strrep(tekst, 'ae', ae_small);
            tekst = strrep(tekst, 'aa', aa_small);
            
            % Håndter også store bogstaver
            tekst = strrep(tekst, 'OE', OE_cap);
            tekst = strrep(tekst, 'AE', AE_cap);
            tekst = strrep(tekst, 'AA', AA_cap);
        end
        
        function demoProgrammet()
            % Viser brug af biblioteket med eksempler
            fprintf('ElektroMatBib - Videregående Matematik Bibliotek Demonstrationer\n');
            fprintf('==================================================\n\n');
            
            % Demo af Laplace transformation
            fprintf('1. LAPLACE TRANSFORMATION DEMO:\n');
            fprintf('Laplacetransformation af f(t) = e^(-2t):\n');
            syms t s;
            f = exp(-2*t);
            F = ElektroMatBib.laplace(f, t, s);
            fprintf('L{e^(-2t)} = %s\n', char(F));
            fprintf('\n');
            
            % Demo af invers Laplace
            fprintf('2. INVERS LAPLACE DEMO:\n');
            syms s t;
            F = 1/(s^2 + 4);
            f = ElektroMatBib.inversLaplace(F, s, t);
            fprintf('L^(-1){1/(s^2 + 4)} = %s\n', char(f));
            fprintf('\n');
            
            % Demo af Fourier-rækker
            fprintf('3. FOURIER RÆKKER DEMO:\n');
            T = 2*pi;
            % Vis en periodisk signal og dens Fourier-rækker (grafisk)
            ElektroMatBib.visFourierRaekker(@(t) square(t), T, 10);
            fprintf('\n');
            
            % Demo af LTI system
            fprintf('4. LTI SYSTEM DEMO:\n');
            % Differentialligning: y'' + 0.5y' + 2y = x(t)
            a = [1 0.5 2];  % koefficienter: a_n, a_{n-1}, ..., a_0
            b = [1];        % koefficienter: b_m, b_{m-1}, ..., b_0
            [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a);
            fprintf('Overføringsfunktion: H(s) = ');
            ElektroMatBib.visPolynomBroek(num, den);
            fprintf('\n');
            
            % Vis impulsrespons grafisk
            ElektroMatBib.visImpulsrespons(num, den);
        end

        function kommandoOversigt(kategori)
            % Viser en oversigt over kommandoer og deres brug i ElektroMatBib
            % Input: kategori (valgfri) - specificerer en bestemt kategori at vise
            %   Options: 'laplace', 'fourier', 'lti', 'diff', 'hjælp'
            %   Default: Viser alle kategorier
            
            % Hvis ingen kategori er specificeret, vis hovedmenuen
            if nargin < 1
                fprintf('\n=== ElektroMatBib Kommandooversigt ===\n');
                fprintf('Vælg en kategori for at se detaljer:\n');
                fprintf('1. Laplace trans. (Brug: kommandoOversigt(''laplace''))\n');
                fprintf('2. Fourier trans. (Brug: kommandoOversigt(''fourier''))\n');
                fprintf('3. LTI systemer   (Brug: kommandoOversigt(''lti''))\n');
                fprintf('4. Diff.ligninger (Brug: kommandoOversigt(''diff''))\n');
                fprintf('5. Hjælpefunkt.   (Brug: kommandoOversigt(''hjælp''))\n');
                return;
            end
            
            % Vis kommandooversigt afhængigt af kategori
            switch lower(kategori)
                case 'laplace'
                    fprintf('\n=== LAPLACE TRANSFORMATIONS FUNKTIONER ===\n');
                    fprintf('\n--- F = laplace(f, t, s) ---\n');
                    fprintf('Beregner Laplacetransformationen af f(t)\n');
                    
                    fprintf('\n--- f = inversLaplace(F, s, t) ---\n');
                    fprintf('Beregner den inverse Laplacetransformation af F(s)\n');
                    
                    fprintf('\n--- tabel = laplaceTransformationsTabel() ---\n');
                    fprintf('Viser en tabel over almindelige Laplacetransformationer\n');
                    
                    fprintf('\n--- [poles, zeros] = analyserLaplace(F) ---\n');
                    fprintf('Analyserer poler og nulpunkter i en Laplacetransformation\n');
                    
                case 'fourier'
                    fprintf('\n=== FOURIER FUNKTIONER ===\n');
                    
                    fprintf('\n--- [a0, an, bn] = fourierKoefficienter(f, T, n) ---\n');
                    fprintf('Beregner Fourier-koefficienter for en periodisk funktion\n');
                    
                    fprintf('\n--- visFourierRaekker(f, T, n) ---\n');
                    fprintf('Visualiserer Fourier-rækker for en periodisk funktion\n');
                    
                    fprintf('\n--- F = fourierTransform(f, t, omega) ---\n');
                    fprintf('Beregner Fourier-transformationen af f(t)\n');
                    
                    fprintf('\n--- visFrekvensspektrum(f, t_range) ---\n');
                    fprintf('Visualiserer amplitudespektrum og fasespektrum for en funktion\n');
                    
                case 'lti'
                    fprintf('\n=== LTI SYSTEM FUNKTIONER ===\n');
                    
                    fprintf('\n--- [num, den] = diffLigningTilOverfoeringsfunktion(b, a) ---\n');
                    fprintf('Konverterer diff.ligning til overføringsfunktion\n');
                    
                    fprintf('\n--- H = overfoer(num, den, s) ---\n');
                    fprintf('Evaluerer overføringsfunktionen ved værdi s\n');
                    
                    fprintf('\n--- [mag, phase] = bode(num, den, omega) ---\n');
                    fprintf('Beregner amplituderespons og faserespons ved frekvens omega\n');
                    
                    fprintf('\n--- visBodeDiagram(num, den, omega_range) ---\n');
                    fprintf('Visualiserer Bode-diagram for et LTI-system\n');
                    
                    fprintf('\n--- visImpulsrespons(num, den) ---\n');
                    fprintf('Visualiserer impulsrespons for et LTI-system\n');
                    
                    fprintf('\n--- [t, y] = beregnSteprespons(num, den, t_range) ---\n');
                    fprintf('Beregner steprespons for et LTI-system\n');
                    
                case 'diff'
                    fprintf('\n=== DIFFERENTIALLIGNING FUNKTIONER ===\n');
                    
                    fprintf('\n--- [t, y] = loesLineaerODE(a, f, init_cond, t_range) ---\n');
                    fprintf('Løser lineær diff.ligning med konstante koefficienter\n');
                    
                    fprintf('\n--- [partiel] = partielBroekopdeling(num, den) ---\n');
                    fprintf('Foretager partiel brøkopløsning af en rationel funktion\n');
                    
                    fprintf('\n--- analyserDifferentialligning(a) ---\n');
                    fprintf('Analyserer en differentialligning og klassificerer den\n');
                    
                case 'hjælp'
                    fprintf('\n=== HJÆLPEFUNKTIONER ===\n');
                    
                    fprintf('\n--- tekst = unicode_dansk(inputTekst) ---\n');
                    fprintf('Konverterer tekst med erstatninger til unicode-tegn for danske bogstaver\n');
                    
                    fprintf('\n--- demoProgrammet() ---\n');
                    fprintf('Viser brug af biblioteket med eksempler\n');
                    
                    fprintf('\n--- kommandoOversigt([kategori]) ---\n');
                    fprintf('Viser en oversigt over kommandoer og deres brug i ElektroMatBib\n');
                    
                otherwise
                    fprintf('\nUkendt kategori: %s\n', kategori);
                    fprintf('Gyldige kategorier: ''laplace'', ''fourier'', ''lti'', ''diff'', ''hjælp''\n');
            end
        end
        
        %% LAPLACE TRANSFORMATIONER %%
        
        function F = laplace(f, t, s)
            % Beregner Laplacetransformationen af f(t)
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            %   s - kompleks variabel (symbolsk)
            % Output:
            %   F - Laplacetransformationen F(s)
            
            % Brug MATLAB's symbolske motor til at beregne Laplace-transformationen
            if nargin < 3
                syms s;
            end
            
            if nargin < 2
                syms t;
            end
            
            F = laplace(f, t, s);
        end
        
        function f = inversLaplace(F, s, t)
            % Beregner den inverse Laplacetransformation af F(s)
            % Input:
            %   F - funktion af s (symbolsk)
            %   s - kompleks variabel (symbolsk)
            %   t - tidsvariabel (symbolsk)
            % Output:
            %   f - den oprindelige funktion f(t)
            
            % Brug MATLAB's symbolske motor til at beregne den inverse Laplace-transformation
            if nargin < 3
                syms t;
            end
            
            if nargin < 2
                syms s;
            end
            
            f = ilaplace(F, s, t);
        end
        
        function tabel = laplaceTransformationsTabel()
            % Viser en tabel over almindelige Laplacetransformationer
            
            % Definer tabellen over almindelige Laplace-transformationer
            tabel = {
                'f(t)', 'F(s)', 'Betingelser';
                '\delta(t)', '1', '';
                'u(t) (enhedstrin)', '1/s', 'Re(s) > 0';
                't^n', 'n!/s^(n+1)', 'Re(s) > 0, n ≥ 0 heltal';
                'e^(at)', '1/(s-a)', 'Re(s) > Re(a)';
                't*e^(at)', '1/(s-a)^2', 'Re(s) > Re(a)';
                'sin(at)', 'a/(s^2 + a^2)', 'Re(s) > 0';
                'cos(at)', 's/(s^2 + a^2)', 'Re(s) > 0';
                'e^(at)*sin(bt)', 'b/((s-a)^2 + b^2)', 'Re(s) > Re(a)';
                'e^(at)*cos(bt)', '(s-a)/((s-a)^2 + b^2)', 'Re(s) > Re(a)';
                't*sin(at)', '2as/(s^2 + a^2)^2', 'Re(s) > 0';
                't*cos(at)', 's^2 - a^2)/(s^2 + a^2)^2', 'Re(s) > 0';
                't^n*e^(at)', 'n!/(s-a)^(n+1)', 'Re(s) > Re(a), n ≥ 0 heltal';
            };
            
            % Vis tabellen
            disp('Laplace Transformations Tabel:');
            disp('-----------------------------------------------------------------------------------');
            fprintf('%-20s %-40s %-20s\n', 'f(t)', 'F(s)', 'Betingelser');
            disp('-----------------------------------------------------------------------------------');
            for i = 2:size(tabel, 1)
                fprintf('%-20s %-40s %-20s\n', tabel{i, 1}, tabel{i, 2}, tabel{i, 3});
            end
            disp('-----------------------------------------------------------------------------------');
        end
        
        function [poles, zeros] = analyserLaplace(F)
            % Analyserer poler og nulpunkter i en Laplacetransformation
            % Input:
            %   F - symbolsk udtryk for Laplacetransformationen F(s)
            % Output:
            %   poles - vector med polerne
            %   zeros - vektor med nulpunkterne
            
            syms s;
            
            % Konverter til brøk
            [num, den] = numden(F);
            
            % Find nulpunkter i tælleren
            zeros = solve(num == 0, s);
            
            % Find poler i nævneren
            poles = solve(den == 0, s);
            
            % Vis resultaterne
            fprintf('Analyse af F(s) = %s:\n', char(F));
            fprintf('Poler:\n');
            disp(poles);
            fprintf('Nulpunkter:\n');
            disp(zeros);
        end
        
        %% FOURIER RÆKKER OG TRANSFORMATION %%
        
        function [a0, an, bn] = fourierKoefficienter(f, T, n)
            % Beregner Fourier-koefficienter for en periodisk funktion
            % Input:
            %   f - funktion handle @(t) ...
            %   T - periode
            %   n - antal led i rækken (order)
            % Output:
            %   a0 - konstant led
            %   an - cosinus koefficienter [a1, a2, ..., an]
            %   bn - sinus koefficienter [b1, b2, ..., bn]
            
            % Grundfrekvens
            omega = 2*pi/T;
            
            % Numerisk integration for a0
            a0 = (2/T) * integral(@(t) f(t), 0, T/2);
            
            % Arrays til at holde koefficienter
            an = zeros(1, n);
            bn = zeros(1, n);
            
            % Beregn koefficienter for hvert led
            for k = 1:n
                an(k) = (2/T) * integral(@(t) f(t) .* cos(k*omega*t), 0, T);
                bn(k) = (2/T) * integral(@(t) f(t) .* sin(k*omega*t), 0, T);
            end
        end
        
        function visFourierRaekker(f, T, n)
            % Visualiserer Fourier-rækker for en periodisk funktion
            % Input:
            %   f - funktion handle @(t) ...
            %   T - periode
            %   n - antal led i rækken (order)
            
            % Beregn Fourier-koefficienter
            [a0, an, bn] = ElektroMatBib.fourierKoefficienter(f, T, n);
            
            % Grundfrekvens
            omega = 2*pi/T;
            
            % Definer Fourier-række funktion
            function y = fourierSeries(t, a0, an, bn, omega)
                y = a0 / 2;
                for k = 1:length(an)
                    y = y + an(k) * cos(k * omega * t) + bn(k) * sin(k * omega * t);
                end
            end
            
            % Definer tid-array for plotting - inkluder flere perioder
            t = linspace(-T, 2*T, 1000);
            
            % Beregn original funktion og Fourier-approksimationer
            y_exact = arrayfun(@(x) f(x), t);
            
            figure;
            
            % Plot original funktion
            plot(t, y_exact, 'k-', 'LineWidth', 2);
            hold on;
            
            % Plot Fourier-approksimationer med forskellige antal led
            colors = jet(n);
            approx_orders = round(linspace(1, n, min(5, n)));
            
            for i = 1:length(approx_orders)
                order = approx_orders(i);
                y_approx = arrayfun(@(x) fourierSeries(x, a0, an(1:order), bn(1:order), omega), t);
                plot(t, y_approx, 'LineWidth', 1.5, 'Color', colors(order,:));
            end
            
            grid on;
            xlabel('t');
            ylabel('f(t)');
            title(['Fourier-række approximationer (N = ' num2str(n) ')']);
            
            % Opret legend med korrekte navne
            legend_names = {'Original'};
            for i = 1:length(approx_orders)
                legend_names{end+1} = ['N = ' num2str(approx_orders(i))];
            end
            legend(legend_names, 'Location', 'best');
            
            % Vis også Fourier-koefficienter
            figure;
            
            % Plot an koefficienter
            subplot(2, 1, 1);
            stem(0:n, [a0/2, an], 'filled');
            grid on;
            xlabel('n');
            ylabel('a_n');
            title('Cosinus koefficienter');
            
            % Plot bn koefficienter
            subplot(2, 1, 2);
            stem(1:n, bn, 'filled');
            grid on;
            xlabel('n');
            ylabel('b_n');
            title('Sinus koefficienter');
        end
        
        function F = fourierTransform(f, t, omega)
            % Beregner Fourier-transformationen af f(t)
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            %   omega - frekvens variabel (symbolsk)
            % Output:
            %   F - Fourier-transformationen F(omega)
            
            % Brug MATLAB's symbolske motor til at beregne Fourier-transformationen
            if nargin < 3
                syms omega;
            end
            
            if nargin < 2
                syms t;
            end
            
            F = fourier(f, t, omega);
        end
        
        function visFrekvensspektrum(f, t_range)
            % Visualiserer amplitudespektrum og fasespektrum for en funktion
            % Input:
            %   f - funktion handle @(t) ...
            %   t_range - [t_min, t_max] tidsinterval
            
            % Diskretiser funktionen
            Fs = 1000;  % Samplingsfrekvens
            dt = 1/Fs;
            t = t_range(1):dt:t_range(2);
            x = arrayfun(f, t);
            
            % Beregn FFT
            N = length(x);
            X = fft(x);
            
            % Frekvensakse (positiv side)
            freq = (0:N/2) * Fs / N;
            
            % Tag kun den første halvdel af frekvenserne (Nyquist)
            X_half = X(1:length(freq));
            
            % Beregn amplitude og fase
            amplitude = abs(X_half) / N;
            phase = angle(X_half);
            
            % Plot amplitude og fase
            figure;
            
            % Amplitudespektrum
            subplot(2, 1, 1);
            plot(freq, amplitude);
            grid on;
            xlabel('Frekvens (Hz)');
            ylabel('Amplitude');
            title('Amplitudespektrum');
            
            % Fasespektrum
            subplot(2, 1, 2);
            plot(freq, phase);
            grid on;
            xlabel('Frekvens (Hz)');
            ylabel('Fase (radianer)');
            title('Fasespektrum');
        end
        
        %% LTI SYSTEM FUNKTIONER %%
        
        function [num, den] = diffLigningTilOverfoeringsfunktion(b, a)
            % Konverterer differentialligning til overføringsfunktion
            % Input:
            %   b - koefficienter for input [b_m, b_{m-1}, ..., b_0]
            %   a - koefficienter for output [a_n, a_{n-1}, ..., a_0]
            % Output:
            %   num - tæller polynomium
            %   den - nævner polynomium
            
            % Sørg for at a og b har korrekt format
            if isempty(a) || a(1) == 0
                error('Koefficienten a_n må ikke være 0');
            end
            
            % Normaliser så højeste koefficient i a er 1
            if a(1) ~= 1
                b = b / a(1);
                a = a / a(1);
            end
            
            % Returner tæller og nævner
            num = b;
            den = a;
        end
        
        function H = overfoer(num, den, s)
            % Evaluerer overføringsfunktionen ved værdi s
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   s - komplex værdi eller array af værdier
            % Output:
            %   H - overføringsfunktionsværdi(er)
            
            % Evaluer polynomier
            H = polyval(num, s) ./ polyval(den, s);
        end
        
        function [mag, phase] = bode(num, den, omega)
            % Beregner amplituderespons og faserespons ved frekvens omega
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   omega - frekvens i rad/s
            % Output:
            %   mag - amplituderespons
            %   phase - faserespons i radianer
            
            % Evaluer overføringsfunktion ved s = j*omega
            s = 1j * omega;
            H = ElektroMatBib.overfoer(num, den, s);
            
            % Beregn amplitude og fase
            mag = abs(H);
            phase = angle(H);
        end
        
        function visBodeDiagram(num, den, omega_range)
            % Visualiserer Bode-diagram for et LTI-system
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   omega_range - [omega_min, omega_max] frekvensinterval
            
            % Genererer frekvensakse (logaritmisk)
            omega = logspace(log10(omega_range(1)), log10(omega_range(2)), 1000);
            
            % Beregn amplitude og fase
            [mag, phase] = ElektroMatBib.bode(num, den, omega);
            
            % Konverter amplitude til dB
            mag_db = 20 * log10(mag);
            
            % Konverter fase til grader
            phase_deg = phase * 180 / pi;
            
            % Plot Bode-diagram
            figure;
            
            % Amplituderespons
            subplot(2, 1, 1);
            semilogx(omega, mag_db);
            grid on;
            xlabel('Frekvens (rad/s)');
            ylabel('Amplitude (dB)');
            title('Bodediagram - Amplituderespons');
            
            % Faserespons
            subplot(2, 1, 2);
            semilogx(omega, phase_deg);
            grid on;
            xlabel('Frekvens (rad/s)');
            ylabel('Fase (grader)');
            title('Bodediagram - Faserespons');
        end
        
        function visImpulsrespons(num, den)
            % Visualiserer impulsrespons for et LTI-system
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            
            % Skab et impuls system
            sys = tf(num, den);
            
            % Definer tidsinterval baseret på systemets tidskonstant
            p = roots(den);
            tau = -1 / max(real(p(real(p) < 0)));
            t_max = min(10 * tau, 100);  % Maks tid er 10 gange tidskonstanten eller 100, hvad end er mindst
            
            % Brug MATLAB's impulsrespons funktion
            figure;
            impulse(sys, [0 t_max]);
            grid on;
            title('Impulsrespons');
        end
        
        function [t, y] = beregnSteprespons(num, den, t_range)
            % Beregner steprespons for et LTI-system
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   t_range - [t_min, t_max] tidsinterval
            % Output:
            %   t - tidsvektor
            %   y - steprespons
            
            % Skab et system
            sys = tf(num, den);
            
            % Brug MATLAB's steprespons funktion
            [y, t] = step(sys, t_range);
            
            % Plot stepresponsen
            figure;
            plot(t, y);
            grid on;
            xlabel('Tid');
            ylabel('Amplitude');
            title('Steprespons');
        end
        
        function visPolynomBroek(num, den)
            % Visualiserer et polynomium i brøkform
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            
            syms s;
            
            % Konverter polynomier til symbolske udtryk
            num_sym = poly2sym(num, s);
            den_sym = poly2sym(den, s);
            
            % Vis som brøk
            disp(num_sym / den_sym);
        end
        
        %% DIFFERENTIALLIGNING FUNKTIONER %%
        
        function [t, y] = loesLineaerODE(a, f, init_cond, t_range)
            % Løser lineær differentialligning med konstante koefficienter
            % a_n*y^(n) + ... + a_1*y' + a_0*y = f(t)
            % Input:
            %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
            %   f - funktion handle @(t) eller 0 for homogen ligning
            %   init_cond - begyndelsesbetingelser [y(0), y'(0), ..., y^(n-1)(0)]
            %   t_range - [t_min, t_max] tidsinterval
            % Output:
            %   t - tidsvektor
            %   y - løsningsvektor (første søjle er y, anden søjle er y', osv.)
            
            % Orden af differentialligningen
            n = length(a) - 1;
            
            % Konverter til system af førsteordens differentialligninger
            A = zeros(n);
            for i = 1:n-1
                A(i, i+1) = 1;
            end
            A(n, :) = -a(n+1:-1:2) / a(1);
            
            B = zeros(n, 1);
            B(n) = 1 / a(1);
            
            % Definer ODE-funktion
            if isnumeric(f) && f == 0
                % Homogen ligning
                odefun = @(t, y) A * y;
            else
                % Inhomogen ligning
                odefun = @(t, y) A * y + B * f(t);
            end
            
            % Løs systemet
            [t, Y] = ode45(odefun, t_range, init_cond);
            y = Y;
        end
        
        function [partiel] = partielBroekopdeling(num, den)
            % Foretager partiel brøkopløsning af en rationel funktion
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            % Output:
            %   partiel - cell array med delbrøker
            
            syms s;
            
            % Konverter polynomier til symbolske udtryk
            num_sym = poly2sym(num, s);
            den_sym = poly2sym(den, s);
            
            % Udfør partiel brøkopløsning
            [r, p, k] = residue(num, den);
            
            % Vis resultatet
            fprintf('Partiel brøkopløsning af: \n');
            disp(num_sym / den_sym);
            fprintf('giver: \n');
            
            partiel = cell(length(r), 1);
            
            % Opret symbolsk udtryk for hver delbrøk
            expr = 0;
            for i = 1:length(r)
                if imag(p(i)) == 0
                    % Reelt pol
                    term = r(i) / (s - p(i));
                    partiel{i} = term;
                    expr = expr + term;
                    fprintf('  %s\n', char(term));
                elseif i < length(r) && p(i) == conj(p(i+1))
                    % Komplekst polpar - håndter begge poler samtidigt
                    a = real(r(i));
                    b = imag(r(i));
                    alpha = real(p(i));
                    beta = imag(p(i));
                    
                    term = 2*(a*(s-alpha) + b*beta) / ((s-alpha)^2 + beta^2);
                    partiel{i} = term;
                    expr = expr + term;
                    fprintf('  %s\n', char(term));
                    
                    % Spring over det konjugerede pol
                    i = i + 1;
                end
            end
            
            % Tilføj polynom del hvis der er en
            if ~isempty(k)
                poly_part = poly2sym(k, s);
                expr = expr + poly_part;
                fprintf('  %s\n', char(poly_part));
                partiel{end+1} = poly_part;
            end
            
            fprintf('\nSamlet udtryk:\n');
            disp(expr);
        end
        
        function analyserDifferentialligning(a)
            % Analyserer en differentialligning og klassificerer den
            % Input:
            %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
            
            % Find rødder i det karakteristiske polynomium
            p = roots(a);
            
            % Vis rødderne
            disp('Rødder i det karakteristiske polynomium:');
            for i = 1:length(p)
                if imag(p(i)) == 0
                    fprintf('  λ_%d = %g (reel)\n', i, p(i));
                else
                    fprintf('  λ_%d = %g + %gi (kompleks)\n', i, real(p(i)), imag(p(i)));
                end
            end
            
            % Klassificer løsningstypen for andenordens ligning
            if length(a) == 3
                discriminant = a(2)^2 - 4*a(1)*a(3);
                
                if discriminant > 0
                    disp('Dette er en overdæmpet løsning (reelle forskellige rødder).');
                elseif discriminant == 0
                    disp('Dette er en kritisk dæmpet løsning (dobbeltrod).');
                else
                    disp('Dette er en underdæmpet løsning (komplekse rødder).');
                    
                    % Beregn dæmpningsforhold og naturlig frekvens
                    zeta = -a(2) / (2 * sqrt(a(1) * a(3)));
                    omega_n = sqrt(a(3) / a(1));
                    fprintf('  Dæmpningsforhold: ζ = %g\n', zeta);
                    fprintf('  Naturlig frekvens: ω_n = %g rad/s\n', omega_n);
                end
            end
        end
    end
end