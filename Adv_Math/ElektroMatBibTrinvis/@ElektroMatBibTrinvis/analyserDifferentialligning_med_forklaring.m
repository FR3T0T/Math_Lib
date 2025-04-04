
        
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