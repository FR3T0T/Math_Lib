% ElektroMatBib.m - MATLAB Matematisk Bibliotek specifikt lavet til DTU Kursus: 62735 Videregående Matematik for Diplom Elektroteknologi
%
% Dette bibliotek giver praktiske funktioner til at løse opgaver indenfor:
% - Laplace transformation
% - Fourier transformation og rækker
% - Lineære tidsinvariante systemer
% - Differentialligninger
%
% Forfatter: Frederik Tots
% Version: 1.0
% Dato: 2/4/2025

classdef ElektroMatBib
    methods(Static)
        %% HJÆLPEFUNKTIONER %%
        
        function tekst = unicode_dansk(inputTekst)
            % UNICODE_DANSK Konverterer mellem almindelige erstatninger og unicode for danske tegn
            %
            % Syntax:
            %   tekst = ElektroMatBib.unicode_dansk(inputTekst)
            %
            % Input:
            %   inputTekst - Tekst med erstatninger ('ae', 'oe', 'aa', etc.)
            % 
            % Output:
            %   tekst - Tekst med unicode-tegn ('æ', 'ø', 'å', etc.)
            %
            % Eksempel:
            %   s = ElektroMatBib.unicode_dansk('loes differentialligning')
            %   % Resultat: "løs differentialligning"
            
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
            % DEMOPROGRAMMET Viser brug af biblioteket med eksempler
            %
            % Syntax:
            %   ElektroMatBib.demoProgrammet()
            %
            % Denne funktion viser eksempler på de vigtigste funktioner i biblioteket
            
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
            try
                T = 2*pi;
                % Vis en periodisk signal og dens Fourier-rækker (grafisk)
                ElektroMatBib.visFourierRaekker(@(t) square(t), T, 10);
                fprintf('Fourierrækker beregnet og visualiseret.\n');
            catch e
                fprintf('Kunne ikke vise Fourier-rækker demo: %s\n', e.message);
            end
            fprintf('\n');
            
            % Demo af LTI system
            fprintf('4. LTI SYSTEM DEMO:\n');
            % Differentialligning: y'' + 0.5y' + 2y = x(t)
            a = [1 0.5 2];  % koefficienter: a_n, a_{n-1}, ..., a_0
            b = [1];        % koefficienter: b_m, b_{m-1}, ..., b_0
            [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a);
            fprintf('Overføringsfunktion H(s) = \n');
            ElektroMatBib.visPolynomBroek(num, den);
            fprintf('\n');
            
            % Vis impulsrespons grafisk
            try
                ElektroMatBib.visImpulsrespons(num, den);
                fprintf('Impulsrespons visualiseret.\n');
            catch e
                fprintf('Kunne ikke vise impulsrespons: %s\n', e.message);
            end
            
            % Løs en komplet opgave
            fprintf('\n5. KOMPLET OPGAVELØSNING DEMO:\n');
            fprintf('Opgave: Analyser et andenordens LTI-system med differentialligningen:\n');
            fprintf('y'''' + 0.5y'' + 2y = x(t)\n');
            fprintf('Find systemets overføringsfunktion, poler, impulsrespons og steprespons\n\n');
            
            % Vis overføringsfunktionen i brøkform
            fprintf('Overføringsfunktion:\n');
            ElektroMatBib.visPolynomBroek(num, den);
            
            % Analyser differentialligningen
            fprintf('\nAnalyse af systemet:\n');
            ElektroMatBib.analyserDifferentialligning(a);
            
            % Analyser overføringsfunktionen (find poler og nulpunkter)
            try
                syms s;
                F = poly2sym(num, s) / poly2sym(den, s);
                [poles, zeros] = ElektroMatBib.analyserLaplace(F);
            catch e
                fprintf('Kunne ikke analysere overføringsfunktionen: %s\n', e.message);
            end
            
            % Vis steprespons
            try
                fprintf('\nBeregner og plotter steprespons:\n');
                [t, y] = ElektroMatBib.beregnSteprespons(num, den, [0, 10]);
                fprintf('Steprespons visualiseret.\n');
            catch e
                fprintf('Kunne ikke beregne steprespons: %s\n', e.message);
            end
            
            % Vis Bode-diagram
            try
                fprintf('\nViser Bode-diagram:\n');
                ElektroMatBib.visBodeDiagram(num, den, [0.1, 100]);
                fprintf('Bode-diagram visualiseret.\n');
            catch e
                fprintf('Kunne ikke vise Bode-diagram: %s\n', e.message);
            end
        end

        function kommandoOversigt(kategori)
            % KOMMANDOOVERSIGT Viser en oversigt over kommandoer og deres brug i ElektroMatBib
            %
            % Syntax:
            %   ElektroMatBib.kommandoOversigt()             % viser hovedmenuen
            %   ElektroMatBib.kommandoOversigt('laplace')    % viser laplace funktioner
            %   ElektroMatBib.kommandoOversigt('fourier')    % viser fourier funktioner
            %   ElektroMatBib.kommandoOversigt('lti')        % viser LTI funktioner
            %   ElektroMatBib.kommandoOversigt('diff')       % viser differentialligning funktioner
            %   ElektroMatBib.kommandoOversigt('hjælp')      % viser hjælpefunktioner
            %
            % Input:
            %   kategori (valgfri) - specificerer en bestemt kategori at vise
            %   Options: 'laplace', 'fourier', 'lti', 'diff', 'hjælp'
            
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
                    fprintf('Syntax:\n');
                    fprintf('  F = ElektroMatBib.laplace(f)         %% Bruger symbolske variable t og s\n');
                    fprintf('  F = ElektroMatBib.laplace(f, t)      %% Bruger symbolsk variabel s\n');
                    fprintf('  F = ElektroMatBib.laplace(f, t, s)   %% Specificerer både t og s\n');
                    fprintf('Eksempel:\n');
                    fprintf('  syms t s\n');
                    fprintf('  f = exp(-2*t);\n');
                    fprintf('  F = ElektroMatBib.laplace(f, t, s)   %% Resultat: 1/(s+2)\n');
                    
                    fprintf('\n--- f = inversLaplace(F, s, t) ---\n');
                    fprintf('Beregner den inverse Laplacetransformation af F(s)\n');
                    fprintf('Syntax:\n');
                    fprintf('  f = ElektroMatBib.inversLaplace(F)         %% Bruger symbolske variable s og t\n');
                    fprintf('  f = ElektroMatBib.inversLaplace(F, s)      %% Bruger symbolsk variabel t\n');
                    fprintf('  f = ElektroMatBib.inversLaplace(F, s, t)   %% Specificerer både s og t\n');
                    fprintf('Eksempel:\n');
                    fprintf('  syms s t\n');
                    fprintf('  F = 1/(s^2 + 4);\n');
                    fprintf('  f = ElektroMatBib.inversLaplace(F, s, t)   %% Resultat: (1/2)*sin(2*t)\n');
                    
                    fprintf('\n--- tabel = laplaceTransformationsTabel() ---\n');
                    fprintf('Viser en tabel over almindelige Laplacetransformationer\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.laplaceTransformationsTabel()\n');
                    
                    fprintf('\n--- [poles, zeros] = analyserLaplace(F) ---\n');
                    fprintf('Analyserer poler og nulpunkter i en Laplacetransformation\n');
                    fprintf('Syntax:\n');
                    fprintf('  [poles, zeros] = ElektroMatBib.analyserLaplace(F)   %% F er et symbolsk udtryk\n');
                    fprintf('Eksempel:\n');
                    fprintf('  syms s\n');
                    fprintf('  F = (s+1)/((s+2)*(s^2+4));\n');
                    fprintf('  [poles, zeros] = ElektroMatBib.analyserLaplace(F)\n');
                    
                case 'fourier'
                    fprintf('\n=== FOURIER FUNKTIONER ===\n');
                    
                    fprintf('\n--- [a0, an, bn] = fourierKoefficienter(f, T, n) ---\n');
                    fprintf('Beregner Fourier-koefficienter for en periodisk funktion\n');
                    fprintf('Syntax:\n');
                    fprintf('  [a0, an, bn] = ElektroMatBib.fourierKoefficienter(f, T, n)\n');
                    fprintf('Input:\n');
                    fprintf('  f - funktion handle @(t) ...\n');
                    fprintf('  T - periode\n');
                    fprintf('  n - antal led i rækken\n');
                    fprintf('Eksempel:\n');
                    fprintf('  f = @(t) square(t);  %% Firkantsignal\n');
                    fprintf('  T = 2*pi;\n');
                    fprintf('  n = 10;\n');
                    fprintf('  [a0, an, bn] = ElektroMatBib.fourierKoefficienter(f, T, n)\n');
                    
                    fprintf('\n--- visFourierRaekker(f, T, n) ---\n');
                    fprintf('Visualiserer Fourier-rækker for en periodisk funktion\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.visFourierRaekker(f, T, n)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  f = @(t) square(t);\n');
                    fprintf('  T = 2*pi;\n');
                    fprintf('  n = 20;\n');
                    fprintf('  ElektroMatBib.visFourierRaekker(f, T, n)\n');
                    
                    fprintf('\n--- F = fourierTransform(f, t, omega) ---\n');
                    fprintf('Beregner Fourier-transformationen af f(t)\n');
                    fprintf('Syntax:\n');
                    fprintf('  F = ElektroMatBib.fourierTransform(f, t, omega)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  syms t omega\n');
                    fprintf('  f = exp(-abs(t));\n');
                    fprintf('  F = ElektroMatBib.fourierTransform(f, t, omega)\n');
                    
                    fprintf('\n--- visFrekvensspektrum(f, t_range) ---\n');
                    fprintf('Visualiserer amplitudespektrum og fasespektrum for en funktion\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.visFrekvensspektrum(f, [t_min, t_max])\n');
                    fprintf('Eksempel:\n');
                    fprintf('  f = @(t) exp(-t).*sin(2*pi*5*t).*(t>=0);\n');
                    fprintf('  ElektroMatBib.visFrekvensspektrum(f, [0, 2])\n');
                    
                case 'lti'
                    fprintf('\n=== LTI SYSTEM FUNKTIONER ===\n');
                    
                    fprintf('\n--- [num, den] = diffLigningTilOverfoeringsfunktion(b, a) ---\n');
                    fprintf('Konverterer differentialligning til overføringsfunktion\n');
                    fprintf('Syntax:\n');
                    fprintf('  [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a)\n');
                    fprintf('Input:\n');
                    fprintf('  b - koefficienter for input [b_m, b_{m-1}, ..., b_0]\n');
                    fprintf('  a - koefficienter for output [a_n, a_{n-1}, ..., a_0]\n');
                    fprintf('Eksempel:\n');
                    fprintf('  %% y'''' + 0.5y'' + 2y = x(t)\n');
                    fprintf('  a = [1 0.5 2];\n');
                    fprintf('  b = [1];\n');
                    fprintf('  [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a)\n');
                    
                    fprintf('\n--- H = overfoer(num, den, s) ---\n');
                    fprintf('Evaluerer overføringsfunktionen ved værdi s\n');
                    fprintf('Syntax:\n');
                    fprintf('  H = ElektroMatBib.overfoer(num, den, s)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1];\n');
                    fprintf('  den = [1 0.5 2];\n');
                    fprintf('  H = ElektroMatBib.overfoer(num, den, 1i)   %% Evaluerer ved s = i\n');
                    
                    fprintf('\n--- [mag, phase] = bode(num, den, omega) ---\n');
                    fprintf('Beregner amplituderespons og faserespons ved frekvens omega\n');
                    fprintf('Syntax:\n');
                    fprintf('  [mag, phase] = ElektroMatBib.bode(num, den, omega)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1];\n');
                    fprintf('  den = [1 0.5 2];\n');
                    fprintf('  [mag, phase] = ElektroMatBib.bode(num, den, 2)\n');
                    fprintf('  %% Konverter til dB: mag_db = 20*log10(mag)\n');
                    fprintf('  %% Konverter til grader: phase_deg = phase*180/pi\n');
                    
                    fprintf('\n--- visBodeDiagram(num, den, omega_range) ---\n');
                    fprintf('Visualiserer Bode-diagram for et LTI-system\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.visBodeDiagram(num, den, [omega_min, omega_max])\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1];\n');
                    fprintf('  den = [1 0.5 2];\n');
                    fprintf('  ElektroMatBib.visBodeDiagram(num, den, [0.1, 100])\n');
                    
                    fprintf('\n--- visImpulsrespons(num, den) ---\n');
                    fprintf('Visualiserer impulsrespons for et LTI-system\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.visImpulsrespons(num, den)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1];\n');
                    fprintf('  den = [1 0.5 2];\n');
                    fprintf('  ElektroMatBib.visImpulsrespons(num, den)\n');
                    
                    fprintf('\n--- [t, y] = beregnSteprespons(num, den, t_range) ---\n');
                    fprintf('Beregner steprespons for et LTI-system\n');
                    fprintf('Syntax:\n');
                    fprintf('  [t, y] = ElektroMatBib.beregnSteprespons(num, den, [t_min, t_max])\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1];\n');
                    fprintf('  den = [1 0.5 2];\n');
                    fprintf('  [t, y] = ElektroMatBib.beregnSteprespons(num, den, [0, 10])\n');
                    
                case 'diff'
                    fprintf('\n=== DIFFERENTIALLIGNING FUNKTIONER ===\n');
                    
                    fprintf('\n--- [t, y] = loesLineaerODE(a, f, init_cond, t_range) ---\n');
                    fprintf('Løser lineær differentialligning med konstante koefficienter\n');
                    fprintf('Syntax:\n');
                    fprintf('  [t, y] = ElektroMatBib.loesLineaerODE(a, f, init_cond, [t_min, t_max])\n');
                    fprintf('Input:\n');
                    fprintf('  a - koefficienter [a_n, a_{n-1}, ..., a_0]\n');
                    fprintf('  f - funktion handle @(t) eller 0 for homogen ligning\n');
                    fprintf('  init_cond - begyndelsesbetingelser [y(0), y''(0), ..., y^(n-1)(0)]\n');
                    fprintf('Eksempel:\n');
                    fprintf('  %% Løs y'''' + 0.5y'' + 2y = 0 med y(0)=1, y''(0)=0\n');
                    fprintf('  a = [1 0.5 2];\n');
                    fprintf('  f = 0;  %% homogen ligning\n');
                    fprintf('  init_cond = [1; 0];\n');
                    fprintf('  [t, y] = ElektroMatBib.loesLineaerODE(a, f, init_cond, [0, 10])\n');
                    
                    fprintf('\n--- [partiel] = partielBroekopdeling(num, den) ---\n');
                    fprintf('Foretager partiel brøkopløsning af en rationel funktion\n');
                    fprintf('Syntax:\n');
                    fprintf('  [partiel] = ElektroMatBib.partielBroekopdeling(num, den)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1 0];\n');
                    fprintf('  den = [1 3 2];  %% s^2 + 3s + 2 = (s+1)(s+2)\n');
                    fprintf('  ElektroMatBib.partielBroekopdeling(num, den)\n');
                    
                    fprintf('\n--- analyserDifferentialligning(a) ---\n');
                    fprintf('Analyserer en differentialligning og klassificerer den\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.analyserDifferentialligning(a)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  %% Analyser y'''' + 0.5y'' + 2y = 0\n');
                    fprintf('  a = [1 0.5 2];\n');
                    fprintf('  ElektroMatBib.analyserDifferentialligning(a)\n');
                    
                case 'hjælp'
                    fprintf('\n=== HJÆLPEFUNKTIONER ===\n');
                    
                    fprintf('\n--- tekst = unicode_dansk(inputTekst) ---\n');
                    fprintf('Konverterer tekst med erstatninger til unicode-tegn for danske bogstaver\n');
                    fprintf('Syntax:\n');
                    fprintf('  tekst = ElektroMatBib.unicode_dansk(inputTekst)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  s = ElektroMatBib.unicode_dansk(''loes differentialligning'')\n');
                    fprintf('  %% Resultat: "løs differentialligning"\n');
                    
                    fprintf('\n--- demoProgrammet() ---\n');
                    fprintf('Viser brug af biblioteket med eksempler\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.demoProgrammet()\n');
                    
                    fprintf('\n--- kommandoOversigt([kategori]) ---\n');
                    fprintf('Viser en oversigt over kommandoer og deres brug i ElektroMatBib\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.kommandoOversigt()             %% viser hovedmenuen\n');
                    fprintf('  ElektroMatBib.kommandoOversigt(''laplace'')    %% viser laplace funktioner\n');
                    fprintf('  ElektroMatBib.kommandoOversigt(''fourier'')    %% viser fourier funktioner\n');
                    fprintf('  ElektroMatBib.kommandoOversigt(''lti'')        %% viser LTI funktioner\n');
                    fprintf('  ElektroMatBib.kommandoOversigt(''diff'')       %% viser differentialligning funktioner\n');
                    fprintf('  ElektroMatBib.kommandoOversigt(''hjælp'')      %% viser hjælpefunktioner\n');
                    
                    fprintf('\n--- visPolynomBroek(num, den) ---\n');
                    fprintf('Visualiserer et polynomium i brøkform\n');
                    fprintf('Syntax:\n');
                    fprintf('  ElektroMatBib.visPolynomBroek(num, den)\n');
                    fprintf('Eksempel:\n');
                    fprintf('  num = [1 2];  %% s + 2\n');
                    fprintf('  den = [1 3 2];  %% s^2 + 3s + 2\n');
                    fprintf('  ElektroMatBib.visPolynomBroek(num, den)\n');
                    
                otherwise
                    fprintf('\nUkendt kategori: %s\n', kategori);
                    fprintf('Gyldige kategorier: ''laplace'', ''fourier'', ''lti'', ''diff'', ''hjælp''\n');
                    fprintf('Prøv igen med en gyldig kategori eller kald kommandoOversigt() uden argumenter\n');
            end
        end
        
        %% LAPLACE TRANSFORMATIONER %%
        
        function F = laplace(f, t, s)
            % LAPLACE Beregner Laplacetransformationen af f(t)
            %
            % Syntax:
            %   F = ElektroMatBib.laplace(f)         % Bruger symbolske variable t og s
            %   F = ElektroMatBib.laplace(f, t)      % Bruger symbolsk variabel s
            %   F = ElektroMatBib.laplace(f, t, s)   % Specificerer både t og s
            %
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            %   s - kompleks variabel (symbolsk)
            % 
            % Output:
            %   F - Laplacetransformationen F(s)
            %
            % Eksempel:
            %   syms t s
            %   f = exp(-2*t);
            %   F = ElektroMatBib.laplace(f, t, s)   % Resultat: 1/(s+2)
            
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
            % INVERSLAPLACE Beregner den inverse Laplacetransformation af F(s)
            %
            % Syntax:
            %   f = ElektroMatBib.inversLaplace(F)         % Bruger symbolske variable s og t
            %   f = ElektroMatBib.inversLaplace(F, s)      % Bruger symbolsk variabel t
            %   f = ElektroMatBib.inversLaplace(F, s, t)   % Specificerer både s og t
            %
            % Input:
            %   F - funktion af s (symbolsk)
            %   s - kompleks variabel (symbolsk)
            %   t - tidsvariabel (symbolsk)
            % 
            % Output:
            %   f - den oprindelige funktion f(t)
            %
            % Eksempel:
            %   syms s t
            %   F = 1/(s^2 + 4);
            %   f = ElektroMatBib.inversLaplace(F, s, t)   % Resultat: (1/2)*sin(2*t)
            
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
            % LAPLACETRANSFORMATIONSTABEL Viser en tabel over almindelige Laplacetransformationer
            %
            % Syntax:
            %   ElektroMatBib.laplaceTransformationsTabel()
            %
            % Denne funktion viser en tabel over almindelige Laplacetransformationer
            % og deres betingelser for gyldighed.
            
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
                't*cos(at)', '(s^2 - a^2)/(s^2 + a^2)^2', 'Re(s) > 0';
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
            % ANALYSERLAPLACE Analyserer poler og nulpunkter i en Laplacetransformation
            %
            % Syntax:
            %   [poles, zeros] = ElektroMatBib.analyserLaplace(F)
            %
            % Input:
            %   F - symbolsk udtryk for Laplacetransformationen F(s)
            % 
            % Output:
            %   poles - vector med polerne
            %   zeros - vektor med nulpunkterne
            %
            % Eksempel:
            %   syms s
            %   F = (s+1)/((s+2)*(s^2+4));
            %   [poles, zeros] = ElektroMatBib.analyserLaplace(F)
            
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
            % FOURIERKOEFFICIENTER Beregner Fourier-koefficienter for en periodisk funktion
            %
            % Syntax:
            %   [a0, an, bn] = ElektroMatBib.fourierKoefficienter(f, T, n)
            %
            % Input:
            %   f - funktion handle @(t) ...
            %   T - periode
            %   n - antal led i rækken (order)
            % 
            % Output:
            %   a0 - konstant led
            %   an - cosinus koefficienter [a1, a2, ..., an]
            %   bn - sinus koefficienter [b1, b2, ..., bn]
            %
            % Eksempel:
            %   f = @(t) square(t);  % Firkantsignal
            %   T = 2*pi;
            %   n = 10;
            %   [a0, an, bn] = ElektroMatBib.fourierKoefficienter(f, T, n)
            
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
            % VISFOURIERRAEKKER Visualiserer Fourier-rækker for en periodisk funktion
            %
            % Syntax:
            %   ElektroMatBib.visFourierRaekker(f, T, n)
            %
            % Input:
            %   f - funktion handle @(t) ...
            %   T - periode
            %   n - antal led i rækken (order)
            %
            % Eksempel:
            %   f = @(t) square(t);
            %   T = 2*pi;
            %   n = 20;
            %   ElektroMatBib.visFourierRaekker(f, T, n)
            
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
            % FOURIERTRANSFORM Beregner Fourier-transformationen af f(t)
            %
            % Syntax:
            %   F = ElektroMatBib.fourierTransform(f, t, omega)
            %
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            %   omega - frekvens variabel (symbolsk)
            % 
            % Output:
            %   F - Fourier-transformationen F(omega)
            %
            % Eksempel:
            %   syms t omega
            %   f = exp(-abs(t));
            %   F = ElektroMatBib.fourierTransform(f, t, omega)
            
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
            % VISFREKVENSSPEKTRUM Visualiserer amplitudespektrum og fasespektrum for en funktion
            %
            % Syntax:
            %   ElektroMatBib.visFrekvensspektrum(f, [t_min, t_max])
            %
            % Input:
            %   f - funktion handle @(t) ...
            %   t_range - [t_min, t_max] tidsinterval
            %
            % Eksempel:
            %   f = @(t) exp(-t).*sin(2*pi*5*t).*(t>=0);
            %   ElektroMatBib.visFrekvensspektrum(f, [0, 2])
            
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
            % DIFFLIGNINGTILOVERFØRINGSFUNKTION Konverterer differentialligning til overføringsfunktion
            %
            % Syntax:
            %   [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a)
            %
            % Input:
            %   b - koefficienter for input [b_m, b_{m-1}, ..., b_0]
            %   a - koefficienter for output [a_n, a_{n-1}, ..., a_0]
            % 
            % Output:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %
            % Eksempel:
            %   % y'' + 0.5y' + 2y = x(t)
            %   a = [1 0.5 2];
            %   b = [1];
            %   [num, den] = ElektroMatBib.diffLigningTilOverfoeringsfunktion(b, a)
            
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
            % OVERFOER Evaluerer overføringsfunktionen ved værdi s
            %
            % Syntax:
            %   H = ElektroMatBib.overfoer(num, den, s)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   s - komplex værdi eller array af værdier
            % 
            % Output:
            %   H - overføringsfunktionsværdi(er)
            %
            % Eksempel:
            %   num = [1];
            %   den = [1 0.5 2];
            %   H = ElektroMatBib.overfoer(num, den, 1i)   % Evaluerer ved s = i
            
            % Evaluer polynomier
            H = polyval(num, s) ./ polyval(den, s);
        end
        
        function [mag, phase] = bode(num, den, omega)
            % BODE Beregner amplituderespons og faserespons ved frekvens omega
            %
            % Syntax:
            %   [mag, phase] = ElektroMatBib.bode(num, den, omega)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   omega - frekvens i rad/s
            % 
            % Output:
            %   mag - amplituderespons
            %   phase - faserespons i radianer
            %
            % Eksempel:
            %   num = [1];
            %   den = [1 0.5 2];
            %   [mag, phase] = ElektroMatBib.bode(num, den, 2)
            %   % Konverter til dB: mag_db = 20*log10(mag)
            %   % Konverter til grader: phase_deg = phase*180/pi
            
            % Evaluer overføringsfunktion ved s = j*omega
            s = 1j * omega;
            H = ElektroMatBib.overfoer(num, den, s);
            
            % Beregn amplitude og fase
            mag = abs(H);
            phase = angle(H);
        end
        
        function visBodeDiagram(num, den, omega_range)
            % VISBODEDIAGRAM Visualiserer Bode-diagram for et LTI-system
            %
            % Syntax:
            %   ElektroMatBib.visBodeDiagram(num, den, [omega_min, omega_max])
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   omega_range - [omega_min, omega_max] frekvensinterval
            %
            % Eksempel:
            %   num = [1];
            %   den = [1 0.5 2];
            %   ElektroMatBib.visBodeDiagram(num, den, [0.1, 100])
            
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
            % VISIMPULSRESPONS Visualiserer impulsrespons for et LTI-system
            %
            % Syntax:
            %   ElektroMatBib.visImpulsrespons(num, den)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %
            % Eksempel:
            %   num = [1];
            %   den = [1 0.5 2];
            %   ElektroMatBib.visImpulsrespons(num, den)
            
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
            % BEREGNSTEPRESPONS Beregner steprespons for et LTI-system
            %
            % Syntax:
            %   [t, y] = ElektroMatBib.beregnSteprespons(num, den, [t_min, t_max])
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   t_range - [t_min, t_max] tidsinterval
            % 
            % Output:
            %   t - tidsvektor
            %   y - steprespons
            %
            % Eksempel:
            %   num = [1];
            %   den = [1 0.5 2];
            %   [t, y] = ElektroMatBib.beregnSteprespons(num, den, [0, 10])
            
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
            % VISPOLYNOMBROEK Visualiserer et polynomium i brøkform
            %
            % Syntax:
            %   ElektroMatBib.visPolynomBroek(num, den)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %
            % Eksempel:
            %   num = [1 2];  % s + 2
            %   den = [1 3 2];  % s^2 + 3s + 2
            %   ElektroMatBib.visPolynomBroek(num, den)
            
            syms s;
            
            % Konverter polynomier til symbolske udtryk
            num_sym = poly2sym(num, s);
            den_sym = poly2sym(den, s);
            
            % Vis som brøk
            disp(num_sym / den_sym);
        end
        
        %% DIFFERENTIALLIGNING FUNKTIONER %%
        
        function [t, y] = loesLineaerODE(a, f, init_cond, t_range)
            % LOESLINEAERODE Løser lineær differentialligning med konstante koefficienter
            %
            % Syntax:
            %   [t, y] = ElektroMatBib.loesLineaerODE(a, f, init_cond, [t_min, t_max])
            %
            % Input:
            %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
            %   f - funktion handle @(t) eller 0 for homogen ligning
            %   init_cond - begyndelsesbetingelser [y(0), y'(0), ..., y^(n-1)(0)]
            %   t_range - [t_min, t_max] tidsinterval
            % 
            % Output:
            %   t - tidsvektor
            %   y - løsningsvektor (første søjle er y, anden søjle er y', osv.)
            %
            % Eksempel:
            %   % Løs y'' + 0.5y' + 2y = 0 med y(0)=1, y'(0)=0
            %   a = [1 0.5 2];
            %   f = 0;  % homogen ligning
            %   init_cond = [1; 0];
            %   [t, y] = ElektroMatBib.loesLineaerODE(a, f, init_cond, [0, 10])
            
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
            % PARTIELBROEKOPDELING Foretager partiel brøkopløsning af en rationel funktion
            %
            % Syntax:
            %   [partiel] = ElektroMatBib.partielBroekopdeling(num, den)
            %
            % Input:
            %   num - tæller polynomium
            %   den - nævner polynomium
            % 
            % Output:
            %   partiel - cell array med delbrøker
            %
            % Eksempel:
            %   num = [1 0];
            %   den = [1 3 2];  % s^2 + 3s + 2 = (s+1)(s+2)
            %   ElektroMatBib.partielBroekopdeling(num, den)
            
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
            % ANALYSERDIFFERENTIALLIGNING Analyserer en differentialligning og klassificerer den
            %
            % Syntax:
            %   ElektroMatBib.analyserDifferentialligning(a)
            %
            % Input:
            %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
            %
            % Eksempel:
            %   % Analyser y'' + 0.5y' + 2y = 0
            %   a = [1 0.5 2];
            %   ElektroMatBib.analyserDifferentialligning(a)
            
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