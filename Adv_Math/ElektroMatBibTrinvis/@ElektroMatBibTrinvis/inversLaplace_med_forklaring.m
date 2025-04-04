
        
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
            
            % Uddybend