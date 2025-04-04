
        
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
            
            % Uddybend