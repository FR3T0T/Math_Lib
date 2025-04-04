
        
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