% MatIngBib.m - MATLAB Matematisk Ingenioerbibliotek til 01911 "Matematisk Analyse og Modellering"
% Dette bibliotek giver praktiske funktioner til at loese opgaver indenfor:
% - Komplekse tal
% - Polynomier
% - Taylorpolynomier
% - Differentialligninger

classdef MatIngBib
    methods(Static)
        %% HJAELPEFUNKTIONER %%
        
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
            fprintf('MatIngBib - Matematisk Ingeniørbibliotek Demonstrationer\n');
            fprintf('==================================================\n\n');
            
            % Demo af komplekse tal
            fprintf('1. KOMPLEKSE TAL DEMO:\n');
            z = 3 + 4i;
            fprintf('Komplekst tal: z = %g + %gi\n', real(z), imag(z));
            [r, theta] = MatIngBib.kompleksPolaer(z);
            fprintf('Polær form: r = %g, theta = %g rad (%g grader)\n', r, theta, theta*180/pi);
            fprintf('Euler notation: z = %g * e^(%gi)\n', r, theta);
            fprintf('\n');
            
            % Demo af polynomier
            fprintf('2. POLYNOMIER DEMO:\n');
            p = [1 0 -4]; % x^2-4
            fprintf('Polynomium: p(x) = x^2 - 4\n');
            roedder = MatIngBib.findRoedder(p);
            fprintf('Rødder: %g og %g\n', roedder(1), roedder(2));
            fprintf('\n');
            
            % Demo af Taylor
            fprintf('3. TAYLOR DEMO:\n');
            fprintf('3. ordens Taylor-polynomium for e^x omkring x=0:\n');
            p = MatIngBib.taylorPoly(@exp, 0, 3);
            fprintf('p(x) = %g + %g*x + %g*x^2 + %g*x^3\n', p(1), p(2), p(3)/2, p(4)/6);
            fprintf('\n');
            
            % Demo af differentialligninger
            fprintf('4. DIFFERENTIALLIGNING DEMO:\n');
            fprintf("Løser y'' + 0.5y' + 2y = 0, y(0)=1, y'(0)=0\n");  % Ændret til dobbelte anførselstegn
            [t, y] = MatIngBib.loesAndenOrden(1, 0.5, 2, 0, [1; 0], 0:0.1:10);
            fprintf('Løsning ved t=1: y(1) = %g\n', interp1(t, y(:,1), 1));
            
            % Plot løsningen
            figure;
            plot(t, y(:,1));
            title(MatIngBib.unicode_dansk('Løsning til andenordens differentialligning'));
            xlabel('t'); ylabel('y(t)');
            grid on;
            fprintf('\n');
            
            % Demo af unicode_dansk funktionen
            fprintf('\n5. DANSKE TEGN DEMO:\n');
            original = 'Løser andenordens differentialligning med dæmpning';
            dansk = MatIngBib.unicode_dansk(original);
            fprintf('Original: %s\nMed danske tegn: %s\n', original, dansk);
        end


        function kommandoOversigt(kategori)
            % Viser en oversigt over kommandoer og deres brug i MatIngBib
            % Input: kategori (valgfri) - specificerer en bestemt kategori at vise
            %   Options: 'kompleks', 'poly', 'taylor', 'difflign', 'hjælp'
            %   Default: Viser alle kategorier
            
            % Hvis ingen kategori er specificeret, vis hovedmenuen
            if nargin < 1
                fprintf('\n=== MatIngBib Kommandooversigt ===\n');
                fprintf('Vælg en kategori for at se detaljer:\n');
                fprintf('1. Komplekse tal  (Brug: kommandoOversigt(''kompleks''))\n');
                fprintf('2. Polynomier     (Brug: kommandoOversigt(''poly''))\n');
                fprintf('3. Taylor-rækker  (Brug: kommandoOversigt(''taylor''))\n');
                fprintf('4. Diff.ligninger (Brug: kommandoOversigt(''difflign''))\n');
                fprintf('5. Hjælpefunkt.   (Brug: kommandoOversigt(''hjælp''))\n');
                return;
            end
            
            % Afhængigt af kategori, vis relevante kommandoer
            switch lower(kategori)
                case 'kompleks'
                    fprintf('\n=== KOMPLEKSE TAL FUNKTIONER ===\n');
                    
                    % vis
                    fprintf('\n--- vis(z, [label]) ---\n');
                    fprintf('Visualiserer komplekst tal i kompleksplanen\n');
                    fprintf('Eksempel: MatIngBib.vis(3+4i, ''Eksempel'')\n');
                    fprintf('Output: Opretter en figur med det komplekse tal\n');
                    
                    % kompleksPolaer
                    fprintf('\n--- [r, theta] = kompleksPolaer(z) ---\n');
                    fprintf('Konverterer komplekst tal til polær form\n');
                    fprintf('Eksempel: [r, theta] = MatIngBib.kompleksPolaer(1+1i)\n');
                    fprintf('Output: r = %g, theta = %g rad\n', sqrt(2), pi/4);
                    
                    % polaerTilKompleks
                    fprintf('\n--- z = polaerTilKompleks(r, theta) ---\n');
                    fprintf('Konverterer polær form til komplekst tal\n');
                    fprintf('Eksempel: z = MatIngBib.polaerTilKompleks(2, pi/3)\n');
                    fprintf('Output: z ≈ %g + %gi\n', 2*cos(pi/3), 2*sin(pi/3));
                    
                    % deMoivre
                    fprintf('\n--- [re, im] = deMoivre(n, theta) ---\n');
                    fprintf('Beregner cos(n*theta) og sin(n*theta) vha. DeMoivre''s formel\n');
                    fprintf('Eksempel: [c, s] = MatIngBib.deMoivre(3, pi/6)\n');
                    
                    % kompleksPotens
                    fprintf('\n--- result = kompleksPotens(z, n) ---\n');
                    fprintf('Beregner z^n for komplekst tal, inkl. alle n mulige værdier hvis n er brøk\n');
                    fprintf('Eksempel: r = MatIngBib.kompleksPotens(2+3i, 2)\n');
                    fprintf('Eksempel: r = MatIngBib.kompleksPotens(1, 1/3) % giver kubikrødder af 1\n');
                    
                case 'poly'
                    fprintf('\n=== POLYNOMIE FUNKTIONER ===\n');
                    
                    % findRoedder
                    fprintf('\n--- roedder = findRoedder(koeff) ---\n');
                    fprintf('Finder rødder i et polynomium\n');
                    fprintf('Eksempel: r = MatIngBib.findRoedder([1 0 -4]) % x^2 - 4\n');
                    fprintf('Output: r = [2; -2]\n');
                    
                    % evaluerPoly
                    fprintf('\n--- vaerdi = evaluerPoly(koeff, x) ---\n');
                    fprintf('Evaluerer et polynomium ved værdi x\n');
                    fprintf('Eksempel: v = MatIngBib.evaluerPoly([1 0 -4], 3) % 3^2 - 4\n');
                    fprintf('Output: v = 5\n');
                    
                    % polyDivision
                    fprintf('\n--- [q, r] = polyDivision(p, d) ---\n');
                    fprintf('Dividerer polynomium p med polynomium d: p = q*d + r\n');
                    fprintf('Eksempel: [q, r] = MatIngBib.polyDivision([1 -5 6], [1 -2])\n');
                    fprintf('Output: q = [1 -3], r = [0]\n');
                    
                    % faktoriserPoly
                    fprintf('\n--- faktorer = faktoriserPoly(koeff) ---\n');
                    fprintf('Faktoriserer et polynomium\n');
                    fprintf('Eksempel: f = MatIngBib.faktoriserPoly([1 -5 6])\n');
                    
                    % polyTilTekst
                    fprintf('\n--- tekst = polyTilTekst(koeff, [variabel]) ---\n');
                    fprintf('Konverterer polynomium-koefficienter til pæn tekstrepræsentation\n');
                    fprintf('Eksempel: s = MatIngBib.polyTilTekst([1 -5 6])\n');
                    fprintf('Output: "x^2 -5x +6"\n');
                    
                case 'taylor'
                    fprintf('\n=== TAYLOR FUNKTIONER ===\n');
                    
                    % taylorPoly
                    fprintf('\n--- koeff = taylorPoly(func, x0, n) ---\n');
                    fprintf('Beregner koefficienter for Taylor-polynomium af orden n\n');
                    fprintf('Eksempel: k = MatIngBib.taylorPoly(@exp, 0, 3) % e^x omkring x=0\n');
                    fprintf('Output: k = [1 1 0.5 0.166...] % koefficienter for 1 + x + x^2/2 + x^3/6\n');
                    
                    % evaluerTaylor
                    fprintf('\n--- vaerdi = evaluerTaylor(koeff, x0, x) ---\n');
                    fprintf('Evaluerer et Taylor-polynomium ved værdi x\n');
                    fprintf('Eksempel: v = MatIngBib.evaluerTaylor([1 1 0.5 1/6], 0, 1) % e^1 ≈ 2.71\n');
                    fprintf('Output: v ≈ 2.67\n');
                    
                    % visTaylorApproks
                    fprintf('\n--- visTaylorApproks(func, x0, n_max, x_range) ---\n');
                    fprintf('Visualiserer Taylor-approksimationer af funktionen\n');
                    fprintf('Eksempel: MatIngBib.visTaylorApproks(@sin, 0, 5, [-pi pi])\n');
                    fprintf('Output: Opretter en graf med sinusfunktionen og Taylor-approksimationer\n');
                    
                case 'difflign'
                    fprintf('\n=== DIFFERENTIALLIGNING FUNKTIONER ===\n');
                    
                    % Første ordens
                    fprintf('\n--- FØRSTEORDENS DIFFERENTIALLIGNINGER ---\n');
                    
                    % loesForsteOrden
                    fprintf('\n--- [t, y] = loesForsteOrden(ode_func, tspan, y0, [options]) ---\n');
                    fprintf('Løser førsteordens differentialligning y'' = f(t,y)\n');
                    fprintf('Eksempel: [t, y] = MatIngBib.loesForsteOrden(@(t,y) -2*y, [0 5], 1)\n');
                    fprintf('Løser y'' = -2y med y(0) = 1, som har løsningen y = e^(-2t)\n');
                    
                    % loesLinForsteOrden
                    fprintf('\n--- [t, y] = loesLinForsteOrden(p, q, tspan, y0, [options]) ---\n');
                    fprintf('Løser lineær førsteordens differentialligning y'' + p(t)*y = q(t)\n');
                    fprintf('Eksempel: [t, y] = MatIngBib.loesLinForsteOrden(@(t) 1, @(t) t, [0 5], 0)\n');
                    
                    % Anden ordens
                    fprintf('\n--- ANDENORDENS DIFFERENTIALLIGNINGER ---\n');
                    
                    % loesAndenOrden
                    fprintf('\n--- [t, y] = loesAndenOrden(a, b, c, f_func, init_cond, tspan, [options]) ---\n');
                    fprintf('Løser andenordens differentialligning a*y'''' + b*y'' + c*y = f(t)\n');
                    fprintf('Eksempel: [t, y] = MatIngBib.loesAndenOrden(1, 0.5, 2, 0, [1; 0], 0:0.1:10)\n');
                    fprintf('Løser y'''' + 0.5y'' + 2y = 0 med y(0) = 1, y''(0) = 0\n');
                    
                    % loesAndenOrdenKonstant
                    fprintf('\n--- [t, y] = loesAndenOrdenKonstant(a, b, c, f_func, init_cond, tspan) ---\n');
                    fprintf('Løser andenordens differentialligning med konstante koefficienter\n');
                    fprintf('Eksempel: Se loesAndenOrden eksemplet\n');
                    
                    % visAndenOrdenTyper
                    fprintf('\n--- visAndenOrdenTyper() ---\n');
                    fprintf('Visualiserer de tre typer af andenordens lineære homogene diff.ligninger\n');
                    fprintf('Eksempel: MatIngBib.visAndenOrdenTyper()\n');
                    fprintf('Output: Opretter en figur med 3 løsningskurver (over/under/kritisk dæmpning)\n');
                    
                case 'hjælp'
                    fprintf('\n=== HJÆLPEFUNKTIONER ===\n');
                    
                    % unicode_dansk
                    fprintf('\n--- tekst = unicode_dansk(inputTekst) ---\n');
                    fprintf('Konverterer tekst med erstatninger til unicode-tegn for danske bogstaver\n');
                    fprintf('Eksempel: s = MatIngBib.unicode_dansk(''loes differentialligning'')\n');
                    fprintf('Output: "løs differentialligning"\n');
                    
                    % karakteristiskeRoedder
                    fprintf('\n--- rod = karakteristiskeRoedder(a, b, c) ---\n');
                    fprintf('Finder rødderne i det karakteristiske polynomium a*λ^2 + b*λ + c\n');
                    fprintf('Eksempel: r = MatIngBib.karakteristiskeRoedder(1, 4, 4)\n');
                    fprintf('Output: Viser analyse af rødderne (kritisk dæmpet i dette tilfælde)\n');
                    
                    % polynomRoedder
                    fprintf('\n--- roedder = polynomRoedder(koeff) ---\n');
                    fprintf('Finder alle rødder i et polynomium og analyserer dem\n');
                    fprintf('Eksempel: r = MatIngBib.polynomRoedder([1 0 0 -1])\n');
                    fprintf('Output: Viser analyse af rødderne i x^3 - 1\n');
                    
                    % demo
                    fprintf('\n--- demoProgrammet() ---\n');
                    fprintf('Viser brug af biblioteket med eksempler\n');
                    fprintf('Eksempel: MatIngBib.demoProgrammet()\n');
                    fprintf('Output: Kører en række demonstrationer af biblioteket\n');
                    
                    % denne kommando
                    fprintf('\n--- kommandoOversigt([kategori]) ---\n');
                    fprintf('Viser en oversigt over kommandoer og deres brug i MatIngBib\n');
                    fprintf('Eksempel: MatIngBib.kommandoOversigt() % viser hovedmenuen\n');
                    fprintf('Eksempel: MatIngBib.kommandoOversigt(''kompleks'') % viser komplekse funktioner\n');
                    
                otherwise
                    fprintf('\nUkendt kategori: %s\n', kategori);
                    fprintf('Gyldige kategorier: ''kompleks'', ''poly'', ''taylor'', ''difflign'', ''hjælp''\n');
                    fprintf('Prøv igen med en gyldig kategori eller kald kommandoOversigt() uden argumenter\n');
            end
        end
        
        %% KOMPLEKSE TAL FUNKTIONER %%
        
        function vis(z, label)
            % Visualiserer et komplekst tal i kompleksplanen
            figure;
            plot(real(z), imag(z), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
            hold on;
            line([0, real(z)], [0, imag(z)], 'Color', 'b', 'LineWidth', 2);
             
            % Tegn enhedscirklen
            theta = linspace(0, 2*pi, 100);
            plot(cos(theta), sin(theta), 'k--');
            
            grid on;
            axis equal;
            xlabel('Re(z)');
            ylabel('Im(z)');
            
            if nargin < 2
                title('Komplekst tal');
            else
                title(label);
            end
            
            text(real(z) + 0.1, imag(z) + 0.1, ['z = ' num2str(real(z)) ' + ' num2str(imag(z)) 'i']);
            text(real(z)/2, imag(z)/2, ['|z| = ' num2str(abs(z))]);
            
            % Tegn vinklen
            r = abs(z);
            theta = angle(z);
            t = linspace(0, theta, 50);
            if theta > 0
                plot(0.2*cos(t), 0.2*sin(t), 'g-', 'LineWidth', 1.5);
            else
                plot(0.2*cos(t), 0.2*sin(t), 'g-', 'LineWidth', 1.5);
            end
            text(0.3*cos(theta/2), 0.3*sin(theta/2), ['\theta = ' num2str(theta) ' rad']);
        end
        
        function [r, theta] = kompleksPolaer(z)
            % Konverterer komplekst tal til polaer form: z = r*e^(i*theta)
            r = abs(z);
            theta = angle(z);
        end
        
        function z = polaerTilKompleks(r, theta)
            % Konverterer polaer form til komplekst tal
            z = r * exp(1i * theta);
        end
        
        function [re, im] = deMoivre(n, theta)
            % Beregner cos(n*theta) og sin(n*theta) ved hjaelp af DeMoivre's formel
            z = exp(1i * theta);
            z_n = z^n;
            re = real(z_n);  % cos(n*theta)
            im = imag(z_n);  % sin(n*theta)
        end
        
        function result = kompleksPotens(z, n)
            % Beregner z^n for et komplekst tal z
            % Giver alle n mulige vaerdier hvis n er en broek
            
            if mod(n, 1) == 0
                % Heltal potens
                result = z^n;
            else
                % Broek potens - giver multiple vaerdier
                [r, theta] = MatIngBib.kompleksPolaer(z);
                k = 0:(ceil(1/n)-1);
                result = r^n * exp(1i * (theta*n + 2*pi*k));
            end
        end
        
        %% POLYNOMIER %%
        
        function roedder = findRoedder(koeff)
            % Finder roedderne i et polynomium
            % koeff: vektor med koefficienter [a_n, a_{n-1}, ..., a_1, a_0]
            % for polynomiet a_n*x^n + a_{n-1}*x^{n-1} + ... + a_1*x + a_0
            roedder = roots(koeff);
        end
        
        function vaerdi = evaluerPoly(koeff, x)
            % Evaluerer et polynomium ved vaerdi x
            vaerdi = polyval(koeff, x);
        end
        
        function [q, r] = polyDivision(p, d)
            % Dividerer polynomium p med polynomium d: p = q*d + r
            [q, r] = deconv(p, d);
        end
        
        function faktorer = faktoriserPoly(koeff)
            % Faktoriserer et polynomium
            % Returnerer en celle-array af faktor-koefficienter
            
            r = roots(koeff);
            faktorer = cell(1, length(r));
            
            % For hver rod, lav faktoren (x - r_i)
            for i = 1:length(r)
                faktorer{i} = [1, -r(i)];
            end
            
            % Inkluder en faktor for den foerende koefficient hvis ikke 1
            if koeff(1) ~= 1
                faktorer{end+1} = koeff(1);
            end
        end
        
        function polyTekst = polyTilTekst(koeff, variabel)
            % Konverterer polynomium-koefficienter til paen tekstrepraesentation
            if nargin < 2
                variabel = 'x';
            end
            
            n = length(koeff) - 1;
            terms = cell(1, n+1);
            
            for i = 1:n+1
                power = n - i + 1;
                coef = koeff(i);
                
                if coef == 0
                    terms{i} = '';
                    continue;
                end
                
                % Haandter fortegn korrekt
                if i > 1 && coef > 0
                    prefix = '+';
                elseif coef < 0
                    prefix = '-';
                    coef = abs(coef);
                else
                    prefix = '';
                end
                
                % Konstruer term baseret paa eksponent
                if power == 0
                    terms{i} = [prefix num2str(coef)];
                elseif power == 1
                    if coef == 1
                        terms{i} = [prefix variabel];
                    else
                        terms{i} = [prefix num2str(coef) variabel];
                    end
                else
                    if coef == 1
                        terms{i} = [prefix variabel '^' num2str(power)];
                    else
                        terms{i} = [prefix num2str(coef) variabel '^' num2str(power)];
                    end
                end
            end
            
            % Fjern tomme termer og forbind med mellemrum
            terms = terms(~cellfun('isempty', terms));
            if isempty(terms)
                polyTekst = '0';
            else
                polyTekst = strjoin(terms, ' ');
            end
        end
        
        %% TAYLOR POLYNOMIER %%
        
        function koeff = taylorPoly(func, x0, n)
    % Beregner koefficienter for Taylor-polynomium af orden n
    % for funktion func omkring x0
    % 
    % Input:
    %   func - Funktion handle (f.eks. @exp, @sin eller @(x) x^2)
    %   x0   - Udviklingspunkt (hvor Taylor-rækken centreres)
    %   n    - Orden af Taylor-polynomiet
    %
    % Output:
    %   koeff - Vektor med koefficienter [a_0, a_1, a_2, ..., a_n]
    %           hvor a_i er koefficienten for (x-x0)^i / i!
    %
    % Eksempler:
    %   k = taylorPoly(@exp, 0, 3)
    %   % Giver [1, 1, 0.5, 0.166...] svarende til 1 + x + x^2/2 + x^3/6
    %
    %   k = taylorPoly(@(x) sin(x), 0, 5)
    %   % Giver [0, 1, 0, -1/6, 0, 1/120] svarende til x - x^3/6 + x^5/120

    % Kontroller input
    if ~isa(func, 'function_handle')
        error('func skal være et funktion handle');
    end
    
    if ~isscalar(x0) || ~isnumeric(x0)
        error('x0 skal være et skalart tal');
    end
    
    if ~isscalar(n) || ~isnumeric(n) || n < 0 || mod(n,1) ~= 0
        error('n skal være et ikke-negativt heltal');
    end
    
    % Brug symbolsk matematik hvis muligt
    try
        syms x;
        f = func(x);
        koeff = zeros(1, n+1);
        for i = 0:n
            df = diff(f, i);
            koeff(i+1) = double(subs(df, x, x0)) / factorial(i);
        end
    catch
        % Numerisk tilnærmelse hvis symbolsk metode fejler
        koeff = zeros(1, n+1);
        h = 1e-8;
        
        % Beregn funktion og numeriske afledte
        koeff(1) = func(x0);  % 0'te afledte = funktionsværdi
        
        % For højere ordens afledte
        for i = 1:n
            % Implementer en mere præcis numerisk differentiationsmetode
            if i == 1
                % Centreret differenskvotient for første afledte
                koeff(i+1) = (func(x0 + h) - func(x0 - h)) / (2 * h);
            else
                % Brug finitte differenser for højere ordens afledte
                df = zeros(1, 2*i+1);
                x_vals = x0 + (-i:i) * h;
                
                for j = 1:length(x_vals)
                    df(j) = func(x_vals(j));
                end
                
                % Beregn i'te afledte ved centreret differenskvotient
                for j = 1:i
                    for k = 1:length(df)-1
                        df(k) = (df(k+1) - df(k)) / h;
                    end
                    df = df(1:end-1);
                end
                
                koeff(i+1) = df(1) / factorial(i);
            end
        end
    end
    
    % Håndtér numeriske unøjagtigheder - rund meget små værdier til 0
    tol = 1e-12;
    koeff(abs(koeff) < tol) = 0;
end
        
        function vaerdi = evaluerTaylor(koeff, x0, x)
            % Evaluerer et Taylor-polynomium ved vaerdi x
            % koeff: vektor med Taylor-koefficienter [a_0, a_1, a_2, ..., a_n]
            % x0: udviklingspunkt
            
            n = length(koeff) - 1;
            vaerdi = 0;
            
            for i = 0:n
                vaerdi = vaerdi + koeff(i+1) * (x - x0)^i;
            end
        end
        
        function visTaylorApproks(func, x0, n_max, x_range)
            % Visualiserer Taylor-approksimationer af funktionen
            % func: funktion handle
            % x0: udviklingspunkt
            % n_max: maksimal orden af Taylor-polynomium
            % x_range: range for x-aksen [x_min, x_max]
            
            x = linspace(x_range(1), x_range(2), 1000);
            y_exact = arrayfun(func, x);
            
            figure;
            plot(x, y_exact, 'k-', 'LineWidth', 2, 'DisplayName', 'Eksakt funktion');
            hold on;
            
            colors = jet(n_max);
            
            for n = 1:n_max
                koeff = MatIngBib.taylorPoly(func, x0, n);
                y_taylor = zeros(size(x));
                
                for i = 1:length(x)
                    y_taylor(i) = MatIngBib.evaluerTaylor(koeff, x0, x(i));
                end
                
                plot(x, y_taylor, 'LineWidth', 1.5, 'Color', colors(n,:), ...
                    'DisplayName', ['n = ' num2str(n)]);
            end
            
            % Marker udviklingspunkt
            plot(x0, func(x0), 'ro', 'MarkerSize', 10, 'LineWidth', 2, ...
                'DisplayName', 'Udviklingspunkt');
            
            grid on;
            xlabel('x');
            ylabel('y');
            title(MatIngBib.unicode_dansk(['Taylor-approksimationer omkring x_0 = ' num2str(x0)]));
            legend('Location', 'best');
        end
        
        %% FOERSTEORDENS DIFFERENTIALLIGNINGER %%
        
        function [t, y] = loesForsteOrden(ode_func, tspan, y0, varargin)
            % Loeser foersteordens differentialligning y' = f(t,y)
            % ode_func: funktion handle paa formen f(t,y)
            % tspan: vektor [t_start, t_slut] eller detaljeret tidsvektor
            % y0: begyndelsesvaerdi
            % varargin: ekstra parametre til ode45
            
            [t, y] = ode45(ode_func, tspan, y0, varargin{:});
        end
        
        function [t, y] = loesLinForsteOrden(p, q, tspan, y0, varargin)
            % Loeser lineaer foersteordens differentialligning y' + p(t)*y = q(t)
            % p, q: funktion handles
            % tspan: vektor [t_start, t_slut] eller detaljeret tidsvektor
            % y0: begyndelsesvaerdi
            
            ode_func = @(t, y) q(t) - p(t)*y;
            [t, y] = MatIngBib.loesForsteOrden(ode_func, tspan, y0, varargin{:});
        end
        
        function [t, y] = loesForsteOrdenSeparabel(ode_func, tspan, y0, varargin)
            % Loeser separabel foersteordens differentialligning y' = f(t)*g(y)
            % ode_func: funktion handle paa formen @(t,y) f(t)*g(y)
            % tspan: vektor [t_start, t_slut] eller detaljeret tidsvektor
            % y0: begyndelsesvaerdi
            
            [t, y] = ode45(ode_func, tspan, y0, varargin{:});
        end
        
        %% ANDENORDENS DIFFERENTIALLIGNINGER %%
        
        function [t, y] = loesAndenOrden(a, b, c, f_func, init_cond, tspan, varargin)
            % Loeser andenordens differentialligning a*y'' + b*y' + c*y = f(t)
            % a, b, c: konstante koefficienter
            % f_func: funktion handle paa formen f(t) eller 0 for homogen ligning
            % init_cond: [y(t_0); y'(t_0)]
            % tspan: vektor [t_start, t_slut] eller detaljeret tidsvektor
            
            % Konverter til system af foersteordens differentialligninger
            if isnumeric(f_func) && f_func == 0
                % Homogen ligning (f(t) = 0)
                odefun = @(t, Y) [Y(2); -(b/a)*Y(2) - (c/a)*Y(1)];
            else
                % Inhomogen ligning
                odefun = @(t, Y) [Y(2); -(b/a)*Y(2) - (c/a)*Y(1) + f_func(t)/a];
            end
            
            % Loes systemet
            [t, Y] = ode45(odefun, tspan, init_cond, varargin{:});
            y = Y;
        end
        
        function [t, y] = loesAndenOrdenKonstant(a, b, c, f_func, init_cond, tspan)
            % Loeser andenordens differentialligning med konstante koefficienter
            % a*y'' + b*y' + c*y = f(t)
            % a, b, c: konstante koefficienter
            % f_func: funktion handle f(t) eller 0 for homogen ligning
            % init_cond: [y(t_0); y'(t_0)]
            % tspan: vektor [t_start, t_slut] eller detaljeret tidsvektor
            
            [t, y] = MatIngBib.loesAndenOrden(a, b, c, f_func, init_cond, tspan);
        end
        
        function visAndenOrdenTyper()
            % Visualiserer de tre typer af andenordens lineaere homogene 
            % differentialligninger med konstante koefficienter
            
            % Tidsinterval
            tspan = 0:0.1:10;
            
            % Begyndelsesbetingelser
            y0 = [1; 0]; % y(0) = 1, y'(0) = 0
            
            % Overdaempet (to reelle forskellige roedder)
            [t1, y1] = MatIngBib.loesAndenOrden(1, 5, 6, 0, y0, tspan);
            
            % Kritisk daempet (dobbeltrod)
            [t2, y2] = MatIngBib.loesAndenOrden(1, 6, 9, 0, y0, tspan);
            
            % Underdaempet (komplekse roedder)
            [t3, y3] = MatIngBib.loesAndenOrden(1, 0.5, 1, 0, y0, tspan);
            
            % Plot resultaterne
            figure;
            plot(t1, y1(:,1), 'r-', 'LineWidth', 2, 'DisplayName', MatIngBib.unicode_dansk('Overdaempet'));
            hold on;
            plot(t2, y2(:,1), 'g-', 'LineWidth', 2, 'DisplayName', MatIngBib.unicode_dansk('Kritisk daempet'));
            plot(t3, y3(:,1), 'b-', 'LineWidth', 2, 'DisplayName', MatIngBib.unicode_dansk('Underdaempet'));
            
            grid on;
            xlabel('t');
            ylabel('y(t)');
            title(MatIngBib.unicode_dansk('Typer af andenordens lineaere differentialligninger'));
            legend('Location', 'best');
        end
        
        %% MAPLE-LIGNENDE NUMERISKE FUNKTIONER %%
        
        function rod = karakteristiskeRoedder(a, b, c)
            % Finder roedderne i det karakteristiske polynomium a*λ^2 + b*λ + c
            rod = roots([a, b, c]);
            
            % Analyser typen af roedder
            if isreal(rod) && abs(rod(1) - rod(2)) < 1e-10
                disp(MatIngBib.unicode_dansk('Dobbeltrod (kritisk daempet):'));
                disp(rod(1));
            elseif isreal(rod)
                disp(MatIngBib.unicode_dansk('To reelle roedder (overdaempet):'));
                disp(rod);
            else
                disp(MatIngBib.unicode_dansk('Komplekse roedder (underdaempet):'));
                disp(rod);
                disp([MatIngBib.unicode_dansk('Daempningsfaktor: '), num2str(real(rod(1)))]);
                disp(['Frekvens: ', num2str(abs(imag(rod(1))))]);
            end
        end
        
        function roedder = polynomRoedder(koeff)
            % Finder alle roedder i et polynomium og analyserer dem
            roedder = roots(koeff);
            
            disp(MatIngBib.unicode_dansk('Polynomieroedder:'));
            for i = 1:length(roedder)
                if isreal(roedder(i))
                    disp(['Rod ', num2str(i), ': ', num2str(roedder(i)), ' (reel)']);
                else
                    disp(['Rod ', num2str(i), ': ', num2str(roedder(i)), ' (kompleks)']);
                end
            end
            
            % Find multiplicitet af roedder
            unique_roots = unique(roedder);
            for i = 1:length(unique_roots)
                mult = sum(abs(roedder - unique_roots(i)) < 1e-10);
                if mult > 1
                    disp(['Rod ', num2str(unique_roots(i)), ' har multiplicitet ', num2str(mult)]);
                end
            end
        end
    end
end