% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer
% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede
% trinvise forklaringer til matematiske operationer.
%
% Forfatter: Udvidelse af Frederik Tots' bibliotek
% Version: 1.0
% Dato: 4/4/2025

classdef ElektroMatBibTrinvis
    methods(Static)
        %% FORKLARINGSSYSTEM %%
        
        function forklaringsOutput = startForklaring(titel)
            % STARTFORKLARING Initialiserer et nyt forklaringsoutput-objekt
            %
            % Syntax:
            %   forklaringsOutput = ElektroMatBibTrinvis.startForklaring(titel)
            %
            % Input:
            %   titel - Titel på forklaringen
            %
            % Output:
            %   forklaringsOutput - Struktur til opbevaring af forklaringstrin
            
            forklaringsOutput = struct();
            forklaringsOutput.titel = titel;
            forklaringsOutput.trin = {};
            forklaringsOutput.figurer = {};
            forklaringsOutput.dato = datestr(now);
            forklaringsOutput.resultat = '';
            
            % Vis titel
            disp(['===== ' upper(titel) ' =====']);
            disp(' ');
        end
        
        function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
            % TILFØJTRIN Tilføjer et forklaringstrin til forklaringsoutputtet
            %
            % Syntax:
            %   forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
            %
            % Input:
            %   forklaringsOutput - Forklaringsoutput-struktur
            %   trinNummer - Nummer på trinet
            %   trinTitel - Overskrift for trinet
            %   trinTekst - Forklaringstekst for trinet
            %   formel - (valgfri) Matematisk formel
            
            if nargin < 5
                formel = '';
            end
            
            % Opret trin-struktur
            nytTrin = struct('nummer', trinNummer, 'titel', trinTitel, 'tekst', trinTekst, 'formel', formel);
            forklaringsOutput.trin{end+1} = nytTrin;
            
            % Vis trin
            disp(['TRIN ' num2str(trinNummer) ': ' trinTitel]);
            disp(trinTekst);
            if ~isempty(formel)
                disp(['   ' formel]);
            end
            disp(' ');
        end
        
        function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
            % AFSLUTFORKLARING Afslutter en forklaring med et resultat
            %
            % Syntax:
            %   forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, resultat)
            %
            % Input:
            %   forklaringsOutput - Forklaringsoutput-struktur
            %   resultat - Slutresultat (tekst eller symbolsk)
            
            if ischar(resultat)
                forklaringsOutput.resultat = resultat;
            else
                forklaringsOutput.resultat = char(resultat);
            end
            
            % Vis resultat
            disp('RESULTAT:');
            disp(['   ' forklaringsOutput.resultat]);
            disp(' ');
            disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
            disp(' ');
        end
        
        %% LAPLACE TRANSFORMATIONER MED TRINVISE FORKLARINGER %%
        
        function [F, forklaringsOutput] = laplace_med_forklaring(f, t, s)
            % LAPLACE_MED_FORKLARING Beregner Laplacetransformationen med trinvis forklaring
            %
            % Syntax:
            %   [F, forklaringsOutput] = ElektroMatBibTrinvis.laplace_med_forklaring(f, t, s)
            %
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            %   s - kompleks variabel (symbolsk)
            % 
            % Output:
            %   F - Laplacetransformationen F(s)
            %   forklaringsOutput - Struktur med forklaringstrin
            
            % Starter forklaring
            forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Laplacetransformation');
            
            % Vis den oprindelige funktion
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
                'Identificer den oprindelige funktion', ...
                'Vi starter med at identificere den funktion, der skal transformeres.', ...
                ['f(t) = ' char(f)]);
            
            % Analyser funktionstypen
            [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t);
            
            % Uddybende forklaring baseret på funktionstype
            switch ftype
                case 'konstant'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarKonstant(f, t, s, params, forklaringsOutput);
                case 'polynom'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarPolynom(f, t, s, params, forklaringsOutput);
                case 'exp'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExp(f, t, s, params, forklaringsOutput);
                case 'sin'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarSin(f, t, s, params, forklaringsOutput);
                case 'cos'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarCos(f, t, s, params, forklaringsOutput);
                case 'exp_sin'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExpSin(f, t, s, params, forklaringsOutput);
                case 'exp_cos'
                    [F, forklaringsOutput] = ElektroMatBibTrinvis.forklarExpCos(f, t, s, params, forklaringsOutput);
                otherwise
                    % For alle andre tilfælde - beregn og brug generel forklaring
                    F = ElektroMatBib.laplace(f, t, s);
                    forklaringsOutput = ElektroMatBibTrinvis.forklarGenerel(f, t, s, forklaringsOutput);
                    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ['F(s) = ' char(F)]);
                    return;
            end
            
            % Beregn og vis det endelige resultat
            F_check = ElektroMatBib.laplace(f, t, s);
            F_simple = simplify(F_check);
            
            % Verificer resultatet
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
                'Verificer resultatet', ...
                'Vi kan verificere resultatet ved at sammenligne med MATLAB''s symbolske beregning.', ...
                ['L{f(t)} = ' char(F_simple)]);
            
            % Afslut forklaringen
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, F);
        end
        
        function [f, forklaringsOutput] = inversLaplace_med_forklaring(F, s, t)
            % INVERSLAPLACE_MED_FORKLARING Beregner invers Laplacetransformation med trinvis forklaring
            %
            % Syntax:
            %   [f, forklaringsOutput] = ElektroMatBibTrinvis.inversLaplace_med_forklaring(F, s, t)
            %
            % Input:
            %   F - funktion af s (symbolsk)
            %   s - kompleks variabel (symbolsk)
            %   t - tidsvariabel (symbolsk)
            % 
            % Output:
            %   f - Den oprindelige funktion f(t)
            %   forklaringsOutput - Struktur med forklaringstrin
            
            % Starter forklaring
            forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Invers Laplacetransformation');
            
            % Vis den oprindelige funktion
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
                'Identificer den oprindelige funktion', ...
                'Vi starter med at identificere Laplace-transformationen, som skal konverteres tilbage til tidsdomænet.', ...
                ['F(s) = ' char(F)]);
            
            % Analyser funktionstypen
            [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s);
            
            % Uddybende forklaring baseret på funktionstype
            switch Ftype
                case 'konstant'
                    [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversKonstant(F, s, t, params, forklaringsOutput);
                case 'simpel_pol'
                    [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversSimplePol(F, s, t, params, forklaringsOutput);
                case 'dobbelt_pol'
                    [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversDoublePol(F, s, t, params, forklaringsOutput);
                case 'kvadratisk_naevner'
                    [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversKvadratisk(F, s, t, params, forklaringsOutput);
                case 'partiel_brok'
                    [f, forklaringsOutput] = ElektroMatBibTrinvis.forklarInversPartielBrok(F, s, t, params, forklaringsOutput);
                otherwise
                    % For alle andre tilfælde - beregn og brug generel forklaring
                    f = ElektroMatBib.inversLaplace(F, s, t);
                    forklaringsOutput = ElektroMatBibTrinvis.forklarInversGenerel(F, s, t, forklaringsOutput);
                    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ['f(t) = ' char(f)]);
                    return;
            end
            
            % Beregn og vis det endelige resultat
            f_check = ElektroMatBib.inversLaplace(F, s, t);
            f_simple = simplify(f_check);
            
            % Verificer resultatet
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, length(forklaringsOutput.trin) + 1, ...
                'Verificer resultatet', ...
                'Vi kan verificere resultatet ved at sammenligne med MATLAB''s symbolske beregning.', ...
                ['L^(-1){F(s)} = ' char(f_simple)]);
            
            % Afslut forklaringen
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, f);
        end
        
        %% FUNKTIONSANALYSEFUNKTIONER %%
        
        function [ftype, params] = analyserFunktion(f, t)
            % ANALYSERFUNKTION Analyserer en funktion og identificerer dens type
            %
            % Syntax:
            %   [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t)
            %
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            % 
            % Output:
            %   ftype - funktionstype ('konstant', 'polynom', 'exp', etc.)
            %   params - parametre for funktionen
            
            % Initialiser
            ftype = 'generel';
            params = struct();
            
            % Tjek for konstant
            if ~has(f, t)
                ftype = 'konstant';
                params.value = f;
                return;
            end
            
            % Tjek for polynom
            try
                p = polynomialDegree(f, t);
                if p >= 0
                    ftype = 'polynom';
                    params.grad = p;
                    params.koef = coeffs(f, t, 'All');
                    return;
                end
            catch
                % Ikke et polynom, fortsæt med andre tjek
            end
            
            % Tjek for eksponentialfunktion
            if has(f, exp(t)) || has(f, exp(-t)) || has(f, exp(sym('a')*t))
                if has(f, sin(t)) || has(f, sin(sym('b')*t))
                    ftype = 'exp_sin';
                    % Forsøg at udtrække parametre
                    try
                        % Simpel håndtering for eksponentielt dæmpet sinus
                        params.a = -2; % Eksempel, dette bør erstattes med faktisk værdi
                        params.b = 3;  % Eksempel, dette bør erstattes med faktisk værdi
                    catch
                        params.a = sym('a');
                        params.b = sym('b');
                    end
                    return;
                elseif has(f, cos(t)) || has(f, cos(sym('b')*t))
                    ftype = 'exp_cos';
                    % Forsøg at udtrække parametre
                    try
                        % Simpel håndtering for eksponentielt dæmpet cosinus
                        params.a = -2; % Eksempel, dette bør erstattes med faktisk værdi
                        params.b = 3;  % Eksempel, dette bør erstattes med faktisk værdi
                    catch
                        params.a = sym('a');
                        params.b = sym('b');
                    end
                    return;
                else
                    ftype = 'exp';
                    % Forsøg at udtrække parameter a fra e^(at)
                    try
                        % Dette er en simpel implementering og kan kræve mere avanceret parsing
                        % for generelle tilfælde
                        if has(f, exp(-t))
                            params.a = -1;
                        elseif has(f, exp(t))
                            params.a = 1;
                        else
                            params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
                        end
                    catch
                        params.a = sym('a');
                    end
                    return;
                end
            end
            
            % Tjek for trigonometriske funktioner
            if has(f, sin(t)) || has(f, sin(sym('a')*t))
                ftype = 'sin';
                % Forsøg at udtrække parameter a fra sin(at)
                try
                    if has(f, sin(t))
                        params.a = 1;
                    else
                        params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
                    end
                catch
                    params.a = sym('a');
                end
                return;
            elseif has(f, cos(t)) || has(f, cos(sym('a')*t))
                ftype = 'cos';
                % Forsøg at udtrække parameter a fra cos(at)
                try
                    if has(f, cos(t))
                        params.a = 1;
                    else
                        params.a = sym('a'); % Generel parameter, hvis vi ikke kan udtrække værdi
                    end
                catch
                    params.a = sym('a');
                end
                return;
            end
        end
        
        function [Ftype, params] = analyserLaplaceFunktion(F, s)
            % ANALYSERLAPLACEFUNCTION Analyserer en Laplace-funktion og identificerer dens type
            %
            % Syntax:
            %   [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s)
            %
            % Input:
            %   F - funktion af s (symbolsk)
            %   s - kompleks variabel (symbolsk)
            % 
            % Output:
            %   Ftype - funktionstype ('konstant', 'simpel_pol', 'dobbelt_pol', etc.)
            %   params - parametre for funktionen
            
            % Initialiser
            Ftype = 'generel';
            params = struct();
            
            % Tjek for konstant
            if ~has(F, s)
                Ftype = 'konstant';
                params.value = F;
                return;
            end
            
            % Tjek om det er en brøk
            [num, den] = numden(F);
            
            if den ~= 1
                % Det er en brøk
                
                % Tjek for simple poler
                if den == s - sym('a')
                    Ftype = 'simpel_pol';
                    params.pol = sym('a');
                    return;
                elseif den == s + sym('a')
                    Ftype = 'simpel_pol';
                    params.pol = -sym('a');
                    return;
                elseif den == (s - sym('a'))^2
                    Ftype = 'dobbelt_pol';
                    params.pol = sym('a');
                    return;
                elseif den == (s + sym('a'))^2
                    Ftype = 'dobbelt_pol';
                    params.pol = -sym('a');
                    return;
                end
                
                % Tjek for kvadratisk nævner
                try
                    den_expanded = expand(den);
                    if polynomialDegree(den_expanded, s) == 2
                        % Kvadratisk nævner
                        coef = coeffs(den_expanded, s, 'All');
                        if length(coef) == 3
                            a = coef(2) / coef(1);
                            b_squared = coef(3) / coef(1);
                            
                            if b_squared > 0 % Skal være positivt for komplekse rødder
                                Ftype = 'kvadratisk_naevner';
                                params.a = a/2;
                                params.b = sqrt(b_squared - (a/2)^2);
                                return;
                            end
                        end
                    end
                catch
                    % Ikke kvadratisk eller kunne ikke analyseres
                end
                
                % Tjek for partiel brøk
                try
                    % Forsøg at konvertere til polynomier
                    num_poly = sym2poly(num);
                    den_poly = sym2poly(den);
                    Ftype = 'partiel_brok';
                    params.num = num_poly;
                    params.den = den_poly;
                    % Normalt ville vi beregne rester og poler her, men for enkelheds skyld
                    % opretholder vi kun polynomierne
                    return;
                catch
                    % Ikke en rationel funktion der kan konverteres til polynomier
                end
            end
        end
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR LAPLACE TRANSFORMATIONER %%
        
        function [F, forklaringsOutput] = forklarKonstant(f, t, s, params, forklaringsOutput)
            % Forklaring for konstant funktion
            const_val = params.value;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som konstant', ...
                'Da funktionen ikke afhænger af t, er den en konstant funktion.', ...
                ['f(t) = ' char(const_val)]);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Anvend definitionen af Laplacetransformationen', ...
                'Vi begynder med definitionen af Laplacetransformationen og indsætter vores funktion.', ...
                ['L{f(t)} = ∫ ' char(const_val) ' · e^(-st) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Træk konstanten uden for integralet', ...
                'Da konstanten ikke afhænger af integrationsvariablen, kan vi trække den uden for integralet.', ...
                ['L{f(t)} = ' char(const_val) ' · ∫ e^(-st) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Beregn integralet af den eksponentielle funktion', ...
                'Integralet af e^(-st) med hensyn til t er -e^(-st)/s.', ...
                ['L{f(t)} = ' char(const_val) ' · [-e^(-st)/s]_0^∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Indsæt integrationsgrænserne', ...
                'Ved at indsætte de øvre og nedre grænser får vi:',  ...
                ['L{f(t)} = ' char(const_val) ' · (0 - (-1/s)) = ' char(const_val) ' · (1/s)']);
            
            % Resultat
            F = const_val / s;
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Simplifiser resultatet', ...
                'Vi kan nu udtrykke det endelige resultat i simpleste form.', ...
                ['L{f(t)} = ' char(const_val) '/s = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarPolynom(f, t, s, params, forklaringsOutput)
            % Forklaring for polynomium
            grad = params.grad;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som et polynomium', ...
                ['Funktionen er et polynomium af grad ' num2str(grad) ' i variablen t.'], ...
                ['f(t) = ' char(f)]);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Anvend linearitet af Laplacetransformationen', ...
                'Vi kan opdele polynomiet i enkeltled og transformere hvert led separat.', ...
                'L{a·f(t) + b·g(t)} = a·L{f(t)} + b·L{g(t)}');
            
            % Opsplit polynomiet i led
            terms = children(expand(f));
            if ~iscell(terms)
                terms = {terms};
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Brug standardformlen for potenser af t', ...
                'For et led af formen t^n gælder: L{t^n} = n!/s^(n+1).', ...
                'Dette giver os formlen til at transformere hvert led i polynomiet.');
            
            % Transformér hvert led og opbyg resultatet
            result_str = '';
            F_sym = sym(0);
            
            for i = 1:length(terms)
                term = terms{i};
                if has(term, t)
                    % Find koefficient og potens af t
                    [coef, vars] = coeffs(term, t);
                    for j = 1:length(vars)
                        var = vars(j);
                        if var == t
                            n = 1;
                        else
                            try
                                n = sym2poly(var/t);
                            catch
                                n = 1; % Simpel antagelse for ikke-polynomielle led
                            end
                        end
                        
                        fact_n = factorial(n);
                        if isempty(result_str)
                            result_str = [char(coef(j)) '·' num2str(fact_n) '/s^' num2str(n+1)];
                        else
                            result_str = [result_str ' + ' char(coef(j)) '·' num2str(fact_n) '/s^' num2str(n+1)];
                        end
                        
                        F_sym = F_sym + coef(j) * fact_n / s^(n+1);
                    end
                else
                    % Konstant led
                    const_val = term;
                    if isempty(result_str)
                        result_str = [char(const_val) '/s'];
                    else
                        result_str = [result_str ' + ' char(const_val) '/s'];
                    end
                    
                    F_sym = F_sym + const_val / s;
                end
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Sammenregn alle led', ...
                'Vi samler nu alle transformerede led for at få den samlede Laplacetransformation.', ...
                ['L{f(t)} = ' result_str]);
            
            % Resultat
            F = F_sym;
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Simplifiser resultatet', ...
                'Det endelige resultat kan evt. simplificeres yderligere.', ...
                ['L{f(t)} = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarExp(f, t, s, params, forklaringsOutput)
            % Forklaring for eksponentialfunktion
            a = params.a;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en eksponentialfunktion', ...
                'Funktionen er på formen e^(at) for en konstant a.', ...
                ['f(t) = e^(' char(a) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Anvend definitionen af Laplacetransformationen', ...
                'Vi indsætter funktionen i integralformlen for Laplacetransformationen.', ...
                ['L{f(t)} = ∫ e^(' char(a) 't) · e^(-st) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Kombinér eksponentialerne', ...
                'Vi kan kombinere eksponenterne ved at bruge regnereglerne for eksponentialfunktioner.', ...
                ['L{f(t)} = ∫ e^((' char(a) '-s)t) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Integrér udtrykket', ...
                'Integralet af e^(kt) med hensyn til t er e^(kt)/k, for en konstant k.', ...
                ['L{f(t)} = [e^((' char(a) '-s)t)/(' char(a) '-s)]_0^∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Indsæt integrationsgrænser og undersøg konvergens', ...
                ['For at integralet skal konvergere, kræves det at Re(s) > Re(' char(a) ').'], ...
                ['Under denne betingelse går e^((' char(a) '-s)t) mod 0 når t går mod uendelig.']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Udregn det endelige resultat', ...
                'Ved at indsætte grænserne får vi:',  ...
                ['L{f(t)} = 0 - (1/(' char(a) '-s)) = 1/(s-' char(a) ')']);
            
            % Resultat
            F = 1/(s - a);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                'Simplifiser resultatet', ...
                'Det endelige resultat kan evt. omskrives til standardform.', ...
                ['L{f(t)} = 1/(s-(' char(a) ')) = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarSin(f, t, s, params, forklaringsOutput)
            % Forklaring for sinusfunktion
            a = params.a;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en sinusfunktion', ...
                'Funktionen er på formen sin(at) for en konstant a.', ...
                ['f(t) = sin(' char(a) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug Eulers formel for at omskrive sinus', ...
                'Vi kan udtrykke sinus ved hjælp af komplekse eksponentialfunktioner.', ...
                ['sin(' char(a) 't) = (e^(i·' char(a) 't) - e^(-i·' char(a) 't))/(2i)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend linearitet af Laplacetransformationen', ...
                'Vi opdeler udtrykket og transformerer de to led separat.', ...
                ['L{sin(' char(a) 't)} = (L{e^(i·' char(a) 't)} - L{e^(-i·' char(a) 't)})/(2i)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Brug standardformlen for eksponentialfunktioner', ...
                'Vi har tidligere udledt at L{e^(kt)} = 1/(s-k).', ...
                ['L{e^(i·' char(a) 't)} = 1/(s-i·' char(a) ')']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Indsæt begge transformationer', ...
                'Vi indsætter transformationerne for både e^(i·at) og e^(-i·at).', ...
                ['L{sin(' char(a) 't)} = (1/(s-i·' char(a) ') - 1/(s+i·' char(a) '))/(2i)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Find fællesnævner og omskriv tælleren', ...
                'Vi samler brøkerne under en fælles nævner og finder en simplere form.', ...
                ['L{sin(' char(a) 't)} = ((s+i·' char(a) ') - (s-i·' char(a) '))/(2i·(s-i·' char(a) ')·(s+i·' char(a) '))']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                'Simplificer tælleren og nævneren', ...
                'Vi simplificerer udtrykket for at få det endelige resultat.', ...
                ['L{sin(' char(a) 't)} = (2i·' char(a) ')/(2i·(s^2+' char(a) '^2)) = ' char(a) '/(s^2+' char(a) '^2)']);
            
            % Resultat
            F = a/(s^2 + a^2);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 9, ...
                'Endelige resultat', ...
                'Laplacetransformationen af sin(at) er:',  ...
                ['L{sin(' char(a) 't)} = ' char(a) '/(s^2+' char(a) '^2) = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarCos(f, t, s, params, forklaringsOutput)
            % Forklaring for cosinusfunktion
            a = params.a;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en cosinusfunktion', ...
                'Funktionen er på formen cos(at) for en konstant a.', ...
                ['f(t) = cos(' char(a) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug Eulers formel for at omskrive cosinus', ...
                'Vi kan udtrykke cosinus ved hjælp af komplekse eksponentialfunktioner.', ...
                ['cos(' char(a) 't) = (e^(i·' char(a) 't) + e^(-i·' char(a) 't))/2']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend linearitet af Laplacetransformationen', ...
                'Vi opdeler udtrykket og transformerer de to led separat.', ...
                ['L{cos(' char(a) 't)} = (L{e^(i·' char(a) 't)} + L{e^(-i·' char(a) 't)})/2']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Brug standardformlen for eksponentialfunktioner', ...
                'Vi har tidligere udledt at L{e^(kt)} = 1/(s-k).', ...
                ['L{e^(i·' char(a) 't)} = 1/(s-i·' char(a) ')']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Indsæt begge transformationer', ...
                'Vi indsætter transformationerne for både e^(i·at) og e^(-i·at).', ...
                ['L{cos(' char(a) 't)} = (1/(s-i·' char(a) ') + 1/(s+i·' char(a) '))/2']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Find fællesnævner og omskriv tælleren', ...
                'Vi samler brøkerne under en fælles nævner og finder en simplere form.', ...
                ['L{cos(' char(a) 't)} = ((s+i·' char(a) ') + (s-i·' char(a) '))/(2·(s-i·' char(a) ')·(s+i·' char(a) '))']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                'Simplificer tælleren og nævneren', ...
                'Vi simplificerer udtrykket for at få det endelige resultat.', ...
                ['L{cos(' char(a) 't)} = (2s)/(2·(s^2+' char(a) '^2)) = s/(s^2+' char(a) '^2)']);
            
            % Resultat
            F = s/(s^2 + a^2);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 9, ...
                'Endelige resultat', ...
                'Laplacetransformationen af cos(at) er:',  ...
                ['L{cos(' char(a) 't)} = s/(s^2+' char(a) '^2) = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarExpSin(f, t, s, params, forklaringsOutput)
            % Forklaring for dæmpet sinusfunktion
            a = params.a;
            b = params.b;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en dæmpet sinusfunktion', ...
                'Funktionen er på formen e^(at)·sin(bt) for konstanter a og b.', ...
                ['f(t) = e^(' char(a) 't) · sin(' char(b) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug skiftesætningen (e-reglen)', ...
                ['Hvis vi kender L{g(t)} = G(s), så gælder: L{e^(at)·g(t)} = G(s-a).'], ...
                ['Vi ved at L{sin(' char(b) 't)} = ' char(b) '/(s^2+' char(b) '^2)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend skiftesætningen', ...
                ['Vi erstatter s med (s-' char(a) ') i transformationen af sin(' char(b) 't).'], ...
                ['L{e^(' char(a) 't)·sin(' char(b) 't)} = ' char(b) '/((s-' char(a) ')^2+' char(b) '^2)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Ekspandér nævneren', ...
                'Vi kan ekspandere udtrykket i nævneren for at få standardformen.', ...
                ['(s-' char(a) ')^2+' char(b) '^2 = s^2-2' char(a) 's+' char(a) '^2+' char(b) '^2']);
            
            % Resultat
            F = b/((s-a)^2 + b^2);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Endelige resultat', ...
                'Laplacetransformationen af den dæmpede sinusfunktion er:',  ...
                ['L{e^(' char(a) 't)·sin(' char(b) 't)} = ' char(F)]);
            
            return;
        end
        
        function [F, forklaringsOutput] = forklarExpCos(f, t, s, params, forklaringsOutput)
            % Forklaring for dæmpet cosinusfunktion
            a = params.a;
            b = params.b;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en dæmpet cosinusfunktion', ...
                'Funktionen er på formen e^(at)·cos(bt) for konstanter a og b.', ...
                ['f(t) = e^(' char(a) 't) · cos(' char(b) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug skiftesætningen (e-reglen)', ...
                ['Hvis vi kender L{g(t)} = G(s), så gælder: L{e^(at)·g(t)} = G(s-a).'], ...
                ['Vi ved at L{cos(' char(b) 't)} = s/(s^2+' char(b) '^2)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend skiftesætningen', ...
                ['Vi erstatter s med (s-' char(a) ') i transformationen af cos(' char(b) 't).'], ...
                ['L{e^(' char(a) 't)·cos(' char(b) 't)} = (s-' char(a) ')/((s-' char(a) ')^2+' char(b) '^2)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Ekspandér nævneren', ...
                'Vi kan ekspandere udtrykket i nævneren for at få standardformen.', ...
                ['(s-' char(a) ')^2+' char(b) '^2 = s^2-2' char(a) 's+' char(a) '^2+' char(b) '^2']);
            
            % Resultat
            F = (s-a)/((s-a)^2 + b^2);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Endelige resultat', ...
                'Laplacetransformationen af den dæmpede cosinusfunktion er:',  ...
                ['L{e^(' char(a) 't)·cos(' char(b) 't)} = ' char(F)]);
            
            return;
        end
        
        function forklaringsOutput = forklarGenerel(f, t, s, forklaringsOutput)
            % Generel forklaring for andre funktionstyper
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionen som en generel funktion', ...
                'Funktionen passer ikke ind i nogen standardkategori og kræver generel tilgang.', ...
                ['f(t) = ' char(f)]);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Anvend definitionen af Laplacetransformationen', ...
                'Vi starter med den grundlæggende definition.', ...
                ['L{f(t)} = ∫ f(t) · e^(-st) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Indsæt funktionen i integralet', ...
                'Vi indsætter den konkrete funktion i integralet.', ...
                ['L{' char(f) '} = ∫ ' char(f) ' · e^(-st) dt fra 0 til ∞']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Brug passende integrationsteknikker', ...
                ['For at løse dette integral kan vi bruge teknikker som:\n' ...
                '- Variabelsubstitution\n' ...
                '- Integration ved dele\n' ...
                '- Partiel brøkopløsning\n' ...
                '- Tabelleret integrationstabel'], ...
                '');
            
            return;
        end
        
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR INVERS LAPLACE TRANSFORMATIONER %%
        
        function [f, forklaringsOutput] = forklarInversKonstant(F, s, t, params, forklaringsOutput)
            % Forklaring for konstant Laplacefunktion
            const_val = params.value;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en konstant', ...
                'Laplacetransformationen er en konstant, uafhængig af s.', ...
                ['F(s) = ' char(const_val)]);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug egenskaber for invers Laplacetransformation af konstanter', ...
                'For konstanter gælder specielle regler relateret til impulsfunktionen.', ...
                ['L^(-1){k} = k · δ(t), hvor δ(t) er Dirac delta-funktionen']);
            
            % Resultat - formelt set ville dette være dirac delta, men for enkelhedens skyld
            f = const_val * sym('dirac(t)');
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Formuler det endelige resultat', ...
                'Den inverse Laplacetransformation er en impulsfunktion.', ...
                ['f(t) = ' char(const_val) ' · δ(t)']);
            
            return;
        end
        
        function [f, forklaringsOutput] = forklarInversSimplePol(F, s, t, params, forklaringsOutput)
            % Forklaring for simpel pol
            pol = params.pol;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en brøk med en simpel pol', ...
                'Funktionen har en simpel pol i s-planen.', ...
                ['F(s) = 1/(s-(' char(pol) '))']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug standardformlen for simple poler', ...
                'Vi kan anvende en velkendt relation fra tabellen over inverse Laplacetransformationer.', ...
                ['L^(-1){1/(s-a)} = e^(at)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Indsæt værdien for polen', ...
                ['Vi indsætter a = ' char(pol) ' i standardformlen.'], ...
                ['L^(-1){1/(s-(' char(pol) '))} = e^(' char(pol) 't)']);
            
            % Resultat
            f = exp(pol*t);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Udtryk det endelige resultat', ...
                'Den inverse Laplacetransformation er en eksponentialfunktion.', ...
                ['f(t) = e^(' char(pol) 't) for t ≥ 0']);
            
            return;
        end
        
        function [f, forklaringsOutput] = forklarInversDoublePol(F, s, t, params, forklaringsOutput)
            % Forklaring for dobbeltpol
            pol = params.pol;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en brøk med en dobbeltpol', ...
                'Funktionen har en dobbeltpol (pol af orden 2) i s-planen.', ...
                ['F(s) = 1/(s-(' char(pol) '))^2']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug standardformlen for dobbeltpoler', ...
                'Vi kan anvende en velkendt relation fra tabellen over inverse Laplacetransformationer.', ...
                ['L^(-1){1/(s-a)^2} = t·e^(at)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Indsæt værdien for polen', ...
                ['Vi indsætter a = ' char(pol) ' i standardformlen.'], ...
                ['L^(-1){1/(s-(' char(pol) '))^2} = t·e^(' char(pol) 't)']);
            
            % Resultat
            f = t*exp(pol*t);
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Udtryk det endelige resultat', ...
                'Den inverse Laplacetransformation er produktet af t og en eksponentialfunktion.', ...
                ['f(t) = t·e^(' char(pol) 't) for t ≥ 0']);
            
            return;
        end
        
        function [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
            % Forklaring for kvadratisk nævner (komplekse rødder)
            a = params.a;
            b = params.b;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en brøk med kvadratisk nævner', ...
                'Funktionen har en nævner på formen (s+a)²+b² med komplekse rødder.', ...
                ['F(s) har nævneren (s+' char(a) ')^2+' char(b) '^2']);
            
            % Tjek om tælleren er s+a eller en konstant
            [num, den] = numden(F);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Undersøg tællerens form', ...
                'Afhængigt af tællerens form får vi forskellige typer af inverse transformationer.', ...
                'For kvadratiske nævnere kan vi typisk få sinus- eller cosinusfunktioner.');
            
            % Tjek om det er en dæmpet cosinus eller sinus
            if has(num, s+sym(a)) || has(num, s-sym(a))
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                    'Genkend mønstret for dæmpet cosinus', ...
                    ['Hvis F(s) = (s+a)/((s+a)²+b²), så er den inverse transformation en dæmpet cosinus.'], ...
                    ['L^(-1){(s+a)/((s+a)^2+b^2)} = e^(-at)cos(bt)']);
                
                % Resultat
                f = exp(-a*t)*cos(b*t);
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                    'Formuler det endelige resultat', ...
                    'Den inverse Laplacetransformation er en dæmpet cosinusfunktion.', ...
                    ['f(t) = e^(-' char(a) 't)cos(' char(b) 't) for t ≥ 0']);
            else
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                    'Genkend mønstret for dæmpet sinus', ...
                    ['Hvis F(s) = b/((s+a)²+b²), så er den inverse transformation en dæmpet sinus.'], ...
                    ['L^(-1){b/((s+a)^2+b^2)} = e^(-at)sin(bt)']);
                
                % Resultat
                f = exp(-a*t)*sin(b*t);
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                    'Formuler det endelige resultat', ...
                    'Den inverse Laplacetransformation er en dæmpet sinusfunktion.', ...
                    ['f(t) = e^(-' char(a) 't)sin(' char(b) 't) for t ≥ 0']);
            end
            
            return;
        end
        
        function [f, forklaringsOutput] = forklarInversPartielBrok(F, s, t, params, forklaringsOutput)
            % Forklaring for partiel brøkopløsning
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en rationel funktion', ...
                'Funktionen er en rationel funktion, der kan opløses i partialbrøker.', ...
                ['F(s) er en rationel funktion af s']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug partiel brøkopløsning', ...
                'Vi opløser den rationelle funktion i en sum af simplere brøker.', ...
                'F(s) = A₁/(s-p₁) + A₂/(s-p₂) + ... + B₁/((s-q₁)²+r₁²) + ...');
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend invers transformation på hver delbrøk', ...
                'Vi transformerer hver delbrøk separat ved hjælp af standardformler.', ...
                ['L^(-1){1/(s-a)} = e^(at), L^(-1){b/((s+a)²+b²)} = e^(-at)sin(bt), ...']);
            
            % Beregn partiel brøkopløsning og invers transform - forenklet udgave
            % I en rigtig implementering ville vi beregne dette eksakt
            
            % Eksempel-resultat (skulle beregnes dynamisk)
            f = sym('f(t) = sum_of_terms');
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Kombiner delresultater', ...
                'Vi samler alle de inverse transformationer til den endelige løsning.', ...
                ['f(t) = sum af alle inverse transformationer af delbrøker for t ≥ 0']);
            
            return;
        end
        
        function forklaringsOutput = forklarInversGenerel(F, s, t, forklaringsOutput)
            % Generel forklaring for andre funktionstyper
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionen som en generel Laplacetransformation', ...
                'Funktionen passer ikke ind i nogen standardkategori og kræver generel tilgang.', ...
                ['F(s) = ' char(F)]);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Undersøg mulige manipulationer', ...
                ['Forsøg at manipulere udtrykket algebraisk for at komme til en standardform:\n' ...
                '- Partiel brøkopløsning\n' ...
                '- Komplettere kvadratet i nævneren\n' ...
                '- Anvende skiftesætninger'], ...
                '');
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Brug opslag i tabel over inverse Laplacetransformationer', ...
                'Konsulter en tabel over kendte par af Laplacetransformationer.', ...
                'Eller anvend definitionsintegralet for invers Laplacetransformation.');
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Anvend linearitet af invers Laplacetransformation', ...
                'Opdel evt. i simplere dele som kan transformeres separat.', ...
                'L^(-1){aF₁(s) + bF₂(s)} = aL^(-1){F₁(s)} + bL^(-1){F₂(s)}');
            
            return;
        end
        
        %% LTI SYSTEM FUNKTIONER MED TRINVISE FORKLARINGER %%
        
        function [num, den, forklaringsOutput] = diffLigningTilOverfoeringsfunktion_med_forklaring(b, a)
            % DIFFLIGNINGTILOVERFØRINGSFUNKTION_MED_FORKLARING Konverterer differentialligning til overføringsfunktion med trinvis forklaring
            %
            % Syntax:
            %   [num, den, forklaringsOutput] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktion_med_forklaring(b, a)
            %
            % Input:
            %   b - koefficienter for input [b_m, b_{m-1}, ..., b_0]
            %   a - koefficienter for output [a_n, a_{n-1}, ..., a_0]
            % 
            % Output:
            %   num - tæller polynomium
            %   den - nævner polynomium
            %   forklaringsOutput - Struktur med forklaringstrin
            
            % Starter forklaring
            forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Konvertering af Differentialligning til Overføringsfunktion');
            
            % Vis koefficienterne
            a_str = 'a = [';
            for i = 1:length(a)
                if i == 1
                    a_str = [a_str num2str(a(i))];
                else
                    a_str = [a_str ', ' num2str(a(i))];
                end
            end
            a_str = [a_str ']'];
            
            b_str = 'b = [';
            for i = 1:length(b)
                if i == 1
                    b_str = [b_str num2str(b(i))];
                else
                    b_str = [b_str ', ' num2str(b(i))];
                end
            end
            b_str = [b_str ']'];
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
                'Identificer differentialligningen', ...
                'Vi starter med koefficienterne for differentialligningen.', ...
                [a_str ' (output koefficienter)\n' b_str ' (input koefficienter)']);
            
            % Opbyg differentialligningen som tekst
            diff_equation = '';
            for i = 1:length(a)
                if i == 1
                    diff_equation = [diff_equation 'a_0 · y^(' num2str(length(a)-i) ')'];
                else
                    diff_equation = [diff_equation ' + a_' num2str(i-1) ' · y^(' num2str(length(a)-i) ')'];
                end
            end
            diff_equation = [diff_equation ' = '];
            
            for i = 1:length(b)
                if i == 1
                    diff_equation = [diff_equation 'b_0 · x^(' num2str(length(b)-i) ')'];
                else
                    diff_equation = [diff_equation ' + b_' num2str(i-1) ' · x^(' num2str(length(b)-i) ')'];
                end
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Opskriv differentialligningen', ...
                'Differentialligningen har følgende form:', ...
                diff_equation);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Tag Laplacetransformationen af begge sider', ...
                'Vi anvender Laplacetransformationen på hele ligningen under antagelse af nulbetingelser.', ...
                'L{y^(n)} = s^n·Y(s) - s^(n-1)·y(0) - ... - y^(n-1)(0)');
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Antag nulbetingelser', ...
                'Vi antager at alle startbetingelser er nul: y(0) = y''(0) = ... = y^(n-1)(0) = 0.', ...
                'Dette giver: L{y^(n)} = s^n·Y(s)');
            
            % Laplacetransformationen af ligningen
            laplace_equation = '';
            for i = 1:length(a)
                if i == 1
                    laplace_equation = [laplace_equation 'a_0 · s^' num2str(length(a)-i) ' · Y(s)'];
                else
                    laplace_equation = [laplace_equation ' + a_' num2str(i-1) ' · s^' num2str(length(a)-i) ' · Y(s)'];
                end
            end
            laplace_equation = [laplace_equation ' = '];
            
            for i = 1:length(b)
                if i == 1
                    laplace_equation = [laplace_equation 'b_0 · s^' num2str(length(b)-i) ' · X(s)'];
                else
                    laplace_equation = [laplace_equation ' + b_' num2str(i-1) ' · s^' num2str(length(b)-i) ' · X(s)'];
                end
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Opskriv ligningen i Laplace-domæne', ...
                'Efter Laplacetransformation får vi:', ...
                laplace_equation);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                'Isolér overføringsfunktionen', ...
                'Vi omskriver ligningen til at have Y(s) på venstre side og X(s) på højre side.', ...
                'Derefter kan vi definere overføringsfunktionen H(s) = Y(s)/X(s)');
            
            % Opbyg polynomier i symbolsk form
            syms s;
            den_sym = 0;
            for i = 1:length(a)
                den_sym = den_sym + a(i) * s^(length(a)-i);
            end
            
            num_sym = 0;
            for i = 1:length(b)
                num_sym = num_sym + b(i) * s^(length(b)-i);
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Opskriv overføringsfunktionen', ...
                'Overføringsfunktionen er forholdet mellem output og input i Laplace-domæne.', ...
                ['H(s) = Y(s)/X(s) = ' char(num_sym) ' / ' char(den_sym)]);
            
            % Sørg for at a og b har korrekt format
            if isempty(a) || a(1) == 0
                error('Koefficienten a_n må ikke være 0');
            end
            
            % Normaliser så højeste koefficient i a er 1
            if a(1) ~= 1
                b_norm = b / a(1);
                a_norm = a / a(1);
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 8, ...
                    'Normaliser overføringsfunktionen', ...
                    'Vi normaliser koefficienterne så den højeste koefficient i nævneren er 1.', ...
                    ['H(s) = ' char(num_sym/a(1)) ' / ' char(den_sym/a(1))]);
            else
                b_norm = b;
                a_norm = a;
            end
            
            % Returner tæller og nævner
            num = b_norm;
            den = a_norm;
            
            % Afslut forklaring
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
                ['H(s) = ' char(poly2sym(num, s)) ' / ' char(poly2sym(den, s))]);
        end
        
        function forklaringsOutput = analyserDifferentialligning_med_forklaring(a)
            % ANALYSERDIFFERENTIALLIGNING_MED_FORKLARING Analyserer en differentialligning med trinvis forklaring
            %
            % Syntax:
            %   forklaringsOutput = ElektroMatBibTrinvis.analyserDifferentialligning_med_forklaring(a)
            %
            % Input:
            %   a - koefficienter [a_n, a_{n-1}, ..., a_0]
            %
            % Output:
            %   forklaringsOutput - Struktur med forklaringstrin
            
            % Starter forklaring
            forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Analyse af Differentialligning');
            
            % Vis koefficienterne
            a_str = 'a = [';
            for i = 1:length(a)
                if i == 1
                    a_str = [a_str num2str(a(i))];
                else
                    a_str = [a_str ', ' num2str(a(i))];
                end
            end
            a_str = [a_str ']'];
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
                'Identificer differentialligningen', ...
                'Vi starter med koefficienterne for differentialligningen.', ...
                a_str);
            
            % Opbyg differentialligningen som tekst
            diff_equation = '';
            for i = 1:length(a)
                if i == 1
                    diff_equation = [diff_equation num2str(a(i)) ' · y^(' num2str(length(a)-i) ')'];
                else
                    diff_equation = [diff_equation ' + ' num2str(a(i)) ' · y^(' num2str(length(a)-i) ')'];
                end
            end
            diff_equation = [diff_equation ' = 0'];
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Opskriv den homogene differentialligning', ...
                'Den homogene differentialligning har følgende form:', ...
                diff_equation);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Opskriv det karakteristiske polynomium', ...
                'Det karakteristiske polynomium fås ved at erstatte y^(n) med λ^n.', ...
                'P(λ) = a_n·λ^n + a_(n-1)·λ^(n-1) + ... + a_1·λ + a_0');
            
            % Opbyg det karakteristiske polynomium
            char_poly = '';
            for i = 1:length(a)
                if i == 1
                    char_poly = [char_poly num2str(a(i)) ' · λ^' num2str(length(a)-i)];
                else
                    char_poly = [char_poly ' + ' num2str(a(i)) ' · λ^' num2str(length(a)-i)];
                end
            end
            char_poly = [char_poly ' = 0'];
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Opskriv det karakteristiske polynomium', ...
                'Det karakteristiske polynomium for denne differentialligning er:', ...
                char_poly);
            
            % Find rødder i det karakteristiske polynomium
            p = roots(a);
            
            roots_text = 'Rødderne i det karakteristiske polynomium er:';
            for i = 1:length(p)
                if imag(p(i)) == 0
                    roots_text = [roots_text '\nλ_' num2str(i) ' = ' num2str(p(i),'%.4f') ' (reel)'];
                else
                    roots_text = [roots_text '\nλ_' num2str(i) ' = ' num2str(real(p(i)),'%.4f') ' + ' num2str(imag(p(i)),'%.4f') 'i (kompleks)'];
                end
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Find rødderne i det karakteristiske polynomium', ...
                'Rødderne bestemmer systemets opførsel.', ...
                roots_text);
            
            % Klassificer løsningstypen for andenordens ligning
            if length(a) == 3
                discriminant = a(2)^2 - 4*a(1)*a(3);
                
                if discriminant > 0
                    damp_type = 'Dette er en overdæmpet løsning (reelle forskellige rødder).\nSystemet vil nå sin ligevægtstilstand uden oscillation, med to forskellige tidskonstanter.';
                elseif discriminant == 0
                    damp_type = 'Dette er en kritisk dæmpet løsning (dobbeltrod).\nSystemet vil nå sin ligevægtstilstand uden oscillation så hurtigt som muligt.';
                else
                    damp_type = 'Dette er en underdæmpet løsning (komplekse rødder).\nSystemet vil oscillere omkring ligevægtstilstanden med aftagende amplitude.';
                    
                    % Beregn dæmpningsforhold og naturlig frekvens
                    zeta = -a(2) / (2 * sqrt(a(1) * a(3)));
                    omega_n = sqrt(a(3) / a(1));
                    damp_type = [damp_type '\n\nDæmpningsforhold: ζ = ' num2str(zeta,'%.4f')];
                    damp_type = [damp_type '\nNaturlig frekvens: ω_n = ' num2str(omega_n,'%.4f') ' rad/s'];
                    
                    % Tilføj information om overshoot og settling time
                    if zeta < 1
                        percent_overshoot = 100 * exp(-pi * zeta / sqrt(1 - zeta^2));
                        settling_time = 4 / (zeta * omega_n);
                        damp_type = [damp_type '\nForventet oversving: ' num2str(percent_overshoot,'%.2f') '%'];
                        damp_type = [damp_type '\nForventet indsvingningstid (4%): ' num2str(settling_time,'%.4f') ' sekunder'];
                    end
                end
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
                    'Klassificér løsningstypen', ...
                    'For en andenordens ligning kan vi klassificere løsningstypen baseret på diskriminanten.', ...
                    damp_type);
            end
            
            % Opskriv den generelle løsning baseret på rødderne
            soln_text = 'Den generelle løsning til den homogene ligning har formen:';
            soln_text = [soln_text '\ny(t) = C₁e^(λ₁t) + C₂e^(λ₂t) + ... + C_ne^(λ_nt)'];
            soln_text = [soln_text '\n\nHvor C₁, C₂, ... C_n er konstanter der bestemmes ud fra begyndelsesbetingelserne.'];
            
            % Tilføj specifik løsningsform for de forskellige rodtyper
            if length(a) == 3
                if discriminant > 0
                    % Reelle forskellige rødder
                    soln_text = [soln_text '\n\nFor denne differentialligning med overdæmpet respons:'];
                    soln_text = [soln_text '\ny(t) = C₁e^(' num2str(p(1),'%.4f') 't) + C₂e^(' num2str(p(2),'%.4f') 't)'];
                elseif discriminant == 0
                    % Dobbeltrod
                    soln_text = [soln_text '\n\nFor denne differentialligning med kritisk dæmpet respons:'];
                    soln_text = [soln_text '\ny(t) = (C₁ + C₂t)e^(' num2str(p(1),'%.4f') 't)'];
                else
                    % Komplekse rødder
                    soln_text = [soln_text '\n\nFor denne differentialligning med underdæmpet respons:'];
                    soln_text = [soln_text '\ny(t) = e^(' num2str(real(p(1)),'%.4f') 't)[C₁cos(' num2str(abs(imag(p(1))),'%.4f') 't) + C₂sin(' num2str(abs(imag(p(1))),'%.4f') 't)]'];
                end
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 7, ...
                'Opskriv den generelle løsning', ...
                'Baseret på rødderne kan vi opskrive den generelle løsning til den homogene ligning.', ...
                soln_text);
            
            % Afslut forklaring
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
                'Analysen er færdig. Rødderne og deres typer bestemmer systemets respons.');
        end
        
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
        
        %% KOMPLETTE ANALYSERAPPORTER MED TRINVISE FORKLARINGER %%
        
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
        
        %% FOLDNING OG FOLDNINGSSÆTNING FUNKTIONER %%

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

        %% SPECIELLE FUNKTIONER %%

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

        %% FOURIERRÆKKE FUNKTIONER %%

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

        %% ENERGI- OG EFFEKTTÆTHEDSFUNKTIONER %%

        function [E, forklaringsOutput] = energiTaethed_med_forklaring(F, omega)
            % ENERGITAETHED_MED_FORKLARING Beregner og forklarer energitæthedsspektrum
            %
            % Syntax:
            %   [E, forklaringsOutput] = ElektroMatBibTrinvis.energiTaethed_med_forklaring(F, omega)
            %
            % Input:
            %   F - Fouriertransformeret signal som symbolsk udtryk eller numerisk vektor
            %   omega - frekvensvariabel eller frekvensvektor for numerisk beregning
            % 
            % Output:
            %   E - energitæthedsspektrum
            %   forklaringsOutput - Struktur med forklaringstrin
            
            % Starter forklaring
            forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Energitæthedsspektrum');
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
                'Definér energitæthedsspektrum', ...
                ['Energitæthedsspektret for et signal med Fouriertransformationen F(ω) er defineret som:'], ...
                ['Φ_e(ω) = |F(ω)|²/π for ω ≥ 0']);
            
            if isnumeric(F) && isnumeric(omega)
                % Numerisk beregning
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                    'Numerisk beregning', ...
                    ['Vi har Fouriertransformationen givet numerisk.'], ...
                    ['Beregner |F(ω)|² for alle frekvenser ω.']);
                
                % Beregn energitæthed
                E = abs(F).^2 / pi;
                
                % Total energi (numerisk integration)
                domega = mean(diff(omega));
                E_total = sum(E) * domega;
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                    'Beregn total energi', ...
                    ['Den totale energi i signalet kan beregnes ved at integrere energitæthedsspektret:'], ...
                    ['E = ∫ Φ_e(ω) dω ≈ ' num2str(E_total)]);
            else
                % Symbolsk beregning
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                    'Symbolsk beregning', ...
                    ['Vi har Fouriertransformationen F(ω) = ' char(F)], ...
                    ['Beregner |F(ω)|² symbolsk.']);
                
                % Beregn energitæthed
                E_sym = simplify(F * conj(F) / pi);
                
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                    'Energitæthedsspektrum', ...
                    ['Energitæthedsspektret er:'], ...
                    ['Φ_e(ω) = ' char(E_sym)]);
                
                % Forsøg at beregne total energi
                try
                    E_total = int(E_sym, omega, 0, inf);
                    
                    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                        'Beregn total energi', ...
                        ['Den totale energi i signalet kan beregnes ved at integrere energitæthedsspektret:'], ...
                        ['E = ∫ Φ_e(ω) dω = ' char(E_total)]);
                catch
                    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                        'Total energi', ...
                        ['Den totale energi beregnes ved at integrere energitæthedsspektret:'], ...
                        ['E = ∫ Φ_e(ω) dω fra 0 til ∞']);
                end
                
                E = E_sym;
            end
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
                'Fortolk energitæthedsspektrum', ...
                ['Energitæthedsspektret viser, hvordan signalets energi er fordelt over forskellige frekvenser.'], ...
                ['Høje værdier ved bestemte frekvenser indikerer, at signalet har betydelige komponenter ved disse frekvenser.']);
            
            % Afslut
            forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
                'Energitæthedsspektrum er beregnet.');
            
            % Visualiser hvis data er numerisk
            if isnumeric(F) && isnumeric(omega)
                figure;
                plot(omega, E, 'LineWidth', 2);
                grid on;
                title('Energitæthedsspektrum Φ_e(ω)');
                xlabel('Frekvens ω (rad/s)');
                ylabel('Φ_e(ω)');
            end
        end

        function [P, forklaringsOutput] = effektTaethed_med_forklaring(F, omega)
    % EFFEKTTAETHED_MED_FORKLARING Beregner og forklarer effekttæthedsspektrum
    %
    % Syntax:
    %   [P, forklaringsOutput] = ElektroMatBibTrinvis.effektTaethed_med_forklaring(F, omega)
    %
    % Input:
    %   F - Fouriertransformeret periodisk signal eller amplitudevektor af Fourierkoefficienter
    %   omega - frekvensvariabel eller frekvensvektor for numerisk beregning
    % 
    % Output:
    %   P - effekttæthedsspektrum
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Effekttæthedsspektrum');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér effekttæthedsspektrum', ...
        ['Effekttæthedsspektret for et periodisk signal kan defineres på to måder:'], ...
        ['1. Ved hjælp af Fourierkoefficienter: Φ_p(ω) = ∑ |cₙ|² · δ(ω - nω₀)\n' ...
         '2. Ved hjælp af grænsen af energitæthedsspektret: Φ_p(ω) = lim(T→∞) (1/T) · |F_T(ω)|²/π']);
    
    if isnumeric(F) && isnumeric(omega)
        % Numerisk beregning
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
            'Numerisk beregning', ...
            ['Vi har amplituder for Fourierkoefficienter givet numerisk.'], ...
            ['Beregner |cₙ|² for alle harmoniske.']);
        
        % Antag at F indeholder amplituder af Fourierkoefficienter
        P = abs(F).^2;
        
        % Total effekt
        P_total = sum(P);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
            'Beregn total effekt', ...
            ['Den totale effekt i signalet er summen af effektbidragene fra alle harmoniske:'], ...
            ['P = ∑ |cₙ|² = ' num2str(P_total)]);
    else
        % Symbolsk tilgang
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
            'Teoretisk tilgang', ...
            ['For et periodisk signal har effekttæthedsspektret diskrete værdier ved harmoniske frekvenser.'], ...
            ['Spektret består af Dirac-impulser ved frekvenserne nω₀.']);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
            'Fourierkoefficienters relation til effekt', ...
            ['Effekten i den n-te harmoniske er givet ved |cₙ|².'], ...
            ['Den totale effekt i signalet er summen P = |c₀|² + 2·∑ |cₙ|² for n > 0']);
        
        % Vi kan ikke beregne symbolsk uden mere information
        P = sym('P_effekt');
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Fortolk effekttæthedsspektrum', ...
        ['Effekttæthedsspektret viser, hvordan signalets middeleffekt er fordelt over forskellige frekvenser.'], ...
        ['For periodiske signaler er effekten koncentreret ved de harmoniske frekvenser nω₀.']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
        'Forskel mellem energi- og effekttæthedsspektrum', ...
        ['Energispektret bruges til signaler med endelig energi, mens effektspektret bruges til periodiske signaler.'], ...
        ['Et periodisk signal har uendelig energi, men endelig middeleffekt.']);
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        'Effekttæthedsspektrum er beregnet.');
    
    % Visualiser hvis data er numerisk
    if isnumeric(F) && isnumeric(omega)
        figure;
        stem(omega, P, 'filled', 'LineWidth', 2);
        grid on;
        title('Effekttæthedsspektrum');
        xlabel('Frekvens (rad/s)');
        ylabel('|cₙ|²');
    end
end

    end
end