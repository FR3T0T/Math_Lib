function kompletSystemAanalyse(num, den, system_navn)
    % KOMPLETSYSTEMAANALYSE Udfører en komplet analyse af et LTI-system med trinvise forklaringer
    %
    % Syntax:
    %   ElektroMatBibTrinvis.kompletSystemAanalyse(num, den, system_navn)
    %
    % Input:
    %   num - tæller polynomium (kan være numerisk eller symbolsk)
    %   den - nævner polynomium (kan være numerisk eller symbolsk)
    %   system_navn - navn på systemet (valgfrit)
    
    % Default navn hvis ikke angivet
    if nargin < 3
        system_navn = 'Lineært Tidsinvariant System';
    end
    
    disp(['===== KOMPLET ANALYSE AF ' upper(system_navn) ' =====']);
    disp(' ');
    
    % Håndter symbolske input
    syms s t;
    
    % Konverter symbolske udtryk til Laplace-domænet og derefter til polynomier
    if ~isnumeric(num)
        disp('Symbolsk højreside detekteret - konverterer til Laplace-domænet');
        try
            % Hvis det er et symbolsk udtryk i t, find Laplace-transformation
            if has(num, t)
                [num_laplace, ~] = ElektroMatBibTrinvis.laplaceMedForklaring(num, t, s);
                disp('Laplace-transformation af højreside:');
                disp(num_laplace);
                
                % Hvis resultatet er rationelt, brug kun tæller
                [num_n, num_d] = numden(num_laplace);
                if ~isequal(num_d, 1)
                    disp('Bemærk: Højresiden er en brøk, bruger kun tæller.');
                    disp(['Tæller: ' char(num_n)]);
                    disp(['Nævner vil blive tilføjet til systemets nævner']);
                    
                    % Opdater nævneren
                    if isnumeric(den)
                        den_sym = poly2sym(den, s);
                        den_sym = den_sym * num_d;
                        den = sym2poly(den_sym);
                    else
                        den = den * num_d;
                    end
                    
                    num_laplace = num_n;
                end
                
                % Konverter til polynom
                try
                    num = sym2poly(num_laplace);
                catch
                    disp('Kunne ikke konvertere direkte til polynom, bruger numerisk approximation');
                    num = double(coeffs(num_laplace, s, 'All'));
                end
            else
                % Hvis det allerede er et udtryk i s-domænet
                try
                    num = sym2poly(num);
                catch
                    disp('Kunne ikke konvertere direkte til polynom, bruger numerisk approximation');
                    num = double(coeffs(num, s, 'All'));
                end
            end
        catch e
            disp(['Advarsel: Kunne ikke konvertere symbolsk højreside korrekt: ' e.message]);
            disp('Fortsætter med det originale udtryk');
        end
    end
    
    if ~isnumeric(den)
        try
            % Hvis venstre side er symbolsk, konverter til polynom
            if has(den, t)
                disp('Konverterer symbolsk nævner fra tidsdomænet til Laplace-domænet');
                [den_laplace, ~] = ElektroMatBibTrinvis.laplaceMedForklaring(den, t, s);
                den = sym2poly(den_laplace);
            else
                den = sym2poly(den);
            end
        catch e
            disp(['Advarsel: Kunne ikke konvertere symbolsk venstresiden korrekt: ' e.message]);
            disp('Fortsætter med det originale udtryk');
        end
    end
    
    % 1. Konverter til overføringsfunktion
    disp('1. OVERFØRINGSFUNKTION:');
    try
        [~, ~, tf_forklaring] = ElektroMatBibTrinvis.diffLigningTilOverfoeringsfunktionMedForklaring(num, den);
        disp(' ');
    catch e
        disp(['Fejl under konvertering til overføringsfunktion: ' e.message]);
    end
    
    % 2. Analysér differentialligningen
    disp('2. ANALYSE AF DIFFERENTIALLIGNING:');
    a = den;  % Koefficienterne a er nævnerpolynomiet
    forklaring = ElektroMatBibTrinvis.analyserDifferentialligningMedForklaring(a);
    disp(' ');
    
    % 3. Beregn og visualisér steprespons
    disp('3. STEPRESPONS:');
    try
        [~, ~, step_forklaring] = ElektroMatBibTrinvis.beregnStepresponsMedForklaring(num, den, [0, 20]);
        disp(' ');
    catch e
        disp(['Fejl under beregning af steprespons: ' e.message]);
    end
    
    % 4. Beregn og visualisér frekvensrespons
    disp('4. FREKVENSRESPONS (BODE-DIAGRAM):');
    try
        bode_forklaring = ElektroMatBibTrinvis.visBodeDiagramMedForklaring(num, den, [0.01, 100]);
        disp(' ');
    catch e
        disp(['Fejl under beregning af frekvensrespons: ' e.message]);
    end
    
    % Analysér stabilitet
    try
        p = roots(den);
        unstable_poles = sum(real(p) >= 0);
        
        disp('5. STABILITETSVURDERING:');
        disp(['Poler: ' num2str(p')]);
        
        if unstable_poles > 0
            disp(['USTABILT SYSTEM! ' num2str(unstable_poles) ' pol(er) i højre halvplan.']);
        else
            disp('STABILT SYSTEM. Alle poler i venstre halvplan.');
        end
    catch e
        disp(['Fejl under stabilitetsanalyse: ' e.message]);
    end
    
    disp(' ');
    disp(['===== ANALYSE AFSLUTTET FOR ' upper(system_navn) ' =====']);
end