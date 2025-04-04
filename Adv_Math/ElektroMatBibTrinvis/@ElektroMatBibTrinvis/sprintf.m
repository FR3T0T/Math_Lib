
        
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
                disp('Kredsløbet er udæmpet (ζ ≈ 0) - vedvarend