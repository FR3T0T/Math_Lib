
        
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
                'Anvend