
        
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